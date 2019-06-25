<?php

use Phalcon\Config\Adapter\Ini as ConfigIni;

defined('APP_PATH') || define('APP_PATH', realpath('.') . '/app');

function ve($d)
{
    var_dump($d);
    exit();
}

function va($d)
{
    echo '<pre>';
    var_dump($d);
}

function pe($d)
{
    echo '<pre>';
    print_r($d);
    exit();
}

function jsonEncode($d)
{
    return json_encode($d, JSON_UNESCAPED_UNICODE);

}

function env($d, $default = null)
{
    static $__env = [];
    if (empty($__env)) {
        $_env = dirname(APP_PATH) . '/.env';
        $config = new ConfigIni($_env);
        $__env = $config;
    }
    return isset($__env->$d) ? $__env->$d : $default;
}

function mSectime()
{
    list($t1, $t2) = explode(' ', microtime());
    $st = (float)sprintf('%.0f', (floatval($t1) + floatval($t2)) * 1000);
    return $st;
}

function isHTTPS()
{
    if (!isset($_SERVER)) return FALSE;
    if (!isset($_SERVER['HTTPS'])) return FALSE;
    if ($_SERVER['HTTPS'] === 1) {  //Apache
        return TRUE;
    } elseif ($_SERVER['HTTPS'] === 'on') { //IIS
        return TRUE;
    } elseif ($_SERVER['SERVER_PORT'] == 443) { //其他
        return TRUE;
    }
    return FALSE;
}

function setOrigin()
{
//    $slhttp = ((isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == 'on') || (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https')) ? 'https://' : 'http://';
    $slhttp = isHTTPS() ? 'https://' : 'http://';
    if (!empty($_SERVER['HTTP_ORIGIN']) && strpos($_SERVER['HTTP_ORIGIN'], Config::ALLOW_ORIGIN_TEST) !== false) {
        return $slhttp . Config::ALLOW_ORIGIN_TEST;
    } else {
        return $slhttp . Config::ALLOW_ORIGIN;
    }
}

function utf8ToGbk($line)
{
    if (is_array($line)) {
        foreach ($line as $keyd => $item) {
            $line[$keyd] = utf8ToGbk($item);
        }
    } elseif (is_string($line)) {
        $line = mb_convert_encoding($line, 'GB2312', 'UTF-8');
    }
    return $line;
}

function GbkToUtf8($line)
{
    if (is_array($line)) {
        foreach ($line as $keyd => $item) {
            $line[$keyd] = GbkToUtf8($item);
        }
    } elseif (is_string($line)) {
        if ($str = mb_detect_encoding($line, array("ASCII", "UTF-8", "GB2312", "GBK", "BIG5"))) {
            if ($str !== 'UTF-8') {
                $line = iconv($str, 'UTF-8', $line);
            }
        }
    }
    return $line;
}

function APP_TIME()
{
    static $___time;
    if (!empty($___time)) {
        return $___time;
    }
    if (PHP_SAPI == 'cli') {
        return time();
    }
    $___time = time();
    return $___time;
}

function APP_TODAY()
{
    static $___timeD;
    if (!empty($___timeD)) {
        return $___timeD;
    }
    if (PHP_SAPI == 'cli') {
        return date('Ymd');
    }
    $___timeD = date('Ymd');
    return $___timeD;
}

function weekStart()
{
    $today = APP_TODAY();
    $w = date('w');
    $weekStartTime = strtotime("{$today} -" . ($w ? $w - 1 : 6) . ' days');
    $weekStart = date('Ymd', $weekStartTime);
    return [$weekStartTime, $weekStart];
}

/**
 * 公共方法库
 * @author Teeva
 *
 */
class Common
{
    /**
     * 引入文件
     * @access static
     * @param string $filename 文件名
     * @return bool
     */
    public static function importFile($filename)
    {
        static $_importFiles = array();
        if (!isset($_importFiles[$filename])) {
            if (file_exists($filename)) {
                require_once $filename;
                $_importFiles[$filename] = true;
            } else {
                $_importFiles[$filename] = false;
            }
        }
        return $_importFiles[$filename];
    }

    /**
     * 引入配置文件
     * @access public static
     * @param string $filename
     * @return mixed array | false
     * @throws Exception
     */
    public static function importConfigFile($filename)
    {
        static $_importFiles = array();
        if (!isset($_importFiles[$filename])) {
            if (file_exists($filename)) {
                $ext = pathinfo($filename, PATHINFO_EXTENSION);
                switch ($ext) {
                    case 'php':
                        $config = require_once $filename;
                        break;
                    case 'ini':
                        $config = parse_ini_file($filename);
                        break;
                    case 'json':
                        $config = json_decode(file_get_contents($filename), true);
                        break;
                    case 'xml':
                        $config = (array)simplexml_load_file($filename);
                        break;
                    default:
                        throw new Exception('配置文件格式错误！');
                }
                $_importFiles[$filename] = $config;
            } else {
                $_importFiles[$filename] = false;
            }
        }
        return $_importFiles[$filename];
    }

    public static function curl_http($durl, $data = null, $tout = 30, $c_out = 3, $json = false)
    {
        if (empty($durl)) {
            return false;
        }
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $durl);
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, $c_out);
        curl_setopt($ch, CURLOPT_TIMEOUT, $tout);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_HEADER, false);
        if ($data) {
            curl_setopt($ch, CURLOPT_POST, 1);
            curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
        }
        if ($json) {
            curl_setopt($ch, CURLOPT_HTTPHEADER, array(
                    'Content-Type: application/json; charset=utf-8',
                )
            );
        }
        if (strstr($durl, 'https')) {
            curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
            curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
        }
        $r = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $errno = curl_errno($ch);
        curl_close($ch);

        return array(
            'code' => $httpCode,
            'content' => $r,
            'error' => $errno,
        );
    }

    public static function getClientIP()
    {
        if (getenv("HTTP_CLIENT_IP"))
            $ip = getenv("HTTP_CLIENT_IP");
        else if (getenv("HTTP_X_FORWARDED_FOR"))
            $ip = getenv("HTTP_X_FORWARDED_FOR");
        else if (getenv("REMOTE_ADDR"))
            $ip = getenv("REMOTE_ADDR");
        else $ip = "";
        return $ip;
    }

    /*
     * @param $low 安全别级低
     */
    public static function clean_xss(&$string, $low = true)
    {
        if (!is_array($string)) {
            $string = trim($string);
            $string = strip_tags($string);
            $string = htmlspecialchars($string);
            if ($low) {
                return True;
            }
            $string = str_replace(array('"', "\\", "'", "/", "..", "../", "./", "//"), '', $string);
            $no = '/%0[0-8bcef]/';
            $string = preg_replace($no, '', $string);
            $no = '/%1[0-9a-f]/';
            $string = preg_replace($no, '', $string);
            $no = '/[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]+/S';
            $string = preg_replace($no, '', $string);
            return True;
        }
        $keys = array_keys($string);
        foreach ($keys as $key) {
            self::clean_xss($string [$key]);
        }
    }


}