<?php

use lib\Mlogger\Logger as MCLogger;

class MLogger
{
    public function __construct($config = [])
    {
        $defaultConfig = [
            'filename' => 'quizfpm' . date('Ymd') . '.log',
            'source' => 'quiz',
            'path' => MLOG_PATH,
        ];

        $config = empty($config) ? $defaultConfig : $config;
        \lib\Mlogger\Logger::init($config);
    }

    public function writeLog($msg, $level)
    {
        $backtrace = debug_backtrace(2);
        $last_function = array();
        foreach ($backtrace as $item) {
            if (isset($item['class'])) {
                if ($item['class'] != __CLASS__) {
                    $callFunction = $item;
                    break;
                }
                $last_function = $item;
            }
        }
        $line = isset($last_function['line']) ? $last_function['line'] : '';
        $class = isset($callFunction['class']) ? $callFunction['class'] : '';
        $func = isset($callFunction['function']) ? $callFunction['function'] : '';
        if (empty($class) && empty($func)) {
            $pos = '[FILE:' . (isset($last_function['file']) ? basename($last_function['file']) : '') . ']';
        } else {
            $pos = '[CLASS:' . $class . '][FUNCTION:' . $func . ']';
        }
        $position = $pos . '[LINE:' . $line . ']';
        $log = array(
            'tag' => array('POS' => $position),
            'msg' => $msg,
        );
        if ($level == MCLogger::ERROR || $level == MCLogger::FATAL) {

        }
        MCLogger::record($log, $level);
        MCLogger::save();

    }

    public function debug($message)
    {
        $this->writeLog($message, MCLogger::DEBUG);
    }

    public function error($message)
    {
        $this->writeLog($message, MCLogger::ERROR);
    }

    public function info($message)
    {
        $this->writeLog($message, MCLogger::INFO);
    }

    public function notice($message)
    {
        $this->writeLog($message, MCLogger::TRACE);
    }

    public function trace($message)
    {
        $this->writeLog($message, MCLogger::TRACE);
    }

    public function warning($message)
    {
        $this->writeLog($message, MCLogger::WARN);
    }

    public function fatal($message)
    {
        $this->writeLog($message, MCLogger::FATAL);
    }

    public function emergency($message)
    {
        $this->writeLog($message, MCLogger::FATAL);
    }
}
