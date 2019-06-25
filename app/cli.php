<?php

use Phalcon\DI\FactoryDefault\CLI as CliDI;
use Phalcon\CLI\Console as ConsoleApp;
use Phalcon\Config\Adapter\Ini as ConfigIni;

$di = new CliDI();

define('APPLICATION_PATH', realpath(dirname(__FILE__)));
define('APP_PATH', realpath(dirname(__FILE__)));
!defined('CONF_PATH') && define('CONF_PATH', APP_PATH . "/config");
define('Lib', APP_PATH . '/lib');
define('TASK_PATH', APP_PATH . '/tasks');    //Task路径
require dirname(APP_PATH) . '/vendor/autoload.php';
require Lib . '/common.php';

$config = Common::importConfigFile(CONF_PATH . "/config.php"); //加载配置
require Lib . '/Mlogger/MLogger.php';
require Lib . '/Mlogger/Logger.php';

/* * ** 定义运行环境 *** */
define('IS_TEST', env('ENV') == 'DEV' ? true : false);

if (!IS_TEST) {
    error_reporting(0);
} else {
    error_reporting(E_ALL);
    ini_set('display_errors', true);
}


try {
    $loader = new \Phalcon\Loader();
    $loader_config = \Common::importConfigFile(APP_PATH . '/config/loader.php');
    $normal_config = $loader_config['normal'];
    $normal_config = array_merge($normal_config, [TASK_PATH]);
    $loader->registerDirs($normal_config)->register();

    $di->setShared('view', function () use ($config) {
        $view = new Phalcon\Mvc\View();
        $view->setViewsDir(TASK_PATH . '/views');
        $view->registerEngines(
            array(
                '.volt' => function ($view, $di) use ($config) {
                    $volt = new Phalcon\Mvc\View\Engine\Volt($view, $di);
                    $volt->setOptions(array(
                        'compiledPath' => $config['application']['cacheDir'],
                        'compiledSeparator' => '_'
                    ));
                    return $volt;
                },
                '.phtml' => 'Phalcon\Mvc\View\Engine\Php'
            ));
        return $view;
    });

    $di->setShared('db', function () use ($config) {
        $dbConfig = $config['database'];
        $class = 'Phalcon\Db\Adapter\Pdo\\' . $dbConfig['adapter'];
        unset($dbConfig['adapter']);
        return new $class($dbConfig);
    });
    $di->setShared('redis', function () use ($config) {
        if (mb_strpos($config['redis']['port'], ',')) {
            $_posrArr = explode(',', $config['redis']['port']);
            $cluster = [];
            foreach ($_posrArr as $p) {
                $cluster[] = $config['redis']['host'] . ':' . $p;
            }
            return new \RedisCluster(null, $cluster);
        } else {
            $redis = new \Redis();
            $redis->pconnect($config['redis']['host'], $config['redis']['port'], isset($config['redis']['timeout']) ? $config['redis']['timeout'] : 2);
            !empty($config['redis']['password']) && $redis->auth($config['redis']['password']);
            $redis->select($config['redis']['database']);
            return $redis;
        }
    });
    $di->setShared('logger', function () {
        //    $file = APP_PATH.'/logs/'.date('Y-m-d').'.log';
        //    $logger = new Phalcon\Logger\Adapter\File( $file );
        $logger = new MLogger();
        return $logger;
    }
    );
    $di->setShared('modelsMetadata', function () {
        return new Phalcon\Mvc\Model\Metadata\Memory();
    });

    $Console = new ConsoleApp();
    $Console->setDI($di);

    //命令行参数
    $arguments = array();
    $params = array();

    foreach ($argv as $k => $arg) {
        if ($k == 1) {
            $arguments['task'] = $arg;
        } elseif ($k == 2) {
            $arguments['action'] = $arg;
        } elseif ($k >= 3) {
            $params[] = $arg;
        }
    }
    if (count($params) > 0) {
        $arguments['params'] = $params;
    }

    define('CURRENT_TASK', (isset($argv[1]) ? $argv[1] : null));
    define('CURRENT_ACTION', (isset($argv[2]) ? $argv[2] : null));

    $Console->handle($arguments);
} catch (\Exception $e) {
    if ($di->getShared('logger')) {
        $di->getShared('logger')->error('CLI Error[' . $e->getFile() . ':' . $e->getLine() . ']: ' . $e->getMessage());
    }
    echo $e->getMessage() . "\r\n";
}
