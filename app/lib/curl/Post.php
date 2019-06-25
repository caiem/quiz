<?php
/**
 * POST方式 cURL
 *
 */
class Post extends AbstractCurl {
    protected $with_file;
    /**
	 * 调用父构造方法
	 *
	 */
	public function __construct( $with_file=FALSE ) {
            $this->with_file = $with_file;
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
		curl_setopt($this->_ch, CURLOPT_POST, true);
		if (!empty($para)) {
			if (!$this->with_file && is_array($para)) {
				$para = http_build_query($para);
			}
                        curl_setopt($this->_ch, CURLOPT_POSTFIELDS, $para);
		}
	}

    public function getCurlInstance()
    {
        return $this->_ch;
    }
}
