<?php
/**
 * 文件加载器配置
 */
return array(
    /***** 命名空间  ******/
    'namespace' => array(
        'Manage\Controller' => APP_PATH.'/admin/controllers',
        'Api\Controller' => APP_PATH.'/api/controllers'
    ),
    /***** 非命名空间（普通文件） *****/
    'normal' => array(
        APP_PATH.'/logics',
        APP_PATH.'/lib',
        APP_PATH.'/models',
        APP_PATH.'/enum',
        APP_PATH . '/rediskey',
        APP_PATH.'/sdk',
        APP_PATH.'/lib/curl',
        APP_PATH.'/advertiser'
    )
);