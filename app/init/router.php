<?php
namespace App\Init;
use Phalcon\Mvc\Router;
/**
 * 路由初始化
 * @author Teeva
 * 
 */
class RouterInit{
	protected static $router;

	/*
	 * 初始化路由器
	 * @access public static
	 * @return \Phalcon\Mvc\Router
	 */
	public static function run(){
//		if(empty(self::$router)){
//			self::$router = new Router();
//		}

		$router = new Router();
        $router->setUriSource(Router::URI_SOURCE_SERVER_REQUEST_URI);
		$routes_config = \Common::importConfigFile(APP_PATH.'/config/routes.php');
		foreach ($routes_config as $routes){
			$router->add($routes['pattern'],$routes['paths']);
		}
        $router->handle();
        return $router;
	}
}