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
        广告投放详情
        <small>广告投放管理</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">广告投放管理</a></li>
        <li class="active">广告投放详情</li>
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
                      <label>广告主:</label>
                      <input name="uname" type="text" value="{{searchItem['uname']|default('')}}" class="form-control"  placeholder="请输入用户名">
                    </div>
                    <div class="form-group">
                      <label>投放状态:</label>
                      <select name="status" class="form-control">
                        {% for key,item in advertisingType%}
                          <option value="{{key}}" {%if key==searchItem['status'] or (searchItem['status']=='' and key==4)%}selected{%endif%}>{{item}}</option>
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
                        {% for key,item in CostType%}
                          <option value="{{key}}" {%if key==searchItem['cost_type'] %}selected{%endif%}>{{item}}</option>
                        {% endfor %}
                      </select>
                    </div>
                    <div class="form-group">
                      <label>开始时间:</label>
                      <input name="begin_time" type="date" value="{{searchItem['begin_time']|default('')}}" onClick="WdatePicker()" class="form-control Wdate" placeholder="">
                    </div>
                    <div class="form-group">
                      <label>结束时间:</label>
                      <input name="end_time" type="date" value="{{searchItem['end_time']|default('')}}" onClick="WdatePicker()" class="form-control Wdate" placeholder="">
                    </div>
                    <div style="padding:5px 20px;float:right">
                        <input type="submit" class="btn btn-info" value="查询"/>
                        <a href="javascript:void(0);" class="btn btn-info download">下载</a>
                    </div>
                </form>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover">
                <tr>
                  <th>[ID]广告名称</th>
                  <th>广告主</th>
                  <th>点位类型</th>
                  <th width="80" >
                    <span class="sort" field='pv' desc="{% if order and order[0]=='pv' and order[1]%}0{%else%}1{%endif%}">总曝光<a class="fa fa-sort {% if order and order[0]=='pv'%}fa-sort-{{order[1]?'desc':'asc'}}{%endif%}"></a></span>
                    /<br/><span class="sort" field='click' desc="{% if order and order[0]=='click' and order[1]%}0{%else%}1{%endif%}">总点击<a class="fa fa-sort {% if order and order[0]=='click'%}fa-sort-{{order[1]?'desc':'asc'}}{%endif%}"></a></span>
                  </th>
                  <th>点击率</th>
                  <th style="text-align: center;">IOS<br/>点击量/曝光/单价</th>
                  <th style="text-align: center;">Android<br/>点击量/曝光/单价</th>
                  <th style="text-align: center;">网页<br/>点击量/曝光/单价</th>
                  <th>收益/计费方式</th>
                  <th>状态</th>
                  <th width="160">操作</th>
                </tr>
                {% for index, item in advertiseList %}
                <tr>
                  <td>[{{ item['ad_id'] }}]{{ item['ad_name'] }}</td>
                  <td>{{ item['username'] }}</td>
                  <td>{{advertiseTarget[item['target']]}}{% if item['target']==2%}{{item['platforms']==4 ? "-PC":"-WAP"}}{%endif%}-{{ advertiseType[item['ad_type']] }}</td>
                  <td>{{ item['total_pv'] }}/{{ item['total_click'] }}</td>
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
                  <td title="{{ item['day_cost_limit']|default('--') }}">{{ item['total_cost'] }}/{{CostType[item['cost_type']]}}</td>
                  <td>{{ advertisingType[item['status']] }}</td>
                  <td>
                    <button class="btn btn-xs btn-default ADdetail" url="/manage/Advertis/view?ad_id={{ item['ad_id'] }}">详情</button>
                    {% if item['cost_type']==1%}
                        <a href="/manage/Advertis/clickdetail?ad_id={{ item['ad_id'] }}" class="btn btn-xs btn-default" download>点击明细 <i class="fa fa-download"></i></a>
                    {% elseif item['cost_type']==2 %}
                        <a href="/manage/Advertis/pvdetail?ad_id={{ item['ad_id'] }}" class="btn btn-xs btn-default" download>浏览量明细 <i class="fa fa-download"></i></a>
                    {% endif %}
                    <a href="/manage/Advertis/operateloglist?ad_id={{item['ad_id']}}" class="btn btn-xs btn-default">操作明细</a>
                {#    <button class="btn btn-xs btn-default viewPos" url="/manage/Advertis/getadposhistory?ad_id={{ item['ad_id'] }}">历史点位<i class="fa fa-search"></i></button>
                    {% if item['status']==4 %}
                        <button class="btn btn-xs btn-default viewPos" url="/manage/Advertis/getadpos?ad_id={{ item['ad_id'] }}">查看点位</button>
                    {%endif%} #}
                    <button class="btn btn-xs btn-default posPreview" url="/manage/Advertis/posview?pf={{ item['platforms'] }}&adt={{item['ad_type']}}&adz={{item['source']['dsp_size']|default('')}}">空闲点位预览</button>
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
<div id="modal-viewPos" class="modal fade modal-form">
  <div class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4 class="modal-title">查看广告占用点位</h4>
        </div>
        <div class="modal-body">
            <div id="noticePos">该广告正在上传广告系统...</div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal"> 关闭  </button>
        </div>
    </div>
  </div>
</div>
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
<!-- ./wrapper -->
{{ partial('common/footer') }}
<script src="/plugins/my97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/plugins/cityselect/jquery.cityselect.js"></script>
<script>
$(document).ready(function(){
  $(".download").click(function(){
    var form = $("#query_form");
    form.attr("action","/manage/Advertis/download");
    form.submit();
    form.attr("action","");
  });
    
  $(".viewPos").click(function(){
     var url = $(this).attr('url')
     $.getJSON(url,function(data){
        if(data.code=='200'){
            $('#noticePos').html(data.result);
        }else{
            $('#noticePos').html(data.msg);
        }
        $('#modal-viewPos').modal('show');
     });
  })
  $(".ADdetail").click(function(){
     var url = $(this).attr('url')
     $.getJSON(url,function(data){
        if(data.code=='200'){
            $('#ADdetail').html(data.result);
        }else{
            $('#ADdetail').html(data.msg);
        }
        $('#modal-ADdetail .modal-title').html('查看广告详情');
        $('#modal-ADdetail').modal('show');
     });
  })
  $('.sort').click(function(){
    var form = $("#query_form");
    var data = form.serialize();
    var order = $(this).attr('field');
    var desc = $(this).attr('desc');
    data = data + '&order=' + order + '&desc='+( desc ? desc : 0 );
    window.location.href='/manage/Advertis/adindex?'+data;
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
  $(".posPreview").click(function(){
     var url = $(this).attr('url')
     $.getJSON(url,function(data){
        if(data.code=='200'){
            var str = '<table class="table"><tr><th>点位ID</th><th>站点名</th><th>一级模块名称</th><th>二级模块名称</th><th>点位名</th></tr>';
            for( var i in data.result ){
                str += '<tr><td>'+data.result[i].pos_id+'</td><td>'+data.result[i].site_name+'</td><td>'+data.result[i].p_section_name+
                '</td><td>'+data.result[i].section_name+'</td><td>'+data.result[i].name+'</td></tr>'
            }
            str += '</table>';
            $('#ADdetail').html(str);
        }else{
            $('#ADdetail').html(data.msg);
        }
        $('#modal-ADdetail .modal-title').html('空闲点位预览');
        $('#modal-ADdetail').modal('show');
     });
  })
});
</script>
</body>
</html>
