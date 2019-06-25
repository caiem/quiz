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
        投放日报表
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li class="active">投放日报表</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">

      <div class="row">
        <div class="col-xs-12">
          <div class="box">
            <div class="box-header">
                <form class="form-inline" role="form" method="post">
                    <div class="form-group">
                      <label>开始时间:</label>
                      <input name="btime" type="date" onClick="WdatePicker()" class="form-control Wdate" placeholder="">
                    </div>
                    <div class="form-group">
                      <label>结束时间:</label>
                      <input name="etime" type="date" onClick="WdatePicker()" class="form-control Wdate" placeholder="">
                    </div>
                    <div class="form-group">
                      <label>广告ID/名称:</label>
                      <input name="adname" type="text" class="form-control" placeholder="请输入广告ID或名称">
                    </div>
                    <input type="submit" class="btn btn-info" value="查询"/>
                </form>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover">
                <tr>
                  <th>推广ID</th>
                  <th>广告名称</th>
                  <th>IDFA数量</th>
                  <th>操作</th>
                </tr>
                {% for index, item in userList %}
                <tr>
                  <td>{{ item['status'] }}</td>
                  <td>{{ item['status'] }}</td>
                  <td>{{ item['status'] }}</td>
                  <td>
                    <button class="editUser btn btn-xs btn-warning text-fill" url="" user_id="{{item['status']}}">查看明细</button>
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
{{ partial('common/footer') }}
<script src="/plugins/my97DatePicker/WdatePicker.js"></script>
</body>
</html>