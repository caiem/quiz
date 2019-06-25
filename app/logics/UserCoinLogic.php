<?php

class UserCoinLogic extends Logic
{
    public function incrCoin($uid, $num)
    {
        if (empty($uid)) {
            return false;
        }
        $num = (int)$num;

       /*$condition = array(
            'conditions' => 'uid= :uid:',
            'bind' => array('uid' => $uid),
            'for_update' => true
        );
        $infoModel = Info::findFirst($condition);
        if ($infoModel) {
            $infoModel->coin = $infoModel->coin + $num;
        } else {
            $infoModel = new Info();
            $infoModel->coin = $num;
            $infoModel->uid = $uid;
        }
        if ($infoModel->coin < 0) {
            $infoModel->coin = 0;
        }*/

        $connection = $this->getDI()->getShared('db');
        if ($num > 0) {
            $sql = "update `info` set `coin` = `coin`+{$num} WHERE `uid` = {$uid}";
        } else {
            $sql = "update `info` set `coin` = IF(`coin`< ".abs($num).",0,`coin`-" . abs($num) . ") WHERE `uid` = " . $uid;
        }
        try{
            $_upres = $connection->execute($sql);
        }catch (Exception $e){
            $connection->connect();
            $_upres = $connection->execute($sql);
        }

        if ($_upres === false) {
            return false;
        }
        $redis = $this->getDI()->get('redis');
        $rediskey = RedisKey::getUserInfoKey($uid);

        if ($num < 0) {
            DailyLogic::getInstance()->dailyDone($uid, 'cost300Coin', abs($num));
        }
        $redis->del($rediskey);
        return true;
    }
}