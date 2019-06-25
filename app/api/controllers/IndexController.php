<?php

namespace Api\Controller;


class IndexController extends ApiBaseController
{
    function initialize()
    {
    }


    public function RankinfoAction()
    {
        exit();
        $sdefaultDate = date("Y-m-d");
        $sdefaultDate = '20190602';
        $first = 1;//表示每周星期一为开始日期 0表示每周日为开始日期


        ve(\Info::getRankStart(18));
    }

    public function tongjiAction()
    {
        if ($this->request->get('debugd') != 'showquiz2019') {
            echo 'endp';
            exit();
        }

        $oridate = $date = $this->request->get('date');
        if (empty($date)) {
            $date = date('Ymd');
        }
        $end = '<pre><br/>';
        echo APP_TODAY();
        echo '参与人数统计:' . $end;

        echo "\t" . '今天:' . $this->redis->pfcount(\RedisKey::LOGIN_UNIQUE_USERS . APP_TODAY()) . $end;
        echo "\t" . '昨天:' . $this->redis->pfcount(\RedisKey::LOGIN_UNIQUE_USERS . date('Ymd', strtotime("-1 day"))) . $end;

        $serverday = date('Ymd', strtotime("-7 day"));
        $serventime = strtotime($serverday);
        $sql = "SELECT COUNT(*) as cc from `user` where loginTime>=$serventime";
        $data = $this->getDI()->getDb()->fetchOne($sql);
        echo "\t" . '最近7天:' . $data['cc'] . $end;

        $serverday = date('Ymd', strtotime("-30 day"));
        $serventime = strtotime($serverday);
        $sql = "SELECT COUNT(*) as cc from `user` where loginTime>=$serventime";
        $data = $this->getDI()->getDb()->fetchOne($sql);
        echo "\t" . '最近30天:' . $data['cc'] . $end;

        echo '留存(%):' . $end;
        $sql = "SELECT * from `retain`   order by `date` desc limit 10";
        $data_ = $this->getDI()->getDb()->fetchAll($sql);
        if ($data_) {
            foreach ($data_ as $data) {
                echo "\t 日期:{$data['date']}:注册用户数:{$data['adduser']} 、登录用户数:{$data['loginuser']}、 次日留存:" . ($data['yesterday'] * 100) . "  、3天留存:" . ($data['threeday'] * 100) . "、7天留存:" . ($data['sevenday'] * 100) . "、30天留存:" . ($data['thrityday'] * 100) . $end;
            }
        }

        echo $date;
        echo '比赛参与统计:' . $end;

        echo "\t" . '比赛参与人数:' . $this->redis->pfcount(\RedisKey::COUNT_UNIQUE_USERS . $date) . $end;
        echo "\t" . '排位赛参与次数:' . $this->redis->get(\RedisKey::RANK_TAKE_TIMES . $date) . $end;
        echo "\t" . '排位赛参与人数:' . $this->redis->pfcount(\RedisKey::COUNT_RANK_UNIQUE_USERS . $date) . $end;

        echo "\t" . '好友对战参与次数:' . $this->redis->get(\RedisKey::FRIEND_TAKE_TIMES . $date) . $end;
        echo "\t" . '好友对战参与人数:' . $this->redis->pfcount(\RedisKey::COUNT_FRIEND_UNIQUE_USERS . $date) . $end;
        echo $date;

        echo '用户行为统计：' . $end;

        echo "\t" . '日常活动:' . $this->redis->get(\RedisKey::DAILY_VISIT_TIMES . $date) . $end;
        echo "\t" . '日常活动-签到:' . $this->redis->get(\RedisKey::DAILY_SIGN_TIMES . $date) . $end;
        echo "\t" . '日常活动-参与1场排位赛:' . $this->redis->get(\RedisKey::TAKE_RANK_TIMES . $date) . $end;
        echo "\t" . '日常活动-消费300铜钱:' . $this->redis->get(\RedisKey::COST_300_TIMES . $date) . $end;
        echo "\t" . '日常活动-分享给好友:' . $this->redis->get(\RedisKey::SHARE_FRIEND_TIMES . $date) . $end;
        echo "\t" . '日常活动-邀请三位好友:' . $this->redis->get(\RedisKey::INVITE_3_FRIEND_TIMES . $date) . $end;
        echo "\t" . '日常活动-邀请好友对战:' . $this->redis->get(\RedisKey::PLAY_FRIEND_TIMES . $date) . $end;

        echo '<br/>' . $end;
        echo "\t" . '我的行囊:' . $this->redis->get(\RedisKey::PACKAGE_TIMES . $date) . $end;
        echo "\t" . '限时铜钱卡:' . $this->redis->get(\RedisKey::PACKAGE_TIMES_TYPE . \Info::$addMoneyCard . $date) . $end;
        echo "\t" . '加分卡:' . $this->redis->get(\RedisKey::PACKAGE_TIMES_TYPE . \Info::$addScoreCard . $date) . $end;
        echo "\t" . '排位保护卡:' . $this->redis->get(\RedisKey::PACKAGE_TIMES_TYPE . \Info::$protectStarCard . $date) . $end;
        echo '<br/>' . $end;

        echo "\t" . '排行榜:' . $this->redis->get(\RedisKey::RANK_OPEN_TIMES . $date) . $end;
        echo "\t" . '每日抽奖:' . $this->redis->get(\RedisKey::DRAW_TIMES . $date) . $end;
        echo '<br/>' . $end;

        echo "\t" . '成就:合成角色次数:' . $this->redis->get(\RedisKey::MERGE_ROLE_TIMES . $date) . $end;
        echo '<br/>' . $end;

        echo "\t" . '好友对战-放弃:' . $this->redis->get(\RedisKey::$friendAbandonTimes . $date) . $end;
        exit();
    }


