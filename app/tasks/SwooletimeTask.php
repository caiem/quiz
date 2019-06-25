<?php

class SwooletimeTask extends \Phalcon\Cli\Task
{

    public $server = null;
    private $redis, $db = null;
    public $timer, $timerRobot;

    /*发送通知*/
    public function msgData($status = 0, $type = '', $msg = '', $data = [])
    {
        $re_msg = [];
        $re_msg['code'] = $status;
        $re_msg['cmd'] = $type;
        $re_msg['msg'] = $msg;
        $re_msg['data'] = $data;
        return jsonEncode($re_msg);
    }

    public function checkToken($msgData)
    {
        if (empty($msgData) || !is_array($msgData) || empty($msgData['accessToken']) || empty($msgData['cmd']) || empty($msgData['uid'])) {
            return false;
        }

        

        if ($msgData['accessToken'] != md5(\Config::$authKey . (int)$msgData['uid'] . (int)$msgData['expireTime'])) {
            return false;
        }
        return true;
    }

    public function wsAction()
    {
//        echo jsonEncode(func_get_args());
        $_arr = func_get_args();
//        $res= var_export($_arr,1);
//        file_put_contents(__DIR__.'/test.txt',$res);
        if (empty($_arr[0])) {
            return false;
        }
        $frame = $_arr[0]['frame'];
        $server = $_arr[0]['server'];
        if (empty($frame->data) || empty($server)) {
            return false;
        }
        echo date('Ymd H:i:s') . " receive: {$frame->data}\n";
        $msgData = json_decode($frame->data, 1);

        if (!$this->checkToken($msgData)) {
            echo "wrong token: {$frame->data}" . PHP_EOL;
            try {
                $server->push($frame->fd, $this->msgData(-1004, 'wrongToken'));
                $server->close($frame->fd);
            } catch (Exception $ee) {

            }
            return false;
        }
        $uid = $msgData['uid'];
        $this->initDb();
        switch ($msgData['cmd']) {
            case 'matchGame':
                $this->redis->PFADD(RedisKey::COUNT_UNIQUE_USERS . APP_TODAY(), [$uid]);
                $this->redis->expire(RedisKey::COUNT_UNIQUE_USERS . APP_TODAY(), 86400 * 3);
                if ($msgData['gameType'] == 1) {//排位
                    $_times = $this->redis->incr(RedisKey::RANK_TAKE_TIMES . APP_TODAY());
                    if ($_times <= 2) {
                        $this->redis->expire(RedisKey::RANK_TAKE_TIMES . APP_TODAY(), 86400 * 3);
                    }
                    $this->redis->PFADD(RedisKey::COUNT_RANK_UNIQUE_USERS . APP_TODAY(), [$uid]);
                    $this->redis->expire(RedisKey::COUNT_RANK_UNIQUE_USERS . APP_TODAY(), 86400 * 3);
                    $this->rankFindUser($uid, $msgData, $frame, $server);
                } elseif ($msgData['gameType'] == 2) {//好友
                    $_times = $this->redis->incr(RedisKey::FRIEND_TAKE_TIMES . APP_TODAY());
                    if ($_times <= 2) {
                        $this->redis->expire(RedisKey::FRIEND_TAKE_TIMES . APP_TODAY(), 86400 * 3);
                    }
                    $this->redis->PFADD(RedisKey::COUNT_FRIEND_UNIQUE_USERS . APP_TODAY(), [$uid]);
                    $this->redis->expire(RedisKey::COUNT_FRIEND_UNIQUE_USERS . APP_TODAY(), 86400 * 3);
                    $this->friendFindUser($uid, $msgData, $frame, $server);
                } else {
                    $server->push($frame->fd, $this->msgData(-1004, $msgData['cmd'], 'wrong gameType'));
                }
                return false;
                break;
            case 'abandonGame'://for friend only
                if (empty($msgData['roomId'])) {
                    $server->push($frame->fd, $this->msgData(-1004, $msgData['cmd'], 'need roomId'));
                }
                $this->abandonGame($msgData, $frame, $server);
                \CountLogic::getInstance()->incrCount(RedisKey::$friendAbandonTimes);
                return false;
                break;
            case 'joinRoom'://for friend only
                if (empty($msgData['roomId'])) {
                    $server->push($frame->fd, $this->msgData(-1004, $msgData['cmd'], 'need roomId'));
                }
                $this->joinRoom($msgData, $frame, $server);
                return false;
                break;
            /*       case 'question':
                       if (empty($msgData['roomId']) || empty($msgData['q'])) {
                           $server->push($frame->fd, $this->msgData(-1004, $msgData['cmd']));
                           return false;
                       }
                       $this->getQuestion($uid, $msgData['roomId'], $msgData['q'], $frame, $server);
                       break;*/
            case 'ans':
                if (empty($msgData['roomId']) || empty($msgData['q']) || empty($msgData['ans'])) {
                    $server->push($frame->fd, $this->msgData(-1004, $msgData['cmd']), 'empty params');
                    return false;
                }
                $this->ansQuestion($uid, $msgData['roomId'], $msgData['q'], $msgData['ans'], $frame, $server);
                break;
            default:
                $retMsg = $this->msgData(-1, 'wrongArg');
                $server->push($frame->fd, $retMsg);
                break;
        }
        $this->server = $server;
    }

