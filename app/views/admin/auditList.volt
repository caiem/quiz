{{ partial('common/header') }}
<link rel="stylesheet" href="/plugins/select2/select2.min.css">
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
        开户审核
        <small>用户管理</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">用户管理</a></li>
        <li class="active">开户审核</li>
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
                      <label>广告投放商:</label>
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
                  <th>广告投放商</th>
                  <th>主体类型</th>
                  <th>名称</th>
                  <th>联系手机</th>
                  <th>审核状态</th>
                  <th>时间</th>
                  <th>备注</th>
                  <th width="120">操作</th>
                </tr>
                {% for index, item in List %}
                <tr>
                    <td>{{item['username']}}</td>
                    <td>{{item['type']}}</td>
                    <td>{{item['name']}}</td>
                    <td>{{item['phone']}}</td>
                    <td><span class="label {{item['status']==1?'label-success':(item['status']==2?'label-warning':'label-default')}}">{{auditStatus[item['status']]}}</span></td>
                    <td title="{{date('Y-m-d H:i:s',item['created'])}}">{{date('Y-m-d H:i:s',item['updated'])}}</td>
                    <td uname="{{item['auditor']}}"><span data-toggle="tooltip" title="{{item['mark']}}">{{item['smark']}}</span></td>
                    <td>
                        <a href="/manage/User/viewaccount?uid={{item['user_id']}}" class="btn btn-xs btn-default text-fill" target="_blank">详情</a>
                        {% if item['status']!=1 %}
                        <button class="btn btn-xs btn-success text-fill Audit" uname="{{item['username']}}" uid="{{item['user_id']}}" value="1">审核通过</button>
                        {% endif %}
                        {% if item['status']!=2 %}
                        <button class="btn btn-xs btn-warning text-fill Audit" uname="{{item['username']}}" uid="{{item['user_id']}}" value="2">审核不通过</button>
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
<div id="modal-Audit" class="modal fade modal-form">
  <div class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4 class="modal-title"><span class="no_pass">不</span>通过<span id="audit_uname" style="color:red"></span>的开户申请</h4>
        </div>
        <div class="modal-body">
            <form action="/manage/User/audit" role="form" method="POST">
                <input id="audit_uid" name="uid" type="hidden" class="form-control"/>
                <input id="audit_val" name="val" type="hidden" class="form-control"/>
                <div class="form-group pass">
                    <label>销售人员</label>
                    <select data-toggle="tooltip" title="选择销售人员" name="saler" class="form-control select2">
                        <option value="">选择销售人员</option>
                        {% for index,saler in Salers %}
                            <option value="{{index}}">{{saler}}</option>
                        {% endfor %}
                    </select>
                </div>
                <div class="form-group no_pass">
                    <label>请填写不通过理由（50字以内）</label>
                    <div>
                        <textarea name="reason" rows="5" cols="80" class="form-control"></textarea>
                    </div>
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
<script src="/plugins/select2/select2.full.min.js"></script>
<script>
    $(function(){
        $(".select2").select2();
        $('.Audit').click(function(){
            var uname = $(this).attr('uname');
            var uid = $(this).attr('uid');
            var val = $(this).attr('value');
            if( val==1 ){
               $('.pass').removeClass('hidden');
               $('.no_pass').addClass('hidden');
            }else{
               $('.no_pass').removeClass('hidden');
               $('.pass').addClass('hidden');
            }
            $('#audit_uname').html(uname);
            $('#audit_uid').val(uid);
            $('#audit_val').val(val);
            $('#modal-Audit').modal('show');
        });
        $("#modal-Audit .btn-primary").click(function(){
            var query = $("#modal-Audit form").serialize();
            var url = $("#modal-Audit form").attr("action");
            ajaxDev(url,query,'');
        });
    })
</script>
</body>
</html>