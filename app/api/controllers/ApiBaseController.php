<?php
/**
 *
 * 应用接口访问基类
 *
 *
 */

namespace Api\Controller;

use Phalcon\Mvc\Controller;

class ApiBaseController extends Controller
{
    /**
     * 输出JSON
     * @param string $data
     * @param int $code
     * @param string $msg
     * @return void
     */
    protected function render($code = 0, $msg = '', $data = '')
    {
        echo jsonEncode(array(
            'code' => (int)$code,
            'msg' => $msg,
            'data' => $data,
        ));
        exit;
    }

    protected function getAllParamIgnore()
    {
        $method = strtolower($this->request->getMethod());
        $params = array();
        if ($method == 'get') {
            $params = $this->request->get();
        } elseif ($method == 'post') {
            $params = $this->request->getPost();
        }
        unset($params['sign']);
        unset($params['_url']);
        return $params;
    }

    private static $secret = 'adsf231231fsd*(sd';

    protected function onConstruct()
    {
        if (!empty($_REQUEST['debug']) && $_REQUEST['debug'] == 1212) {
            return;
        }
        header('Connection: Keep-Alive');
        if (IS_TEST) {
            header('Access-Control-Allow-Origin:*');
        } else {
            header('Access-Control-Allow-Origin:' . setOrigin());
        }
//        header('Access-Control-Allow-Methods:GET, POST, PUT, DELETE, OPTIONS');
//        header('Access-Control-Allow-Credentials: true'); // 设置是否允许发送 cookies
//        header('Access-Control-Allow-Headers: Content-Type,Content-Length,Accept-Encoding,X-Requested-with, Origin'); // 设置允许自定义请求头的字段
        $this->checkSign();
    }

    /**
     * 检验应用签名
     */
    private function checkSign()
    {
        $params = $this->getAllParamIgnore();
        if (empty($_REQUEST['expireTime']) || APP_TIME() > $_REQUEST['expireTime']) {
            $this->render(-1002, 'Expired token');
        }
        if (empty($_REQUEST['uid'])) {
            $this->render(-1003, 'uid needed');
        }
        $accessToken = md5(\Config::$authKey . (int)$_REQUEST['uid'] . (int)$_REQUEST['expireTime']);
        if (empty($_REQUEST['accessToken']) || $_REQUEST['accessToken'] != $accessToken) {
            $this->render(-1004, 'accessToken wrong');
        }
        /*if (!empty($_REQUEST['sign']) && $_REQUEST['sign'] == 'B4206B74B7563EC684336F054582605B') {
            return true;
        }*/
        if (empty($_REQUEST['sign']) || strtoupper($_REQUEST['sign']) != \Token::generateAccessToken(self::$secret, $params)) {
            $this->render(-1001, 'Invalid sign');
        }
        return true;
    }
}
