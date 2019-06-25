<?php

class UserLogic extends Logic
{

    public $tip = '';

    /*
     * type 1:phone 2:wx
     * */
    public function login($mobile, $type = 1, $fromUid = 0, $name = '', $img = '', $appKey = '')
    {
        if (empty($appKey)) {
            $keys = IS_TEST ? \Config::KEY_MAP_TEST : \Config::KEY_MAP;
            $keys = array_keys($keys);
            $appKey = current($keys);
        }

        if ($type == 1) {
            $condition = array(
                'conditions' => 'phone=:phone: AND appkey=:appkey:',
                'bind' => array('phone' => $mobile, 'appkey' => $appKey)
            );
        } else {
            $condition = array(
                'conditions' => 'openid=:openid: AND appkey=:appkey:',
                'bind' => array('openid' => $mobile, 'appkey' => $appKey)
            );
        }
        $model = new User();
        $expireTime = APP_TIME() + 86400 * 7;

        $user = $model::findFirst($condition);
        $data = [];
        if (!empty($user)) {
            $data['uid'] = $user->uid;
            $data['firstLogin'] = false;
            $data['accessToken'] = md5(Config::$authKey . $user->uid . $expireTime);
            $data['expireTime'] = $expireTime;

            $user->loginTime = time();
            $user->save();

        } else {
            $cuser = new User();

            if ($type == 1) {
                $cuser->phone = $mobile;
            } else {
                $cuser->openid = $mobile;
            }

            $cuser->createTime = time();
            $cuser->loginTime = time();

            $cuser->appkey = $appKey;
            $cuser->type = $type;
            if (empty($name)) {
                //1856 5160 186
                $start = substr($mobile, 0, 4);
                $end = substr($mobile, 8, 3);
                $name = $start . '****' . $end;
            }
            if (empty($img)) {
//                $img = User::DEFAULT_IMG; tmp
                $imgs = array_column(\User::AI_USERS[mt_rand(0, 7)], 2);
                $img = $imgs[array_rand($imgs)];
            }
            $cuser->name = mb_substr($name, 0, 255);
            $cuser->img = mb_substr($img, 0, 500);
            $cuser->ip = Common::getClientIP();

            $ret = $cuser->save();
            if ($ret) {

                $damo = new Daily();
                $damo->uid = $cuser->uid;
                $damo->save();

                $damo = new Info();
                $damo->uid = $cuser->uid;
                $damo->coin = 500;
                $damo->package = jsonEncode(Info::$default);
                $damo->save();

                $damo = new Role();
                $damo->uid = $cuser->uid;
                $damo->role = '';
                $damo->save();

                if ($fromUid) {
                    try {
                        $friend = new Friend();
                        $friend->from_uid = (int)$fromUid;
                        $friend->to_uid = $cuser->uid;
                        $friend->save();
                    } catch (Exception $e) {
                        $this->di->getShared('logger')->info($e->getMessage());
                    }
                }
                $data['uid'] = $cuser->uid;
                $data['firstLogin'] = true;
                $data['accessToken'] = md5(Config::$authKey . $cuser->uid . $expireTime);
                $data['expireTime'] = $expireTime;
            }
        }
        return $data;

    }

    public function reConnect()
    {
        $connection = $this->getDb();
        $connection->close();
        $connection->connect();
    }

