<?php
/**
 * Luke
 * @author Teeva
 *
 */
class Luke{
    
    /**
     * 公钥
     * @var string
     */
    public static $appkey = 'dsp';
    
    /**
     * 密钥
     * @var string
     */
    public static $secret = '4dc9c53c2f66462d28676991e4f3b264';
    
    /**
     * 生成luke的参数签名
     * @access public static
     * @param array $params
     * @return string
     */
    public static function getSign($params){
        $token = self::loopArrayToken($params);
        $token .= self::$secret;
        $token = self::$secret.$token;
        $token = strtoupper(md5($token));
        return $token;
    }
    
    /**
     * 生成luke的参数签名
     * @access public static
     * @param array $params
     * @return string
     */
    public static function getNewSign( $params ){
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
     * 下架广告
     * @access public static
     * @param int $ad_id    DSP的广告id
     * @param string $source    DSP的广告来源
     * @param int $pos_id   广告系统的点位id
     * @return bool
     */
    public static function revertAd($ad_id,$source,$pos_id){
        $params = ['ad_id'=>$ad_id,'ad_source'=>$source,'pos_id'=>$pos_id];
        $params['appkey'] = self::$appkey;
        $params['sign'] = self::getSign($params);
        $curl = new Post();
        $url = "http://api-luke.mama.cn/dsp/revertAd";
        try{
            $json_rs = $curl->socket($url, $params);
            $rs = json_decode($json_rs,true);
            if($rs['code'] == 0){
                return true;
            }else{
                $status = self::getAdStatus($ad_id, $source, $pos_id);
                if($status==2){
                    return true;
                }
                return false;
            }
        }catch(\Exception $e){
            $code = $e->getCode();
            $msg = $e->getMessage();
            //TODO:log
            $logger = Phalcon\Di::getDefault()->getShared('logger');
            $logger->error('下架广告['.$ad_id.'-'.$pos_id.'],Code:'.$code.',Error:'.$msg);
            return false;
        }
    }
    
    /**
     * 提交素材
     * @access public static
     * @param int $ad_id
     * @param string $source
     * @param float $price
     * @param int $pos_id
     * @param string $material
     * @return bool
     */
    public static function submitAd($ad_id,$source,$price,$pos_id,$material){
        $params = ['ad_id'=>$ad_id,'ad_source'=>$source,'price'=>$price,'pos_id'=>$pos_id,'material'=>$material];
        $params['appkey'] = self::$appkey;
        $params['sign'] = self::getSign($params);
        $curl = new Post();
        $url = "http://api-luke.mama.cn/dsp/submitAd";
        try{
            $json_rs = $curl->socket($url, $params);
            $rs = json_decode($json_rs,true);
            if($rs['code'] == 0){
                return true;
            }else{
                return false;
            }
        }catch(\Exception $e){
            $code = $e->getCode();
            $msg = $e->getMessage();
            //TODO:log
            $logger = Phalcon\Di::getDefault()->getShared('logger');
            $logger->error('上架广告['.$ad_id.'-'.$pos_id.'],Code:'.$code.',Error:'.$msg);
            return false;
        }
    }

    /**
     * 获取广告系统当天空闲的点位数据
     * @access public static
     * @return array
     */
    public static function getUnlockPosData(){
        $params = ['appkey'=>self::$appkey];
        $params['sign'] = self::getSign($params);
        $params['timeout'] = 30;
        $curl = new Get();
        $url = "http://api-luke.mama.cn/dsp/getUnlockPosData";
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
            $logger->error('获取空闲点位,Code:'.$code.',Error:'.$msg);
            return array();
        }
    }
    
