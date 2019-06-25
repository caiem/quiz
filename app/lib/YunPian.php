<?php


class YunPian
{

    public static $tip = '';

    public static $yunpianSms = [
        'apikey' => '',
    ];


    public static function sendSms($content, $mobile)
    {
        $apikey = self::$yunpianSms['apikey'];
        $mobile = trim($mobile); //请⽤⾃⼰的⼿机号代替
        $text = $content;
        $ch = curl_init();
        /* 设置验证⽅式 */
        curl_setopt($ch, CURLOPT_HTTPHEADER, array('Accept:text/plain;charset=utf-8',
            'Content-Type:application/x-www-form-urlencoded', 'charset=utf-8'));
        /* 设置返回结果为流 */
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        /* 设置超时时间*/
        curl_setopt($ch, CURLOPT_TIMEOUT, 6);
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 3);
        /* 设置通信⽅式 */
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

        $surl = 'https://sms.yunpian.com/v2/sms/single_send.json';

        $data = array(
            'text' => $text, 'apikey' => $apikey, 'mobile' => $mobile,
        );
        curl_setopt($ch, CURLOPT_URL, $surl);
        curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data));
        $result = curl_exec($ch);
        $_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        $array = json_decode($result, 1);
        if (!empty($array) && $array['code'] == 0) {
            return true;
        } else {
            Phalcon\Di::getDefault()->getShared('logger')->info(json_encode($data) . ' code: ' . $_code . ' result ' . $result);
        }
        return false;
    }


    public static function addSign($sign, $sendSystem)
    {
        echo $sign;
        $apikey = $sendSystem['apikey'];
        $ch = curl_init();
        /* 设置验证⽅式 */
        curl_setopt($ch, CURLOPT_HTTPHEADER, array('Accept:text/plain;charset=utf-8',
            'Content-Type:application/x-www-form-urlencoded', 'charset=utf-8'));
        /* 设置返回结果为流 */
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        /* 设置超时时间*/
        curl_setopt($ch, CURLOPT_TIMEOUT, 5);
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 1);
        /* 设置通信⽅式 */
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

        $surl = 'https://sms.yunpian.com/v2/sign/add.json';

        $data = array(
            'sign' => $sign, 'apikey' => $apikey,
        );
        curl_setopt($ch, CURLOPT_URL, $surl);
        curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data));
        $result = curl_exec($ch);
        $_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        if ($_code != 200) {
            Tool::appLogError(__METHOD__ . $result . ' code:' . $_code);
        }
//        \common\helpers\Tool::apiLog($surl, [$_code, $data,], $result, 'sms-code.log');
        echo '<br/>' . $result;
        $array = json_decode($result, 1);
        if (!empty($array)) {
            if ($array['code'] == 0) {
                echo ' <br/>successs ';
                return;
            }
        }
        echo '  <br/>fail';
    }

    public static function addTpl($sign, $sendSystem, $website = '', $tplType = '')
    {
        echo $sign;
        $apikey = $sendSystem['apikey'];
        $ch = curl_init();
        /* 设置验证⽅式 */
        curl_setopt($ch, CURLOPT_HTTPHEADER, array('Accept:text/plain;charset=utf-8',
            'Content-Type:application/x-www-form-urlencoded', 'charset=utf-8'));
        /* 设置返回结果为流 */
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        /* 设置超时时间*/
        curl_setopt($ch, CURLOPT_TIMEOUT, 5);
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 1);
        /* 设置通信⽅式 */
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

        $surl = 'https://sms.yunpian.com/v2/tpl/add.json';

        $data = array(
            'tpl_content' => $sign,
            'apikey' => $apikey,
            'notify_type' => 3,
        );
        $website && $data['website'] = $website;
        $tplType && $data['tplType'] = $tplType;
        curl_setopt($ch, CURLOPT_URL, $surl);
        curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data));
        $result = curl_exec($ch);
        $_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        if ($_code != 200) {
            Tool::appLogError(__METHOD__ . $result . ' code:' . $_code);
        }
//        \common\helpers\Tool::apiLog($surl, [$_code, $data,], $result, 'sms-code.log');
        echo '<br/>' . $result;
        $array = json_decode($result, 1);
        if (!empty($array)) {
            if (!empty($array['check_status']) && $array['check_status'] != 'FAIL') {
                echo '  <br/>successs';
                return;
            }
        }
        echo '  <br/>fail';
    }

    public static function smsRecord($startTime, $endTime, $mobile, $sendSystem, $size, $page = 1)
    {
        if (!isset($sendSystem['apikey'])) {
            return false;
        }
        $apikey = $sendSystem['apikey']; //修改为您的apikey(https://www.yunpian.com)登录官⽹后获取
        $mobile = trim($mobile); //请⽤⾃⼰的⼿机号代替
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_HTTPHEADER, array('Accept:text/plain;charset=utf-8',
            'Content-Type:application/x-www-form-urlencoded', 'charset=utf-8'));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_TIMEOUT, 5);
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 1);
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

        $surl = 'https://sms.yunpian.com/v2/sms/get_record.json';
        $data = array(
            'apikey' => $apikey,
            'start_time' => $startTime,
            'end_time' => $endTime,
            'page_num' => (int)$page,
            'page_size' => (int)$size,
        );
        $mobile && $data['mobile'] = $mobile;
        curl_setopt($ch, CURLOPT_URL, $surl);
        curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data));
        $result = curl_exec($ch);
        $_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        if ($_code != 200) {
            Tool::appLogError(__METHOD__ . $result . ' code:' . $_code);
        }
        $array = json_decode($result, 1);
        return $array;
    }

}