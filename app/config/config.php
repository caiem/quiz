<?php

defined('APP_PATH') || define('APP_PATH', realpath('.') . '/app');
defined('MLOG_PATH') || define('MLOG_PATH', '/data/logs/phpfpm');

date_default_timezone_set('Asia/Shanghai');

return array(
    'database' => array(
        'adapter' => 'Mysql',
        'host' => env('DB_HOST', '127.0.0.1'),
        'port' => 3306,
        'username' => env('DB_USERNAME', 'root'),
        'password' => env('DB_PASSWORD', 'root'),
        'dbname' => 'quiz',
        'charset' => 'utf8',
    ),
    'application' => array(
        'controllersDir' => APP_PATH . '/controllers/',
        'modelsDir' => APP_PATH . '/models/',
        'viewsDir' => APP_PATH . '/views/',
        'pluginsDir' => APP_PATH . '/plugins/',
        'logsDir' => MLOG_PATH.'/',
        'libDir' => APP_PATH . '/lib/',
        'exceptionDir' => APP_PATH . '/library/exception/',
        'cacheDir' => APP_PATH . '/cache/',
        'logicsDir' => APP_PATH . '/logics/',
        'toolsDir' => APP_PATH . '/tools/',
        'curlDir' => APP_PATH . '/curl/',
        'enumDir' => APP_PATH . '/enum/',
    ),
    'redis' => array(
        'host' => env('REDIS_HOST', ''),
        'password' => env('REDIS_PASSWORD', ''),
        'port' => env('REDIS_PORT', 7003),
        'timeout' => 2,
        'database' => 12,
    ),

);
