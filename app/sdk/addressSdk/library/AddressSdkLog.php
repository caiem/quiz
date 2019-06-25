<?php

/* 把类名称从Log修改为AddressSdkLog,避免调用sdk的应用也有同名的类,导致重定义错误 */

class AddressSdkLog {

    protected $_logger;
    protected $_log_path;
    protected $_threshold = 1;
    protected $_date_fmt = 'Y-m-d H:i:s';
    protected $_enabled = TRUE;
    protected $_levels = array('ERROR' => '1', 'DEBUG' => '2', 'INFO' => '3');
    protected static $_mem = null;
    protected $_mem_key = 'member_sdk_log';

    public function __construct($config = array()) {
        $this->_type = ADDRESS_SDK_LOG_INFO_TYPE;
        if ($this->_type == 'memcache') {
            if (!extension_loaded('memcache')) {
                $this->_enabled = FALSE;
            } else {
                if (!self::$_mem) {
                    self::$_mem = new Memcache();
                    self::$_mem->connect('localhost', 11211);
                }
            }
        } else {
            $this->_log_path = ADDRESS_SDK_LOG_PATH;

            if (!is_dir($this->_log_path)) {
                $this->_enabled = FALSE;
            }
        }
    }

    public function writeLog($msg, $level = 'error') {
        if ($this->_enabled === FALSE) {
            return FALSE;
        }

        $level = strtoupper($level);

        if (!isset($this->_levels[$level])) {
            return FALSE;
        }

        if ($this->_type == 'memcache') {
            $this->_writeLogMemcache($msg, $level);
        } else {
            $this->_writeLogFile($msg, $level);
        }
    }

    public function readLog($num, $date) {
        if ($this->_enabled === FALSE) {
            return FALSE;
        }

        empty($date) && $date = date('Y-m-d');
        if ($this->_type == 'memcache') {
            $this->_readLogMemcache($num, $date);
        } else {
            $this->_readLogFile($num, $date);
        }
    }

    private function _writeLogFile($msg, $level) {
        
        self::createFolder($this->_log_path);//当目录不存时,会自动递归创建目录
        $filepath = $this->_log_path . 'sdk_log_' . date('Y-m-d') . '.log';
        if (!$fp = @fopen($filepath, 'a+')) {
            return FALSE;
        }

        $message = $this->_logFormat($msg, $level);

        flock($fp, LOCK_EX);
        fwrite($fp, $message);
        flock($fp, LOCK_UN);
        fclose($fp);

        return TRUE;
    }

    private function _writeLogMemcache($msg, $level) {

        $message = self::$_mem->get($this->_mem_key);
        $message = $message ? json_decode($message, true) : array();
        $msg = $this->_logFormat($msg, $level);

        //保留10000条记录信息
        if (count($message) >= 10000) {
            array_shift($message);
        }
        array_push($message, $msg);
        //保留半个月
        self::$_mem->set($this->_mem_key, $message, false, 1296000);

        return TRUE;
    }

    private function _readLogFile($num, $date) {
        $filepath = $this->_log_path . 'sdk_log_' . $date . '.log';
        $fp = @fopen($filepath, "r"); //以只读的方式打开online.txt文件
        $pos = -2;
        $eof = "";
        $str = "";
        while ($num > 0) {
            while ($eof != "\n") {
                if (!fseek($fp, $pos, SEEK_END)) {
                    $eof = fgetc($fp);
                    $pos--;
                } else {
                    break;
                }
            }
            $str.=fgets($fp);
            $eof = "";
            $num--;
        }

        fclose($fp);

        echo nl2br($str);

        return TRUE;
    }

    private function _readLogMemcache($num, $date) {
        $message = self::$_mem->get($this->_mem_key);
        $message = $message ? json_decode($message, true) : array();
        $log = count($message) >= $num ? array_slice($message, -$num) : $message;
        $log = array_reverse($log);

        foreach ($log as $v) {
            echo $v . '<br>';
        }
        return TRUE;
    }

    private function _logFormat($msg, $level) {
        //by wangtao:不要使用mb_strlen()函数,因为mbstring不是一个默认扩展。
        //这意味着它默认没有被激活,为了做到兼容性,避免使用sdk的应用受到环境的影响无法使用。所以使用php引擎核心的函数
        strlen($msg) > 10000 && $msg = mb_substr($msg, 0, 10000) . '...';
        $log_str = $level . ' - ' . date($this->_date_fmt) . ' --> ' . $msg . PHP_EOL;

        return $log_str;
    }

    /*
     * +-----------------------------------------
     * 自动创建目录
     * +-----------------------------------------
     * @param $folde
     * +-----------------------------------------
     * 
     * 
     */
    public static function createFolder($folder) {
        if (!file_exists($folder)) {
            //创建文件夹，如果不存在
            $oldmask = umask(0);
            $rs = mkdir($folder, 0777, true);
            umask($oldmask);
        }
    }

}