    public function closeAction($fd)
    {
        $_arr = func_get_args();
        if (empty($_arr[0]['fd'])) {
            return false;
        }
        $fd = $_arr[0]['fd'];
        $this->initRedis();
        $hitUserId = $this->redis->get(RedisKey::$gameRankFdToUser . $fd);
        $hitUserId && $this->redis->del(RedisKey::$gameIsPlay . $hitUserId);
        $this->redis->del(RedisKey::$gameRankFdToUser . $fd);
        echo date('Y-m-d H:i:s') . " client-{$fd} is closed\n";
    }

    public function friendFindUser($uid, $msgData, $frame, $server)
    {
        $this->initDb();
//        $userInfo = UserLogic::getInstance()->getInfo($uid);
        $this->redis->set(RedisKey::$gameRankFdToUser . $frame->fd, $uid, (10 * 60) + 25);

        $roomKey = RedisKey::GAME_ROOM_COUNT . APP_TODAY();
        $num = $this->redis->incr($roomKey);
        if ($num <= 2) {
            $this->redis->expire($roomKey, 86400 * 3);
        }
        $num = APP_TODAY() . '2' . $num;

        $roomKey = RedisKey::$gameRoom . $num;
        $this->redis->hset($roomKey, 'owner', $uid);
        $this->redis->hset($roomKey, 'ownerFd', $frame->fd);
        $this->redis->expire($roomKey, 86400 * 3);

        $server->push($frame->fd, $this->msgData(0, 'FriendRoom', '', ['roomId' => $num]));
    }

    public function abandonGame($msgData, $frame, $server)
    {
        $roomKey = RedisKey::$gameRoom . $msgData['roomId'];
        $num = $this->redis->hincrby($roomKey, 'isAbandon', 1);
        $server->push($frame->fd, $this->msgData(0, $msgData['cmd']));
    }

    public function joinRoom($msgData, $frame, $server)
    {
        $uid = $msgData['uid'];
        $roomKey = RedisKey::$gameRoom . $msgData['roomId'];
        $mgetKeys = [
            'owner',
            'isAbandon',
            'matchUid',
            'ownerFd',
        ];
        $mgetData = $this->redis->hmget($roomKey, $mgetKeys);

        $ownerId = $mgetData['owner'];
        if ($ownerId == $uid) {
            $server->push($frame->fd, $this->msgData(-11, $msgData['cmd'], '房主不能加入自己房间'));
            return false;
        }
        $isAbandon = $mgetData['isAbandon'];
        $matchfd = $mgetData['ownerFd'];
        if (!empty($isAbandon) || !$server->exist($matchfd)) {
            $server->push($frame->fd, $this->msgData(-12, $msgData['cmd'], '很遗憾,房间已关闭'));
            return false;
        }
        $matchUid = $mgetData['matchUid'];
        if (!empty($matchUid)) {
            $server->push($frame->fd, $this->msgData(-13, $msgData['cmd'], '很遗憾,被人捷足先登了!游戏已开始'));
            return false;
        }
        $this->redis->hset($roomKey, 'matchUid', $uid);

        $userInfo = UserLogic::getInstance()->getInfo($uid);

        Friend::addFriend($ownerId, $uid);
        if (!$this->redis->exists(RedisKey::$FriendCardIsGet . APP_TODAY() . $uid)) {
            InfoLogic::getInstance()->incrCard($uid, Info::$addMoneyCard, 1, 86400);
            $this->redis->set(RedisKey::$FriendCardIsGet . APP_TODAY() . $uid, 1, 86400);
            DailyLogic::getInstance()->dailyDone($uid, 'inviteFriendBattle', 1);
        }
        if (!$this->redis->exists(RedisKey::$FriendCardIsGet . APP_TODAY() . $ownerId)) {
            InfoLogic::getInstance()->incrCard($ownerId, Info::$addMoneyCard, 1);
            $this->redis->set(RedisKey::$FriendCardIsGet . APP_TODAY() . $ownerId, 1, 86400);
            DailyLogic::getInstance()->dailyDone($ownerId, 'inviteFriendBattle', 1);
        }

        list ($weekStartTime, $weekStart) = weekStart();
        $invKey = RedisKey::$inviteFriendJoinList . $weekStart . $ownerId;
        if ($this->redis->hsetnx($invKey, $uid, 1)) {
            $todayKey = RedisKey::INVITE_FRIEND_TODAY_LIST . APP_TODAY() . $ownerId;
            if ($this->redis->hlen($todayKey) < 3) {
                if ($this->redis->hsetnx($todayKey, $uid, 1)) {
                    DailyLogic::getInstance()->dailyDone($ownerId, 'inviteNew3Friend', 1);
                }
            }
            $this->redis->expire($todayKey, 86400);
        }
        $this->redis->expireAt($invKey, $weekStartTime + 86400 * 9);


        $this->getMatcher($uid, $ownerId, $userInfo, $frame, $matchfd, $server, 2, $msgData['roomId']);
    }


