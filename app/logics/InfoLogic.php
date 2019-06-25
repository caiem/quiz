<?php

class InfoLogic extends Logic
{
    public $_tip = '';

    public function getPackage($uid)
    {
        $redis = $this->getDI()->get('redis');
        $redisKey = RedisKey::$packageInfo . $uid;

//        $package = $redis->del($redisKey);//tmp
        $package = $redis->hgetall($redisKey);

        if (!empty($package)) {
            return $package;
        }
        $condition = array(
            'conditions' => 'uid= :uid:',
            'bind' => array('uid' => $uid),
            'columns' => 'package'
        );

        $infoModel = Info::findFirst($condition);
        $package = json_decode($infoModel->package, 1);
        empty($package) && $package = [];
        $redis->hmset($redisKey, $package);
        $redis->expire($redisKey, 86400 * 15);

        return $package;
    }

    public function usePackage($uid, $packageId)
    {
        if (empty($uid)) {
            return false;
        }
        $redis = $this->getDI()->get('redis');
        $redisKey = RedisKey::$packageInfo . $uid;

        $package = $this->getPackage($uid);
        if (empty($package[$packageId]) || $package[$packageId] <= 0) {
            $this->_tip = '数量不足';
            return false;
        }
        $redis->HINCRBY($redisKey, $packageId, -1);

        $condition = array(
            'conditions' => 'uid= :uid:',
            'bind' => array('uid' => $uid),
        );

        $infoModel = Info::findFirst($condition);
        if (!empty($infoModel->package)) {
            $packageInfo = json_decode($infoModel->package, 1);
            if (!empty($packageInfo[$packageId]) && $packageInfo[$packageId] >= 1) {
                $packageInfo[$packageId] = $packageInfo[$packageId] - 1;
                $infoModel->package = jsonEncode($packageInfo);
                $infoModel->save();
            }
        }

        switch ($packageId) {
            case 2:
                $setKey = RedisKey::$addScoreCard . $uid;
                $redis->set($setKey, 3);
                break;
            case 1:
                $setKey = RedisKey::$addMoneyCard . $uid;
                $redis->set($setKey, 5);
                break;
            default:
                break;
        }

        return ['left' => $package[$packageId] - 1];
    }

    public function incrCard($uid, $type, $num)
    {
        $condition = array(
            'conditions' => 'uid= :uid:',
            'bind' => array('uid' => $uid),
        );
        $infoModel = Info::findFirst($condition);
        if (!empty($infoModel->package)) {
            $packageInfo = json_decode($infoModel->package, 1);
        } else {
            $packageInfo = [];
        }
        $packageInfo[$type] = (isset($packageInfo[$type]) ? $packageInfo[$type] : 0) + $num;
        $infoModel->package = jsonEncode($packageInfo);
        if ($infoModel->save() === false) {
            return false;
        }
        $redis = $this->getDI()->get('redis');
        $redisKey = RedisKey::$packageInfo . $uid;
        $redis->del($redisKey);
        return true;
    }

    public function getRank($uid)
    {
        $redis = $this->getRedis();
        $selfInfo = UserLogic::getInstance()->getInfo($uid);
        if (empty($selfInfo['name'])) {
            return [];
        }
        $appKey = $selfInfo['app'];
        //$redis->del(RedisKey::RANK_SORT . $appKey);//tmp
        $all = $redis->zRevRange(RedisKey::RANK_SORT . $appKey, 0, 100, true);
        if (empty($all)) {
            $this->initRank();
            $all = $redis->zRevRange(RedisKey::RANK_SORT . $appKey, 0, 100, true);
        }
        $zRank = $redis->ZREVRANK(RedisKey::RANK_SORT . $appKey, $this->makeRankKey($uid, $selfInfo['name'], $selfInfo['img']));
//        var_dump($zRank);
        if ($zRank === false) { //不在1000名内
            $redis->zAdd(RedisKey::RANK_SORT . $appKey, (int)$selfInfo['level'], $this->makeRankKey($uid, $selfInfo['name'], $selfInfo['img']));
            $zRank = $redis->ZREVRANK(RedisKey::RANK_SORT . $appKey, $this->makeRankKey($uid, $selfInfo['name'], $selfInfo['img']));
//            var_dump($zRank);
        }

        $data = [];
        $rank = 1;
        $selfRank = $zRank + 1;
        foreach ($all as $v => $k) {
            list($_uid, $_name, $_img) = explode(Info::RANK_SEP_KEY, $v);
            if ($_uid == $uid) {
                $selfRank = $rank;
            }
            $data[] = [
                'level' => $k,
                'name' => $_name,
                'img' => $_img,
                'rank' => $rank++,
            ];
        }
        $lastReturn = ['list' => $data, 'self' => [
            'level' => $selfInfo['level'],
            'name' => $selfInfo['name'],
            'img' => $selfInfo['img'],
            'rank' => $selfRank,
        ]];

        return $lastReturn;
    }

