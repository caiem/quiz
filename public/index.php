<?php

use Phalcon\Loader;
use Phalcon\Mvc\View;
use Phalcon\Mvc\Application;
use Phalcon\Di\FactoryDefault;
use Phalcon\Mvc\Url as UrlProvider;
use Phalcon\Db\Adapter\Pdo\Mysql as DbAdapter;

define('APP_PATH', dirname(__DIR__) . '/app');
define('CONF_PATH', APP_PATH . "/config");
define('Lib', APP_PATH . '/lib');

require Lib . '/common.php';
define('IS_TEST', env('ENV') == 'DEV' ? true : false);

define('APP_URL', isset($_SERVER['HTTP_X_FORWARDED_HOST']) ? $_SERVER['HTTP_X_FORWARDED_HOST'] : (isset($_SERVER['HTTP_HOST']) ? $_SERVER['HTTP_HOST'] : ''));
require APP_PATH . '/../vendor/autoload.php';

require Lib . '/Mlogger/MLogger.php';
require Lib . '/Mlogger/Logger.php';

if (IS_TEST) {
    error_reporting(E_ALL ^ E_WARNING);
    ini_set('display_errors', true);
} else {
    ini_set('display_errors', false);
    error_reporting(E_ERROR | E_PARSE);
}

try {

    $config = Common::importConfigFile(CONF_PATH . "/config.php");    //加载配置

    Common::importFile(APP_PATH . "/init/loader.php");
    Common::importFile(APP_PATH . "/init/router.php");
    App\Init\LoaderInit::run();
    $router = App\Init\RouterInit::run();

    $di = new Phalcon\Di\FactoryDefault();

    /*    $di->setShared('url', function () use ($config) {
            $url = new Phalcon\Mvc\Url();
            $url->setBaseUri($config['application']['baseUri']);
            return $url;
        });*/

    $di->set(
        "url",
        function () {
            $url = new UrlProvider();
            $url->setBaseUri('/');
            return $url;
        }
    );

    $di->setShared('view', function () use ($config) {
        $view = new Phalcon\Mvc\View();
        $view->setViewsDir($config['application']['viewsDir']);
        $view->registerEngines(
            array(
                '.volt' => function ($view, $di) use ($config) {
                    $volt = new Phalcon\Mvc\View\Engine\Volt($view, $di);
                    $volt->setOptions(array(
                        'compiledPath' => $config['application']['cacheDir'],
                        'compiledSeparator' => '_'
                    ));
                    $volt->getCompiler()->addFunction('in_array', 'in_array');
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
        $dbConfig['persistent']=true;
        return new $class($dbConfig);
    });
    $di->setShared('redis', function () use ($config) {
        if (mb_strpos($config['redis']['port'], ',')) {
            $_posrArr = explode(',', $config['redis']['port']);
            $cluster = [];
            foreach ($_posrArr as $p) {
                $cluster[] = $config['redis']['host'] . ':' . $p;
            }
            return new \RedisCluster(null, $cluster,5,10,true);
        } else {
            $redis = new \Redis();
            $redis->pconnect($config['redis']['host'], $config['redis']['port'], isset($config['redis']['timeout']) ? $config['redis']['timeout'] : 2);
            !empty($config['redis']['password']) && $redis->auth($config['redis']['password']);
            $redis->select($config['redis']['database']);
            return $redis;
        }
    });
    $di->setShared('modelsMetadata', function () {
        return new Phalcon\Mvc\Model\Metadata\Memory();
    });

    $di->setShared('flash', function () {
        return new Phalcon\Flash\Direct(
            array(
                'error' => 'alert alert-danger',
                'success' => 'alert alert-success',
                'notice' => 'alert alert-info',
                'warning' => 'alert alert-warning'
            ));
    }
    );

    $di->setShared('logger', function () {
        $logger = new MLogger();
        return $logger;
    }
    );

    /*$di->setShared('session', function () {
        $session = new Phalcon\Session\Adapter\Files();
        $session->start();
        return $session;
    }
    );*/

    $di->setShared('file_cache', function () use ($config) {
        $frontCache = new \Phalcon\Cache\Frontend\Output(array(
            "lifetime" => 86400
        ));
        $cache = new \Phalcon\Cache\Backend\File($frontCache, array(
            'cacheDir' => $config['application']['cacheDir']
        ));
        return $cache;
    });

    $di->set('router', $router);
    $application = new Application($di);

    $response = $application->handle();

    $response->send();
} catch (\Phalcon\Mvc\Dispatcher\Exception $e) {
    Header("HTTP/1.1 404 Not Found");
} catch (\Exception $e) {
    $response = new \Phalcon\Http\Response();
    $response->setHeader('_Except', $e->getMessage());
    $response->setJsonContent(array("code" => -1, "msg" => '程序运行报错', "data" => false));
    $response->send();
}