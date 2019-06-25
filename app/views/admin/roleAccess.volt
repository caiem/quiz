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
        角色权限
        <small>角色管理</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">角色管理</a></li>
        <li class="active">角色权限</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">

      <div class="row">
        <div class="col-xs-12">
          <div class="box">
            <div class="box-body table-responsive no-padding">
              <form action="/manage/Role/setAccess" id="form_post" method="post">
                <input type="hidden" name="role_id" value="{{role_id}}">
                {% for index,topmenu in modules %}
                <div class="panel panel-primary">
                  <div class="panel-heading">
                    <h3 class="panel-title">{{ topmenu['title']}}</h3>
                  </div>
                  <div class="panel-body">
                      {% for chi,children in topmenu['children']%}
                      <div class="col-md-2">
                        <div class="checkbox">
                          <label class="text-ellipsis" title="{{ children['title']}}"><input type="checkbox" value="{{ children['module_id']}}" name="item[]" {% if access[children['module_id']] is defined %} checked="true"{% endif%}>{{ children['title']}}</label>
                        </div>
                      </div>
                      {% endfor %}
                  </div>
                </div>
                {% endfor %}
                <button class="btn btn-primary" type="button">确认更新角色权限</button>
              </form>
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
{{ partial('common/footer') }}
<script>
$(document).ready(function(){
  $(".btn-primary").click(function(){
    var query = $("#form_post").serialize();
    var url = $("#form_post").attr("action");
    ajaxDev(url,query,'');
  });
});
</script>
</body>
</html>