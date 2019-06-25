<?php
/***
 * 业务逻辑层基类
 * 
 * @author Administrator
 *
 */
class Logic implements \Phalcon\Di\InjectionAwareInterface{
	
    /**
     * @var $di
     */
    protected $di;

    /**
     * Sets the dependency injector
     *
     * @param mixed $dependencyInjector
     */
    public function setDI(\Phalcon\DiInterface $dependencyInjector){
        $this->di = $dependencyInjector;
    }

    /**
     * Returns the internal dependency injector
     *
     * @return \Phalcon\DiInterface
     */
    public function getDI(){
        return $this->di;
    }
    
    public final function __construct(){
        if (method_exists($this, "onConstruct")) {
            $this->onConstruct();
        }
    }
    
    /**
     * 实例化逻辑层并注入到DI
     * @access public
     * @param bool $isNewInstance	是否创建独立对象；默认为false，单例
     * @return $this
     */
    public static function getInstance($isNewInstance = false){
		$className = get_called_class();
        $defaultDi = \Phalcon\Di::getDefault();
        $classObj = ($isNewInstance === false) ? $defaultDi->getShared($className) : $defaultDi->get($className);
        return $classObj;
    }

    public function getTimeDiff($day1,$day2){
        return (strtotime($day1)-strtotime($day2))/86400;
    }

    public function getDb(){
      return  $this->di->getShared('db');
    }

    public function getRedis(){
      return  $this->di->getShared('redis');
    }
}
