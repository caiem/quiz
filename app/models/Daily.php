<?php

use Phalcon\Mvc\Model;

class Daily extends Model
{

    public $uid, $data, $sign, $draw_get;

    public function initialize()
    {
        $this->useDynamicUpdate(true);
        $this->setSource($this->getSource());
    }

    public function getSource()
    {
        return self::tableName();
    }

    public static function tableName()
    {
        return 'daily';
    }

    CONST DEFAULT_GITT = [
        'img' => 'https://images.vrm.cn/2019/04/04/smlw.png',
        'url' => 'https://quan.mx/d6Q5',
    ];

    public static function makeDrawShow($arr)
    {
        if (!empty($arr['get']) && is_array($arr['get'])) {
            $tmp = [];
            foreach ($arr['get'] as $v) {
                if ($v == 'secretGift') {
                    $tmp[] = ['t' => $v,
                        'u' => self::DEFAULT_GITT['url'],
                        'i' => self::DEFAULT_GITT['img'],
                    ];
                } else {
                    $tmp[] = ['t' => $v];
                }
            }
            $arr['get'] = $tmp;
        }
        return $arr;
    }

    public static function getNewHit($data)
    {
        $hit = 1;
        unset($data[APP_TODAY()]);
        $dk = array_keys(array_filter($data));
        sort($dk);
        $lastDay = end($dk);

//        ve($dk);
        $diff = (strtotime(APP_TODAY()) - strtotime($lastDay)) / 86400;
        if ($diff >= 7) {
            return $hit;
        }
        $recentHit = $data[$lastDay];

        $hit = $recentHit + $diff;
        if ($hit <= 0) {
            return 1;
        }
        if ($hit <= 7) {
            return $hit;
        }
        return $hit % 7;
    }


    public static function filterArray($data, $dayLong = 60)
    {
        if (count($data) > $dayLong) {
            ksort($data);
            $toDay = APP_TODAY();
            $logestDay = strtotime($toDay) - 86400 * $dayLong;
            foreach ($data as $_k => $_v) {
                if (strtotime($_k) < $logestDay) {
                    unset($data[$_k]);
                }
            }
        }
        return $data;
    }

}