    /**
     * 获取广告在广告系统的点击数据
     * @param type $ad_id DSP广告ID
     * @param type $source DSP广告来源
     * @param type $begin_time 开始时间
     * @param type $end_time 结束时间
     * @return type
     */
    public static function getAdClickData( $ad_id,$source,$begin_time,$end_time ){
        $params = ['ad_id'=>$ad_id,'ad_source'=>$source,'begin_time'=>$begin_time,'end_time'=>$end_time];
        $params['appkey'] = self::$appkey;
        $params['sign'] = self::getSign($params);
        $params['timeout'] = 30;
        $curl = new Get();
        $url = "http://api-luke.mama.cn/dsp/getAdDetailClick";
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
            $logger->error('获取广告点击数据['.$ad_id.'],Code:'.$code.',Error:'.$msg);
            return array();
        }
    }
    /**
     * 强制上架广告
     * @param type $ad_id 待上架DSP广告ID
     * @param type $source DSP广告来源
     * @param type $price 待上架DSP广告价格
     * @param type $pos_id DSP已占用广告系统的点位ID
     * @param type $material 广告素材json
     * @return boolean
     */
    public static function submitAdForce($ad_id,$source,$price,$pos_id,$material){
        $params = ['ad_id'=>$ad_id,'ad_source'=>$source,'price'=>$price,'pos_id'=>$pos_id,'material'=>$material];
        $params['appkey'] = self::$appkey;
        $params['sign'] = self::getSign($params);
        $curl = new Post();
        $url = "http://api-luke.mama.cn/dsp/submitAdForce";
        try{
            $json_rs = $curl->socket($url, $params);
            $rs = json_decode($json_rs,true);
            if($rs['code'] == 0){
                return true;
            }else{
                return false;
            }
        }catch(\Exception $e){
            $code = $e->getCode();
            $msg = $e->getMessage();
            //TODO:log
            $logger = Phalcon\Di::getDefault()->getShared('logger');
            $logger->error('强制上架广告['.$ad_id.'-'.$pos_id.'],Code:'.$code.',Error:'.$msg);
            return false;
        }
    }
    /**
     * 获取一天的点击和pv总数
     * @param type $ad_id DSP广告ID
     * @param type $source DSP广告来源
     * @param type $date Ymd格式日期
     * @return type
     */
    public static function getAdCurStat($ad_id,$source,$date) {
        $params = ['ad_id'=>$ad_id,'ad_source'=>$source,'date'=>$date];
        $params['appkey'] = self::$appkey;
        $params['sign'] = self::getSign($params);
        $params['timeout'] = 30;
        $curl = new Get();
        $url = "http://api-luke.mama.cn/dsp/getAdCurStat";
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
            $logger->error('获取广告监控数据['.$ad_id.'],Code:'.$code.',Error:'.$msg);
            return array();
        }
    }
    /**
     * 获取广告状态
     * @param type $ad_id
     * @param type $source
     * @param type $pos_id
     * @return mixed false--其他 1-在架 2-下架
     */
    public static function getAdStatus($ad_id,$source,$pos_id) {
        $params = ['ad_id'=>$ad_id,'ad_source'=>$source,'pos_id'=>$pos_id];
        $params['appkey'] = self::$appkey;
        $params['sign'] = self::getSign($params);
        $curl = new Get();
        $url = "http://api-luke.mama.cn/dsp/getAdStatus";
        $map = array('submited'=>1,'reverted'=>2);
        try{
            $json_rs = $curl->socket($url, $params);
            $rs = json_decode($json_rs,true);
            if($rs['code'] == 0){
                return empty( $map[ $rs['data']['status'] ]) ? false : $map[ $rs['data']['status'] ] ;
            }else if($rs['code']==40010){
                return 2;
            }
            return FALSE;
        }catch(\Exception $e){
            $code = $e->getCode();
            $msg = $e->getMessage();
            //TODO:log
            $logger = Phalcon\Di::getDefault()->getShared('logger');
            $logger->error('获取广告状态失败['.$ad_id.'],Code:'.$code.',Error:'.$msg);
            return FALSE;
        }
    }
    /**
     * 根据点位ID获取点位数据
     * @param type $pos_id
     * @return type
     */
    public static function getPosInfo( $pos_id ){
        $params = ['pos_ids'=>$pos_id];
        $params['appkey'] = self::$appkey;
        $params['sign'] = self::getNewSign($params);
        $params['timeout'] = 30;
        $curl = new Get();
        $url = "http://api-luke.mama.cn/adinfo/getPosInfo";
        try{
            $json_rs = $curl->socket($url, $params);
            $rs = json_decode($json_rs,true);
            if( isset($rs['code']) && ( $rs['code'] == 200 || $rs['code']==0)){
                return $rs['data'];
            }else{
                return array();
            }
        }catch(\Exception $e){
            $code = $e->getCode();
            $msg = $e->getMessage();
            //TODO:log
            $logger = Phalcon\Di::getDefault()->getShared('logger');
            $logger->error('获取点位数据失败['.$pos_id.'],Code:'.$code.',Error:'.$msg);
            return array();
        }
    }
}