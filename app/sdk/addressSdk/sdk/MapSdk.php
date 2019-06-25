<?php

/**
 * 区域接口SDK
 * http://swagger-ui.corp.mama.cn/2.0/dist/index.html?url=/2.0/dist/spec/address.api.mama.cn/v1/map.json#!/map
 *
 * User: wudiandian
 * Date: 16-12-19
 * Time: 下午6:57
 * 
 */
class MapSdk extends AddressSdkBase {

    public function __construct() {
        parent::__construct();
    }
    
    /**
     * 根据ip获取地理信息
     *
     * @param string $format 数据返回格式
     * @return mixed
     */
    public function getbyip($ip = null,$format = 'json') {
        $uri = 'map/getbyip';
        $params = array();
        $params['ip'] = $ip;
    
        $result = $this->get($uri, $params, $format);
        if (ADDRESS_SDK_DEBUG) {
            $this->debug();
        }
    
        return $result;
    }
    
    /**
     * 地理位置正向解析信息
     *
     * @param string $format 数据返回格式
     * @return mixed
     */
    public function getbyaddress($address, $city = null,$format = 'json') {
        $uri = 'map/getbyaddress';
        $params = array(
            'address' => $address,
            'city' => $city,
        );
    
        $result = $this->get($uri, $params, $format);
        if (ADDRESS_SDK_DEBUG) {
            $this->debug();
        }
    
        return $result;
    }
    
    /**
     * 地理位置逆向解析信息
     *
     * @param string $format 数据返回格式
     * @return mixed
     */
    public function getbylocation($location, $coordtype = null,$format = 'json') {
        $uri = 'map/getbylocation';
        $params = array(
            'location' => $location,
            'coordtype' => $coordtype,
        );
    
        $result = $this->get($uri, $params, $format);
        if (ADDRESS_SDK_DEBUG) {
            $this->debug();
        }
    
        return $result;
    }
    
    /**
     * 搜索地理位置周边信息
     *
     * @param string $format 数据返回格式
     * @return mixed
     */
    public function getbyplace($query, $region,$format = 'json') {
        $uri = 'map/getbyplace';
        $params = array(
            'query' => $query,
            'region' => $region,
        );
    
        $result = $this->get($uri, $params, $format);
        if (ADDRESS_SDK_DEBUG) {
            $this->debug();
        }
    
        return $result;
    }
    
    /**
     * 手机归属地查询
     *
     * @param string $format 数据返回格式
     * @return mixed
     */
    public function getbyphone($cellphone,$format = 'json') {
        $uri = 'map/getbyphone';
        $params = array(
            'cellphone' => $cellphone,
        );
    
        $result = $this->get($uri, $params, $format);
        if (ADDRESS_SDK_DEBUG) {
            $this->debug();
        }
    
        return $result;
    }
    


}
