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
        模块列表
        <small>模块管理</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">模块管理</a></li>
        <li class="active">模块列表</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">

      <div class="row">
        <div class="col-xs-12">
          <div class="box">
            <div class="box-header">
              <div class="user-add text-right">
              <a class="btn btn-info addedit">新增模块<i class="fa fa-plus"></i></a>
              </div>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover">
                <tr>
                  <th>标题</th>
                  <th>模块名称</th>
                  <th>方法名称</th>
                  <th>类型</th>
                  <th>显示</th>
                  <th>状 态</th>
                  <th>操作</th>
                </tr>
                {% for index, module in module_data %}
                <tr class="text-yellow">
                  <td>{{ module['title'] }}</td>
                  <td>{{ module['module_name'] }}</td>
                  <td>{{ module['method_name'] }}</td>
                  <td>{% if module['type'] == '1' %}<a class="label label-success">模块</a>{% elseif  module['type'] == '2' %}<a class="label label-success">方法</a>{% endif %}</td>
                  <td>{% if module['show'] == '1' %}<a class="label label-success">显示</a>{% else %}<a class="label label-default">隐藏</a>{% endif %}</td>
                  <td>{% if module['status'] == '1' %}<a class="label label-success">正常</a>{% else %}<a class="label label-default">不可用</a>{% endif %}</td>
                  <td><a class="btn btn-xs btn-warning addedit" rel="{{module['module_id']}}">修改</a></td>
                </tr>
                {% for t, children in module['children'] %}
                <tr>
                  <td>{{ children['title'] }}</td>
                  <td>{{ children['module_name'] }}</td>
                  <td>{{ children['method_name'] }}</td>
                  <td>{% if children['type'] == '1' %}<a class="label label-success">模块</a>{% elseif  children['type'] == '2' %}<a class="label label-success">方法</a>{% endif %}</td>
                  <td>{% if children['show'] == '1' %}<a class="label label-success">显示</a>{% else %}<a class="label label-default">隐藏</a>{% endif %}</td>
                  <td>{% if children['status'] == '1' %}<a class="label label-success">正常</a>{% else %}<a class="label label-default">不可用</a>{% endif %}</td>
                  <td><a class="btn btn-xs btn-warning addedit" rel="{{children['module_id']}}" >修改</a></td>
                </tr>
                {% endfor %}
                {% endfor %}
              </table>
            </div>
            <!-- /.box-body -->
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
<div id="modal-addPage" class="modal fade modal-form">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title">新增/编辑模块</h4>
      </div>
      <div class="modal-body">
        <form class="form-horizontal" id="form_add" action="/manage/Module/add" method="POST">
          <table class="table table-bordered">
            <tbody>
              <tr>
                <td>标题</td>
                <td><input id="title" name="title" type="text" class="form-control" placeholder="Enter title"></td>
              </tr>
              <tr>
                <td>父模块</td>
                <td>
                  <select id="parent_id" name="parent_id" class="form-control">
                    <option value="0">根模块</option>
                    {% for index, module in module_data %}
                        <option value="{{module['module_id']}}">{{module['title']}}</option>
                    {% endfor %}
                  </select>
                </td>
              </tr>
              <tr>
                <td>模块名称</td>
                <td><input id="module_name" name="module_name" type="text" class="form-control" placeholder="Enter module name"></td>
              </tr>
              <tr>
                <td>方法名</td>
                <td><input id="method_name" name="method_name" type="text" class="form-control" placeholder="Enter method_name"></td>
              </tr>
              <tr>
                <td>类型</td>
                <td>
                  <select id="type" name="type" class="form-control">
                    <option value="1">模块</option>
                    <option value="2">方法</option>
                  </select>
                </td>
              </tr>
              <tr>
                <td>显示在菜单栏</td>
                <td>
                    <label class="radio-inline">
                      <input id="show1" name="show" type="radio" value="1"> 是 
                    </label>
                    <label class="radio-inline">
                      <input id="show0" name="show" type="radio" value="0"> 否 
                    </label> 
                </td>
              </tr>
              <tr>
                <td>排序</td>
                <td><input id="sort" name="sort" type="number" class="form-control" placeholder="Enter orders"></td>
              </tr>
              <tr>
                <td>状态</td>
                <td>
                  <select id="status" name="status" class="form-control">
                    <option value="1">正常</option>
                    <option value="0">弃用</option>
                  </select>
                </td>
              </tr>
              <input id="id" name="id" type="hidden">
            </tbody>
          </table>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="submit" class="btn btn-primary btn-info pull-right">确认提交</button>
      </div>
    </div>
  </div>
</div>
    {{ partial('common/footer') }}
    <script src="/js/admin/moduleList.js"></script>
    </body>
</html>