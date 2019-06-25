<?php
/**
 * 路由初始化配置
 * （配合router对象使用）
 */

return array(
	array(
        "pattern" => "/api/:controller/:action/:params",
        "paths" => array(
            "namespace" => "Api\Controller",
            "controller" => 1,
            "action" => 2,
            "params" => 3
        )
	),
	array(
        "pattern" => "/manage/:controller/:action/:params",
        "paths" => array(
            "namespace" => "Manage\Controller",
            "controller" => 1,
            "action" => 2,
            "params" => 3
        )
	),
);