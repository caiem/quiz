<?php
/**
 * 
 *
 */
class RuleEngine{
    
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
     * @return bool
     */
    public static function revertAd($ad_id,$source){
        $params = ['ad_id'=>$ad_id,'ad_source'=>$source];
        $params['appkey'] = self::$appkey;
        $params['sign'] = self::getSign($params);
        $curl = new Post();
        $url = "http://api-luke.mama.cn/rule/ad/stopAd";
        $logger = Phalcon\Di::getDefault()->getShared('logger');
        try{
            $json_rs = $curl->socket($url, $params);
            $logger->info( '下架广告['.$ad_id.'],接口返回:'.$json_rs );
            $rs = json_decode($json_rs,true);
            if( isset($rs['code']) && $rs['code'] == 0){
                return true;
            }
            return false;
        }catch(\Exception $e){
            $code = $e->getCode();
            $msg = $e->getMessage();
            //TODO:log
            $logger->error('下架广告['.$ad_id.'],Code:'.$code.',Error:'.$msg);
            return false;
        }
    }
    
    /**
     * 提交素材
     * @access public static
     * @param array $ad_info 数据来自广告基础信息表
     * @param string $source    DSP的广告来源
     * @return bool
     */
    public static function submitAd( $ad_info,$source ){
        $ad_id = $ad_info['ad_id'];
        $_ad_data = self::formatAdInfo($ad_info,$source);
        if( empty($_ad_data) ){
            return FALSE;
        }
        $params = $_ad_data;
        $params['appkey'] = self::$appkey;
        $params['sign'] = self::getSign($params);
        $curl = new Post();
        $url = "http://api-luke.mama.cn/rule/ad/addAd";
        $logger = Phalcon\Di::getDefault()->getShared('logger');
        try{
            $logger->info('上架广告['.$ad_id.'],Param:'.  json_encode($params));
            $json_rs = $curl->socket($url, $params);
            $logger->info( '上架广告['.$ad_id.'],接口返回:'.$json_rs );
            $rs = json_decode($json_rs,true);
            if( isset($rs['code']) && $rs['code'] == 0){
                return true;
            }
            return false;
        }catch(\Exception $e){
            $code = $e->getCode();
            $msg = $e->getMessage();
            //TODO:log
            $logger->error('上架广告['.$ad_id.'],Code:'.$code.',Error:'.$msg);
            return false;
        }
    }
    
    /**
     * 获取一天的点击和pv总数
     * @param type $ad_id DSP广告ID
     * @param type $source DSP广告来源
     * @param type $date Y-m-d格式日期
     * @param type $hour H
     * @return type
     */
    public static function getAdCurStat($ad_id,$source,$date,$hour=-1) {
        $params = ['ad_id'=>$ad_id,'ad_source'=>$source,'date'=>$date];
        if($hour != -1 ){
            $params['hour'] = $hour;
        }
        $params['appkey'] = self::$appkey;
        $params['sign'] = self::getSign($params);
        $params['timeout'] = 30;
        $curl = new Get();
        $url = "http://api-luke.mama.cn/Adstat/getDspPvStat";
        $logger = Phalcon\Di::getDefault()->getShared('logger');
        try{
            $json_rs = $curl->socket($url, $params);
            $logger->info('获取PV监控数据['.$ad_id.'],Data:'. $json_rs);
            $rs = json_decode($json_rs,true);
            if( isset($rs['code']) && $rs['code'] == 0){
                return $rs['data'];
            }
            return array();
        }catch(\Exception $e){
            $code = $e->getCode();
            $msg = $e->getMessage();
            //TODO:log
            $logger->error('获取广告监控数据['.$ad_id.'],Code:'.$code.',Error:'.$msg);
            return array();
        }
    }
    
