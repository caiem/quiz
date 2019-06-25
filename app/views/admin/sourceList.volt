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
        投放素材审核
        <small>广告投放管理</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">广告投放管理</a></li>
        <li class="active">投放素材审核</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">

      <div class="row">
        <div class="col-xs-12">
          <div class="box">
            <div class="box-header">
                <form class="form-inline" role="form">
                    <div class="form-group">
                      <label>广告ID:</label>
                      <input name="ad_id" type="text" value="{{searchItem['ad_id']|default('')}}" class="form-control"  placeholder="请输入广告ID">
                    </div>
                    <div class="form-group">
                      <label>广告投放商:</label>
                      <input name="uname" type="text" value="{{searchItem['uname']|default('')}}" class="form-control"  placeholder="请输入广告商用户名">
                    </div>
                    <div class="form-group">
                      <label>广告类型:</label>
                      <select name="ad_type" class="form-control">
                        <option value="">全部</option>
                        {% for key,item in advertiseType%}
                          <option value="{{key}}" {% if key==searchItem['ad_type']%}selected{% endif %}>{{item}}</option>
                        {% endfor %}
                      </select>
                    </div>
                    <div class="form-group">
                      <label>审核状态:</label>
                      <select name="status" class="form-control">
                        <option value="-1" {% if -1==audit_status %}selected{%endif%}>全部</option>
                        {% for key,item in auditStatus%}
                          <option value="{{key}}" {% if key==audit_status %}selected{%endif%}>{{item}}</option>
                        {% endfor %}
                      </select>
                    </div>
                    <input type="submit" class="btn btn-info" value="查询"/>
                </form>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <form class="form-inline" onsubmit="return checkform();" role="form" method="post">
              <div style="width:96%;margin:0 auto;">
                {% for index, item in advertiseList %}
                <div style="border-radius:0" class="box box-{% if item['status']==2%}warning{%elseif item['status']==1%}success{%else%}primary{%endif%} box-solid">
                    <div class="box-header with-border">
                      <div class="box-title span-padde">
                        <small>
                           <span>ADID:<label>{{item['ad_id']}}</label></span>
                            <span>AD名称:<label>{{item['ad_name']}}</label></span>
                            <span>广告主:<label>{{item['username']}}</label></span>
                            <span>AD类型:<label>{{advertiseType[item['ad_type']]}}</label></span>
                            <span>投放时间:<label>{{date('Y-m-d H:i',item['begin_time'])}} ~ {{item['end_time'] is empty ?'':date('Y-m-d H:i',item['end_time'])}}</label></span>
                            <span>时间点:<label>{{item['begin_hour']}} ~ {{item['end_hour']}}</label></span>
                        </small>
                      </div>
                      <div class="box-tools pull-right">
                        <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i>
                        </button>
                      </div>
                    </div>
                    <div class="box-body">
                      {% if item['ad_type'] =="banner"%}
                          <label>广告链接：</label><a target="_blank" href="{{item['source']['link']}}">{{item['source']['link']}}</a><br/>
                          {% if item['source']['pic'] is not empty %}
                          <img width="600" height="100" src="{{item['source']['pic']}}">
                          {% endif %}
                      {%elseif item['ad_type'] =="inforflow"%}
                          <div class="span-padde"><span><label>标题：</label>{{item['source']['title']|default('')}}</span><span><label>副标题：</label>{{item['source']['subtitle']|default('')}}</span>
                          <span><label>品牌名称：</label>{{item['source']['brand_name']|default('')}}</span><label>广告链接：</label><a target="{{item['source']['link']}}" href="{{item['source']['link']}}">{{item['source']['link']}}</a></div>
                          {% if item['source']['img'] is not empty %}
                          <img data-toggle="tooltip" title="品牌头像" width="150" height="150" src="{{item['source']['img']}}">
                          {% endif %}
                          {% if item['source']['pic1'] is not empty %}
                          <img data-toggle="tooltip" title="图片一" width="150" height="150" src="{{item['source']['pic1']}}">
                          {% endif %}
                          {% if item['source']['pic2'] is not empty %}
                          <img data-toggle="tooltip" title="图片二" width="150" height="150" src="{{item['source']['pic2']}}">
                          {% endif %}
                          {% if item['source']['pic3'] is not empty %}
                          <img data-toggle="tooltip" title="图片三" width="150" height="150" src="{{item['source']['pic3']}}">
                          {% endif %}
                      {%endif%}
                    </div>
                    <input name="ids[]" type="hidden" value="{{item['audit_id']}}">
                    {% if item['status']==0 and audit_status==0%}
                    <div class="box-footer span-padde">
                        <span><input class="pass_radio" name="pass_{{item['audit_id']}}" type="radio" value="1" {% if item['status']==1%}checked{%endif%}>通过  
                        <input  class="unpass_radio" name="pass_{{item['audit_id']}}" type="radio" value="2" {% if item['status']==2%}checked{%endif%}>不通过</span>  
                        不通过理由：
                        <select name="reason_{{item['audit_id']}}" class="form-control reason_select">
                            {% for key,val in auditReason%}
                              <option value="{{val}}">{{val}}</option>
                            {% endfor %}
                        </select>
                        <input name="reason_other_{{item['audit_id']}}" class="form-control reason_input">
                    </div>
                    {% elseif item['status']==1 and audit_status==1%}
                    <div class="box-footer">
                        不通过理由：<select name="reason" class="form-control reason_select">
                            {% for key,val in auditReason%}
                              <option value="{{val}}">{{val}}</option>
                            {% endfor %}
                        </select>
                        <input name="other" class="form-control reason_input">
                        <a class="btn btn-info reaudit" aid="{{item['audit_id']}}" value="2">重新审核</a>
                    </div>
                    {% elseif item['status']==2%}
                    <div class="box-footer">
                        不通过理由：{{item['reason']}} {% if audit_status==2 %}<a class="btn btn-info btn-xs reaudit" aid="{{item['audit_id']}}" value="1">重新审核</a>{%endif%}
                    </div>
                    {% endif%}
                </div>
                {% endfor %}
                {% if audit_status==0 and advertiseList %}
                <a class="btn btn-primary selectAll">全选</a><input type="submit" class="btn btn-primary" value="批量审核"/>
                {%endif%}
                {%%}
                </div>
              </form>
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
{{ partial('common/footer') }}
<script>
    function checkform(){
        var submit = true;
        $('input[type=radio]:checked').each(function(){
            if( $(this).val() ==2 ){
                var target = $(this).closest('.box-footer');
                var reason_select = target.children('.reason_select').val();
                if( reason_select=='自定义'){
                    var reason_input = target.children('.reason_input').val();
                    if(!reason_input){
                        alert("请输入自定义审核不通过原因");
                        submit = false;
                    }
                }
            }
        });
        return submit;
    }
    $(function(){
        $('form').on('click','.reaudit',function(){
            if(confirm('确定要重新审核？')){
                var aid = $(this).attr('aid');
                var value = $(this).attr('value');
                var data = {id:aid,status:value};
                if( value=="2" ){
                    var reason = $(this).parent().find('.reason_select').val();
                    if( reason=='自定义'){
                        var reason = $(this).parent().find('.reason_input').val();
                        if( !reason ){
                            alert("请输入自定义审核不通过原因");
                            return;
                        }
                    }
                    data.reason = reason;
                }
                ajaxDev('/manage/Advertis/reaudit',data, '');
            }
        })
        var status = 1;
        $('a.selectAll').click(function(){
            $('.pass_radio').each(function(){
                if(status){
                    $(this).prop('checked',true);
                }else{
                    $(this).prop('checked',false);
                }
            });
            status = status ? 0 : 1;
        });
    })
</script>
</body>
</html>