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
        开票申请
        <small>用户管理</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="/manage/User/advertiser">用户管理</a></li>
        <li class="active">开票申请</li>
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
                    <input type="submit" class="btn btn-info" value="查询"/>
                </form>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover">
                <tr>
                  <th>广告投放商</th>
                  <th>发票项目</th>
                  <th>申请金额</th>
                  <th>申请时间</th>
                  <th>对应合同编号</th>
                  <th>状态</th>
                  <th>备注</th>
                </tr>
                {% for index, item in List %}
                <tr>
                  <td>{{ item['username'] }}</td>
                  <td>{{ itemMap[item['item']] }}</td>
                  <td>{{ item['amount'] }}</td>
                  <td>{% if item['created'] is not empty %}{{ date('Y-m-d H:i:s',item['created']) }}{% endif %}</td>
                  <td>{{ item['contract_no'] }}</td>
                  <td>{{ statusMap[item['status']] }}</td>
                  <td>{%if item['mark'] is not empty%}{{item['status']==2?'发票凭证：':(item['status']==-1?'不通过理由：':'')}}{{ item['mark'] }}{%endif%}</td>
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