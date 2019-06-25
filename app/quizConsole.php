<?php

use Phalcon\Di\FactoryDefault\Cli as CliDI,
    Phalcon\Cli\Console as ConsoleApp;
use Phalcon\Db\Adapter\Pdo\Mysql as DbAdapter;

// 使用CLI工厂类作为默认的服务容器
$di = new CliDI();

// 定义应用目录路径
defined('APPLICATION_PATH')
|| define('APPLICATION_PATH', realpath(dirname(__FILE__)));

define('APP_PATH', realpath(dirname(__FILE__)));
define('CONF_PATH', APP_PATH . "/config");
//echo APP_PATH.PHP_EOL;
require dirname(APP_PATH) . '/vendor/autoload.php';
define('Lib', APP_PATH . '/lib');
define('TASK_PATH', APP_PATH . '/tasks');

require Lib . '/common.php';

define('IS_TEST', env('ENV') == 'DEV' ? true : false);

require APP_PATH . '/../vendor/autoload.php';

if (IS_TEST) {
    error_reporting(E_ALL ^ E_NOTICE ^ E_WARNING);
    ini_set('display_errors', true);
} else {
    error_reporting(E_ERROR | E_PARSE);
}

/**
 * 注册类自动加载器
 */
$loader = new \Phalcon\Loader();
$loader_config = \Common::importConfigFile(APP_PATH . '/config/loader.php');
$normal_config = $loader_config['normal'];
$normal_config = array_merge($normal_config, [TASK_PATH]);
$loader->registerDirs($normal_config)->register();

$config = Common::importConfigFile(CONF_PATH . "/config.php");    //加载配置

require Lib . '/Mlogger/MLogger.php';
require Lib . '/Mlogger/Logger.php';

$di->setShared('db', function () use ($config) {
    $dbConfig = $config['database'];
    $class = 'Phalcon\Db\Adapter\Pdo\\' . $dbConfig['adapter'];
    unset($dbConfig['adapter']);
    $dbConfig['persistent'] = true;
    return new $class($dbConfig);
});
$di->setShared('redis', function () use ($config) {
    if (mb_strpos($config['redis']['port'], ',')) {
        $_posrArr = explode(',', $config['redis']['port']);
        $cluster = [];
        foreach ($_posrArr as $p) {
            $cluster[] = $config['redis']['host'] . ':' . $p;
        }
        return new \RedisCluster(null, $cluster, 5, 10, true);
    } else {
        $redis = new \Redis();
        $redis->pconnect($config['redis']['host'], $config['redis']['port'], isset($config['redis']['timeout']) ? $config['redis']['timeout'] : 2);
        !empty($config['redis']['password']) && $redis->auth($config['redis']['password']);
        $redis->select($config['redis']['database']);
        return $redis;
    }
});

// 创建console应用
$console = new ConsoleApp();
$console->setDI($di);

return $console;