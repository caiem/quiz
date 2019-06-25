<?php

/**
 * 区域接口SDK
 * http://swagger-ui.corp.mama.cn/2.0/dist/index.html?url=/2.0/dist/spec/address.api.mama.cn/v1/regions.json#!/regions
 *
 * User: wudiandian
 * Date: 16-12-19
 * Time: 下午6:57
 * 
 */
class RegionsSdk extends AddressSdkBase {

    public function __construct() {
        parent::__construct();
    }

    /**
     * 获取省,直辖市列表
     *
     * @param string $format 数据返回格式
     * @return mixed
     */
    public function getProvince($format = 'json') {
        $uri = 'regions/getprovince';
        $params = array();

        $result = $this->get($uri, $params, $format);
        if (ADDRESS_SDK_DEBUG) {
            $this->debug();
        }

        return $result;
    }

    /**
     * 获取所有城市列表
     *
     * @param string $format 数据返回格式
     * @return mixed
     */
    public function getCitylist($format = 'json') {
        $uri = 'regions/getcitylist';
        $params = array();

        $result = $this->get($uri, $params, $format);
        if (ADDRESS_SDK_DEBUG) {
            $this->debug();
        }

        return $result;
    }
    
    /**
     * 获取等级城市列表
     *
     * @param string $format 数据返回格式
     * @return mixed
     */
    public function getcitylevellist($format = 'json') {
        $uri = 'regions/getcitylevellist';
        $params = array();
    
        $result = $this->get($uri, $params, $format);
        if (ADDRESS_SDK_DEBUG) {
            $this->debug();
        }
    
        return $result;
    }
    
    /**
     * 获取省级城市列表
     *
     * @param string $format 数据返回格式
     * @return mixed
     */
    public function getprovincialcity($format = 'json') {
        $uri = 'regions/getprovincialcity';
        $params = array();
    
        $result = $this->get($uri, $params, $format);
        if (ADDRESS_SDK_DEBUG) {
            $this->debug();
        }
    
        return $result;
    }
    
    /**
     * 获取特殊地区
     *
     * @param string $format 数据返回格式
     * @return mixed
     */
    public function getspecialregion($format = 'json') {
        $uri = 'regions/getspecialregion';
        $params = array();

        $result = $this->get($uri, $params, $format);
        if (ADDRESS_SDK_DEBUG) {
            $this->debug();
        }

        return $result;
    }
    
    /**
     * 根据名称获取地区信息
     *
     * @param string $format 数据返回格式
     * @return mixed
     */
    public function getregionbyname($name,$format = 'json') {
        $uri = 'regions/getregionbyname';
        $params = array();
        $params['name'] = $name;
    
        $result = $this->get($uri, $params, $format);
        if (ADDRESS_SDK_DEBUG) {
            $this->debug();
        }
    
        return $result;
    }
    
    /**
     * 根据id获取本级及所有下级地区列表
     *
     * @param string $format 数据返回格式
     * @return mixed
     */
    public function getlistbyid($id,$format = 'json') {
        $uri = 'regions/getlistbyid';
        $params = array();
        $params['id'] = $id;
    
        $result = $this->get($uri, $params, $format);
        if (ADDRESS_SDK_DEBUG) {
            $this->debug();
        }
    
        return $result;
    }
    
    /**
     * 根据name获取本级及所有下级地区列表
     *
     * @param string $format 数据返回格式
     * @return mixed
     */
    public function getlistbyname($name,$format = 'json') {
        $uri = 'regions/getlistbyname';
        $params = array();
        $params['name'] = $name;
    
        $result = $this->get($uri, $params, $format);
        if (ADDRESS_SDK_DEBUG) {
            $this->debug();
        }
    
        return $result;
    }
    
    /**
     * 根据id获取地区信息
     *
     * @param string $format 数据返回格式
     * @return mixed
     */
    public function getbyid($id,$format = 'json') {
        $uri = 'regions/getbyid';
        $params = array();
        $params['id'] = $id;
    
        $result = $this->get($uri, $params, $format);
        if (ADDRESS_SDK_DEBUG) {
            $this->debug();
        }
    
        return $result;
    }
    
    /**
     * 根据ids获取多个地区信息
     *
     * @param string $format 数据返回格式
     * @return mixed
     */
    public function getbyids($ids,$format = 'json') {
        $uri = 'regions/getbyids';
        $params = array();
        $params['ids'] = $ids;
    
        $result = $this->get($uri, $params, $format);
        if (ADDRESS_SDK_DEBUG) {
            $this->debug();
        }
    
        return $result;
    }
    
    /**
     * 根据parent_id获取地区信息
     *
     * @param string $format 数据返回格式
     * @return mixed
     */
    public function getbyparentid($pid,$format = 'json') {
        $uri = 'regions/getbyparentid';
        $params = array();
        $params['pid'] = $pid;
    
        $result = $this->get($uri, $params, $format);
        if (ADDRESS_SDK_DEBUG) {
            $this->debug();
        }
    
        return $result;
    }
    
    /**
     * 由下级的id, 获取他的上级信息
     *
     * @param string $format 数据返回格式
     * @return mixed
     */
    public function getparentbyid($id,$format = 'json') {
        $uri = 'regions/getparentbyid';
        $params = array();
        $params['id'] = $id;
    
        $result = $this->get($uri, $params, $format);
        if (ADDRESS_SDK_DEBUG) {
            $this->debug();
        }
    
        return $result;
    }


}
