<?php
/**
 * User: wudiandian
 * Date: 16-12-16
 * Time: 下午4:55
 */

define('ADDR_APP_VERSION', '1.0');
//开启debug模式
define('ADDRESS_SDK_DEBUG', isset($_GET['debug']) && $_GET['debug']==1);/*by wangtao 常量名称改为ADDRESS_SDK_DEBUG,以避免与其他框架中APP_DEBUG的常量冲突*/

//define('ADDRESS_SDK_DEBUG', 1);

//是否跳过签名验证（须在debug模式下）
define('ADDR_TOKEN_DEBUG', false);


//PHP配置
date_default_timezone_set('Asia/Shanghai');

//定义根目录
define('ADDRESSSDK_PATH', str_replace('\\', '/', str_replace('init.php', '', __FILE__)));

//日志主目录
define('ADDRESS_SDK_LOG_PATH', ADDRESSSDK_PATH . 'log/');
define('ADDRESS_SDK_LOG_INFO_FLAG', true);//是否记录INFO日志
define('ADDRESS_SDK_LOG_INFO_TYPE', 'file');//日志存放类型：支持file和memcache，memcache保存最近15天内的10000条日志

require(ADDRESSSDK_PATH.'library/AddressSdkBase.php');/*把类名称改掉,加前缀,因为出现过与调用方重名base类的情况*/
require(ADDRESSSDK_PATH.'library/AddressSdkLog.php');
