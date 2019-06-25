{{ partial('common/header') }}
<link rel="stylesheet" href="/plugins/daterangepicker/daterangepicker.css">
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
        财务记录
        <small>广告投放管理</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="/manage/Advertis">广告投放管理</a></li>
        <li class="active">财务记录</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">

      <div class="row">
        <div class="col-xs-12">
          <div class="box">
            <div class="box-header">
                <form id="query_form" class="form-inline" role="form">
                    <div class="form-group" style="float:right;margin-right:80px">
                        <div class="input-group">
                            <div class="input-group-addon">
                              <i class="fa fa-calendar"></i>
                            </div>
                            <input name="date" size="50" value="{{q_data['date']}}" type="text" class="form-control pull-right" id="date_ranges">
                        </div>
                        <input name="uid" value="{{q_data['uid']}}" type="hidden">
                    </div>
                </form>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover">
                <tr>
                  <th>日期</th>
                  <th>存入(元)</th>
                  <th>支出(元)</th>
                {#  <th>操作</th> #}
                </tr>
                {% for index, item in List %}
                <tr>
                  <td>{{ item['date'] }}</td>
                  <td>{{ item['income'] }}</td>
                  <td>{{ item['cost'] }}</td>
                {#  <td></td> #}
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
<script src="/plugins/daterangepicker/moment.min.js"></script>
<script src="/plugins/daterangepicker/daterangepicker.js"></script>
    <script>
    $(function(){
        $('#date_ranges').daterangepicker({
            "startDate": "{{q_data['btime']}}",
            "endDate": "{{q_data['etime']}}"
        }, function(start, end, label) {
          //console.log("New date range selected: " + start.format('YYYY-MM-DD') + " to " + end.format('YYYY-MM-DD') + " (predefined range: " + label + ")");
            $('#query_form input[name=date]').val(start.format('MM/DD/YYYY')+" - "+end.format('MM/DD/YYYY'))
            $('#query_form').submit();
        });
    });
    </script>
</body>
</html>