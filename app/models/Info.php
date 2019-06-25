<?php

use Phalcon\Mvc\Model;

class Info extends Model
{
    public $id, $uid, $coin, $levelUpdateTime, $level, $package, $first_sign;

    public function initialize()
    {
        $this->useDynamicUpdate(true);
        $this->setSource($this->getSource());
    }

    public static $default = ['1' => 1];
    public static $packageIds = [
        1, 2,
    ];

    public static $addMoneyCard = 1;
    public static $addScoreCard = 2;
    public static $protectStarCard = 3;

    CONST RANK_SEP_KEY = '{,s^}';


    public function getSource()
    {
        return 'info';
    }

    public function afterSave()
    {
        if ($this->uid) {
            $redis = $this->getDI()->get('redis');
            try {
                $redis->del(RedisKey::$packageInfo . $this->uid);
            } catch (Exception $e) {

            }
        }
    }

    public function afterDelete()
    {

    }

    public static function getRankStart($level)
    {
        $rank = intval($level / 6);
        $start = intval($level % 6);

        if ($rank >= 7) {
            $rank = 7;
        }
        return [$rank, $start];
    }

    public static function needLowerRank($level)
    {
        list($rank, $start) = self::getRankStart($level);
        if ($rank > User::CANT_REDUCE_RANK && $start == 0) {
            return true;
        }
        return false;
    }

    public static function rankStartToLevel($string)
    {
        $fp = mb_strpos($string, 'I');
        $rank = mb_substr($string, 0, $fp);
        $rank = User::RANK_TO_LEVEL[$rank];

        $start = mb_substr($string, $fp);
        $start = trim($start, '星');
        $start = substr_count($start, 'I');
        return [$rank, $start];
    }


}