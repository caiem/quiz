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
        资金账户管理
        <small>广告投放管理</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">广告投放管理</a></li>
        <li class="active">资金账户管理</li>
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
                      <label for="uname">账户名称:</label>
                      <input name="uname" size="45" type="text" class="form-control" id="uname" placeholder="请输入用户名">
                    </div>
                    <input type="submit" class="btn btn-info" value="查询"/>
                </form>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover">
                <tr>
                  <th>ID</th>
                  <th>账号名称</th>
                  <th>总赠送余额</th>
                  <th>总充值余额</th>
                  <th>总账户余额</th>
                  <th>上一次充值时间</th>
                  <th>操作</th>
                </tr>
                {% for index, user in userList %}
                <tr>
                  <td>{{ user['user_id'] }}</td>
                  <td>{{ user['username'] }}</td>
                  <td>{{ user['rebate'] }}</td>
                  <td>{{ user['balance'] }}</td>
                  <td>{{ user['balance'] + user['rebate'] }}</td>
                  <td>{% if user['last_charge_time'] is not empty %}{{ date('Y-m-d H:i:s',user['last_charge_time']) }}{% endif %}</td>
                  <td>
                    <button class="btn btn-default btn-xs user-charge" uname="{{user['username']}}" uid="{{user['user_id']}}">充值</button>
                    <a class="btn btn-xs btn-warning text-fill" href="/manage/Advertis/chargeHistory?uid={{user['user_id']}}">充值历史</a>
                    <a class="btn btn-xs btn-primary text-fill" href="/manage/Advertis/finance?uid={{user['user_id']}}">财务记录</a>
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
<div id="modal-charge" class="modal fade modal-form">
  <div class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4 class="modal-title">将为<span style="color:red" id="charge_name">XXXX</span>充值</h4>
        </div>
        <div class="modal-body">
            <form id="form_charge" action="/manage/Advertis/charge" role="form" method="POST">
                <table class="table table-bordered">
                    <tbody>
                        <input id="charge_uid" name="user_id" type="hidden" class="form-control"/>
                        <tr>
                            <td>充值金额</td>
                            <td><input name="charge" id="charge" type="number" class="form-control" /></td>
                        </tr>
                        <tr>
                            <td>是否返点</td>
                            <td>
                                <label class="radio-inline">
                                    <input type="radio" name="is_rebate" value="0" checked> 否
                                </label>
                                <label class="radio-inline">
                                    <input type="radio" name="is_rebate" value="1"> 是
                                </label>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal"> 关闭  </button>
            <button type="button" class="btn btn-primary" id="btn-charge">确认充值</button>
        </div>
    </div>
  </div>
</div>
{{ partial('common/footer') }}
<script>
$(function(){
    $('button.user-charge').click(function () {
        $("#charge_uid").val($(this).attr('uid'));
        $("#charge_name").html(' '+$(this).attr('uname')+' ')
        $('#modal-charge').modal('show');
    });
    $("#btn-charge").click(function () {
        var query = $("#form_charge").serialize();
        var url = $("#form_charge").attr("action");
        ajaxDev(url, query, '');
    });
});
</script>
</body>
</html>