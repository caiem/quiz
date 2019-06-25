<?php

use Phalcon\Mvc\Model;

class Role extends Model
{
    public static $roles = [
        1, 2, 3, 4, 5, 6, 7, 8, 9,
    ];

    const ROLE_COIN_ADD_RATE = [
        1 => 103 / 100,
        2 => 105 / 100,
        3 => 107 / 100,
        4 => 110 / 100,
        5 => 110 / 100,
        6 => 112 / 100,
        7 => 112 / 100,
        8 => 115 / 100,
        9 => 115 / 100,
    ];

    const ROLE_DRAW_ADD_RATE = [
        5 => 1,
        6 => 3,
        7 => 3,
        8 => 5,
        9 => 5,
    ];

    public $uid, $role;

    public function initialize()
    {
        $this->useDynamicUpdate(true);
        $this->setSource($this->getSource());
    }

    public function getSource()
    {
        return 'role';
    }


}