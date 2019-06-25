<?php

use Phalcon\Mvc\Model;

class Retain extends Model
{
    public $id, $date, $threeday, $sevenday, $thrityday, $loginuser,$yesterday,$adduser;

    public function initialize()
    {
        $this->useDynamicUpdate(true);
        $this->setSource($this->getSource());
    }
}