    public function makeRankKey($uid, $name, $img)
    {
        return implode(Info::RANK_SEP_KEY, [$uid, $name, $img]);
    }

    public function initRank()
    {
        $redis = $this->getRedis();
        $limit = 1000 * 2;
        /*$condition = [];
        $condition["limit"] = $limit;
        $condition["offset"] = 0;
        $condition['order'] = 'level desc,levelUpdateTime DESC';
        $condition['columns'] = 'uid,level';
        $data = \Info::find($condition)->toArray();

        $uids = array_column($data, 'uid');

        $condition = array(
            'conditions' => 'uid IN({uid:array})',
            'bind' => array('uid' => $uids),
            'cloumns' => 'uid,name,img'
        );
        $udata = \User::find($condition)->toArray();
        $utoname = [];
        foreach ($udata as $v) {
            $utoname[$v['uid']] = $v;
        }*/

        foreach (IS_TEST ? Config::KEY_MAP_TEST : Config::KEY_MAP as $key_ => $_) {
            $redis->del(RedisKey::RANK_SORT_TMP . $key_);
        }
        $sql = "SELECT info.uid,level,name,img,appkey from info LEFT JOIN `user` on info.uid=`user`.uid ORDER BY level desc,levelUpdateTime ASC limit {$limit}";
        $data = $this->getDb()->fetchAll($sql);

        foreach ($data as $v) {
            $newKey = $this->makeRankKey($v['uid'], $v['name'], $v['img']);
            $_res = $redis->zAdd(RedisKey::RANK_SORT_TMP . $v['appkey'], (int)$v['level'], $newKey);
        }
        foreach (IS_TEST ? Config::KEY_MAP_TEST : Config::KEY_MAP as $key_ => $_) {
            $_res = $redis->rename(RedisKey::RANK_SORT_TMP . $key_, RedisKey::RANK_SORT . $key_);
        }
    }

    public function getRankOld($uid, $page)
    {
        $redis = $this->getDI()->get('redis');
        $redisKey = RedisKey::$rankList . $uid;
//        $data = $redis->del($redisKey);
        $data = $redis->get($redisKey);
//ve($data);
        if (!empty($data)) {
            return json_decode($data, 1);
        }

//        $allData = $redis->del(RedisKey::$rankListAll);
        $allData = $redis->get(RedisKey::$rankListAll);
//        ve($allData);
        if (empty($allData)) {
            $limit = 100;
            $condition = [];
            $condition["limit"] = $limit;
            $condition["offset"] = ($page - 1) * $limit;
            $condition['order'] = 'level desc,levelUpdateTime ASC';
            $condition['columns'] = 'uid,level';
            $data = \Info::find($condition)->toArray();

            if (!empty($data)) {
                $uids = array_column($data, 'uid');

                $condition = array(
                    'conditions' => 'uid IN({uid:array})',
                    'bind' => array('uid' => $uids),
                    'cloumns' => 'uid,name,img'
                );
                $udata = \User::find($condition)->toArray();
                $utoname = [];
                foreach ($udata as $v) {
                    $utoname[$v['uid']] = $v;
                }
                $rank = ($page - 1) * $limit;
                foreach ($data as $k => $v) {
                    $data[$k]['name'] = isset($utoname[$v['uid']]) ? $utoname[$v['uid']]['name'] : '';
                    $data[$k]['img'] = isset($utoname[$v['uid']]) ? $utoname[$v['uid']]['img'] : '';
                    $data[$k]['rank'] = ++$rank;
                }
            }
            $redis->set(RedisKey::$rankListAll, jsonEncode($data ? $data : []), 1800);
        } else {
            $data = json_decode($allData, 1);
        }

//        ve($data);
        foreach ($data as $dk => $dv) {
            unset($data[$dk]['uid']);
        }
        $self = $this->initSelf($uid);
        $lastreturn = ['list' => $data, 'self' => $self];
//        ve($lastreturn);
        $redis->set($redisKey, jsonEncode($lastreturn), 1800);
        return $lastreturn;
    }

