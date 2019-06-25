{{ partial('common/header') }}
<style>
.show_more{
    display:none;
    color:#333;
}
.desc{
    word-break: break-all;
    word-wrap:break-word;
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
        广告操作明细
        <small>自助投放管理</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">自助投放管理</a></li>
        <li class="active">操作明细</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">

      <div class="row">
        <div class="col-xs-12">
          <div class="box">
            <div class="box-header">
                
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover">
                <tr>
                  <th>广告ID</th>
                  <th>广告名称</th>
                  <th>操作类型</th>
                  <th width="450">操作说明</th>
                  <th>操作时间</th>
                </tr>
                {% for index, item in logList %}
                <tr>
                  <td>{{ item['ad_id'] }}</td>
                  <td>{{ item['ad_name'] }}</td>
                  <td>{{ item['opt_name'] }}</td>
                  <td class="desc">{{ item['message'] }}</td>
                  <td>{% if item['add_time'] is not empty %}{{ date('Y-m-d H:i:s',item['add_time']) }}{% endif %}</td>
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
    <script>
    $(function(){
        $('.more').click(function(){
            $(this).children('.show_more').toggle();
        });
    })
    </script>
</body>
</html>