    private function initDb()
    {

        $this->initRedis();
        if (empty($this->db)) {
            $this->db = $this->di->getShared('db');
        }
    }

    private function initRedis()
    {
        if (empty($this->redis)) {
            $this->redis = $this->di->getShared('redis');
        }
    }

    public function getQuestion($uid, $roomId, $qid, $frame, $server)
    {
//        $this->initRedis();
    }

    public function getAllCount($sendQuestionTime, $nowMstime, $qid)
    {
        $allCount = 200;
//            echo " dd $nowMstime  _ $sendQuestionTime _ " . PHP_EOL;
        $diff = (int)$nowMstime - (int)$sendQuestionTime;
//            echo 'diff '.$diff .' '.$nowMstime.' '.$sendQuestionTime. PHP_EOL;
        if ($sendQuestionTime && $diff) {
            $count = intval($diff / 500);
//                echo 'count  ' . $count . PHP_EOL;
            if ($count == 1) {
                $allCount = 190;
            } elseif ($count >= 2) {
                $allCount = 190;
                $allCount -= intval(($count / 2)) * 10;
                if ($allCount <= 0) {
                    echo "warn:to low $nowMstime  $sendQuestionTime " . $diff . PHP_EOL;
                    $allCount = 0;
                }
            }
        }

        if ($qid == 5) {
            $allCount = $allCount * 2;
        }
        return $allCount;
    }

    public function ansQuestion($uid, $roomId, $qid, $ans, $frame, $server)
    {
        $nowMstime = mSectime();
        $this->initRedis();
        $roomKey = RedisKey::$gameRoom . $roomId;
        $isAns = $this->redis->hget($roomKey, $uid . '_q_' . $qid . '_ans');
        if ($isAns) {
            echo 'cant repeat answer';
            return false;
        }
//        echo $roomKey, $uid . '_q_' . $qid . '_ans', $ans . PHP_EOL;
        $this->redis->hset($roomKey, $uid . '_q_' . $qid . '_ans', $ans);
        $tmpMget = ['ans_' . $qid, 'q_' . $qid, 'userIds'];
        $tmpGet = $this->redis->HMGET($roomKey, $tmpMget);

        $trueq = !empty($tmpGet['ans_' . $qid]) ? $tmpGet['ans_' . $qid] : '';
        if ($trueq && $trueq == $ans) {
//            echo 'qtime_' . $qid . '_' . $uid . PHP_EOL;
            $sendQuestionTime = $this->redis->hget($roomKey, 'qtime_' . $qid . '_' . $uid);//'qtime_' . $qid . '_' . $userId
//            echo " dd $nowMstime  _ $sendQuestionTime _ " . PHP_EOL;
            $allCount = $this->getAllCount($sendQuestionTime, $nowMstime, $qid);

            $incRes = $this->redis->hget($roomKey, $uid . '_card_' . Info::$addScoreCard);
            if ($incRes) {
                $allCount = round($allCount * 110 / 100);
            }
//            echo $uid . ' allCount ' . $allCount . PHP_EOL;
            $allCount && $this->redis->HINCRBY($roomKey, $uid . '_score', $allCount);

            $rightNum = $this->redis->incr(RedisKey::USER_RIGHT_NUM . $uid, 1);
            RoleLogic::getInstance()->rightNumToRole($uid, $rightNum);
        }
//        $qestion_ = !empty($tmpGet['q_' . $qid]) ? $tmpGet['q_' . $qid] : '';
//        $qestionArr = json_decode($qestion_, 1);

        /*$show = [];
        $show[] = ['o' => $qestionArr['op1'], 't' => $qestionArr['op1'] == $trueq ? 1 : 0];
        $show[] = ['o' => $qestionArr['op2'], 't' => $qestionArr['op2'] == $trueq ? 1 : 0];
        $data = $this->msgData(0, 'ansResult', '', $show);
        $server->push($frame->fd, $data);*/

        $users = !empty($tmpGet['userIds']) ? $tmpGet['userIds'] : '';
        $userArr = explode('_', $users);
        if (count($userArr) == 2) {

            $needAnswerNum = 2;
            $nowAnser = $this->redis->HINCRBY($roomKey, $qid . '_done', 1);
            if ($nowAnser >= $needAnswerNum) {
                if (!empty($this->timer) && strpos($this->timer, $roomId . '_') !== false) {//tmp
                    $show = ['qid' => $qid, 't' => $trueq];
                    $fds = $this->redis->hget($roomKey, 'allFds');

                    $fdsArr = explode('_', $fds);

//                $wrongAns = array_diff([$qestionArr['op1'], $qestionArr['op2']], [$trueq]);
//                $wrongAns = current($wrongAns);
//                echo "{$qestion_} true {$trueq};wrong ans:" . $wrongAns . PHP_EOL;//tmp
                    $ukey = [];
                    foreach ($userArr as $uval) {
                        $ukey[$uval] = $uval . '_mathUserFd';
//                        echo  $uval . '_score '.$this->redis->hget($roomKey, $uval . '_score').PHP_EOL;
                        $show['users'][$uval]['score'] = $this->redis->hget($roomKey, $uval . '_score');
                        $show['users'][$uval]['ans'] = trim($this->redis->hget($roomKey, $uval . '_q_' . $qid . '_ans'));
                    }
                    $data = $this->msgData(0, 'queResult', '', $show);

//                    echo $qid . ' queResult' . jsonEncode($fdsArr) . PHP_EOL;
                    foreach ($fdsArr as $fdv) {
                        $fdv && $server->push($fdv, $data);
                    }
                    $this->clearAndSetTimer($roomKey, $ukey, $roomId, $qid, $server);
                }
            }
        }

        return true;
    }

