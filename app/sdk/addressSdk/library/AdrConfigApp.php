<?php
/**
 * User: vincent.cao
 * Date: 14-5-4
 * Time: 上午9:57
 */

/**
 *  App配置
 */


class AdrConfigApp
{
    public static $version = null;
    public static $app_server = null;
    public static $app_key = null;
    public static $source = null;//接入方域名
}

AdrConfigApp::$version = '1.0';
AdrConfigApp::$app_server = 'http://address.api.mama.cn';
AdrConfigApp::$app_key = 'a9bfcbd77aed59d33d77710050ce42d6';
AdrConfigApp::$source = '';//接入方域名

