<?php
use \phalcon\Exception;

class RemoteApiException extends Exception
{
	/**
	 * 错误信息数组
	 *
	 * @var array
	 */
	protected static $_codeList = array(

		1001 => 'Api Server Response 404',
		1000 => 'Api Server Response Other Error',
		10086 => 'Not support Curl Mutli'

	);

	public function __construct($code, $message = null, $previous = null) {
		if (!is_numeric($code)) {
			$code = 10008;
		}
		$message = isset($message) ? $message : self::$_codeList[$code];
		parent::__construct($message, $code, $previous);
	}

	public static function getCodeName($code = '') {
		return isset(self::$_codeList[$code]) ? self::$_codeList[$code] : self::$_codeList['10008'];
	}
}