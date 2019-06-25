<?php

class RoleLogic extends Logic
{
    public $tip = '';

    public function mergeRole($uid, $level)
    {

        if (!in_array($level, Role::$roles)) {
            $this->tip = '角色id错误';
            return false;
        }
        if ($level >= 9) {
            $this->tip = '已经顶级了';
            return false;
        }
        $condition = array(
            'conditions' => 'uid= :uid:',
            'bind' => array('uid' => $uid),
        );

        $model = Role::findFirst($condition);
        if (empty($model)) {
            return false;
        }
        $role = json_decode($model->role, 1);
        if ($role[$level] < 2) {
            $this->tip = '角色数不够';
            return false;
        }
        $role[$level]--;
        $role[$level]--;

        $newl = $level + 1;
        if (!isset($role[$newl])) {
            $role[$newl] = 0;
        }
        $role[$newl]++;
        $role = array_filter($role);
        ksort($role);

        $model->role = jsonEncode($role);
        $model->update();
        $redisKey = RedisKey::$roleList . $uid;
        $redis = $this->getDI()->get('redis');
        $redis->del($redisKey);
        return true;

    }

    public function addRole($uid, $level)
    {
        if (!in_array($level, Role::$roles)) {
            return false;
        }
        $redis = $this->getDI()->get('redis');
        $condition = array(
            'conditions' => 'uid= :uid:',
            'bind' => array('uid' => $uid),
        );

        $model = Role::findFirst($condition);
        if (empty($model)) {
            return false;
        }
        $role = json_decode($model->role, 1);
        if (!is_array($role)) {
            $role = [];
        }
        if (!isset($role[$level])) {
            $role[$level] = 0;
        }
        $role[$level]++;
        ksort($role);
        $model->role = jsonEncode($role);
        $model->update();
        $redisKey = RedisKey::$roleList . $uid;
//        $getDraw = $redis->del($redisKey);
        $redis->del($redisKey);
        return true;
    }

    public function rightNumToRole($uid, $rightNum = 0)
    {
        try {
            if (empty($rightNum) || empty($uid)) {
                return false;
            }
            if ($rightNum % 50 != 0) {
                return false;
            }
            $maxRole = $this->allRole($uid, 1);
            if ($maxRole >= 2) {
                $randHit = mt_rand(1, $maxRole - 1);
            } else {
                $randHit = 1;
            }
            RoleLogic::getInstance()->addRole($uid, $randHit);
        } catch (Exception $e) {
        }
    }

    public function allRole($uid, $type)
    {
        if (empty($uid)) {
            return false;
        }
        $redis = $this->getDI()->get('redis');
        $redisKey = RedisKey::$roleList . $uid;
//        $getDraw = $redis->del($redisKey);
        $getDraw = $redis->get($redisKey);
        if (!empty($getDraw)) {
            if ($type) {
                $getDrawArr = json_decode($getDraw, 1);
                if (!empty($getDrawArr)) {
                    return (int)max(array_column($getDrawArr, 'type'));
                } else {
                    return 0;
                }
            } else {
                return json_decode($getDraw, 1);
            }
        }
        $condition = array(
            'conditions' => 'uid= :uid:',
            'bind' => array('uid' => $uid),
        );

        $model = Role::findFirst($condition);
        if (empty($model)) {
            return false;
        }
        if (!empty($model->role)) {
            $role = json_decode($model->role, 1);
        } else {
            $role = [];
        }
        $show = [];
        foreach ($role as $k => $v) {
            $show[] = ['type' => $k, 'num' => $v];
        }
        $redis->set($redisKey, jsonEncode($show), 86400 * 8);
        if ($type) {
            return $show ? (int)max(array_column($show, 'type')) : 0;
        } else {
            return $show;
        }
    }


}