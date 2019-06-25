{{ partial('common/header') }}
<link rel="stylesheet" href="/plugins/fancybox/jquery.fancybox.min.css" type="text/css" media="screen" />
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
        点位管理
        <small>应用点位管理</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">应用点位管理</a></li>
        <li class="active">点位管理</li>
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
                      <label>开发者:</label>
                      <input name="uname" type="text" value="{{q_data['uname']|default('')}}" class="form-control"  placeholder="请输入广告商用户名">
                    </div>
                    <div class="form-group">
                      <label>审核状态:</label>
                      <select name="status" class="form-control">
                        <option value="-1" {% if -1==q_data['status'] %}selected{%endif%}>全部</option>
                        {% for key,item in auditStatus%}
                          <option value="{{key}}" {% if key==q_data['status'] %}selected{%endif%}>{{item}}</option>
                        {% endfor %}
                      </select>
                    </div>
                    <input type="submit" class="btn btn-info" value="查询"/>
                </form>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
                <table class="table table-hover">
                <tr>
                  <th><input class="select_all" type="checkbox"></th>
                  <th>开发者</th>
                  <th>应用</th>
                  <th>点位名称</th>
                  <th>广告类型</th>
                  <th>广告尺寸</th>
                  <th>素材要求</th>
                  <th>广告效果图</th>
                  <th>审核状态</th>
                  <th>时间</th>
                  <th>备注</th>
                  <th width="120">操作</th>
                </tr>
                {% for index, item in List %}
                <tr>
                    <td><input class="select_one" type="checkbox" value="{{item['pos_id']}}"></td>
                    <td>{{item['username']}}</td>
                    <td>{{item['app_name']}}</td>
                    <td>{{item['pos_name']}}</td>
                    <td>{{item['type']}}</td>
                    <td>{{item['size']}}</td>
                    <td>{{item['format']}}</td>
                    <td>
                        {% for file in item['files'] %}
                            <a class="viewImg" data-fancybox="group" href="/upload/{{ file }}"><img src="/upload/{{ file }}" style="width:80px;height:80px"/></a>
                        {% endfor %}
                    </td>
                    <td><span class="label {{item['status']==1?'label-success':(item['status']==2?'label-warning':'label-default')}}">{{auditStatus[item['status']]}}</span></td>
                    <td>{{date('Y-m-d H:i:s',item['created'])}}</td>
                    <td uname="{{item['auditor']}}"><span data-toggle="tooltip" title="{{item['mark']}}">{{item['smark']}}</span></td>
                    <td>
                        {% if item['status']!=1 %}
                        <button class="btn btn-xs btn-success text-fill Audit" posname="{{item['pos_name']}}" posid="{{item['pos_id']}}" value="1">审核通过</button>
                        {% endif %}
                        {% if item['status']!=2 %}
                        <button class="btn btn-xs btn-warning text-fill Audit" posname="{{item['pos_name']}}" posid="{{item['pos_id']}}" value="2">审核不通过</button>
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
            {% if 1 !=q_data['status'] and List %}
            <button style="margin-top: -64px;margin-left: 20px;position: absolute;" class="btn btn-primary auditAll">批量审核通过</button>
            {% endif %}
          <!-- /.box -->
        </div>
      </div>

    </section>
    <!-- /.content -->
  </div>
  <!-- /.content-wrapper -->
  {{ partial('common/copyright') }}
</div>
<div id="modal-Audit" class="modal fade modal-form">
  <div class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4 class="modal-title">不通过<span id="audit_posname" style="color:red"></span>的开户申请</h4>
        </div>
        <div class="modal-body">
            <form action="/manage/Apppos/posaudit" role="form" method="POST">
                <input id="audit_posid" name="posid" type="hidden" class="form-control"/>
                <input id="audit_val" name="val" type="hidden" class="form-control"/>
                <label>请填写不通过理由（50字以内）</label>
                <div>
                    <textarea name="reason" rows="5" cols="80" class="form-control"></textarea>
                </div>
            </form>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal"> 关闭  </button>
            <button type="button" class="btn btn-primary submitForm">确认提交</>
        </div>
        
    </div>
  </div>
</div>
<!-- ./wrapper -->
{{ partial('common/footer') }}
<script type="text/javascript" src="/plugins/fancybox/jquery.fancybox.min.js"></script>
<script>
    $(function(){
        $('.viewImg').fancybox();
        $('.Audit').click(function(){
            var posname = $(this).attr('posname');
            var posid = $(this).attr('posid');
            var val = $(this).attr('value');
            if( val==1 ){
                ajaxDev('/manage/Apppos/posaudit',{posid:posid,val:val}, '');
            }else{
                $('#audit_posname').html(posname);
                $('#audit_posid').val(posid);
                $('#audit_val').val(val);
                $('#modal-Audit').modal('show');
            }
        });
        $("#modal-Audit .btn-primary").click(function(){
            var query = $("#modal-Audit form").serialize();
            var url = $("#modal-Audit form").attr("action");
            ajaxDev(url,query,'');
        });
        $('.select_all').change(function(){
            if( $(this).prop("checked")==false ){
                $('.select_one').prop("checked",false);
            }else{
                $('.select_one').prop("checked",true);
            }
        });
        $('.select_one').change(function(){
            if( $(this).prop("checked")==false ){
                $('.select_all').prop("checked",false);
            }
        });
        $('.auditAll').click(function(){
            var poslist = '';
            $('.select_one:checked').each(function(){
                poslist += ',' + $(this).val();
            });
            if( poslist == '' ){
                alert('请先选择数据');
                return;
            }
            ajaxDev('/manage/Apppos/posaudit',{posid:poslist.substr(1),val:1}, '');
        })
    })
</script>
</body>
</html>