    public function showredisAction()
    {
        $uid = $this->request->get('uid');
        if (empty($uid)) {
            $this->render(-1, '用户uid缺失');
        }
        $redis = $this->getDI()->get('redis');
        var_dump(\RedisKey::$addMoneyCard . ' :' . $redis->get(\RedisKey::$addMoneyCard . $uid));
        var_dump(\RedisKey::$addScoreCard . ' :' . $redis->get(\RedisKey::$addScoreCard . $uid));
        var_dump(\RedisKey::USER_RIGHT_NUM . ' :' . $redis->get(\RedisKey::USER_RIGHT_NUM . $uid));

    }

    public function infoAction()
    {
        $uid = $this->request->get('uid');
        if (empty($uid)) {
            $this->render(-1, '用户uid缺失');
        }

        $info = \UserLogic::getInstance()->getInfo($uid);

        if (empty($info['account'])) {
            $info = \UserLogic::getInstance()->getInfo($uid, true);
        }

        $redis = $this->getDI()->get('redis');
        //        $redis->publish(\RedisKey::INTER_API, jsonEncode([
        $redis->rpush(\RedisKey::INTER_API, jsonEncode([
            'appKey' => IS_TEST ? \Config::KEY_MAP_TEST[$info['app']] : \Config::KEY_MAP[$info['app']],
            'accountType' => $info['type'] == 1 ? 'PHONE' : 'WX',
            'account' => $info['account'],
        ]));

        if ($info) {
            $this->render(0, '', $info);
        } else {
            $this->render(-1, '获取失败');
        }

    }

    public function dailyAction()
    {
        $uid = $this->request->get('uid');
        if (empty($uid)) {
            $this->render(-1, '用户uid缺失');
        }

        $info = \UserLogic::getInstance()->getDailyInfo($uid);
        \CountLogic::getInstance()->incrCount(\RedisKey::DAILY_VISIT_TIMES);
        if ($info) {
            $this->render(0, '', $info);
        } else {
            $this->render(-1, '获取失败');
        }
    }

    public function signAction()
    {
        $uid = $this->request->get('uid');
        if (empty($uid)) {
            $this->render(-1, '用户uid缺失');
        }

        $info = \UserLogic::getInstance()->getSignInfo($uid);
        if ($info) {
            $this->render(0, '', $info);
        } else {
            $this->render(-1, '获取失败');
        }
    }

    public function signTodayAction()
    {
        $uid = $this->request->get('uid');
        if (empty($uid)) {
            $this->render(-1, '用户uid缺失');
        }

        $dd = \UserLogic::getInstance();
        $info = $dd->signToday($uid);
        if ($info) {
            \CountLogic::getInstance()->incrCount(\RedisKey::DAILY_SIGN_TIMES);
            $this->render(0, '', $info);
        } else {
            $this->render(-1, $dd->tip ? $dd->tip : '获取失败');
        }
    }

