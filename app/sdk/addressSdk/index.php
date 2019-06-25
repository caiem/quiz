<?php
/**
 * 用户接口SDK入口文件
 * wiki.corp.mama.cn/pages/viewpage.action?pageId=557081
 *
 * User: vincent.cao
 * Date: 14-5-4
 * Time: 上午9:57
 */

//require('init.php');
require(dirname(__FILE__) . '/init.php');
/**
 * 修改成绝对路径形式引入文件:
 * 根据include的机制:
 * 如果include没有指定目录位置,只给了文件名称,则优先在 include_path 下寻找文件,如果没找到该文件则。include 最后才在调用脚本文件所在的目录和当前工作目录下寻找
 * 
 * 为避免受到使用sdk包的应用的php.ini中的include_path影响,所以修改成绝对路径调用
 * by wangtao 2015.4.25
 * --------------------------------------------------------------
 */
class AddressSdkIndex
{

    private static $_instance = array();

    public static function factory($sdkName)
    {

        $sdkFile = ADDRESSSDK_PATH . 'sdk/' . $sdkName.'.php';
        if(!file_exists($sdkFile))
        {
            exit('The '.$sdkName.' file is not exist!');
        }

        require_once $sdkFile;
        $sdkClassName = ucfirst($sdkName);
        if (class_exists($sdkClassName))
        {
            return self::getInstance($sdkClassName);
        } else
        {
            exit('Sdk class is not exist!');
        }
    }


    private static function getInstance($sdkClassName) {
        if (!isset(self::$_instance[$sdkClassName])) {
            self::$_instance[$sdkClassName] = new $sdkClassName();
        }
        return self::$_instance[$sdkClassName];
    }

    public static function readLog($num, $date)
    {
//        $logger = new Log();
        $logger = new AddressSdkLog();/*by wantao：调用方比如thinkphp(天使盒子)那边调用的时候有个同名的Log类,导致重定义错误,所以对sdk的类名称加前缀AddressSdkLog,以避免以后类似问题,其他类命名会慢慢边做边修改*/
        $logger->readLog($num, $date);
    }

}