    public function getInfo($uid, $reCreate = false)
    {
        if (empty($uid)) {
            return false;
        }
        $uid = (int)$uid;
        $redis = $this->getDI()->get('redis');
        $rediskey = RedisKey::getUserInfoKey($uid);

        $reCreate && $redis->del($rediskey);
        $data = $redis->hgetall($rediskey);

        $today = date('Ymd');
        $checkkey = RedisKey::$todayIsLogin . date('Ymd') . $uid;
        if (!$redis->get($checkkey)) {
            $checkFindM = [
                'conditions' => 'uid= :uid:',
                'bind' => array('uid' => $uid),
                'columns' => 'sign'];
            try {
                $dModel = Daily::findFirst($checkFindM);
            } catch (Exception $dbe) {
                $this->reConnect();
                $dModel = Daily::findFirst($checkFindM);
            }
            if (!empty($dModel->sign)) {
                $sign = json_decode($dModel->sign, 1);
            } else {
                $sign = [];
            }
            $sign[$today] = 0;
            $sign = Daily::filterArray($sign);
            $dModel->sign = jsonEncode($sign);
//            $dModel->update();
            $sql = "UPDATE `" . Daily::tableName() . "` SET `sign`='" . addslashes($dModel->sign) . "'  WHERE uid=" . $uid;
            $this->getDb()->execute($sql);
            $redis->set($checkkey, 1, 86500);

            $redis->PFADD(RedisKey::LOGIN_UNIQUE_USERS . APP_TODAY(), [$uid]);
            $redis->expire(RedisKey::LOGIN_UNIQUE_USERS . APP_TODAY(), 86400 * 8);
        }

        if (empty($data)) {
            try {
                $UserModel = User::findFirst($uid);
            } catch (Exception $dbe) {
                $this->reConnect();
                $UserModel = User::findFirst($uid);
            }
            if (empty($UserModel)) {
                return $data;
            }
            $data['name'] = $UserModel->name;
            $data['img'] = $UserModel->img;
            $data['app'] = $UserModel->appkey;
            $data['account'] = !empty($UserModel->phone) ? $UserModel->phone : $UserModel->openid;
            $data['type'] = $UserModel->type;
            $data['createTime'] = $UserModel->createTime;
            $condition = array(
                'conditions' => 'uid= :uid:',
                'bind' => array('uid' => $uid),
                'columns' => 'coin,level,first_sign'
            );
            $infoModel = Info::findFirst($condition);
            $data['coin'] = $infoModel ? $infoModel->coin : 0;
            $data['level'] = $infoModel ? $infoModel->level : 0;
            $data['first_sign'] = $infoModel ? $infoModel->first_sign : 0;

            $redis->hmset($rediskey, $data);
            $redis->expire($rediskey, 3600 * 20);
        }
        return $data;
    }


    public function getDailyInfo($uid)
    {
        $uid = (int)$uid;
        $redis = $this->getDI()->get('redis');
        $rediskey = RedisKey::$dailyInfo . date('Ymd') . $uid;
//        $data = $redis->del($rediskey);//tmp
        $data = $redis->hgetall($rediskey);

        if (!empty($data)) {
            return $data;
        }

        $Model = Daily::findFirst([
            'conditions' => 'uid= :uid:',
            'bind' => array('uid' => $uid),
            'columns' => 'data',
        ]);
        $data = $today = [];
        if (!empty($Model->data)) {
            $data = json_decode($Model->data, 1);
        }
        $today = !empty($data[APP_TODAY()]) ? $data[APP_TODAY()] : [];

        if (empty($today)) {
            $today['isSign'] = 0;
            $today['isSign_'] = 1;
            $today['isSign_o'] = 0;
            $today['rankTimes'] = 0;
            $today['rankTimes_'] = 1;
            $today['rankTimes_o'] = 0;
            $today['cost300Coin'] = 0;
            $today['cost300Coin_'] = 300;
            $today['cost300Coin_o'] = 0;
            $today['shareFriend'] = 0;
            $today['shareFriend_'] = 1;
            $today['shareFriend_o'] = 0;
            $today['inviteNew3Friend'] = 0;
            $today['inviteNew3Friend_'] = 3;
            $today['inviteNew3Friend_o'] = 0;
            $today['inviteFriendBattle'] = 0;
            $today['inviteFriendBattle_'] = 1;
            $today['inviteFriendBattle_o'] = 0;
        }

        $data[APP_TODAY()] = $today;
        $data = Daily::filterArray($data, 4);
        $Model->data = jsonEncode($data);
//        $Model->update();
        $sql = "UPDATE `" . Daily::tableName() . "` SET `data`='" . addslashes($Model->data) . "'  WHERE uid=" . $uid;
        $this->getDb()->execute($sql);

        $redis->hmset($rediskey, $today);
        $redis->expire($rediskey, 87000);

        return $today;
    }

    public function getSignInfo($uid)
    {
        $uid = (int)$uid;
        $redis = $this->getDI()->get('redis');
        $rediskey = RedisKey::$signInfo . APP_TODAY() . $uid;
        $redis->del($rediskey);
        $data = $redis->get($rediskey);

        if (!empty($data) && is_array(json_decode($data, 1))) {
            return json_decode($data, 1);
        }
        $toDay = APP_TODAY();
        $Model = Daily::findFirst([
            'conditions' => 'uid= :uid:',
            'bind' => array('uid' => $uid),
            'columns' => 'sign'
        ]);
        $signedDays = [];
        if (!empty($Model->sign)) {
            $_signedDays = $data = json_decode($Model->sign, 1);
            foreach ($_signedDays as $k => $v) {
                $v && $signedDays[] = $k;
            }
        }
        $hit = Daily::getNewHit($data);

        $showDays = [];
        for ($_count = 0, $_i = -$hit; $_count < 7; $_count++, $_i++) {
            $showDays[] = date('Ymd', strtotime($toDay) + $_i * 86400 + 86400);
        }
        $data = [];

        $canShowSuipian = $this->canRandGetRole($uid);

        foreach ($showDays as $i => $v) {
            $data[] = [
                'sort' => $i, 'day' => $v, 'isSign' => in_array($v, $signedDays), 'hit' => $toDay == $v ? 1 : 0, 'suipian' => $canShowSuipian ? ($i == 2 ? 1 : 0) : 0];
        }
        $redis->set($rediskey, jsonEncode($data), 86500);
        return $data;
    }