    private function getBaseCoin($score)
    {
        if ($score >= 900) {
            $coin = 150;
        } elseif ($score >= 700 && $score < 900) {
            $coin = 130;
        } elseif ($score >= 500 && $score < 700) {
            $coin = 120;
        } else {
            $coin = 110;
        }
        return $coin;
    }

    public function dealResult($roomId, $server)
    {
        $this->initDb();
        $roomKey = RedisKey::$gameRoom . $roomId;
        $_data = $this->redis->hmget($roomKey, ['userIds', 'gameType']);
        $users = $_data['userIds'];
        $gameType = $_data['gameType'];
        $userArr = explode('_', $users);
        $show = [];
        if (count($userArr) == 2) {

            $score = [];
            foreach ($userArr as $uval) {
                $_score = $this->redis->hget($roomKey, $uval . '_score');
                $score[$uval] = $_score;
                $show['user'][$uval]['score'] = (int)$_score;
            }
            $winnerUid = array_search(max($score), $score);
            $hasWinner = count(array_unique($score)) > 1 ? true : false;

            $show['winner'] = $hasWinner ? $winnerUid : 'None';

            foreach ($userArr as $uid) {
                $show['user_protect_card'] = false;
                if (in_array($gameType, [1])) {
                    if (!$hasWinner) {
                        UserCoinLogic::getInstance()->incrCoin($uid, 100);
                        $show['user'][$uid]['coin'] = 0;
                    } else {
                        if ($uid) {
                            if ($winnerUid == $uid) {
                                $winnerScore = $score[$uid];
                                $_base = $baseCoin = $this->getBaseCoin($winnerScore);

                                $coinString = "roomId:{$roomId},winner:$uid,base:$_base";

                                $maxRole = RoleLogic::getInstance()->allRole($uid, 1);
                                if ($maxRole && isset(Role::ROLE_COIN_ADD_RATE[$maxRole])) {
                                    $baseCoin = round($baseCoin * Role::ROLE_COIN_ADD_RATE[$maxRole]);
                                    $coinString .= ",role_add:" . Role::ROLE_COIN_ADD_RATE[$maxRole];
                                }

                                if ($this->redis->hget($roomKey, $uid . '_card_' . Info::$addMoneyCard)) {
                                    $baseCoin = round($baseCoin * 1.5);
                                    $coinString .= ",moneyCard:1.5";
                                }

//                                echo $coinString . PHP_EOL;

                                if ($baseCoin) {
                                    UserCoinLogic::getInstance()->incrCoin($uid, $baseCoin);
                                }

                                InfoLogic::getInstance()->updateLevel($uid, 'incr');
                                $show['user'][$uid]['coin'] = $baseCoin;
                            } else {

                                $_userInfo = UserLogic::getInstance()->getInfo($uid);
                                $canUse = Info::needLowerRank($_userInfo['level']);

                                if ($canUse && InfoLogic::getInstance()->usePackage($uid, Info::$protectStarCard)) {
                                    \CountLogic::getInstance()->incrCount(\RedisKey::PACKAGE_TIMES_TYPE . Info::$protectStarCard);
                                    $show['user_protect_card'] = true;
                                } else {
                                    InfoLogic::getInstance()->updateLevel($uid, 'decr');
                                }
                                $show['user'][$uid]['coin'] = 0;
                            }

                            $localUser = UserLogic::getInstance()->getInfo($uid);
                            if ($localUser['level'] < 0) {
                                echo "error " . $uid . PHP_EOL;
                            }
                            $show['user'][$uid]['level'] = (int)$localUser['level'];

                            if (!$this->redis->exists(RedisKey::$isJoinRankGames . APP_TODAY() . $uid)) {
                                DailyLogic::getInstance()->dailyDone($uid, 'rankTimes', 1);
                            }
                        }
                    }
                }
                $data = $this->msgData(0, 'result', '', $show);

                $fd = $this->redis->hget($roomKey, $uid . '_mathUserFd');
                try {
                    $fd && $server->push($fd, $data);
                } catch (exception $eee) {

                }
            }
        }
    }