    /**
     * 格式化数据为规则引擎所需数据
     * @param array $ad_info 广告数据
     * @param string $source    DSP的广告来源
     * @return boolean/array
     */
    private static function formatAdInfo( $ad_info,$source ){
        $_ad_content = json_decode($ad_info['content'],TRUE);
        if(empty($_ad_content)){
            return FALSE;
        }
        $user = Advertiser::findByUID( $ad_info['user_id'] );
        $type = empty( $user->type ) ? 0: $user->type ;
        $type_map = RuleMap::ADVERTISER_TYPE_MAP;
        $ad_flag  =  $type_map[$type];
        $type_map = RuleMap::AD_TYPE_MAP;
        $_ad_data = array(
            'ad_id'=>$ad_info['ad_id'],
            'ad_source'=>$source,
            'adflag'=>$ad_flag,
            'material'=>array(
                'pv_code'=>  empty($ad_info['pv_monitor_link'])?'':$ad_info['pv_monitor_link'],
                'click_code'=> empty($ad_info['click_monitor_link'])?'':$ad_info['click_monitor_link'],
                'rule'=>array(
                    'type'=> $type_map[$ad_info['ad_type']]
                )
            )
        );
        if(!empty($_ad_content['dsp_size'])){
            $_ad_data['material']['rule']['px'] = $_ad_content['dsp_size'];
            unset($_ad_content['dsp_size']);
        }
        if( !empty($ad_info['ad_size']) ){
            $_ad_data['material']['rule']['px'] = $ad_info['ad_size'];
        }
        $cost_type_map = RuleMap::COST_TYPE_MAP;
        $_ad_data['cost_type'] = $cost_type_map[$ad_info['cost_type']];
        $_ad_data['material']['content'] = $_ad_content;
        $price_setting = AdCostSetting::getAdCostSetting($ad_info['ad_id']);
        if( $ad_info['target']==  AdvertisEnum::AD_TARGET_WAP ){
            $_key = $ad_info['platforms']== AdvertisEnum::AD_PLATFORM_PC ?'pc':'web';
            $_ad_data['click_price'][$_key] = $price_setting['wap_price'];
            $_ad_data['material']['rule']['platform'][]=$_key;
        }else if($ad_info['target']==  AdvertisEnum::AD_TARGET_APP ){
            switch ( $ad_info['platforms'] ){
                case AdvertisEnum::AD_PLATFORM_IOS:
                    $_ad_data['click_price']['ios'] = $price_setting['ios_price'];
                    $_ad_data['material']['rule']['platform'][]='ios';
                    break;
                case AdvertisEnum::AD_PLATFORM_ANDROID:
                    $_ad_data['click_price']['android'] = $price_setting['android_price'];
                    $_ad_data['material']['rule']['platform'][]='android';
                    break;
                default :
                    $_ad_data['click_price']['ios'] = $price_setting['ios_price'];
                    $_ad_data['click_price']['android'] = $price_setting['android_price'];
                    $_ad_data['material']['rule']['platform'][]='ios';
                    $_ad_data['material']['rule']['platform'][]='android';
                    break;
            }
        }
        $_ad_rule_data = array();
        if( !empty($ad_info['ugroupid']) ){
            $ugroup_data = AdUserGroup::findByPk( $ad_info['ugroupid'] );
            if( !empty($ugroup_data['data']['gender']) ){
                $gender_map = RuleMap::GENDER_MAP;
                $_ad_rule_data['sex'] = $gender_map[$ugroup_data['data']['gender']];
            }
            if( !empty($ugroup_data['data']['pstatus']) ){
                $py_map = RuleMap::PY_TYPE_MAP;
                foreach ($ugroup_data['data']['pstatus'] as $item){
                    if( empty($py_map[$item]) ){
                        continue;
                    }
                    $_ad_rule_data['py_status'][] = $py_map[$item];
                }
            }
            if( !empty($ugroup_data['data']['tags']) ){
                $_ad_rule_data['tag'] = $ugroup_data['data']['tags'];
            }
            if( !empty($ugroup_data['data']['zone']) ){
                $_ad_rule_data['area'] = $ugroup_data['data']['zone'];
            } else if( !empty($ugroup_data['data']['site']) ) {
                foreach ($ugroup_data['data']['site'] as $item){
                    $_zone = AdUserGroup::siteToZone($item);
                    if( empty($_zone) ){
                        continue;
                    }
                    $_ad_rule_data['area'][] = $_zone;
                }
            }
            if( !empty($ugroup_data['data']['reg_time']) ){
                $_ad_rule_data['reg_time'] = $ugroup_data['data']['reg_time'];
            }
        }
        if( !empty($_ad_rule_data) ){
            $_ad_rule_data = array($_ad_rule_data);
        }
        return ['ad'=> json_encode($_ad_data),'rule'=> json_encode($_ad_rule_data)];
    }
    
