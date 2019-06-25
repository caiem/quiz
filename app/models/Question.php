<?php

use Phalcon\Mvc\Model;

class Question extends Model
{
    public $id,$q,$op1,$op2,$ans;
    public function initialize()
    {
        $this->useDynamicUpdate(true);
        $this->setSource($this->getSource());
    }

    public function getSource()
    {
        return 'question';
    }

    public function afterSave()
    {

    }

    public function afterDelete()
    {

    }

}