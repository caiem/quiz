{{ partial('common/header') }}
</head>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper">

  {{ partial('common/navbar',['logout':'/manage/index/logout']) }}
  <!-- Left side column. contains the logo and sidebar -->
  {{ partial('common/sidebar',['type':'/manage']) }}

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        系统设置
        <small>系统管理</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">系统管理</a></li>
        <li class="active">系统设置</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">
        <div class="row">
            <div class="col-xs-12">
                <div class="box">
                    <div class="box-body table-responsive no-padding">
                        <form class="form-horizontal" action="/manage/Index/setting" id="form_post" method="post">
                          <!-- 用户名设置 -->
                          <div class="panel panel-primary">
                            <div class="panel-heading">
                                <h3 class="panel-title">常量配置</h3>
                            </div>
                            <div class="panel-body">
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="formGroupInputLarge">余额提示邮件：</label>
                                    <div class="col-sm-6">
                                        <input class="form-control" type="number" min="0" name="lowerLimit" value="{{configs['lowerLimit']|default('')}}">
                                        <small>广告投放商余额达到一定值后发送邮件进行提示。不设置则不发送。以元为单位。</small>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="formGroupInputLarge">广告商账号默认密码：</label>
                                    <div class="col-sm-6">
                                        <input class="form-control" type="text" name="initialPwd" value="{{configs['initialPwd']|default('')}}">
                                        <small>创建广告商账号默认填写密码。默认为：mamawang123</small>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="formGroupInputLarge">开发者账号默认密码：</label>
                                    <div class="col-sm-6">
                                        <input class="form-control" type="text" name="develop_init_pwd" value="{{configs['develop_init_pwd']|default('')}}">
                                        <small>创建开发者账号默认填写密码。默认为：mmwdeveloper</small>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="formGroupInputLarge">账户最低充值金额：</label>
                                    <div class="col-sm-6">
                                        <input class="form-control" type="text" name="charge_limit" value="{{configs['charge_limit']|default('')}}">
                                        <small>广告商自助充值最低金额。默认为：100</small>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="formGroupInputLarge">账户首充最低金额：</label>
                                    <div class="col-sm-6">
                                        <input class="form-control" type="text" name="first_charge" value="{{configs['first_charge']|default('')}}">
                                        <small>广告商首次充值最低金额。默认为：5000</small>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="formGroupInputLarge">可选充值金额：</label>
                                    <div class="col-sm-6">
                                        <input class="form-control" type="text" name="charge_list" value="{{configs['charge_list']|default('')}}">
                                        <small>广告商可选充值金额。</small>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="formGroupInputLarge">推广联系人：</label>
                                    <div class="col-sm-6">
                                        <input class="form-control" type="text" name="contract_name" value="{{configs['contract_name']|default('')}}">
                                        <small>推广平台联系人</small>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="formGroupInputLarge">推广联系人邮箱：</label>
                                    <div class="col-sm-6">
                                        <input class="form-control" type="text" name="contract_email" value="{{configs['contract_email']|default('')}}">
                                        <small>推广平台联系人的邮箱</small>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="formGroupInputLarge">返点设置：</label>
                                    <div class="col-sm-6">
                                        <textarea class="form-control" name="charge_rebate">{{configs['charge_rebate']|default('')}}</textarea>
                                        <small>充值返点设置,格式：<span class="red">金额:返点值</span>，其中返点值为小数，一行一个配置</small>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="formGroupInputLarge">合同通知人：</label>
                                    <div class="col-sm-6">
                                        <textarea class="form-control" name="contract_notice">{{configs['contract_notice']|default('')}}</textarea>
                                        <small>合同通知人，一行一个配置</small>
                                    </div>
                                </div>
                                <div class="box box-solid collapsed-box">
                                    <div class="box-header with-border">
                                      <h3 class="box-title">广告相关配置</h3>

                                      <div class="box-tools">
                                        <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i>
                                        </button>
                                      </div>
                                    </div>
                                    <div class="box-body no-padding">
                                      <ul class="nav nav-pills nav-stacked">
                                        <li>
                                            <div class="form-group">
                                                <label class="col-sm-2 control-label" for="formGroupInputLarge">IOS最低CPC单价：</label>
                                                <div class="col-sm-6">
                                                    <input class="form-control" type="text" name="ios_price" value="{{configs['ios_price']|default('')}}">
                                                    <small>IOS最低CPC单价</small>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="form-group">
                                                <label class="col-sm-2 control-label" for="formGroupInputLarge">Android最低CPC价格：</label>
                                                <div class="col-sm-6">
                                                    <input class="form-control" type="text" name="android_price" value="{{configs['android_price']|default('')}}">
                                                    <small>Android最低CPC价格</small>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="form-group">
                                                <label class="col-sm-2 control-label" for="formGroupInputLarge">WAP最低CPC价格：</label>
                                                <div class="col-sm-6">
                                                    <input class="form-control" type="text" name="wap_price" value="{{configs['wap_price']|default('')}}">
                                                    <small>WAP最低CPC价格</small>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="form-group">
                                                <label class="col-sm-2 control-label" for="formGroupInputLarge">CPC日限额最低点击量：</label>
                                                <div class="col-sm-6">
                                                    <input class="form-control" type="nunber" name="day_limit_times" value="{{configs['day_limit_times']|default('')}}">
                                                    <small>CPC日限额初始值,是指日限额的初始设置值是价格的几倍</small>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="form-group">
                                                <label class="col-sm-2 control-label" for="formGroupInputLarge">CPC日限额点击量涨幅：</label>
                                                <div class="col-sm-6">
                                                    <input class="form-control" type="nunber" name="day_limit_steps" value="{{configs['day_limit_steps']|default('')}}">
                                                    <small>CPC日限额增长值,是指日限额每次增长幅度是价格的几倍</small>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="form-group">
                                                <label class="col-sm-2 control-label" for="formGroupInputLarge">CPM单价：</label>
                                                <div class="col-sm-6">
                                                    <input class="form-control" type="text" name="cpm_price" value="{{configs['cpm_price']|default('')}}">
                                                    <small>一个CPM的价格</small>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="form-group">
                                                <label class="col-sm-2 control-label" for="formGroupInputLarge">IOS最低目标CPM值：</label>
                                                <div class="col-sm-6">
                                                    <input class="form-control" type="number" name="ios_target_cpm" value="{{configs['ios_target_cpm']|default('')}}">
                                                    <small>IOS端最低设定的目标CPM值</small>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="form-group">
                                                <label class="col-sm-2 control-label" for="formGroupInputLarge">Android最低目标CPM值：</label>
                                                <div class="col-sm-6">
                                                    <input class="form-control" type="number" name="android_target_cpm" value="{{configs['android_target_cpm']|default('')}}">
                                                    <small>Android端最低设定的目标CPM值</small>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="form-group">
                                                <label class="col-sm-2 control-label" for="formGroupInputLarge">WAP最低目标CPM值：</label>
                                                <div class="col-sm-6">
                                                    <input class="form-control" type="number" name="wap_target_cpm" value="{{configs['wap_target_cpm']|default('')}}">
                                                    <small>WAP端最低设定的目标CPM值</small>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="form-group">
                                                <label class="col-sm-2 control-label" for="formGroupInputLarge">是否给原生广告加水印：</label>
                                                <div class="col-sm-6">
                                                    <label class="radio-inline">
                                                        <input name="native_mask" type="radio" value="yes" {% if configs['native_mask'] is defined and configs['native_mask'] =='yes' %}checked{% endif %}>是 
                                                    </label>
                                                    <label class="radio-inline">
                                                        <input name="native_mask" type="radio" value="no" {% if configs['native_mask'] is defined and configs['native_mask'] =='no' %}checked{% endif %}>否
                                                    </label>
                                                    <small>设置是否给信息流广告加上水印。</small>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="form-group">
                                                <label class="col-sm-2 control-label" for="formGroupInputLarge">App端-信息流-广告尺寸：</label>
                                                <div class="col-sm-6">
                                                    <textarea class="form-control" name="app_info_image_limit">{{configs['app_info_image_limit']|default('')}}</textarea>
                                                    <small>App端-信息流-广告尺寸限制, 格式：<span class="red">宽*高，多个尺寸以","分隔</span></small>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="form-group">
                                                <label class="col-sm-2 control-label" for="formGroupInputLarge">App端-Banner-广告尺寸：</label>
                                                <div class="col-sm-6">
                                                    <textarea class="form-control" name="app_banner_image_limit">{{configs['app_banner_image_limit']|default('')}}</textarea>
                                                    <small>App端-Banner-广告尺寸限制, 格式：<span class="red">宽*高，多个尺寸以","分隔</span></small>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="form-group">
                                                <label class="col-sm-2 control-label" for="formGroupInputLarge">WAP-Banner-广告尺寸：</label>
                                                <div class="col-sm-6">
                                                    <textarea class="form-control" name="wap_banner_image_limit">{{configs['wap_banner_image_limit']|default('')}}</textarea>
                                                    <small>网页端-WAP-Banner-广告尺寸限制, 格式：<span class="red">宽*高，多个尺寸以","分隔</span></small>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="form-group">
                                                <label class="col-sm-2 control-label" for="formGroupInputLarge">PC-Banner-广告尺寸：</label>
                                                <div class="col-sm-6">
                                                    <textarea class="form-control" name="pc_banner_image_limit">{{configs['pc_banner_image_limit']|default('')}}</textarea>
                                                    <small>网页端-PC-Banner-广告尺寸限制, 格式：<span class="red">宽*高，多个尺寸以","分隔</span></small>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="form-group">
                                                <label class="col-sm-2 control-label" for="formGroupInputLarge">曝光频次设置：</label>
                                                <div class="col-sm-6">
                                                    <input class="form-control" type="number" name="exposure_frequency" value="{{configs['exposure_frequency']|default('')}}">
                                                    <small>同一个广告对同一个用户在24小时内的最大曝光次数. <span class="red">修改后次日凌晨生效</span></small>
                                                </div>
                                            </div>
                                        </li>
                                      </ul>
                                    </div>
                                    <!-- /.box-body -->
                                </div>
                                <div class="box box-solid collapsed-box">
                                    <div class="box-header with-border">
                                      <h3 class="box-title">开发者应用相关配置</h3>

                                      <div class="box-tools">
                                        <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i>
                                        </button>
                                      </div>
                                    </div>
                                    <div class="box-body no-padding">
                                      <ul class="nav nav-pills nav-stacked">
                                        <li>
                                            <div class="form-group">
                                                <label class="col-sm-2 control-label" for="formGroupInputLarge">行业设置：</label>
                                                <div class="col-sm-6">
                                                    <textarea class="form-control" name="industry_classify">{{configs['industry_classify']|default('')}}</textarea>
                                                    <small>开发者应用归属行业. 格式：<span class="red">行业标识:行业名称</span>，一行一个配置</small>
                                                </div>
                                            </div>
                                        </li>
                                      </ul>
                                    </div>
                                    <!-- /.box-body -->
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="formGroupInputLarge"></label>
                                    <div class="col-sm-6">
                                        <button class="btn btn-primary setting" type="button">确认修改</button>
                                    </div>
                                </div>
                            </div>
                          </div>
                          <!-- 用户名设置 -->
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- /.content -->
  </div>
  <!-- /.content-wrapper -->
  {{ partial('common/copyright') }}
</div>
<!-- ./wrapper -->
    {{ partial('common/footer') }}
<script>
$(document).ready(function(){
  $(".setting").click(function(){
    var query = $("#form_post").serialize();
    var url = $("#form_post").attr("action");
    ajaxDev(url,query,'');
  });
});
</script>
    </body>
</html>