    public function packageAction()
    {
        $uid = $this->request->get('uid');
        if (empty($uid)) {
            $this->render(-1, '用户uid缺失');
        }

        $info = \InfoLogic::getInstance()->getPackage($uid);
        \CountLogic::getInstance()->incrCount(\RedisKey::PACKAGE_TIMES);
        $this->render(0, '', $info);
    }

    public function usePackageAction()
    {
        $uid = $this->request->get('uid');
        if (empty($uid)) {
            $this->render(-1, '用户uid缺失');
        }
        $packageId = $this->request->get('packageId');
        if (empty($packageId) || !in_array($packageId, \Info::$packageIds)) {
            $this->render(-1, 'package wrong');
        }

        $ins = \InfoLogic::getInstance();
        $info = $ins->usePackage($uid, $packageId);
        \CountLogic::getInstance()->incrCount(\RedisKey::PACKAGE_TIMES_TYPE . $packageId);
        if ($info) {
            $this->render(0, '', $info);
        } else {
            $this->render(-1, $ins->_tip ?? '使用失败');
        }
    }

    public function rankAction()
    {
        $uid = $this->request->get('uid');
        if (empty($uid)) {
            $this->render(-1, '用户uid缺失');
        }

        $page = $this->request->get('page');
        $page = 1;
        if (empty($page) || $page > 3) {
            $this->render(-1, 'page缺失');
        }

        $info = \InfoLogic::getInstance()->getRank($uid, (int)$page);
        \CountLogic::getInstance()->incrCount(\RedisKey::RANK_OPEN_TIMES);
        $this->render(0, '', $info);
    }

    public function drawListAction()
    {
        $uid = $this->request->get('uid');
        if (empty($uid)) {
            $this->render(-1, '用户uid缺失');
        }

        $info = \DailyLogic::getInstance()->showDrawList($uid);
        $this->render(0, '', $info);
    }

    public function dodrawAction()
    {
        $uid = $this->request->get('uid');
        if (empty($uid)) {
            $this->render(-1, '用户uid缺失');
        }

        $dins = \DailyLogic::getInstance();
        $info = $dins->doDraw($uid);
        \CountLogic::getInstance()->incrCount(\RedisKey::DRAW_TIMES);
        if ($info) {
            $this->render(0, '', $info);
        } else {
            $this->render(-1, $dins->_tip ?? '未知错误', []);
        }
    }

    public function allroleAction()
    {
        $uid = $this->request->get('uid');
        $type = $this->request->get('type');
        if (empty($uid)) {
            $this->render(-1, '用户uid缺失');
        }

        $info = \RoleLogic::getInstance()->allRole($uid, $type);
        $this->render(0, '', $info);
    }

    public function mergeRoleAction()
    {
        $uid = $this->request->get('uid');
        $chooseId = $this->request->get('chooseId');
        if (empty($uid)) {
            $this->render(-1, '用户uid缺失');
        }

        $dd = \RoleLogic::getInstance();
        $info = $dd->mergeRole($uid, $chooseId);
        \CountLogic::getInstance()->incrCount(\RedisKey::MERGE_ROLE_TIMES);
        if ($info) {
            $this->render(0, '成功');
        } else {
            $this->render(-1, $dd->tip ? $dd->tip : '合成失败');
        }
    }

    public function dayRewardAction()
    {
        $uid = $this->request->get('uid');
        $type = $this->request->get('type');
        if (empty($uid)) {
            $this->render(-1, '用户uid缺失');
        }
        if (empty($type)) {
            $this->render(-1, '动作缺失');
        }

        $msg = \DailyLogic::getInstance()->dayReward($uid, $type);
        $this->render(0, $msg);
    }

    public function dailyDoAction()
    {
        $uid = $this->request->get('uid');
        $type = $this->request->get('type');
        if (empty($uid)) {
            $this->render(-1, '用户uid缺失');
        }
        if (empty($type) || $type != 'shareFriend') {
            $this->render(-1, 'type缺失');
        }

        $msg = \DailyLogic::getInstance()->dailyDone($uid, 'shareFriend', 1);
        if ($msg) {
            $this->render(0);
        } else {
            $this->render(-1, '未完成或已领');
        }
    }


}