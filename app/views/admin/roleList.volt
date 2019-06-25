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
        组织架构
        <small>组织架构列表</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">角色管理</a></li>
        <li class="active">角色列表</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">

      <div class="row">
        <div class="col-xs-12">
          <div class="box">
            <div class="box-header">
              <div class="user-add text-right">
                <a class="btn btn-info" data-target="#modal-addPage" data-toggle="modal">创建新角色<i class="fa fa-plus"></i></a>
              </div>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover">
                <tr>
                  <th>角色名称</th>
                  <th>描述</th>
                  <th>用户数量</th>
                  <th>状态</th>
                  <th>操作</th>
                </tr>
                {% for index, role in roleList %}
                <tr>
                  <td>{{ role['role_name'] }}</td>
                  <td>{{ role['description'] }}</td>
                  <td>{{ role['user_count'] }}</td>
                  <td>{% if role['status'] == '1' %}<span class="label label-success">正常</span>{% else %}<span class="label label-danger">冻结</span>{% endif %}</td>
                  <td>
                    <a class="editUser btn btn-xs btn-info text-fill" href="/manage/Role/viewRole?role_id={{role['role_id']}}" data-toggle="modal" data-target="#modal">查看<i class="fa fa-street-view"></i></a>
                    <a class="btn btn-warning btn-xs editRole text-fill" rid="{{role['role_id']}}" type="button">修改</a>
                    <a class="editUser btn btn-xs btn-warning text-fill" href="/manage/Role/getAccess?role_id={{role['role_id']}}">权限设置<i class="fa fa-edit"></i></a>
                  </td>
                  
                    
                </tr>
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
<div id="modal" class="modal fade modal-form">
  <div class="modal-dialog">
    <div class="modal-content">
    </div>
  </div>
</div>

<div id="modal-addPage" class="modal fade modal-form">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title">创建新角色</h4>
      </div>
      <div class="modal-body">
      <form id="form_add" action="/manage/Role/addRole" method="POST">
        <table class="table table-bordered">
          <tbody>
            <tr>
              <td>角色名称</td>
              <td><input name="role_name" type="text" class="form-control"></td>
            </tr>
            <tr>
              <td>角色描述</td>
              <td><input name="description" type="text" class="form-control"></td>
            </tr>
          </tbody>
        </table>
      </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="button" class="btn btn-primary">确认提交</button>
      </div>
    </div>
  </div>
</div>

<div id="modal-editPage" class="modal fade modal-form">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title">更新角色信息</h4>
      </div>
      <div class="modal-body">
      <form id="form_edit" action="/manage/Role/editRole" method="POST">
        <table class="table table-bordered">
          <tbody>
            <tr>
              <td>角色名称</td>
              <td><input name="role_name" id="edit_rolename" type="text" class="form-control"></td>
            </tr>
            <tr>
              <td>角色描述</td>
              <td><input name="description" id="edit_description" type="text" class="form-control"></td>
            </tr>
              <td>状态</td>
              <td>
                <label class="radio-inline">
                  <input class="text-fill" name="status" type="radio" id="edit_status_0" value="0"> 冻结
                </label>
                <label class="radio-inline">
                  <input class="text-fill" name="status" type="radio" id="edit_status_1" value="1"> 正常
                </label>
              </td>
            </tr>
          </tbody>
        </table>
        <input type="hidden" name="role_id" value="" id="edit_role_id" />
      </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="button" class="btn btn-primary">确认提交</button>
      </div>
    </div>
  </div>
</div>
{{ partial('common/footer') }}
<script>
$(document).ready(function(){
  $('body').on('hidden.bs.modal', '.modal', function() {
    $(this).removeData('bs.modal');
  });
  $("#modal-addPage .btn-primary").click(function(){
    var query = $("#form_add").serialize();
    var url = $("#form_add").attr("action");
    ajaxDev(url,query,'');
  });
  $(".editRole").click(function(){
    $.getJSON(
      "/manage/Role/getRoleInfo",
      {"role_id": $(this).attr("rid")},
      function( data ) {
        if(data.code == 200){
          $("#edit_rolename").val( data.result.role_name );
          $("#edit_description").val( data.result.description );
          $("#edit_role_id").val( data.result.role_id );
          var status_key = '#edit_status_' +  data.result.status;
          $(status_key).attr("checked", "checked");
        
          $('#modal-editPage').modal('show')
        }
      }
    );
  });
  $("#modal-editPage .btn-primary").click(function(){
    var query = $("#form_edit").serialize();
    var url = $("#form_edit").attr("action");
    ajaxDev(url,query,'');
  });
});
</script>
</body>
</html>