<?php
class AuthToken{

    public static $tokenList = array(
        //key和secret是32位的md5
        'luke' => array(
            'app_id' => '1',
            'client' => 'luke.mama.cn',
            'secret' => '04e18ad6b0da5c22ab092dcb0667097c',
        ),
        'dsp' => array( //用于点击及pv链接的验签
            'app_id' => '2',
            'client' => 'ad.service.mama.cn',
            'secret' => '5eb282b0deagdf24252f42af015967b4',
        )
    );
}