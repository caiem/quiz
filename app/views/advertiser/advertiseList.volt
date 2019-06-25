{{ partial('common/header') }}
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
        自助投放管理<small style="padding-left:30px;color:red">
            {% if AGENT_OR_SUB !=3 %}
            当前账户余额：<span id="acount_rest">{{account['balance']+account['rebate']}}</span> RMB{% if show=="detail" %}&nbsp&nbsp&nbsp<i class="fa fa-fw fa-question-circle" data-toggle="tooltip" title="C{{account['balance']}} / B{{account['rebate']}}"></i>{% endif %}
            {%else%}
            {% if account['rest']!==false%}账户余额：{{account['rest']>0 ? account['rest'] : 0}}{% endif %} &nbsp&nbsp&nbsp总消耗：{{account['expend']}}
            {% endif %}
        </small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li class="active">自助投放管理</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">

      <div class="row">
        <div class="col-xs-12">
          <div class="box">
            <div class="box-header">
                <form id="query_form" class="form-inline" role="form">
                    <div class="form-group">
                      <label>广告ID:</label>
                      <input name="ad_id" type="text" value="{{searchItem['ad_id']|default('')}}" class="form-control"  placeholder="请输入广告ID">
                    </div>
                    <div class="form-group">
                      <label>投放状态:</label>
                      <select name="status" class="form-control">
                        {% for key,item in advertisingType%}
                          <option value="{{key}}" {%if key==searchItem['status'] or (searchItem['status']=='' and key==4)  %}selected{%endif%}>{{item}}</option>
                        {% endfor %}
                      </select>
                    </div>
                    <div id="targets" class="form-group">
                        <div class="form-group">
                          <label>投放端:</label>
                          <select name="target" class="form-control prov">
                            <option value="">全部</option>
                            {% for key,item in advertiseTarget%}
                              <option value="{{key}}" {%if key==searchItem['target']%}selected{%endif%}>{{item}}</option>
                            {% endfor %}
                          </select>
                        </div>
                        <div class="form-group">
                          <label>广告类型:</label>
                          <select name="ad_type" class="form-control city">
                            <option value="">全部</option>
                            {% for key,item in advertiseType%}
                              <option value="{{key}}" {%if key==searchItem['ad_type']%}selected{%endif%}>{{item}}</option>
                            {% endfor %}
                          </select>
                        </div>
                    </div>
                    <div class="form-group">
                      <label>计费方式:</label>
                      <select name="cost_type" class="form-control">
                        <option value="">全部</option>
                        {% for key,item in adCostType%}
                          <option value="{{key}}" {%if key==searchItem['cost_type'] %}selected{%endif%}>{{item}}</option>
                        {% endfor %}
                      </select>
                    </div>
            {#        <div class="form-group">
                      <label>PV情况:</label>
                      <select name="pv" class="form-control">
                        {% for key,item in advertisePosition%}
                          <option value="{{key}}" {%if searchItem['pv']!='' and key==searchItem['pv']%}selected{%endif%}>{{item}}</option>
                        {% endfor %}
                      </select>
                    </div>  #}
                    <div class="form-group">
                      <label>开始时间:</label>
                      <input name="begin_time" type="date" value="{{searchItem['begin_time']|default('')}}" onClick="WdatePicker()" class="form-control Wdate" placeholder="">
                    </div>
                    <div class="form-group">
                      <label>结束时间:</label>
                      <input name="end_time" type="date" value="{{searchItem['end_time']|default('')}}" onClick="WdatePicker()" class="form-control Wdate" placeholder="">
                    </div>
                    {% if isAgent is not empty %}
                    <div class="form-group">
                      <label>代投企业:</label>
                      <select name="belongto" class="form-control">
                        <option value="">-请选择-</option>
                        {% for key,item in agentLists%}
                          <option value="{{item['user_id']}}" {%if item['user_id']==searchItem['belongto'] %}selected{%endif%}>{{item['realname']}}</option>
                        {% endfor %}
                      </select>
                    </div>
                    {% endif %}
                    <div style="padding:0px 20px;float:right">
                        <input type="submit" class="btn btn-info" value="查询"/>
                        <span style="float:right;margin:0 10px">{% if AGENT_OR_SUB !=3 %}<a {% if account['balance']+account['rebate']>0 %} href="/Advertise/add" {%else%} data-target="#modal-BNotice" data-toggle="modal"  href="javascript:void(0)"{% endif %} class="btn btn-info">新增</a>{% endif %} <a href="javascript:void(0);" class="btn btn-info download">下载</a></span>
                    </div>
                </form>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding" style="overflow-x: visible">
              <table class="table table-hover">
                <tr>
                  <th>名称</th>
                  <th>点位类型</th>
                  <th class="sort" field='pv' desc="{% if order and order[0]=='pv' and order[1]%}0{%else%}1{%endif%}">
                    曝光量<a class="fa fa-sort {% if order and order[0]=='pv'%}fa-sort-{{order[1]?'desc':'asc'}}{%endif%}"></a>
                  </th>
                  <th class="sort" field='click' desc="{% if order and order[0]=='click' and order[1]%}0{%else%}1{%endif%}">
                    点击量<a class="fa fa-sort {% if order and order[0]=='click'%}fa-sort-{{order[1]?'desc':'asc'}}{%endif%}"></a>
                  </th>
                  <th>点击率</th>
                  <th style="text-align: center;">IOS<br/>点击量/曝光/单价</th>
                  <th style="text-align: center;">Android<br/>点击量/曝光/单价</th>
                  <th style="text-align: center;">网页<br/>点击量/曝光/单价</th>
                  <th>总消耗</th>
                  <th>状态</th>
                  <th>备注</th>
                  <th width="140">操作</th>
                </tr>
                {% for index, item in advertiseList %}
                <tr>
                  <td>
                  {% if item['status']!=5 %}
                    <a href="/Advertise/update?id={{item['ad_id']}}">[{{ item['ad_id'] }}]{{ item['ad_name'] }}</a>
                  {% else %}
                    [{{ item['ad_id'] }}]{{ item['ad_name'] }}
                  {% endif %}
                  </td>
                  <td>{{advertiseTarget[item['target']]}}{% if item['target']==2%}{{item['platforms']==4 ? "-PC":"-WAP"}}{%endif%}-{{ advertiseType[item['ad_type']] }}</td>
                  <td>{{ item['total_pv'] }}</td>
                  <td>{{ item['total_click'] }}</td>
                  <td>{{ item['rate'] }}</td>
                  {% if item['cost_type']==1 %}
                    <td>{{ item['ios_cost_clicks']|default(0) }}/{{ item['ios_pv']|default(0) }}/{{ item['ios_price']|default('-') }}</td>
                    <td>{{ item['android_cost_clicks']|default(0) }}/{{ item['android_pv']|default(0) }}/{{ item['android_price']|default('-') }}</td>
                    <td>{{ item['wap_cost_clicks']|default(0) }}/{{ item['wap_pv']|default(0) }}/{{ item['wap_price']|default('-') }}</td>
                  {% else %}
                    <td>{{ item['ios_clicks']|default(0) }}/{{ item['ios_pv']|default(0) }}/{{ item['ios_price']|default('-') }}</td>
                    <td>{{ item['android_clicks']|default(0) }}/{{ item['android_pv']|default(0) }}/{{ item['android_price']|default('-') }}</td>
                    <td>{{ item['wap_clicks']|default(0) }}/{{ item['wap_pv']|default(0) }}/{{ item['wap_price']|default('-') }}</td>
                  {% endif %}
                  <td>{{ item['total_cost']}}/{{adCostType[item['cost_type']]|default('CPC') }}</td>
                  <td>{{ advertisingType[item['status']] }}</td>
                  <td>{%if item['content'] is empty%}<span style="color:#f57c7c">尚未提交广告素材</span>{% elseif item['reason'] is not empty%}{{ item['reason'] }}{% else %}{{adOffLine[item['status']]|default('')}}{%endif%}</td>
                  <td>
                    <a class="btn btn-xs btn-warning text-fill ADdetail" url="/Advertise/view?ad_id={{item['ad_id']}}">详情</a>
                    {% if AGENT_OR_SUB !=3 %}
                    {%if (item['status']==4 or item['status']==6 or item['status']==3 or item['status']==7 or item['status']==8)%}
                    <button class="btn btn-default btn-xs status" ad_id="{{item['ad_id']}}" url="/Advertise/status" ctype="{{item['cost_type']}}" value="{% if item['status'] == '6' %}1{% else %}-1{% endif %}">{% if item['status'] == '6' %}开始投放{% else %}暂停投放{% endif %}</button>
                    {% endif %}
                    <a class="btn btn-xs btn-warning text-fill" {% if account['balance']+account['rebate']>0 %} href="/Advertise/update?id={{item['ad_id']}}" {%else%} data-target="#modal-BNotice" data-toggle="modal"  href="javascript:void(0)"{% endif %}>修改</a>
                    <div class="btn-group nav navbar-nav navbar-right" style="float:none!important">
                        <button type="button" class="btn btn-xs btn-default text-fill">更多操作</button>
                        <button type="button" class="btn btn-xs btn-default text-fill dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                          <span class="caret"></span>
                          <span class="sr-only">Toggle Dropdown</span>
                        </button>
                        <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel" style="top:-{{item['status']!=5?656:538}}%">
                            {% if item['status']!=5%}
                            <li><a {% if account['balance']+account['rebate']>0 %} href="/Advertise/source?id={{item['ad_id']}}" {%else%} data-target="#modal-BNotice" data-toggle="modal"  href="javascript:void(0)"{% endif %}>素材设置</a></li>
                            {% endif %}
                            <li><a {% if account['balance']+account['rebate']>0 %}data-toggle="tooltip" data-placement="left" title="适用于不同定向不同素材的同一尺寸的投放" href="/Advertise/add?cid={{item['ad_id']}}"{%else%} data-target="#modal-BNotice" data-toggle="modal"  href="javascript:void(0)"{% endif %}>复制基本信息</a></li>
                            <li><a {% if account['balance']+account['rebate']>0 %}class="copyAdInfo" data-toggle="tooltip" data-placement="left" data-target="#modal-copyPage" data-toggle="modal" title="适用于不同定向的同一尺寸的投放" href="javascript:void(0)" url="/Advertise/copy?cid={{item['ad_id']}}"{%else%} data-target="#modal-BNotice" data-toggle="modal"  href="javascript:void(0)"{% endif %}>复制基本信息和素材</a></li>
                            <li><a href="/Advertise/operateloglist?ad_id={{item['ad_id']}}">操作明细</a></li>
                            <li><a href="/Advertise/analysis?id={{item['ad_id']}}">流量分析</a></li>
                        </ul>
                    </div>
                    {% endif %}
                  </td>
                </tr>
                {% endfor %}
              </table>
            </div>
            <!-- /.box-body -->
            <div class="box-footer clearfix">
            {{ paginatorHtml }}
            </div>
          </div>
          <!-- /.box -->
        </div>
      </div>

    </section>
    <!-- /.content -->
  </div>
  <!-- /.content-wrapper -->
  {{ partial('common/copyright') }}
</div>
<!-- ./wrapper -->
<div id="modal-ADdetail" class="modal fade modal-form">
  <div class="modal-dialog">
    <div class="modal-content" style="width:800px">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4 class="modal-title">查看广告详情</h4>
        </div>
        <div class="modal-body">
            <div id="ADdetail"></div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal"> 关闭  </button>
        </div>
    </div>
  </div>
</div>
<div id="modal-BNotice" class="modal fade modal-form">
  <div class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4 class="modal-title">余额不足提示</h4>
        </div>
        <div class="modal-body">
            <div id="ADdetail">您当前账号余额为0，请先进行充值~</div>
        </div>
        <div class="modal-footer">
            <a href="/financetool" class="btn btn-primary btn-info"> 去充值 </a>
            <button type="button" class="btn btn-default pull-right" data-dismiss="modal"> 我再想想  </button>
        </div>
    </div>
  </div>
</div>
<div id="modal-copyPage" class="modal fade modal-form">
  <div class="modal-dialog">
    <div class="modal-content" style="width:800px">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4 class="modal-title">复制广告基本信息和素材</h4>
        </div>
        <div class="modal-body">
            <div class="unsuccess">您将复制并创建新的广告投放，基本信息和素材如下，投放日期和用户分组需要另行设置，确定创建吗？</div>
            <div id="ADCopyInfo">
            
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal"> 关闭  </button>
            <button type="submit" class="btn btn-primary btn-info pull-right unsuccess">确认创建</button>
        </div>
    </div>
  </div>
</div>
{{ partial('common/footer') }}
<script src="/plugins/my97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/plugins/cityselect/jquery.cityselect.js"></script>
<script>
$(document).ready(function(){
  $(".download").click(function(){
    var form = $("#query_form");
    form.attr("action","/Advertise/download");
    form.submit();
    form.attr("action","");
  });
  $(".ADdetail").click(function(){
     var url = $(this).attr('url')
     $.getJSON(url,function(data){
        if(data.code=='200'){
            $('#ADdetail').html(data.result);
        }else{
            $('#ADdetail').html(data.msg);
        }
        $('#modal-ADdetail').modal('show');
     });
  });
  $('button.status').click(function () {
    var status = $(this).val();
    var type = $(this).attr('ctype')
    var notice = "";
    if(status == 1){
        notice = "确定要开启投放？";
    }else if(status == -1){
        notice = "确定要暂停投放？";
        if(type=='2'){
            notice = "CPM是预扣费方式，而当前推广还在投放中。确认要暂停投放吗？";
        }
    }else{
        return false;
    }
    ajaxDev($(this).attr('url'), {
        ad_id: $(this).attr('ad_id'),
        status: status
    }, notice);
  });
  $('.sort').click(function(){
     var form = $("#query_form");
     var data = form.serialize();
     var order = $(this).attr('field');
     var desc = $(this).attr('desc');
     data = data + '&order=' + order + '&desc='+( desc ? desc : 0 );
     window.location.href='/Advertise/index?'+data;
  })
    var prov = "{{searchItem['target']|default('')}}" ? "{{searchItem['target']|default('')}}" :$("#targets").find(".prov").val();
    var city = "{{searchItem['ad_type']|default('')}}"? "{{searchItem['ad_type']|default('')}}" :$("#targets").find(".city").val();
    var param = {
        url:{{selectJson}},
        nodata:"none"
    };
    if(prov){
        param.prov = prov;
    }
    if(city){
        param.city = city;
    }
  $("#targets").citySelect(param);

  $('.copyAdInfo').click(function(){
     var url = $(this).attr('url')
     $.getJSON(url,function(data){
        if(data.code=='200'){
            $('#ADCopyInfo').html(data.result);
            $('#modal-copyPage button.btn-primary').attr('url',url);
            $('#modal-copyPage .unsuccess').css({display:"block"});
        }else{
            $('#ADCopyInfo').html(data.msg);
            $('#modal-copyPage .unsuccess').css({display:"none"});
        }
        $('#modal-copyPage').modal('show');
     });
  })
  $('#modal-copyPage button.btn-primary').click(function(){
      var data = $('#adCopy').serialize();
      $.post({
        url: $(this).attr('url'),
        data: data,
        dataType: 'json'
      })
      .done(function (data) {
        if (data.code == 200) {
            window.location.href="/Advertise/update?id="+data.result;
        } else {
          alert(data.msg);
        }
      });
  })
});
</script>
</body>
</html>
