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
        合作联系列表
        <small>合作联系管理</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">合作联系管理</a></li>
        <li class="active">合作联系列表</li>
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
                      <label for="status">状态:</label>
                      <select name="status" class="form-control">
                        <option value="1" {% if q_data['status'] is defined and q_data['status']==1%}selected{% endif %}>已沟通</option>
                        <option value="0" {% if q_data['status'] is defined and q_data['status']==0%}selected{% endif %}>未沟通</option>
                        <option value="-1" {% if q_data['status'] is defined and q_data['status']==-1%}selected{% endif %}>全部</option>
                      </select>
                    </div>
                    <input type="submit" class="btn btn-info" value="查询"/>
                </form>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover">
                <tr>
                  <th>ID</th>
                  <th>姓名</th>
                  <th>联系方式</th>
                  <th>方便洽谈时间</th>
                  <th>合作意向</th>
                  <th>沟通状态</th>
                  <th>添加时间</th>
                  <th>操作</th>
                </tr>
                {% for index, item in List %}
                <tr>
                  <td>{{ item['id'] }}</td>
                  <td>{{ item['username'] }}</td>
                  <td>{{ item['mobile'] }}</td>
                  <td>{{ item['spare_time'] }}</td>
                  <td>{{ item['description'] }}</td>
                  <td>{% if item['status'] == '1' %}<span data-toggle="tooltip" title="{{item['contact_name']}}已于{{date('Y-m-d H:i:s',item['contact_time'])}}进行沟通" class="label label-success">已沟通</span>{% else %}<span class="label label-default">未沟通</span>{% endif %}</td>
                  <td>{{date('Y-m-d H:i:s',item['created'])}}</td>
                  <td>
                    {% if item['status'] == '0' %}<button class="btn btn-warning btn-xs item-status" item_id="{{item['id']}}" url="/manage/corp/updatestatus" value="{% if item['status'] == '0' %}1{% else %}0{% endif %}">已沟通</button>{% endif %}
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
<script type="text/javascript">
$('button.item-status').click(function () {
    ajaxDev($(this).attr('url'), {
        id: $(this).attr('item_id'),
        val: $(this).val()
    }, '');
});
</script>
</body>
</html>
