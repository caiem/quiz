<?php

/**
 * Description of Aiakos
 *
 * @author Administrator
 * @since 2017-7-7 12:24:15
 */
use Mmclib\Aiakos\Aiakos;

class MAiakos {
    /**
     * 
     * @param string $position 事件唯一标识
     * @param int $e_type 1-普通异常，2-致命异常
     */
    static $_notify_email = [
        'yousf@mama.cn'
    ];
    public static function alarm($position,$msg='',$e_type=1) {
        try{
            $tags = array(
                'project'=>'ad.sevice.mama.cn',
                'event'=>$position,
                '_base64_email'=> base64_encode( implode(',', self::$_notify_email) )
            );
            if( !empty($msg) ){
                $tags['msg'] = $msg;
            }
            Aiakos::alarm('exception',gethostname(), $e_type,  $tags, time(), 60);
        } catch ( \Exception $ex ){
            
        }
    }
}
