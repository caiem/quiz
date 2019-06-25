<?php

class Token
{

    /**
     * 生成数据Token
     * @access public static
     * @param mixed $data
     * @return string
     */
    public static function generateDataToken($data)
    {
        if (!is_array($data)) {
            $data = (array)$data;
        }
        $data_str = serialize($data);
        $token = md5($data_str);
        return $token;
    }

    /**
     * 检验数据Token
     * @access public static
     * @param array $data
     * @param string $token
     * @return bool
     */
    public static function checkDataToken($data, $token)
    {
        if (!is_array($data)) {
            $data = (array)$data;
        }
        $data_str = serialize($data);
        $data_token = md5($data_str);
        if ($token == $data_token) {
            return true;
        } else {
            return false;
        }
    }

    public static $_tip = '';

    /**
     * 生成访问Token
     * @param string $secret 密钥
     * @param array $param 请求参数
     * @return string
     */
    public static function generateAccessToken($secret, $param)
    {
        $token = self::loopArrayToken($param);
        $token .= $secret;
        self::$_tip = $token;
        $token = strtoupper(md5($token));
        return $token;
    }

    private static function loopArrayToken($param)
    {
        $token = "";
        ksort($param);
        foreach ($param as $k => $v) {
            if (is_array($v)) {
                $token .= "{$k}";
                $token .= self::loopArrayToken($v);
            } else {
                $token .= "{$k}{$v}";
            }
        }
        return $token;
    }
}