    private function canRandGetRole($uid)
    {
        $userInfo = $this->getInfo($uid);
        $canShowSuipian = false;
        if ($userInfo['first_sign']) {
            if ((strtotime(APP_TODAY()) - strtotime($userInfo['first_sign'])) / 86400 >= 7) {
                $canShowSuipian = true;
            }
        }
        return $canShowSuipian;
    }

    public function signToday($uid)
    {
//        goto  dday;
        if (empty($uid)) {
            return false;
        }
        $uid = (int)$uid;
        $redis = $this->getDI()->get('redis');
        $checkKey = RedisKey::$checkIsSigned . APP_TODAY() . $uid;
//        $redis->del($checkKey);//tmp
        if ($redis->exists($checkKey)) {
            $this->tip = '今日已签到';
            return false;
        }

//        $db = $this->getDI()->getShared('db');

        $Model = Daily::findFirst([
            'conditions' => 'uid= :uid:',
            'bind' => array('uid' => $uid),
        ]);
        $today = APP_TODAY();
        $data = $Model->sign ? json_decode($Model->sign, 1) : [];

        foreach ($data as $k => $v) {
            if ($k == $today && $v) {//已签到
                $redis->set($checkKey, 1, 86500);
                $this->tip = '今日已签到';
                return false;
            }
        }

        $day = Daily::getNewHit($data);
//        ve($day);
//        dday:
//        $day = 7;
        //后面过滤废弃数据

        if (empty($day)) {
            $this->tip = '逻辑有误';
            return false;
        }

        //发奖励
        switch ($day) {
            case '2':
                $res = InfoLogic::getInstance()->incrCard($uid, Info::$addMoneyCard, 3);
                break;
            case '3':
                $canShowSuipian = $this->canRandGetRole($uid);
                if ($canShowSuipian) {
                    $hit = array_rand(Role::$roles);
                } else {
                    $hit = 1;
                }
                $res = RoleLogic::getInstance()->addRole($uid, $hit);
                break;
            case '4':
                $res = InfoLogic::getInstance()->incrCard($uid, Info::$addScoreCard, 3);
                break;
            case '5':
                $res = UserCoinLogic::getInstance()->incrCoin($uid, 300);
                break;
            case '6':
                $res = InfoLogic::getInstance()->incrCard($uid, Info::$addScoreCard, 5);
                break;
            case '7':
                $res = InfoLogic::getInstance()->incrCard($uid, Info::$protectStarCard, 1);
                $res = InfoLogic::getInstance()->incrCard($uid, Info::$addMoneyCard, 5);
                $res = UserCoinLogic::getInstance()->incrCoin($uid, 500);
                break;
            default:
                $uinfo = $this->getInfo($uid, 'first_sign');
                if (empty($uinfo['first_sign'])) {
                    $umodel = Info::findFirst('uid=' . $uid);
                    $umodel->first_sign = APP_TODAY();
                    $umodel->save();
                    $redis->del(RedisKey::getUserInfoKey($uid));
                }
                $res = UserCoinLogic::getInstance()->incrCoin($uid, 200);
                break;
        }

        //操作成功
        if ($res) {
            $data[APP_TODAY()] = $day;
        } else {
            $this->tip = '程序有误';
            return false;
        }

        $data = Daily::filterArray($data);
        if ($Model) {
            $Model->sign = jsonEncode($data);
        } else {
            $Model = new Daily();
            $Model->uid = $uid;
            $Model->sign = jsonEncode($data);
        }
        if ($Model->save() === false) {
            $this->tip = '程序有误';
            return false;
        } else {
            $infoKey = RedisKey::$signInfo . APP_TODAY() . $uid;
            $redis->del($infoKey);
            $redis->set($checkKey, 1, 86500);
        }

        DailyLogic::getInstance()->dailyDone($uid, 'isSign', 1);
        return true;
    }
}