    private function rankMatchFd($rank, $frame, $server, $uid)
    {
        $getUid = $matchfd = 0;
        while (1) {
            $getUid = $matchfd = 0;
            $matchfdUid = $this->redis->SPOP(RedisKey::$gameRankFd . $rank);
//            echo $frame->fd . 'spop key' . RedisKey::$gameRankFd . $rank . ' ' . $matchfd . "\n";
            if (empty($matchfdUid)) {
                break;
            }
            list($matchfd, $getUid) = explode('_', $matchfdUid);
            if ($matchfd == $frame->fd || $getUid == $uid) {
                continue;
            }
            /* $arrFdToUser = [RedisKey::$gameRankFdToUser . $matchfd, RedisKey::$gameRankFdToUser . $frame->fd];
             $arrFdToUser = $this->redis->mget($arrFdToUser);
             if (!empty($arrFdToUser[RedisKey::$gameRankFdToUser . $matchfd]) && $arrFdToUser[RedisKey::$gameRankFdToUser . $matchfd] == $arrFdToUser[RedisKey::$gameRankFdToUser . $frame->fd]) {
                 continue;
             }*/
            $isOnline = $server->exist($matchfd);
            if (empty($isOnline)) {
//                echo ' offline ' . $matchfd . PHP_EOL;
                continue;
            } else {
//                echo ' online ' . $matchfd . PHP_EOL;
                break;
            }
        }
        return [$matchfd, $getUid];
    }

    public function rankFindUser($uid, $msgData, $frame, $server)
    {
        $this->initDb();
        $userInfo = UserLogic::getInstance()->getInfo($uid);
        if (empty($userInfo['coin']) || $userInfo['coin'] < 100) {
            $retInfo = $this->msgData(-1, 'needcoin', '铜钱不足100,不能参加排位赛');
            $server->push($frame->fd, $retInfo);
            return false;
        }
        $incRes = UserCoinLogic::getInstance()->incrCoin($uid, -100);
        if (empty($incRes)) {
            $retInfo = $this->msgData(-1, 'needcoin', '系统错误,请重新请求匹配');
            $server->push($frame->fd, $retInfo);
            return false;
        }
        $this->redis->set(RedisKey::$gameRankFdToUser . $frame->fd, $uid, 100);

        list($rank, $_start) = Info::getRankStart($userInfo['level']);

        list($matchfd, $hitUserId) = $this->rankMatchFd($rank, $frame, $server, $uid);

        if (!empty($matchfd)) {
            $this->getMatcher($uid, $hitUserId, $userInfo, $frame, $matchfd, $server);
            return true;
        }
        $this->redis->SADD(RedisKey::$gameRankFd . $rank, $frame->fd . '_' . $uid);
//            echo 'SADD ' . $frame->fd . PHP_EOL;
        $redis = $this->redis;
        swoole_timer_after(1000 * 4, function () use ($rank, $uid, $frame, $userInfo, $redis, $server) {
            if ($redis->get(RedisKey::$gameIsPlay . $uid)) {
                return true;
            } else {
                RedisKey::class;
                Info::class;
                list($matchfd, $hitUserId) = $this->rankMatchFd($rank, $frame, $server, $uid);
                $redis->srem(RedisKey::$gameRankFd . $rank, $frame->fd . '_' . $uid);
                if (!empty($matchfd)) {
                    $this->getMatcher($uid, $hitUserId, $userInfo, $frame, $matchfd, $server);
                    return true;
                }

                $matchfd = 0;
                $hitUserId = 0;
                $hitUserInfo = $userInfo;

                $rankArr = User::AI_USERS[$rank];
                $_rankArr = array_rand($rankArr);
                $rankArr = $rankArr[$_rankArr];

                $hitUserInfo['img'] = $rankArr[2];
                $hitUserInfo['name'] = $rankArr[0];
                list($num, $cardInfo, $roleInfo) = $this->setRoom($uid, $hitUserId, $userInfo, $hitUserInfo, $frame->fd, $matchfd);
                if (empty($num)) {
                    return false;
                }
                $retInfo = $this->makeMatchInfo($uid, $userInfo, $hitUserId, $hitUserInfo, $num, $cardInfo, $roleInfo);

                $redis->set(RedisKey::$gameIsPlay . $uid, 1, 20);
                $server->push($frame->fd, $retInfo);
                echo "uid:$uid fd:{$frame->fd} match robot" . PHP_EOL;

                swoole_timer_after(2000, function () use ($uid, $frame, $hitUserId, $num, $server) {
                    $this->sendQuestion([$uid => $frame->fd, $hitUserId => 0], $num, 1, $server, true);
                });
            }
        });
    }

