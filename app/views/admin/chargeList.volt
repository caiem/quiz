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
        充值历史
        <small>资金账户管理</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="/manage/Advertis/index">资金账户管理</a></li>
        <li class="active">充值历史</li>
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
                  <th>ID</th>
                  <th>账号名称</th>
                  <th>充值金额</th> 
                  <th>赠送金额</th>
            {#      <th>充值前余额</th>#}
                  <th>充值后余额</th>
                  <th>充值流水账号</th>
                  <th>充值人</th>
                  <th>充值时间</th>
                  <th>支付方式</th>
                  <th>开具发票</th>
                  <th>合同编号</th>
                </tr>
                {% for index, item in chargeList %}
                <tr>
                  <td>{{ item['recharge_id'] }}</td>
                  <td>{{ advertisorname }}</td>
                  <td>{{ item['amount'] }}</td>
                  <td>{{ item['rebate'] }}</td>
            {#      <td>{{ item['pre_balance'] }}</td>#}
                  <td>{{ item['balance'] }}</td> 
                  <td>{{ item['serial_no'] }}</td>
                  <td>{{ item['handler'] }}</td>
                  <td>{% if item['recharge_time'] is not empty %}{{ date('Y-m-d H:i:s',item['recharge_time']) }}{% endif %}</td>
                  <td>{% if item['serial_no'] is not empty %}{{ pay_type_list[item['pay_type']] }}{% else %}后台充值{% endif %}</td><!--暂时只有支付宝-->
                  <td>{% if item['is_invoiced'] is not empty %}
                    <span class="label label-success">是</span>
                    {% else %}
                    <span class="label label-default">否</span>
                    {% endif %}</td>
                  <td>{{ item['contract_no'] }}</td>
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
</body>
</html>