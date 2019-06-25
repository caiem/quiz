<?php

class DailyLogic extends Logic
{

    public $_tip = null;

    public function showDrawList($uid)
    {
        return Daily::makeDrawShow($this->getDrawList($uid));
    }

    public function getDrawList($uid)
    {
        $redis = $this->getDI()->get('redis');
        $redisKey = RedisKey::$drawList . APP_TODAY() . $uid;
//        $getDraw = $redis->del($redisKey);//tmp
        $getDraw = $redis->get($redisKey);
//ve($getDraw);
        if (!empty($getDraw)) {
            return json_decode($getDraw, 1);
        }
        $condition = array(
            'conditions' => 'uid= :uid:',
            'bind' => array('uid' => $uid),
            'columns' => 'uid,draw_get'
        );

        $model = Daily::findFirst($condition);
        $get = json_decode($model->draw_get, 1);
        $show = [];
        if (!empty($get) && !empty($get[APP_TODAY()])) {
            $show = $get[APP_TODAY()];
        } else {
            $show['times'] = 3;
            $show['costTimes'] = 10;
            $show['get'] = [];
        }
        $show['times'] < 0 && $show['times'] = 0;
        $get[APP_TODAY()] = $show;
        $model->draw_get = jsonEncode($get);
        $sql = "UPDATE `" . Daily::tableName() . "` SET `draw_get`='" . addslashes($model->draw_get) . "'  WHERE uid=" . $uid;
        $this->getDb()->execute($sql);

        $redis->set($redisKey, jsonEncode($show), 86499);
        return $show;
    }

    public function get_rand_num_no_ads()
    {
        $hitNum = mt_rand(1, 100);
        if ($hitNum > 30 && $hitNum <= 50) {
            $hitNum = $this->get_rand_num_no_ads();
        }
        return $hitNum;
    }


    public function doDraw($uid)
    {

        $list = $this->getDrawList($uid);
        if (empty($list['times'])) {
            if ($list['costTimes'] <= 0) {
                $this->_tip = '付费次数不能超过10次';
                return false;
            }
            --$list['costTimes'];
            $userInfo = UserLogic::getInstance()->getInfo($uid);
            if ($userInfo['coin'] < 100) {
                $this->_tip = '金币不足';
                return false;
            }
            UserCoinLogic::getInstance()->incrCoin($uid, -100);
        } else {
            --$list['times'];
        }

        $hitNum = mt_rand(1, 100);
        $ret = '';
        $showInfo = [];

        $newAdd = 0;
        if ($hitNum > 50) {
            $maxRole = RoleLogic::getInstance()->allRole($uid, 1);
            if (!empty(Role::ROLE_DRAW_ADD_RATE[$maxRole])) {
                $newAdd = Role::ROLE_DRAW_ADD_RATE[$maxRole];
            }
        }

        if (in_array('secretGift', $list['get']) && $hitNum > 30 && $hitNum <= 50) {
            $hitNum = $this->get_rand_num_no_ads();
        }

        if ($hitNum <= 10) {//
            $res = UserCoinLogic::getInstance()->incrCoin($uid, 200);
            $list['get'][] = $ret = 'coin200';
        } elseif ($hitNum > 10 && $hitNum <= 30) {
            $res = UserCoinLogic::getInstance()->incrCoin($uid, 50);
            $list['get'][] = $ret = 'coin50';
        } elseif ($hitNum > 30 && $hitNum <= 50) {
            $list['get'][] = $ret = 'secretGift';
            $showInfo = ['u' => Daily::DEFAULT_GITT['url'], 'i' => Daily::DEFAULT_GITT['img']];
            $res = true;
        } elseif ($hitNum > 50 && $hitNum <= (60 + $newAdd)) {
            $res = InfoLogic::getInstance()->incrCard($uid, Info::$addMoneyCard, 1);
            $list['get'][] = $ret = 'moneyCard';
        } elseif ($hitNum > (60 + $newAdd) && $hitNum <= (70 + $newAdd * 2)) {
            $res = InfoLogic::getInstance()->incrCard($uid, Info::$addScoreCard, 1);
            $list['get'][] = $ret = 'scoreCard';
        } elseif ($hitNum > (70 + $newAdd * 2) && $hitNum <= (80 + $newAdd * 3)) {
            $res = InfoLogic::getInstance()->incrCard($uid, Info::$protectStarCard, 1);
            $list['get'][] = $ret = 'protectCard';
        } elseif ($hitNum > (80 + $newAdd * 3) && $hitNum <= 100) {
            $res = true;
            $list['get'][] = $ret = 'thanks';
        }
        if (empty($res)) {

        }
        $condition = array(
            'conditions' => 'uid= :uid:',
            'bind' => array('uid' => $uid),
            'columns' => 'uid,draw_get'
        );

        $model = Daily::findFirst($condition);
        $get = !empty($model->draw_get) ? json_decode($model->draw_get, 1) : [];

        $list['times'] < 0 && $list['times'] = 0;
        $get[APP_TODAY()] = $list;
        $get = Daily::filterArray($get, 5);
        $model->draw_get = jsonEncode($get);
//        $model->update();
        $sql = "UPDATE `" . Daily::tableName() . "` SET `draw_get`='" . addslashes($model->draw_get) . "'  WHERE uid=" . $uid;
        $this->getDb()->execute($sql);

        $redisKey = RedisKey::$drawList . APP_TODAY() . $uid;
        $redis = $this->getDI()->get('redis');
        $redis->del($redisKey);
        return ['get' => $ret, 'info' => $showInfo];
    }