    /**
     * 提交应用
     * @param type $source 来源
     * @param type $app_id
     * @param type $app_key
     * @param type $platform 应用平台（多个用逗号分隔，如：ios,android）
     * @param type $fans_amount 日活跃用户数
     * @param type $user_tag 适用人群标签（多个用逗号分隔，如：旅游,阅读）
     * @param type $app_tag 应用标签（多个用逗号分隔，如：母婴,生鲜）
     * @param type $app_desc 应用描述
     * @return boolean
     */
    public static function submitApp( $source, $app_id,$app_key,$platform,$fans_amount,$user_tag,$app_tag,$app_desc ){
        $params = array('app_id'=>$app_id, 'ad_source'=>$source, 'app_secret'=>$app_key, 'platform'=>$platform,
            'fans_amount'=>$fans_amount, 'user_tag'=>$user_tag, 'app_tag'=>$app_tag, 'app_desc'=>$app_desc);
        $params['appkey'] = self::$appkey;
        $params['sign'] = self::getSign($params);
        $curl = new Post();
        $url = "http://api-luke.mama.cn/rule/info/submitApp";
        $logger = Phalcon\Di::getDefault()->getShared('logger');
        try{
            $json_rs = $curl->socket($url, $params);
            $logger->info( '提交应用['.$app_id.'],接口返回:'.$json_rs.', Param:'.  json_encode($params) );
            $rs = json_decode($json_rs,true);
            if( isset($rs['code']) && $rs['code'] == 0){
                return true;
            }
            return false;
        }catch(\Exception $e){
            $code = $e->getCode();
            $msg = $e->getMessage();
            //TODO:log
            $logger->error('提交应用['.$app_id.'],Code:'.$code.',Error:'.$msg);
            return false;
        }
    }
    
    /**
     * 
     * @param type $source
     * @param type $pos_id
     * @param type $app_id
     * @param type $pos_name
     * @param type $app_name
     * @param type $ad_type
     * @param string $image
     * @param type $template_limit  {
            "px": "300*200",
            "byte": "1024（单位：kb）", 
            "format": ["jpg", "png"]
        }
     * @return boolean 
     */
    public static function submitPos( $source, $pos_id,$app_id,$pos_name,$app_name,$ad_type,$image,$template_limit ){
        $params = array('pos_id'=>$pos_id, 'app_id'=>$app_id, 'ad_source'=>$source, 'pos_name'=>$pos_name,
            'app_name'=>$app_name, 'ad_type'=>$ad_type, 'image'=>$image, 'template_limit'=>$template_limit );
        $params['appkey'] = self::$appkey;
        $params['sign'] = self::getSign($params);
        $curl = new Post();
        $url = "http://api-luke.mama.cn/rule/info/submitPosition";
        $logger = Phalcon\Di::getDefault()->getShared('logger');
        try{
            $json_rs = $curl->socket($url, $params);
            $logger->info( '提交点位['.$pos_id.']接口返回:'.$json_rs.',Param:'.  json_encode($params) );
            $rs = json_decode($json_rs,true);
            if( isset($rs['code']) && $rs['code'] == 0){
                return true;
            }
            return false;
        }catch(\Exception $e){
            $code = $e->getCode();
            $msg = $e->getMessage();
            //TODO:log
            $logger->error('提交点位['.$pos_id.'],Code:'.$code.',Error:'.$msg);
            return false;
        }
    }
    
