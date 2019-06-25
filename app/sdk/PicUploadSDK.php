<?php
/**
 * Luke
 * @author Teeva
 *
 */
class PicUploadSDK{
    
    /**
     * 公钥
     * @var string
     */
    public static $appkey = 'T9LuHJkR';
    
    /**
     * 密钥
     * @var string
     */
    public static $secret = '6DhejR3VO05qT1SpI2URRGsNx1KdgXo7';
    
    /**
     * 生成luke的参数签名
     * @access public static
     * @param array $params
     * @return string
     */
    public static function getSign($params){
        $token = self::loopArrayToken($params);
        $token .= self::$secret;
        $token = strtoupper(md5($token));
        return $token;
    }
    
    private static function loopArrayToken($param){
        $token = "";
        ksort($param);
        foreach($param as $k=>$v){
            if(is_array($v)){
                $token .="{$k}";
                $token .= self::loopArrayToken($v);
            }else{
                $token .= "{$k}{$v}";
            }
        }
        return stripslashes($token);
    }
    
    /**
     * 
     * @param type $ext
     * @return type
     */
    public static function getToken( $ext ){
        $params = ['ext'=>$ext,'t'=> time()];
        $params['appkey'] = self::$appkey;
        $params['sign'] = self::getSign($params);
        $curl = new Get();
        $url = "http://picupload.mama.cn/token";
        try{
            $json_rs = $curl->socket($url, $params);
            $rs = json_decode($json_rs,true);
            if($rs['code'] == 0){
                return $rs['data'];
            }else{
                return array();
            }
        }catch(\Exception $e){
            $code = $e->getCode();
            $msg = $e->getMessage();
            //TODO:log
            $logger = Phalcon\Di::getDefault()->getShared('logger');
            $logger->error('获取文件上传Token,Code:'.$code.',Error:'.$msg);
            return array();
        }
    }
    
    /**
     * 上传文件至七牛
     * @param Phalcon\Http\Request\File $file
     * @return boolean
     */
    public static function uploadFile( $file ){
        
        // $image是Phalcon\Http\Request\File的实例
        if (!($file instanceof Phalcon\Http\Request\File)) {
            return null;
        }
        $extension = explode('/', $file->getType())[1];
        $tokens = self::getToken($extension);
        if(empty($tokens)){
            return FALSE;
        }
        $params = $tokens['args'];
        $filekey = $tokens['http_post_file_key'];
        $params[ $filekey ] = new CURLFile( $file->getTempName() );// '@'.$file->getTempName();
        $params['timeout'] = 30;
        $params['connect_time'] = 5;
        $curl = new Post( TRUE );
        $url = $tokens['upload_api'];
        try{
            $json_rs = $curl->socket($url, $params);
            $rs = json_decode($json_rs,true);
            if( !empty($rs) && !empty($rs['key']) ){
                return $tokens['url'];
            }else{
                return false;
            }
        }catch(\Exception $e){
            $code = $e->getCode();
            $msg = $e->getMessage();
            //TODO:log
            $logger = Phalcon\Di::getDefault()->getShared('logger');
            $logger->error('上传文件至七牛['.$url.']失败,Code:'.$code.',Error:'.$msg);
            return false;
        }
    }
}