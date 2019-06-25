<?php
/**
 * 
 *
 */
class ContractSDK{
    
    /**
     * 公钥
     * @var string
     */
    public static $appkey = 'dsp';
    
    /**
     * 密钥
     * @var string
     */
    public static $secret = 'e03af6eb87fc9f84';
    
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
                $v = urlencode(htmlspecialchars_decode($v));
                $token .= "{$k}{$v}";
            }
        }
        return stripslashes($token);
    }
    
    /**
     * 创建合同
     * @param string $customer 客户名称
     * @param string $content 合同内容
     * @param int $begin_time 开始时间
     * @param int $end_time 结束时间
     * @param string $customer_name 客户联系人姓名
     * @param string $customer_email 客户联系人邮箱
     * @param string $customer_phone 客户联系人电话
     * @param string $customer_address 客户联系人地址
     * @param int $saler 销售人员
     * @param string $last_contractno 上一年的合同号
     * @param array $attachment 合同附件
     * @param int $type 合同类型 默认值：4(tz)
     * @param float $amount 合同金额 默认值：0
     * @param int $need_invoice 是否开具发票 默认值：1
     * @param string $mycompany 己方名称 默认值：广州盛成妈妈网络科技股份有限公司
     * @return boolean
     */
    public static function createContract($customer,$content,$begin_time,$end_time,$customer_name,
            $customer_email,$customer_phone,$customer_address,$saler,$last_contractno='',$attachment=NULL,$type=4,$amount=0,$need_invoice=1,$mycompany='广州盛成妈妈网络科技股份有限公司'){
        $params = ['customer'=>$customer,'total_money'=>$amount,'contract_name'=>$content,
            'start_time'=>$begin_time,'end_time'=>$end_time,'contract_type'=>$type,
            'my_company'=>$mycompany,'need_invoice'=>$need_invoice,'customer_contact_name'=>$customer_name,
            'customer_contact_email'=>$customer_email,'customer_contact_phone'=>$customer_phone,'customer_contact_address'=>$customer_address,'saler'=>$saler,'identifie'=>$last_contractno];
        $params['t'] = time();
        $params['do'] = 'do_create_contract';
        $params['appkey'] = self::$appkey;
        $params['sign'] = self::getSign($params);
        $params['timeout'] = 30;
        if(  !is_null($attachment) && is_array($attachment) ){
            foreach ( $attachment as $key=>$item ){
                $params['attachment['.$key.']'] = new CURLFile(realpath($item));
            }
        }
        $curl = new Post(true);
        $url = "http://contract.mama.cn/gateway.php";
        $logger = Phalcon\Di::getDefault()->getShared('logger');
        try{
            $json_rs = $curl->socket($url, $params);
            $logger->info( '创建一般合同,接口返回：'.$json_rs.', Params:'. json_encode($params) );
            $rs = json_decode($json_rs,true);
            if( isset( $rs['code'] ) && $rs['code'] == 0){
                return $rs['data']['identifie']; //$rs['data']['contract_id'];
            }else{
                return false;
            }
        }catch(\Exception $e){
            $code = $e->getCode();
            $msg = $e->getMessage();
            //TODO:log
            $logger->error('创建一般合同异常,Code:'.$code.',Error:'.$msg.', Params:'. json_encode($params) );
            return false;
        }
    }
    
    /**
     * 创建开票申请
     * @param string $title 发票抬头
     * @param string $invoice_company_name 开票公司
     * @param type $invoice_type 发票类型（1、专用，2、普通）
     * @param float $money 发票金额
     * @param int $rm_id 汇款ID
     * @param string $identifie 合同编号
     * @param string $file_path 盖章后的客户资料备案卡文件绝对路径
     * @param string $cert 纳税人证书
     * @param string $contact_name 发票邮寄收件人
     * @param string $contact_phone 发票邮寄收件人电话
     * @param string $contact_address 发票邮寄收件地址
     * @param int $service_type 服务类型
     * @param string $remark 当发票类型为2时，必须备注客户邮箱
     * @param string $company_full_name 公司全称
     * @param string $tax_payer_code 纳税人识别号
     * @param string $invoice_address 纳税人地址
     * @param string $invoice_phone 纳税人电话
     * @param string $invoice_bank  开户银行
     * @param string $invoice_account  开户账户
     * @return boolean
     */
    public static function createInvoice( $title,$invoice_company_name,$invoice_type,
            $money,$rm_id,$identifie,$file_path,$cert,$contact_name,$contact_phone,$contact_address,$service_type=8,$remark='',$company_full_name='',$tax_payer_code='',
            $invoice_address='',$invoice_phone='',$invoice_bank='',$invoice_account=''){
        $params = [
            'title'=>$title,
            'invoice_company_name'=>$invoice_company_name,
            'service_type'=>$service_type,
            'invoice_type'=>$invoice_type,
            'money'=>$money,
            'rm_id'=>$rm_id,
            'identifie'=>$identifie,
            'remark'=>$remark,
            'company_full_name'=>$company_full_name,
            'tax_payer_code'=>$tax_payer_code,
            'invoice_address'=>$invoice_address,
            'invoice_phone'=>$invoice_phone,
            'invoice_bank'=>$invoice_bank,
            'invoice_account'=>$invoice_account,
            'contact_name'=>$contact_name,
            'contact_phone'=>$contact_phone,
            'contact_address'=>$contact_address
        ];
        $params['t'] = time();
        $params['do'] = 'add_invoice';
        $params['appkey'] = self::$appkey;
        $params['sign'] = self::getSign($params);
        if( !empty($file_path) ){
            $params['upfile[0]'] = new CURLFile(realpath($file_path));
        }
        if( !empty($cert) ){
            $params['upfile[1]'] = new CURLFile(realpath($cert));
        }
        $params['timeout'] = 30;
        $curl = new Post(true);
        $url = "http://contract.mama.cn/gateway.php";
        $logger = Phalcon\Di::getDefault()->getShared('logger');
        try{
            $json_rs = $curl->socket($url, $params);
            $logger->info( '创建发票开票申请,接口返回：'.$json_rs.', Params:'. json_encode($params)  );
            $rs = json_decode($json_rs,true);
            if( isset( $rs['code'] ) && $rs['code'] == 0 && !empty($rs['data']['invoice_id'])){
                return $rs['data']['invoice_id'];
            }else{
                return false;
            }
        }catch(\Exception $e){
            $code = $e->getCode();
            $msg = $e->getMessage();
            //TODO:log
            $logger->error('创建发票开票申请,Code:'.$code.',Error:'.$msg.', Params:'. json_encode($params) );
            return false;
        }
    }
    
    /**
     * 获取发票开票状态
     * @param type $invoice_no 合同系统中发票申请ID
     * @return type
     */
    public static function getInvoiceStat($invoice_no) {
        $params = ['invoice_id'=>$invoice_no];
        $params['t'] = time();
        $params['do'] = 'get_invoice';
        $params['appkey'] = self::$appkey;
        $params['sign'] = self::getSign($params);
        $params['timeout'] = 30;
        $curl = new Get();
        $url = "http://contract.mama.cn/gateway.php";
        $logger = Phalcon\Di::getDefault()->getShared('logger');
        try{
            $json_rs = $curl->socket($url, $params);
            $logger->info('获取发票开票状态,接口返回:'. $json_rs );
            $rs = json_decode($json_rs,true);
            if(isset( $rs['code'] ) && $rs['code'] == 0){
                return $rs['data'];
            }else{
                return array();
            }
        }catch(\Exception $e){
            $code = $e->getCode();
            $msg = $e->getMessage();
            //TODO:log
            $logger->error('获取发票开票状态异常,Code:'.$code.',Error:'.$msg.', Params:'. json_encode($params) );
            return array();
        }
    }
    /**
     * 合同回款信息
     * @param string $contract_no 合同编号
     * @param string $remit_name 汇款人
     * @param string $remit_bank 汇款银行
     * @param int $remit_date 汇款日期
     * @param float $remit_money 汇款金额
     * @param type $claim_name 认领人 默认值：妈网推广平台
     * @return boolean
     */
    public static function payment($contract_no,$remit_name,$remit_bank,$remit_date,$remit_money,$claim_name="妈网推广平台") {
        $params = ['remit_name'=>$remit_name,'remit_bank'=>$remit_bank,'remit_date'=>$remit_date,
            'remit_money'=>$remit_money,'claim_name'=>$claim_name,'identifie'=>$contract_no];
        $params['t'] = time();
        $params['do'] = 'add_return_money';
        $params['appkey'] = self::$appkey;
        $params['sign'] = self::getSign($params);
        $params['timeout'] = 30;
        $curl = new Post();
        $url = "http://contract.mama.cn/gateway.php";
        $logger = Phalcon\Di::getDefault()->getShared('logger');
        try{
            $json_rs = $curl->socket($url, $params);
            $logger->info( '更新回款信息,接口返回：'.$json_rs .', Params:'. json_encode($params) );
            $rs = json_decode($json_rs,true);
            if(isset( $rs['code'] ) && $rs['code'] == 0){
                return $rs['data']['rm_id'];
            }else{
                return false;
            }
        }catch(\Exception $e){
            $code = $e->getCode();
            $msg = $e->getMessage();
            //TODO:log
            $logger->error('更新回款信息,Code:'.$code.',Error:'.$msg.', Params:'. json_encode($params) );
            return false;
        }
    }
    /**
     * 更新合同 
     * @param type $contract_no 合同编号
     * @param type $money 合同金额（在原基础上增加）
     * @param type $customer 客户名称（甲方）
     * @param type $contact_name 客户联系人名字
     * @param type $contact_address 客户联系人地址
     * @param type $contact_phone 联系人手机
     * @param type $contact_email 联系人邮箱
     * @param type $attachment 资质文件
     * @param type $need_invoice 是否开发票
     * @return boolean
     */
    public static function updateContract($contract_no,$money=0,$customer=NULL,$contact_name=NULL,$contact_address=NULL,$contact_phone=NULL,$contact_email=NULL,$attachment=NULL,$need_invoice=1) {
        $params = ['identifie'=>$contract_no,'update_value'=>$money,'update_field'=>'total_money'];
        if( !is_null($customer) ){
            $params['customer'] = $customer;
        }
        if( !is_null($contact_name) ){
            $params['contact_name'] = $contact_name;
        }
        if( !is_null($contact_address) ){
            $params['contact_address'] = $contact_address;
        }
        if( !is_null($contact_phone) ){
            $params['contact_phone'] = $contact_phone;
        }
        if( !is_null($contact_email) ){
            $params['contact_email'] = $contact_email;
        }
        if( !is_null($need_invoice) ){
            $params['need_invoice'] = $need_invoice;
        }
        $params['t'] = time();
        $params['do'] = 'update_contract';
        $params['appkey'] = self::$appkey;
        $params['sign'] = self::getSign($params);
        $params['timeout'] = 30;
        if(  !is_null($attachment) && is_array($attachment) ){
            foreach ( $attachment as $key=>$item ){
                $params['attachment['.$key.']'] = new CURLFile(realpath($item));
            }
        }
        $curl = new Post(true);
        $url = "http://contract.mama.cn/gateway.php";
        $logger = Phalcon\Di::getDefault()->getShared('logger');
        try{
            $json_rs = $curl->socket($url, $params);
            $logger->info( '更新合同金额,接口返回：'.$json_rs .', Params:'. json_encode($params) );
            $rs = json_decode($json_rs,true);
            if(isset( $rs['code'] ) && $rs['code'] == 0){
                return true;
            }else{
                return false;
            }
        }catch(\Exception $e){
            $code = $e->getCode();
            $msg = $e->getMessage();
            //TODO:log
            $logger->error('更新合同金额,Code:'.$code.',Error:'.$msg.', Params:'. json_encode($params) );
            return false;
        }
    }
    
    /**
     * 合同执行金额
     * @param string $contract_no
     * @param float $amount
     * @param int $created
     * @param int $begin_time
     * @param int $end_time
     * @param string $operator 默认值：妈网推广平台
     * @return boolean
     */
    public static function createCostMoney($contract_no,$amount,$created,$begin_time,$end_time,$operator='妈网推广平台') {
        $params = ['identifie'=>$contract_no,'executed_money'=>$amount,
            'cal_time'=>$created,'start_time'=>$begin_time,'end_time'=>$end_time,'operator'=>$operator];
        $params['t'] = time();
        $params['do'] = 'add_executed_money';
        $params['appkey'] = self::$appkey;
        $params['sign'] = self::getSign($params);
        $params['timeout'] = 30;
        $curl = new Post();
        $url = "http://contract.mama.cn/gateway.php";
        $logger = Phalcon\Di::getDefault()->getShared('logger');
        try{
            $json_rs = $curl->socket($url, $params);
            $logger->info( '添加合同执行金额,接口返回：'.$json_rs.', Params:'. json_encode($params)  );
            $rs = json_decode($json_rs,true);
            if( isset( $rs['code'] ) && $rs['code'] == 0){
                return true;
            }else{
                return false;
            }
        }catch(\Exception $e){
            $code = $e->getCode();
            $msg = $e->getMessage();
            //TODO:log
            $logger->error('添加合同执行金额,Code:'.$code.',Error:'.$msg.', Params:'. json_encode($params) );
            return false;
        }
    }
    /**
     * 获取销售人员
     * @return type
     */
    public static function getSalers() {
        $params = ['t'=>time()];
        $params['do'] = 'get_salers';
        $params['appkey'] = self::$appkey;
        $params['sign'] = self::getSign($params);
        $params['timeout'] = 30;
        $curl = new Get();
        $url = "http://contract.mama.cn/gateway.php";
        $logger = Phalcon\Di::getDefault()->getShared('logger');
        try{
            $json_rs = $curl->socket($url, $params);
            $rs = json_decode($json_rs,true);
            if(isset( $rs['code'] ) && $rs['code'] == 0){
                return $rs['data'];
            }else{
                $logger->info('获取销售人员接口,接口返回:'. $json_rs );
                return array();
            }
        }catch(\Exception $e){
            $code = $e->getCode();
            $msg = $e->getMessage();
            $logger->error('获取销售人员接口,Code:'.$code.',Error:'.$msg.', Params:'. json_encode($params) );
            return array();
        }
    }
}