    /**
     * 删除应用
     * @access public static
     * @param int $app_id    应用id
     * @param string $source    DSP的广告来源
     * @return bool
     */
    public static function delApp($app_id,$source){
        $params = ['app_id'=>$app_id,'ad_source'=>$source];
        $params['appkey'] = self::$appkey;
        $params['sign'] = self::getSign($params);
        $curl = new Post();
        $url = "http://api-luke.mama.cn/rule/info/delApp";
        $logger = Phalcon\Di::getDefault()->getShared('logger');
        try{
            $json_rs = $curl->socket($url, $params);
            $logger->info( '删除应用['.$app_id.'],接口返回:'.$json_rs );
            $rs = json_decode($json_rs,true);
            if( isset($rs['code']) && $rs['code'] == 0){
                return true;
            }
            return false;
        }catch(\Exception $e){
            $code = $e->getCode();
            $msg = $e->getMessage();
            //TODO:log
            $logger->error('删除应用['.$app_id.'],Code:'.$code.',Error:'.$msg);
            return false;
        }
    }
    
    /**
     * 删除点位
     * @access public static
     * @param int $pos_id    点位id
     * @param int $app_id    应用id
     * @param string $source    DSP的广告来源
     * @return bool
     */
    public static function delPos($pos_id,$app_id,$source){
        $params = ['pos_id'=>$pos_id,'app_id'=>$app_id,'ad_source'=>$source];
        $params['appkey'] = self::$appkey;
        $params['sign'] = self::getSign($params);
        $curl = new Post();
        $url = "http://api-luke.mama.cn/rule/info/delPos";
        $logger = Phalcon\Di::getDefault()->getShared('logger');
        try{
            $json_rs = $curl->socket($url, $params);
            $logger->info( '删除点位['.$pos_id.'],接口返回:'.$json_rs );
            $rs = json_decode($json_rs,true);
            if( isset($rs['code']) && $rs['code'] == 0){
                return true;
            }
            return false;
        }catch(\Exception $e){
            $code = $e->getCode();
            $msg = $e->getMessage();
            //TODO:log
            $logger->error('删除点位['.$pos_id.'],Code:'.$code.',Error:'.$msg);
            return false;
        }
    }
    
    /**
     * 获取点位一天的请求数
     * @param type $date Y-m-d格式日期
     * @param type $source DSP广告来源
     * @param type $pos_id DSP点位ID
     * @param type $hour H
     * @return type
     */
    public static function getPosCurStat($date,$source,$pos_id='',$hour=-1) {
        $params = ['ad_source'=>$source,'date'=>$date];
        if(!empty($pos_id)){
            $params['pos_id'] = $pos_id;
        }
        if($hour != -1 ){
            $params['hour'] = $hour;
        }
        $params['appkey'] = self::$appkey;
        $params['sign'] = self::getSign($params);
        $params['timeout'] = 30;
        $curl = new Get();
        $url = "http://api-luke.mama.cn/Adstat/getDspPosStat";
        $logger = Phalcon\Di::getDefault()->getShared('logger');
        try{
            $json_rs = $curl->socket($url, $params);
            $logger->info('获取POS监控数据['.$pos_id.'],Data:'. $json_rs);
            $rs = json_decode($json_rs,true);
            if( isset($rs['code']) && $rs['code'] == 0){
                return $rs['data'];
            }
            return array();
        }catch(\Exception $e){
            $code = $e->getCode();
            $msg = $e->getMessage();
            //TODO:log
            $logger->error('获取POS监控数据['.$pos_id.'],Code:'.$code.',Error:'.$msg);
            return array();
        }
    }
    
}