    //人人对战匹配
    private function getMatcher($uid, $hitUserId, $userInfo, $frame, $matchFd, $server, $type = 1, $num = null)
    {
//        $hitUserId = $this->redis->get(RedisKey::$gameRankFdToUser . $matchFd);
        $hitUserInfo = UserLogic::getInstance()->getInfo($hitUserId);

        echo $uid . ' match  man ' . $hitUserId . PHP_EOL;
        list($num, $cardInfo, $roleInfo) = $this->setRoom($uid, $hitUserId, $userInfo, $hitUserInfo, $frame->fd, $matchFd, $type, $num);
        if (empty($num)) {
            return false;
        }
        $retInfo = $this->makeMatchInfo($uid, $userInfo, $hitUserId, $hitUserInfo, $num, $cardInfo, $roleInfo);

        $this->redis->set(RedisKey::$gameIsPlay . $uid, 1, 20);
        $this->redis->set(RedisKey::$gameIsPlay . $hitUserId, 1, 20);

//        echo $retInfo . PHP_EOL;
        try {
            $server->push($frame->fd, $retInfo);
            $retInfo = $this->makeMatchInfo($hitUserId, $hitUserInfo, $uid, $userInfo, $num, $cardInfo, $roleInfo);
            $matchFd && $server->push($matchFd, $retInfo);
        } catch (Exception $e) {
//            echo __METHOD__ . $e->getMessage() . PHP_EOL;
        }

        swoole_timer_after(1500, function () use ($uid, $frame, $hitUserId, $matchFd, $num, $server) {
            $this->sendQuestion([$uid => $frame->fd, $hitUserId => $matchFd], $num, 1, $server);
        });
    }

    //发送问题
    public function sendQuestion($userToFd, $roomId, $qid, $server)
    {
        if ($qid > 5) {
            $this->dealResult($roomId, $server);
            return false;
        }

        $_mget = $this->redis->hmget(RedisKey::$gameRoom . $roomId, ['q_' . $qid, 'ans_' . $qid]);
        $q = $_mget['q_' . $qid];
        $trueq = $_mget['ans_' . $qid];
        $dd = json_decode($q, 1);
        $dd['id'] = $qid;
        $data = $this->msgData(0, 'question', '', $dd);
//        echo jsonEncode($userToFd).PHP_EOL;
        foreach ($userToFd as $userId => $fd) {
            if (empty($fd) || empty($userId)) {
                continue;
            }
            try {
                $server->push($fd, $data);
            } catch (Exception $ee) {
            }
            $this->redis->hset(RedisKey::$gameRoom . $roomId, 'qtime_' . $qid . '_' . $userId, strval(mSectime()));

            $isRootbot = in_array('0', $userToFd);
            if ($isRootbot) {
                $robotSendQtime = strval(mSectime());
                $this->redis->hset(RedisKey::$gameRoom . $roomId, 'qtime_' . $qid . '_0', strval(mSectime()));

                swoole_timer_after(1000 * mt_rand(1, 7), function () use ($userId, $fd, $roomId, $qid, $server, $dd, $trueq, $robotSendQtime) {

                    $nowMstime = mSectime();
                    $ruid = 0;
                    $roomKey = RedisKey::$gameRoom . $roomId;

                    $wrongAns = array_diff([$dd['op1'], $dd['op2']], [$dd['ans']]);
                    $wrongAns = current($wrongAns);

                    $robotRand = mt_rand(0, 100);
                    if ($robotRand <= 25) {//tmp
                        $ans = $trueq;
                    } else {
                        $ans = $wrongAns;
                    }
//                    echo 'robot ' . $ruid . '_q_' . $qid . '_ans ' . $ans . ' json:' . jsonEncode($dd) . PHP_EOL;
                    $this->redis->hset($roomKey, $ruid . '_q_' . $qid . '_ans', $ans);
                    $this->redis->HINCRBY($roomKey, $qid . '_done', 1);
//                    echo "robot $qid  $truq $ans".PHP_EOL;
                    if ($trueq == $ans) {
                        $allCount = $this->getAllCount($robotSendQtime, $nowMstime, $qid);
//                        echo "robot true $qid $allCount" . PHP_EOL;
                        $allCount && $this->redis->HINCRBY($roomKey, '0_score', $allCount);
                    }
                    /* $ukey = [];
                     $ukey[0] = '0_mathUserFd';
                     $ukey[$userId] = $userId . '_mathUserFd';
                     $this->clearAndSetTimer($roomKey, $ukey, $roomId, $qid, $server);*/
                });
            }
        }


        //10秒 100毫秒
        $timeId = swoole_timer_after(1000 * 10 + 100, function () use ($userToFd, $roomId, $qid, $server) {
//            echo 'timer '.$qid.PHP_EOL;
            $this->sendQuestionResult($userToFd, $roomId, $qid, $server);
        });
        $this->timer = $roomId . '_' . $timeId;
    }

