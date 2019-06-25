{{ partial('common/header') }}
<link rel="stylesheet" href="/plugins/fancybox/jquery.fancybox.min.css" type="text/css" media="screen" />
<link rel="stylesheet" href="/plugins/select2/select2.min.css">
<style>
    #select_condition{
        background-color: #FFFFD7;//gold;
        height: 60px;
        width:800px;
        text-align: center;
        margin: 0 auto;
        margin-bottom: 15px;
    }
    .ads_tpyes tr{
        cursor: pointer;
    }
</style>
</head>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper">

  {{ partial('common/navbar',['logout':'/index/logout']) }}
  <!-- Left side column. contains the logo and sidebar -->
  {{ partial('common/sidebar_ad') }}

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        修改广告
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">自助投放管理</a></li>
        <li class="active">修改广告</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">
        <div class="row">
            <div class="col-xs-12">
                <div class="box">
                    <div class="box-body table-responsive no-padding">
                        <form class="form-horizontal" action="/Advertise/update?id={{adInfo['ad_id']}}" id="form_post">
                          <!-- 新增广告 -->
                          <div class="panel panel-primary">
                            <div class="panel-heading">
                                <h3 class="panel-title">广告基本信息</h3>
                            </div>
                            <div class="panel-body">
                                <div class="form-group">
                                    <label class="col-sm-2 control-label input_require" for="formGroupInputLarge">广告名称</label>
                                    <div class="col-sm-6">
                                        <input class="form-control" type="text" name="ad_name" value="{{adInfo['ad_name']|default('')}}">
                                    </div>
                                    <div class="col-sm-4 notice_gray">填写易于识别的广告推广名称，不重复</div>
                                </div>
                                {% if isAgent is not empty %}
                                <div class="form-group">
                                  <label class="col-sm-2 control-label input_require" for="formGroupInputLarge">代投企业:</label>
                                  <div class="col-sm-6">
                                    <select name="belongto" class="form-control" disabled>
                                      {% for key,item in agentLists%}
                                        <option value="{{item['user_id']}}"  {% if adInfo['belong_to'] is defined and item['user_id']== adInfo['belong_to']%}selected{% endif %}>{{item['realname']}}</option>
                                      {% endfor %}
                                    </select>
                                  </div>
                                  <div class="col-sm-4 notice_gray">请选择代投企业，选择后该代投企业可以看到该广告。注：一旦选定不可更改</div>
                                </div>
                                {% endif %}
                                <div class="form-group p_notice">
                                    <label class="col-sm-2 control-label input_require" for="formGroupInputLarge">投放端</label>
                                    <div class="col-sm-6">
                                        {% for key,item in advertiseTarget%}
                                        <label class="radio-inline">
                                            <input name="target" type="radio" value="{{key}}" {% if adInfo['target'] is defined and key== adInfo['target']%}checked{%else%}disabled{% endif %}>{{item}}    
                                        </label>
                                        {% endfor %}
                                    </div>
                                    <div class="col-sm-4 notice_gray">选择投放的应用端，分App与网页。<span class="red">注：一旦选定后不可更改</span></div>
                                </div>
                                <div class="form-group p_notice ad_postion">
                                    <label class="col-sm-2 control-label input_require" for="formGroupInputLarge">广告版位</label>
                                    <div class="col-sm-6">
                                        <table class="table table-hover">
                                            <thead style="display:block;">
                                                <tr><th width="240">广告版位</th><th width="120">广告类型</th><th>创意形式</th></tr>
                                            </thead>
                                            <tbody class="target-config wap-config {% if adInfo['target'] is defined and 2!= adInfo['target']  or adInfo['target'] is not defined%}hidden{%endif%} ads_tpyes" style="display:block; max-height:200px;overflow-y: scroll;">
                                                {% for key,item in adPositions%}
                                                {% if item['target']==2 %}
                                                <tr u="1"><td width="240"><input disabled data-content='{{item|json_encode}}' name="kk" type="radio" {% if adInfo['target']==item['target'] AND ( adInfo['target']!=2 ? adInfo['ad_type']== item['ad_type'] : adInfo['ad_type'] ~ '_' ~ adInfo['platforms']  == item['ad_type'] ) AND adInfo['ad_size']==item['ad_size']%}checked{% endif %}/>{{item['name']}}</td><td width="120">{{ item['target']!=2 ? advertiseType[item['ad_type']] :advertiseTypeWap[item['ad_type']] }}</td><td>{{item['ad_size']}}{{item['ad_type']!='inforflow'?'单图':'多图'}}</td></tr>
                                                {% endif %}
                                                {% endfor %}
                                            </tbody>
                                            <tbody class="target-config app-config {% if adInfo['target'] is defined and 1!= adInfo['target']%}hidden{%endif%} ads_tpyes" style="display:block; max-height:200px;overflow-y: scroll;">
                                                {% for key,item in adPositions%}
                                                {% if item['target']!=2 %}
                                                <tr u="1"><td width="240"><input disabled data-content='{{item|json_encode}}' name="kk" type="radio" {% if adInfo['target']==item['target'] AND ( adInfo['target']!=2 ? adInfo['ad_type']== item['ad_type'] : adInfo['ad_type'] ~ '_' ~ adInfo['platforms']  == item['ad_type'] ) AND adInfo['ad_size']==item['ad_size']%}checked{% endif %}/>{{item['name']}}</td><td width="120">{{ item['target']!=2 ? advertiseType[item['ad_type']] :advertiseTypeWap[item['ad_type']] }}</td><td>{{item['ad_size']}}{{item['ad_type']!='inforflow'?'单图':'多图'}}</td></tr>
                                                {% endif %}
                                                {% endfor %}
                                            </tbody>
                                        </table>
                                    </div>
                                    <div class="col-sm-4 notice_gray">选择投放的点位类型。<span class="red">注：一旦选定后不可更改</span></div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="formGroupInputLarge">广告效果预览</label>
                                    <div class="ad_preview col-sm-6">
                                        <a class="viewImg" rel="group" href="/dist/img/nopic.gif"><img style="max-height:80px;max-width:520px" src="/dist/img/nopic.gif"  ></a>
                                    </div>
                                </div>
                                <div class="form-group p_notice">
                                    <label class="col-sm-2 control-label input_require" for="formGroupInputLarge">结算方式</label>
                                    <div class="col-sm-6">
                                        {% for key,item in adCostType%}
                                        <label id="edit_cost_type_{{key}}" class="radio-inline">
                                            <input name="cost_type" type="radio" value="{{key}}" {% if adInfo['cost_type']==key%}checked{%else%}disabled{% endif %}>{{item}}
                                        </label>
                                        {% endfor %}
                                    </div>
                                    <div class="col-sm-4 notice_gray">结算方式。<span class="red">注：一旦选定后不可更改</span></div>
                                </div>
                                <div class="form-group p_notice target-config app-config {% if adInfo['target'] is defined and 1!= adInfo['target']%}hidden{%endif%}">
                                    <label class="col-sm-2 control-label input_require" for="formGroupInputLarge">定向设备</label>
                                    <div class="col-sm-6">
                                        {% for key,item in platfroms%}
                                        <label class="radio-inline">
                                            <input {% if adInfo['cost_type']==2 %}disabled{% endif %} name="platforms" type="radio" value="{{key}}" {% if adInfo['platforms']==key%}checked{%endif%}>{{item}}    
                                        </label>
                                        {% endfor %}
                                    </div>
                                    <div class="col-sm-4 notice_gray">选择app端定向投放的设备。<span class="cost_cpm red">注：一旦选定后不可更改</span></div>
                                </div>
                                <div class="form-group p_notice">
                                    <label class="col-sm-2 control-label input_require" for="formGroupInputLarge">定向条件</label>
                                    <div class="col-sm-6">
                                        <select name="ugoup_select" ugindex="{{ugIndex}}" id="ugoup-select" class="form-control"></select>
                                    </div>
                                    <div class="col-sm-4 notice_gray">选择定向条件。可以直接选择使用已有的分组或重新创建<span class="cost_cpm red"></span></div>
                                </div>
                                <div id="target_setting" class="form-group p_notice">
                                    <label class="col-sm-1 control-label" for="formGroupInputLarge"></label>
                                    <div class="col-sm-9">
                                        <div id="select_condition" class="{% if ugIndex==0%}hidden{% endif %}">已选条件：<span data-content="{{formatData|default('--')}}">{{formatData|default('--')}}</span></div>
                                        <div id="edit-ugroup" class="{% if ugIndex==0%}hidden{% endif %}">
                                        {{ partial('advertiser/UsergroupFormPart') }}
                                        </div>
                                        <div id="new_or_update"></div>
                                        <div class="form-group group-name hidden">
                                            <label class="col-sm-1 control-label input_require" style="width:auto" for="formGroupInputLarge">分组名称:</label>
                                            <div class="col-sm-6">
                                                <input name="ugroup_name" type="text" class="form-control">
                                            </div>
                                            <div class="col-sm-4 notice_gray" style="line-height:20px">使用已有分组并修改了条件，将保存并创建为新分组；如不使用已有分组并选择了相关条件，将保存为新分组。</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="target-config app-config {% if adInfo['target'] is defined and 1!= adInfo['target']%}hidden{%endif%}">
                                    <div class="cost_cpc p_notice">
                                        <div class="form-group ios-pt {% if adInfo['platforms'] is defined and 2== adInfo['platforms']%}hidden{%endif%}">
                                            <label class="col-sm-2 control-label" for="formGroupInputLarge">IOS点击单价</label>
                                            <div class="col-sm-6">
                                                <input class="form-control" type="text" name="ios_price" value="{{adInfo['ios_price']|default('')}}">
                                            </div>
                                            <div class="col-sm-4 notice_gray">IOS端CPC结算单价,建议最低出价：<label class="ppnote">-</label></div>
                                        </div>
                                        <div class="form-group android-pt {% if adInfo['platforms'] is defined and 1== adInfo['platforms']%}hidden{%endif%}">
                                            <label class="col-sm-2 control-label" for="formGroupInputLarge">Android点击单价</label>
                                            <div class="col-sm-6">
                                                <input class="form-control" type="text" name="android_price" value="{{adInfo['android_price']|default('')}}">
                                            </div>
                                            <div class="col-sm-4 notice_gray">安卓端CPC结算单价,建议最低出价：<label class="ppnote">-</label></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="target-config app-config {% if adInfo['target'] is defined and 1!= adInfo['target']%}hidden{%endif%}">
                                    <div class="cost_cpm p_notice">
                                        <div class="form-group ios-pt {% if adInfo['platforms'] is defined and 2== adInfo['platforms']%}hidden{%endif%}">
                                            <label class="col-sm-2 control-label" for="formGroupInputLarge">IOS-目标CPM</label>
                                            <div class="col-sm-6">
                                                <input disabled class="form-control" type="text" name="ios_totals" value="{{adInfo['ios_totals']|default('')}}">
                                            </div>
                                            <div class="col-sm-4 notice_gray">必填。IOS端计划要达到的CPM,单位为个。<span class="red">注：一旦选定后不可更改,CPM单价：<label class="ppnote">-</label></span></div>
                                        </div>
                                        <div class="form-group android-pt {% if adInfo['platforms'] is defined and 1== adInfo['platforms']%}hidden{%endif%}">
                                            <label class="col-sm-2 control-label" for="formGroupInputLarge">Android-目标CPM</label>
                                            <div class="col-sm-6">
                                                <input disabled class="form-control" type="text" name="android_totals" value="{{adInfo['android_totals']|default('')}}">
                                            </div>
                                            <div class="col-sm-4 notice_gray">必填。Android端计划要达到的CPM,单位为个。<span class="red">注：一旦选定后不可更改,CPM单价：<label class="ppnote">-</label></span></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="target-config wap-config {% if adInfo['target'] is defined and 2!= adInfo['target']%}hidden{%endif%}">
                                    <div class="form-group cost_cpc p_notice">
                                        <label class="col-sm-2 control-label input_require" for="formGroupInputLarge">网页点击单价</label>
                                        <div class="col-sm-6">
                                            <input class="form-control" type="text" name="wap_price" value="{{adInfo['wap_price']|default('')}}">
                                        </div>
                                        <div class="col-sm-4 notice_gray">网页投放方式，CPC结算单价。建议最低出价：<label class="ppnote">-</label></div>
                                    </div>
                                </div>
                                <div class="target-config wap-config {% if adInfo['target'] is defined and 2!= adInfo['target']%}hidden{%endif%}">
                                    <div class="form-group cost_cpm p_notice">
                                        <label class="col-sm-2 control-label input_require" for="formGroupInputLarge">网页-目标CPM</label>
                                        <div class="col-sm-6">
                                            <input disabled class="form-control" type="text" name="wap_totals" value="{{adInfo['wap_totals']|default('')}}">
                                        </div>
                                        <div class="col-sm-4 notice_gray">必填。网页计划要达到的CPM,单位为个。<span class="red">注：一旦选定后不可更改,CPM单价：<label class="ppnote">-</label></span></div>
                                    </div>
                                </div>
                                <div class="form-group cost_cpc">
                                    <label class="col-sm-2 control-label input_require" for="formGroupInputLarge">日消费限额（元）</label>
                                    <div class="col-sm-6">
                                        <input class="form-control" type="text" name="day_cost_limit" value="{{adInfo['day_cost_limit']|default('')}}">
                                    </div>
                                    <div class="col-sm-4 notice_gray">必填，选择限额的投放将会在达到日限额后自动停止投放，0代表不限额</div>
                                    {% if isAgent is not empty %}
                                    <div class="red"><span class="col-sm-2"></span>温馨提示：该代投企业根据您的设置，目前余额为：<span class="edit_rest">-</span>，请合理设置日限额</div>
                                    {% endif %}
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label input_require" for="formGroupInputLarge">投放日期</label>
                                    <div class="col-sm-6">
                                        <input class="form-control Wdate" style="display:inline;width:48%" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'})" type="text" name="begin_time" value="{{date('Y-m-d H:i',adInfo['begin_time'])}}">
                                        <span class="cost_cpc">到
                                            <input class="form-control Wdate" style="display:inline;width:48%" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'})" type="text" name="end_time" value="{{date('Y-m-d H:i',adInfo['end_time'])}}">
                                        </span>
                                    </div>
                                    <div class="col-sm-4 notice_gray">投放的具体起始<span class="cost_cpc">和结束</span>日期<span class="cost_cpm">。当设定目标CPM消耗完毕时会自动下架</span></div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label input_require" for="formGroupInputLarge">投放时间</label>
                                    <div class="col-sm-6">
                                        <input class="form-control" style="display:inline;width:48%" type="number" min="0" max="23" name="begin_hour" value="{{adInfo['begin_hour']}}">到
                                        <input class="form-control" style="display:inline;width:48%" type="number" min="0" max="23" name="end_hour" value="{{adInfo['end_hour']}}">
                                    </div>
                                    <div class="col-sm-4 notice_gray">投放的具体每天的时间段范围</div>
                                </div>
                                <input type="hidden" name="uid" value="{{adInfo['user_id']|default('')}}">
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="formGroupInputLarge"></label>
                                    <div class="col-sm-6">
                                        <a class="btn btn-primary setting">修改基本信息</a>    <a url="/Advertise/source?id={{adInfo['ad_id']}}" class="btn btn-primary leavePage">下一步</a> <a url="/Advertise/index" class="btn btn-primary leavePage" >返回列表</a>
                                    </div>
                                </div>
                            </div>
                          </div>
                          <input id="edit_ad_type" name="ad_type" type="hidden" value="{{ adInfo['ad_type'] is defined ? ( adInfo['target']==2 ? adInfo['ad_type']~'_'~adInfo['platforms'] : adInfo['ad_type'] ) : '' }}">
                          <input id="edit_size" name="ad_size" type="hidden" value="{{ adInfo['ad_size'] is defined ? adInfo['ad_size'] : '' }}">
                          <!-- 新增广告 -->
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
<script src="/plugins/select2/select2.full.min.js"></script>
<script type="text/javascript" src="/plugins/fancybox/jquery.fancybox.min.js"></script>
<script src="/plugins/my97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/plugins/cityselect/jquery.cityselect.js"></script>
<script type="text/javascript" src="/js/advertiser/ugroup.js"></script>
<script src="/js/advertiser/editAd.js"></script>
<script>
var img = {{images}};
var uglist = {{ugList}};
$(document).ready(function(){
  $(".setting").click(function(){
    var query = $("#form_post").serialize();
    var url = $("#form_post").attr("action");
    if(checkInput()){
        ajaxDev(url,query,'');
    }
  });

  initAdPreview();
  $('select[name=ad_size]').on('change',function(){
    initAdPreview(true);
  });
  initCostType();
  {% if isAgent is not empty %}
  getbalance();
  {% endif %}
  $('#form_post').on('change','input,select',function(){
        $('.leavePage').data('content',1);
  });
  $('.leavePage').click(function(){
        if( $(this).data('content')==1 && confirm('是否保存当前修改？')){
            $(".setting").click();
        }else{
            window.location.href = $(this).attr('url');
        }
  });
});
$(function(){
  var target = $('input[name=target]:checked').val();
  var offset =  $('.ad_postion input:checked').closest('tr').index();
  var tclass = target =='1' ? '.app-config' : '.wap-config';
  var height = $('.ad_postion tbody'+ tclass +' tr').eq(offset).offset().top - $('.ad_postion tbody'+ tclass +' tr').eq(0).offset().top
  $('.ad_postion tbody').scrollTop( height )
})
</script>
    </body>
</html>
