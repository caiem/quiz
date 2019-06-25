<?php

use Phalcon\Mvc\Model;

class Friend extends Model
{
    public $id,$from_uid,$to_uid;
    public function initialize()
    {
        $this->useDynamicUpdate(true);
        $this->setSource($this->getSource());
    }

    public function getSource()
    {
        return 'friend';
    }

    public static function addFriend($from, $to)
    {
        if (empty($from) || empty($to)) {
            return false;
        }

        try {
            $model = new self();
            $model->from_uid = (int)$from;
            $model->to_uid = (int)$to;
            $model->create();
        } catch (Exception $e) {

        }

    }

}