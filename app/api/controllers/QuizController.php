<?php

namespace Api\Controller;


use Phalcon\Mvc\Controller;

class QuizController extends Controller
{
    private static $domain = IS_TEST ? \Config::ALLOW_ORIGIN_TEST : \Config::ALLOW_ORIGIN;

    function initialize()
    {
        header('Connection: Keep-Alive');
        if (IS_TEST) {
            header('Access-Control-Allow-Origin:*');
        } else {
            header('Access-Control-Allow-Origin:' . setOrigin());
        }


    }


    private function render($code, $msg, $data = '')
    {
        echo jsonEncode(array(
            'code' => (int)$code,
            'msg' => $msg,
            'data' => $data,
        ));
        exit;
    }

    public function indexAction()
    {

    }

    public function wxLoginAction()
    {
  
        $this->render(0, '', $data);
    }

    public function jscfgAction()
    {
        $geturl = $this->request->get('url');
        if (empty($geturl)) {
            $this->render(-1, 'url参数缺失');
        }

        $url = 'http://' . self::$domain . '/api/ycf/xyzj/weixin/getjscfg?url=' . urlencode($geturl);

        $res = \Common::curl_http($url, $data = null, $tout = 15, $c_out = 1);
        if ($res['code'] == 200) {
            $this->render(0, '', json_decode($res['content'], 1));
        } else {
            $this->render(-1, '网络错误:' . $url . ' ' . jsonEncode($res));
        }
    }

    public function wxredirectAction()
    {
        ignore_user_abort(true);

        $appKey = $this->request->get('appkey');
        $userdata = $this->request->get('userdata');

        if (empty($userdata)) {
            $this->render(-1, '参数缺失');
        }
        $userdata = json_decode(base64_decode($userdata), 1);
        if (empty($userdata) || !is_array($userdata)) {
            $this->render(-1, '参数解析失败');
        }
        if (!in_array($appKey, array_keys((IS_TEST ? \Config::KEY_MAP_TEST : \Config::KEY_MAP)))) {
            $this->render(-1, '参数key错误');
        }
        $data = \UserLogic::getInstance()->login($userdata['openid'], $type = 2, (isset($userdata['state']) ? $userdata['state'] : 0), !empty($userdata['nickname']) ? $userdata['nickname'] : '', !empty($userdata['headimgurl']) ? $userdata['headimgurl'] : '', $appKey);
        if (empty($data)) {
            $this->render(-1, '登录失败', $data);
        }

        header("Location: " . (IS_TEST ? 'http:' : 'https:') . "//" . self::$domain . "/fkdtw/?uid={$data['uid']}&expireTime={$data['expireTime']}&firstLogin={$data['firstLogin']}&accessToken=" . $data['accessToken']);
        exit();
      
    }

    public function smsCodeAction()
    {
        $mobile = $this->request->get('mobile');
        if (empty($mobile) || strlen($mobile) != 11) {
            $this->render(-1, '手机号错误');
        }
        $redis = $this->getDI()->get('redis');
        $redisKey = \RedisKey::$mobileTimes . $mobile;
        $times = 0;
        try {
            $times = $redis->get($redisKey);
        } catch (\Exception $eee) {

        }
        if ($times > 6) {
            $this->render(-1, '获取次数过多,请等待');
        }

        if ($redis->exists(\RedisKey::$mobileTern . $mobile)) {
            $this->render(-1, '太频繁了,请等待');
        }
        $redis->set(\RedisKey::$mobileTern . $mobile, 1, 59);

        $rand = mt_rand(1000, 9999);
        $res = \YunPian::sendSms("【金榜题名】您的验证码为{$rand}，有效时间为5分钟，请勿泄露给他人。非常感谢！", $mobile);
        if ($res) {
            $redis->set(\RedisKey::$mobileCode . $mobile, $rand);
            $redis->expire(\RedisKey::$mobileCode . $mobile, 300);

            $redis->incr($redisKey);
            $redis->expireAt($redisKey, time() + 3600);
            $this->render(0, '发送成功');
        } else {
            $this->render(-1, '发送失败');
        }
    }

    public function testAction()
    {

    }

    public function registerUserAction()
    {
        ignore_user_abort(true);
        $mobile = $this->request->get('mobile');
        if (empty($mobile) || strlen($mobile) != 11) {
            $this->render(-1, '手机号错误');
        }
        $code = $this->request->get('code');
        $fromUid = $this->request->get('from_uid');
        if (empty($code) || strlen($code) != 4) {
            $this->render(-1, '验证码无效');
        }
        $redis = $this->getDI()->get('redis');
        $truecode = $redis->get(\RedisKey::$mobileCode . $mobile);
        if (empty($truecode)) {
            $this->render(-1, '验证码错误');
        }
        if ($truecode != $code) {
            $redisKey = \RedisKey::$mobileCodeTryTImes . $mobile;
            $testTimes = $redis->incr($redisKey);
            $redis->expireAt($redisKey, time() + 3600);
            if ($testTimes > 20) {
                $this->render(-1, '尝试次数过多,请等待一小时');
            }
            $this->render(-1, '验证码错误');
        }
        $data = \UserLogic::getInstance()->login($mobile, $type = 1, $fromUid);
        if (empty($data)) {
            $this->render(-1, '登录失败', $data);
        }
        $redis->del(\RedisKey::$mobileCode . $mobile);
        $this->render(0, '登录成功', $data);
    }
}
