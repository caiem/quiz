<?php

class CountLogic extends Logic
{

    public function incrCount($key, $num = 1)
    {
        if(empty($key) || empty($num)){
            return false;
        }
        $key=$key . APP_TODAY();
        $_t = $this->getRedis()->incr($key, $num);
        if ($_t <= 10) {
            $this->getRedis()->expire($key, 86400 * 4);
        }
    }

    public function countUser($type)
    {

    }
}