    public function initSelf($uid)
    {
        $connection = $this->getDI()->get('db');
        $person = $connection->query("SELECT
	b.*
FROM
	(
		SELECT
			t.*, @rownum := @rownum + 1 AS rownum
		FROM
			(SELECT @rownum := 0) r,
			(
				 SELECT uid from `info` ORDER BY level desc,levelUpdateTime ASC
			) AS t
	) AS b
WHERE
	b.uid =" . (int)$uid)->fetchArray();
        $self = [];
        if (!empty($person)) {

            $uinfo = UserLogic::getInstance()->getInfo($uid);

            $self = [
//                'uid' => $person['uid'],
                'level' => $uinfo['level'],
                'img' => $uinfo['img'],
                'name' => $uinfo['name'],
                'rank' => $person['rownum'],
            ];
        }
        return $self;
    }

//$type=incr decr
    public function updateLevel($uid, $type)
    {
        if (empty($uid)) {
            return false;
        }
        $rediskey = RedisKey::getUserInfoKey($uid);

        $redis = $this->getDI()->get('redis');
        $condition = array(
            'conditions' => 'uid= :uid:',
            'bind' => array('uid' => $uid),
            'columns' => 'level'
        );
        $infoModel = Info::findFirst($condition);
        list($rank, $start) = Info::getRankStart($infoModel->level);
        $connection = $this->getDI()->getShared('db');
        $sql = '';
        if ($type == 'decr') {
            if (!empty($infoModel->level)) {
                if ($rank > 2) {
                    if ($start == 0) {
                        $sql = "update `info` set `levelUpdateTime`=" . APP_TIME() . ",`level` = IF(`level`<2,0,`level`-2) WHERE `uid` = " . $uid;
                    } else {
                        $sql = "update `info` set `levelUpdateTime`=" . APP_TIME() . ",`level` = IF(`level`<1,0,`level`-1) WHERE `uid` = " . $uid;
                    }
                } else {
                    if ($start > 0) {
                        $sql = "update `info` set `levelUpdateTime`=" . APP_TIME() . ",`level` = IF(`level`<1,0,`level`-1) WHERE `uid` = " . $uid;
                    }
                }
            }
        } else {//add
            if ($rank < 7) {
                if ($start < 5) {
                    $sql = "update `info` set `levelUpdateTime`=" . APP_TIME() . ",`level` = `level`+1 WHERE `uid` = {$uid}";
                } else {
                    $sql = "update `info` set `levelUpdateTime`=" . APP_TIME() . ",`level` = `level`+2 WHERE `uid` = {$uid}";
                }
            } else {
                $sql = "update `info` set `levelUpdateTime`=" . APP_TIME() . ",`level` = `level`+1 WHERE `uid` = {$uid}";
            }
        }

        if ($sql) {
            try {
                $_upres = $connection->execute($sql);
            } catch (Exception $e) {
                $connection->connect();
                $_upres = $connection->execute($sql);
            }
            $redis->del($rediskey);
            $selfInfo = UserLogic::getInstance()->getInfo($uid);
            if (!empty($selfInfo['name'])) {
                $redis->zAdd(RedisKey::RANK_SORT . $selfInfo['app'], (int)$selfInfo['level'], $this->makeRankKey($uid, $selfInfo['name'], $selfInfo['img']));
            }
        }
        return true;
    }


}