    /*if (empty($today)) {
    $today['isSign'] = 0;
    $today['isSign_'] = 1;
    $today['rankTimes'] = 0;
    $today['rankTimes_'] = 1;
    $today['cost300Coin'] = 0;
    $today['cost300Coin_'] = 300;
    $today['shareFriend'] = 0;
    $today['shareFriend_'] = 1;
    $today['inviteNew3Friend'] = 0;
    $today['inviteNew3Friend_'] = 3;
    $today['inviteFriendBattle'] = 0;
    $today['inviteFriendBattle_'] = 1;
    }*/
    public function dailyDone($uid, $type, $num)
    {
        if (empty($uid) || empty($num)) {
            return false;
        }
        $today = UserLogic::getInstance()->getDailyInfo($uid);
        $fullKey = $type . '_';
        if (empty($today[$fullKey]) || $today[$type] >= $today[$fullKey]) { //已完成
            return false;
        }
        $newVal = $today[$type] + $num;
        $done = 0;
        if ($newVal >= $today[$fullKey]) {
            $done = 1;
            $newVal = $today[$fullKey];
        }
        $model = Daily::findFirst([
            'conditions' => 'uid= :uid:',
            'bind' => array('uid' => $uid),
            'columns' => 'uid,data'
        ]);
        $data = json_decode($model->data, 1);
        $today[$type] = $newVal;
        $data[APP_TODAY()] = $today;
        if ($done && in_array($type, ['isSign', 'inviteFriendBattle'])) { //没有再点击领取这个过程
            $data[APP_TODAY()][$fullKey . 'o'] = 1;
        }
        $model->data = jsonEncode($data);

        $sql = "UPDATE `" . Daily::tableName() . "` SET `data`='" . addslashes($model->data) . "'  WHERE uid=" . $uid;
        $this->getDb()->execute($sql);

        $rediskey = RedisKey::$dailyInfo . APP_TODAY() . $uid;
        $redis = $this->getDI()->get('redis');
        $redis->del($rediskey);
        return true;
    }

    public function dayReward($uid, $type)
    {
        if (empty($uid) || empty($type)) {
            return '参数错误';
        }
        $today = UserLogic::getInstance()->getDailyInfo($uid);
        $fullKey = $type . '_';
        $overKey = $type . '_o';
        if (empty($today[$fullKey])) {
            return '参数错误';
        }
        if ($today[$type] < $today[$fullKey]) {
            return '还未完成';
        }
        if (!empty($today[$overKey])) {
            return '已领取过';
        }
        switch ($type) {
            case 'rankTimes':
                $res = UserCoinLogic::getInstance()->incrCoin($uid, 100);
                \CountLogic::getInstance()->incrCount(\RedisKey::TAKE_RANK_TIMES);
                break;
            case 'cost300Coin':
                $res = InfoLogic::getInstance()->incrCard($uid, Info::$addScoreCard, 2);
                \CountLogic::getInstance()->incrCount(\RedisKey::COST_300_TIMES);
                break;
            case 'shareFriend':
                $res = UserCoinLogic::getInstance()->incrCoin($uid, 200);
                $res = InfoLogic::getInstance()->incrCard($uid, Info::$addScoreCard, 3);
                \CountLogic::getInstance()->incrCount(\RedisKey::SHARE_FRIEND_TIMES);
                break;
            case 'inviteNew3Friend':
                UserCoinLogic::getInstance()->incrCoin($uid, 1000);
                InfoLogic::getInstance()->incrCard($uid, Info::$addScoreCard, 5);
                $res = InfoLogic::getInstance()->incrCard($uid, Info::$addMoneyCard, 3);
                \CountLogic::getInstance()->incrCount(\RedisKey::INVITE_3_FRIEND_TIMES);
                break;
            case 'inviteFriendBattle':
                $res = InfoLogic::getInstance()->incrCard($uid, Info::$addMoneyCard, 1);
                \CountLogic::getInstance()->incrCount(\RedisKey::PLAY_FRIEND_TIMES);
                break;
            default:
                $res = false;
                break;
        }
        if ($res) {

            $model = Daily::findFirst([
                'conditions' => 'uid= :uid:',
                'bind' => array('uid' => $uid),
                'columns' => 'uid,data'
            ]);
            $data = json_decode($model->data, 1);
            $data[APP_TODAY()] = $today;
            $data[APP_TODAY()][$overKey] = 1;
            $model->data = jsonEncode($data);

//            $this->di->getShared('logger')->info();
//            $model->update();
            $sql = "UPDATE `" . Daily::tableName() . "` SET `data`='" . addslashes($model->data) . "'  WHERE uid=" . $uid;
            $this->getDb()->execute($sql);

            $rediskey = RedisKey::$dailyInfo . date('Ymd') . $uid;
            $redis = $this->getDI()->get('redis');
            $redis->del($rediskey);

            return '领取成功';
        } else {
            return '未知错误' . $type;
        }
    }


}