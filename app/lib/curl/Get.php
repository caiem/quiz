<?php
/**
 * Get方式 cURL
 *
 */
class Get extends AbstractCurl {
	
	/**
	 * 调用父构造方法
	 *
	 */
	public function __construct() {
		parent::__construct();
	}
	
	/**
	 * 实现cURL主体的抽象方法
	 *
	 * @param array $para
	 * 
	 * @return void
	 */
	protected function _cUrl($para = array()) {
	    if (!empty($para)) {
            if (is_array($para)) {
                curl_setopt($this->_ch, CURLOPT_URL, $this->_url.'?'.http_build_query($para));
            }
        }	
	}

    public function getCurlInstance()
    {
        return $this->_ch;
    }

}