    public function clearAndSetTimer($roomKey, $ukey, $roomId, $qid, $server)
    {
        if (!empty($this->timer) && strpos($this->timer, $roomId . '_') !== false) {//tmp
//            echo 'timer:' . $this->timer . PHP_EOL;
            $res = false;
            try {
                list($_, $timer) = explode('_', $this->timer);
                $res = swoole_timer_clear($timer);
            } catch (Exception $e) {
                echo 'clear timer' . $e->getMessage() . PHP_EOL;
            }

            if (!$res) {
                return false;
            }
            $hitArr = $this->redis->hmget($roomKey, $ukey);
            foreach ($ukey as $uv => $uk) {
                $ukey[$uv] = !empty($hitArr[$uv . '_mathUserFd']) ? $hitArr[$uv . '_mathUserFd'] : 0;
            }

            if ($qid == 4) {
                $lateTime = 1000;
            } else {
                $lateTime = 2500;
            }
            swoole_timer_after($lateTime, function () use ($ukey, $roomId, $qid, $server) {
                $this->sendQuestion($ukey, $roomId, $qid + 1, $server);
            });
        }
    }

    public function sendQuestionResult($userToFd, $roomId, $qid, $server)
    {
        $roomKey = RedisKey::$gameRoom . $roomId;
        $marr = $this->redis->hmget($roomKey, ['userIds', 'allFds', 'ans_' . $qid]);
        $users = $marr['userIds'];
        $userArr = explode('_', $users);

        $fds = $marr['allFds'];
        $fdsArr = explode('_', $fds);

        $trueq = $marr['ans_' . $qid];
        $show = ['qid' => $qid, 't' => $trueq];

        $keys = [];
        foreach ($userArr as $uval) {
            $keys[] = $uval . '_score';
            $keys[] = $uval . '_q_' . $qid . '_ans';
        }
        $umarr = $this->redis->hmget($roomKey, $keys);

//        echo '$umarr ' . jsonEncode($umarr) . PHP_EOL;
        foreach ($userArr as $uval) {
            $show['users'][$uval]['score'] = isset($umarr[$uval . '_score']) ? $umarr[$uval . '_score'] : 0;
//            echo RedisKey::$gameRoom . $roomId, $uval . '_q_' . $qid . '_ans' . PHP_EOL;
            $show['users'][$uval]['ans'] = trim($umarr[$uval . '_q_' . $qid . '_ans']);
        }
//        $show['normalTime'] = 1;//tmp

        $data = $this->msgData(0, 'queResult', '', $show);

//        echo $qid . ' queResult' . jsonEncode($fdsArr) . PHP_EOL;
        foreach ($fdsArr as $fdv) {
            try {
                $fdv && $server->push($fdv, $data);
            } catch (Exception $eee) {

            }
        }

        if ($qid == 4) {
            $lateTime = 1000;
        } else {
            $lateTime = 2500;
        }
        swoole_timer_after($lateTime, function () use ($userToFd, $roomId, $qid, $server) {
            $this->sendQuestion($userToFd, $roomId, $qid + 1, $server);
        });
    }

