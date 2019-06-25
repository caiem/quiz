<?php
/**
 * User: vincent.cao
 * Date: 14-4-22
 * Time: 上午9:39
 */

require(ADDRESSSDK_PATH . 'library/AdrConfigApp.php');
require(ADDRESSSDK_PATH . 'library/AddressCurl.php');

class AddressSdkBase { /*将类名称从Base修改成AddressSdkBase,原因是：与调用方的类名出现重名冲突,加前缀解决*/

    protected $_curl;
    protected $_app_server;
    protected $_format;
    protected $_method;
    protected $_params;
    protected $_response_string;
    protected $_app_key;
    protected $_app_secret;
    protected $_token_before_md5;

    protected $supported_formats = array(
        'json' 				=> 'application/json',
        'serialize' 		=> 'application/vnd.php.serialized',
        'php' 				=> 'text/plain',
    );


    protected function __construct()
    {
        $this->_curl =  new AddressCurl();
        $this->_app_server = AdrConfigApp::$app_server;
        $this->_app_key = AdrConfigApp::$app_key;

        if (substr($this->_app_server, -1, 1) != '/')
        {
            $this->_app_server .= '/';
        }
        if(stripos($this->_app_server, "https://")!==FALSE){
            $this->_curl->ssl(FALSE);
        }
    }

    public function get($uri, $params = array(), $format = NULL)
    {

        if(  defined('ADDRESS_SDK_DEBUG') && ADDRESS_SDK_DEBUG  && ADDR_TOKEN_DEBUG){
            $params['debug'] = 1;
        }


        $params['appkey'] = $this->_app_key;
        
        if ($params)
        {
            $uri .= '?'.(is_array($params) ? http_build_query($params,NULL,"&") : $params);
        }
        return $this->_call('get', $uri, NULL, $format);
    }


    public function post($uri, $params = array(), $format = NULL)
    {
        if(defined('ADDRESS_SDK_DEBUG') && ADDRESS_SDK_DEBUG && ADDR_TOKEN_DEBUG) $params['debug'] = 1;
        $params['appkey'] = $this->_app_key;
        parse_str(http_build_query($params, NULL, '&'), $params);
        return $this->_call('post', $uri, $params, $format);
    }


    protected function _call($method, $uri, $params = array(), $format = NULL)
    {
        $this->_method = $method;
        $this->_params = $params;
        $this->_curl->params = $params;

        if ($format !== NULL)
        {
            $this->format($format);
        }

        $this->http_header('Accept', $this->mime_type);
        $this->http_header('API-KEY', $this->_app_key);

        $this->_curl->create($this->_app_server.$uri);
        //显示HTTP状态码，不忽略编号小于等于400的HTTP信息。
        $this->_curl->option('failonerror', FALSE);
        $this->_curl->{$method}($params);
        $response = $this->_curl->execute();

//        var_dump($response);//原封不动返回接口的结果,格式化之前的

        return $this->_format_response($response);
    }

    public function http_header($header, $content = NULL)
    {
        $params = $content ? array($header, $content) : array($header);

        call_user_func_array(array($this->_curl, 'http_header'), $params);
    }

    public function format($format)
    {
        if (array_key_exists($format, $this->supported_formats))
        {
            $this->_format = $format;
            $this->mime_type = $this->supported_formats[$format];
        }

        else
        {
            $this->mime_type = $format;
        }

        return $this;
    }

    /**
     * @param $response 返回值
     * @return mixed
     */
    protected function _format_response($response)
    {
        $this->_response_string =& $response;

        if (method_exists($this, '_'.$this->_format))
        {
            return $this->{"_".$this->_format}($response);
        }

        return $response;
    }

    protected function _xml($string)
    {
        return $string ? (array) simplexml_load_string($string, 'SimpleXMLElement', LIBXML_NOCDATA) : array();
    }

    protected function _json($string)
    {
        
        $return_array = json_decode(trim($string), true);
        

        //服务端php出现致命错误,json_decode的结果会是null,记录下来
        if(is_array($return_array)){
            
            return $return_array;
            
        }else{
           
            return  array(
                
                'status'=>500,//表示出现内部错误了
                'message'=>$string,//memberapi端php报出的致命错误信息
                'data'=>false
            );
        }
        
        
    }

    protected function _set_token($secretkey, $param){
        $token = $secretkey;
        $token .= $this->_loop_array_token($param);
        $token .= $secretkey;
        $this->_token_before_md5 = $token;
//        echo $token;
        $token = strtoupper(md5($token));
        return $token;
    }

    protected function _loop_array_token($param){
        $token = "";
        ksort($param);
        foreach($param as $k=>$v){
            if(is_array($v)){
                $token .="{$k}";
                $token .= $this->_loop_array_token($v);
            }else{
                $token .= "{$k}{$v}";
            }
        }
        return stripslashes($token);
    }

    public function debug()
    {
        $request = $this->_curl->debug_request();

        echo "=============================================<br/>\n";
        echo "<h2>Api Test</h2>\n";
        echo "=============================================<br/>\n";
        echo "<h3>Request(".$this->_method.")</h3>\n";
        echo $request['url']."<br/>\n";
        echo "<pre>";
        echo $this->_params ? 'Params:' : '';
        print_r($this->_params);
        echo "</pre>";
        echo "=============================================<br/>\n";
        echo "<h3>Response</h3>\n";

        if ($this->_response_string)
        {
            echo "<code>".nl2br(htmlentities($this->_response_string))."</code><br/>\n\n";
        }

        else
        {
            echo "No response<br/>\n\n";
        }

        echo "=============================================<br/>\n";
        echo 'Token before md5-->'.$this->_token_before_md5 . "<br/>\n";
        echo "=============================================<br/>\n";

        if ($this->_curl->error_string)
        {
            echo "<h3>Errors</h3>";
            echo "<strong>Code:</strong> ".$this->_curl->error_code."<br/>\n";
            echo "<strong>Message:</strong> ".$this->_curl->error_string."<br/>\n";
            echo "=============================================<br/>\n";
        }

        echo "<h3>Call details</h3>";
        echo "<pre>";
        print_r($this->_curl->info);
        echo "</pre>";
        echo "=============================================<br/>\n";
        echo "<h3>Request Method & Params & CurlOpt</h3>\n";
        echo 'Method:'.$this->_method."<br/>\n";
        echo "<pre>";
        echo 'Params:';print_r($this->_params);
        echo "</pre>";
        $constants = get_defined_constants(true);
        foreach($this->_curl->curl_opt_arr as $k => $v)
        {
            $name[array_search($k, $constants['curl'], TRUE)] = $v;

        }
        echo "<pre>";
        echo 'CurlOpt:';print_r($name);
        echo "</pre>";

    }

    public function getResponse()
    {
        return $this->_response_string;
    }
}
