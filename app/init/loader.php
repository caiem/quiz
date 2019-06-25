<?php
namespace App\Init;
use Phalcon\Loader;
/**
 * 文件加载器初始化
 * @author Teeva
 *
 */
class LoaderInit{
	protected static $loader;
	
	/*
	 * 注册文件加载树
	 * @access public static
	 * @return \Phalcon\Loader
	 */
	public static function run(){
		if(!isset(self::$loader)){
			self::$loader = new \Phalcon\Loader();
		}
		$loader = self::$loader;
		$loader_config = \Common::importConfigFile(APP_PATH.'/config/loader.php');
		$namespace_config = $loader_config['namespace'];
		$normal_config = $loader_config['normal'];
		$loader->registerNamespaces($namespace_config)->register();
		$loader->registerDirs($normal_config)->register();
		return $loader;
	}
}