    public function setRoom($uid, $hitUserid, $useInfo, $hitUserInfo, $userFd, $hitUserFd, $gameType = 1, $num = null)
    {
//        echo 'room type ' . $gameType . '  ' . $num . PHP_EOL;
        if ($gameType == 1) {
            $roomKey = RedisKey::GAME_ROOM_COUNT . date('Ymd');
            $num = $this->redis->incr($roomKey);
            if ($num <= 2) {
                $this->redis->expire($roomKey, 86400 * 3);
            }
            $num = date('Ymd') . '1' . $num;
            $roomKey = RedisKey::$gameRoom . $num;
        } else {
            $roomKey = RedisKey::$gameRoom . $num;
        }


        $setArray = [];
        $setArray['gameType'] = $gameType;
        $setArray[$uid . '_name'] = $useInfo['name'];
        $setArray[$hitUserid . '_name'] = $hitUserInfo['name'];

        $setArray[$uid . '_img'] = $useInfo['img'];
        $setArray[$hitUserid . '_img'] = $hitUserInfo['img'];

        $setArray[$uid . '_mathUserFd'] = $userFd;
        $setArray[$hitUserid . '_mathUserFd'] = $hitUserFd;
//        echo $userFd . '_' . $hitUserFd . PHP_EOL;
        $setArray['allFds'] = $userFd . '_' . $hitUserFd;
        $setArray['userIds'] = $uid . '_' . $hitUserid;
        $cardInfo = $roleInfo = [];
        foreach ([$uid, $hitUserid] as $uval) {
            $setArray[$uval . '_score'] = 0;

            $roleInfo[$uval] = $setArray[$uval . '_role'] = RoleLogic::getInstance()->allRole(empty($uval) ? $uid : $uval, 1);

            if (!empty($uval) && $gameType == 1) {
                $times = $this->redis->DECR(RedisKey::$addScoreCard . $uval);
                if (is_numeric($times) && $times >= 0) {
                    $setArray[$uval . '_card_' . Info::$addScoreCard] = 1;
                    $cardInfo[$uval]['score'] = 1;
                } else {
                    $setArray[$uval . '_card_' . Info::$addScoreCard] = 0;
                    $cardInfo[$uval]['score'] = 0;
                }

                $times = $this->redis->DECR(RedisKey::$addMoneyCard . $uval);
                if (is_numeric($times) && $times >= 0) {
                    $setArray[$uval . '_card_' . Info::$addMoneyCard] = 1;
                    $cardInfo[$uval]['money'] = 1;
                } else {
                    $setArray[$uval . '_card_' . Info::$addMoneyCard] = 0;
                    $cardInfo[$uval]['money'] = 0;
                }
            }
        }

        $ques = $this->getQuestions();
        foreach ($ques as $k => $v) {
            $setArray['ans_' . $k] = $v['ans'];
            unset($v['ans']);
            $setArray['q_' . $k] = jsonEncode($v);
        }

        if (empty($ques)) {
            return false;
        }

        $this->redis->hmset($roomKey, $setArray);
        $this->redis->expire($roomKey, 86400 * 3);

        return [$num, $cardInfo, $roleInfo];
    }

    public function makeMatchInfo($uid, $userInfo, $hitUserId, $hitUserInfo, $num, $cardInfo, $roleInfo)
    {
        $data = [
            'roomId' => $num,
            'users' => [
                ['uid' => $uid, 'img' => $userInfo['img'], 'name' => $userInfo['name'], 'level' => $userInfo['level'], 's' => 1,
                    'card' => isset($cardInfo[$uid]) ? $cardInfo[$uid] : [], 'role' => isset($roleInfo[$uid]) ? (int)$roleInfo[$uid] : 0],
                ['uid' => $hitUserId, 'img' => $hitUserInfo['img'], 'name' => $hitUserInfo['name'], 'level' => $hitUserInfo['level'], 's' => 0,
                    'card' => isset($cardInfo[$hitUserId]) ? $cardInfo[$hitUserId] : [], 'role' => isset($roleInfo[$hitUserId]) ? (int)$roleInfo[$hitUserId] : 0]
            ]
        ];
        return $this->msgData(0, 'matchSuccess', '', $data);
    }

    public function getQuestions()
    {

        $data = $this->redis->SRANDMEMBER(RedisKey::$queAll, 5);
        $mkeys = [];
        foreach ($data as $v) {
            $mkeys[] = RedisKey::$queInfo . $v;
        }
        $data = $this->redis->mget($mkeys);


        $q = [];
        $i = 1;
        foreach ($data as $v) {
            $v = json_decode($v, 1);
            $row = [
                'q' => $v['q'],
                'op1' => $v['op1'],
                'op2' => $v['op2'],
                'ans' => $v['ans'],
            ];
            $q[$i] = $row;
            $i++;
        }
        return $q;
    }


}