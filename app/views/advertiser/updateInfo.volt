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
        修改个人资料
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">main</a></li>
        <li class="active">修改个人资料</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">
        <div class="row">
            <div class="col-xs-12">
                <div class="box">
                    <div class="box-body table-responsive no-padding">
                        <form class="form-horizontal" action="/Index/updateInfo" id="form_post">
                          <!-- 修改个人资料 -->
                          <div class="panel panel-primary">
                            <div class="panel-body">
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="formGroupInputLarge">原密码：</label>
                                    <div class="col-sm-6">
                                        <input class="form-control" type="password" name="pwd">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="formGroupInputLarge">修改密码：</label>
                                    <div class="col-sm-6">
                                        <input class="form-control" type="password" name="password">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="formGroupInputLarge">修改邮箱：</label>
                                    <div class="col-sm-6">
                                        <input class="form-control" type="email" name="email" value="{{userInfo['email']}}">
                                    </div>
                                </div>
                                <input type="hidden" name="uid" value="{{userInfo['user_id']}}">
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="formGroupInputLarge"></label>
                                    <div class="col-sm-6">
                                        <a class="btn btn-primary setting">确认修改</a>
                                    </div>
                                </div>
                            </div>
                          </div>
                          <!-- 修改个人资料 -->
                        </form>
                    </div>
                </div>
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
  $(".setting").click(function(){
    var query = $("#form_post").serialize();
    var url = $("#form_post").attr("action");
    if( !formCheck() ){
        return false;
    }
    $.post({
          url: url,
          data: query,
          dataType: 'json'
        })
        .done(function (data) {
          if (data.code == 200) {
            window.location.reload();
          } else {
            alert(data.msg);
          }
        });
  });
});
function formCheck(){
    pwd_regex = new RegExp('(?=.*[0-9])(?=.*[a-zA-Z]).{6,16}');
    email_regex = new RegExp(/^([0-9A-Za-z\-_\.]+)@([0-9a-z]+\.[a-z]{2,3}(\.[a-z]{2})?)$/);
    var pwd = $('input[name=password]')
    if( pwd.val()!='' && !pwd_regex.test( pwd.val() ) ){
        alert('密码必须是6-16位,且必须包含字符和数字');
        pwd.focus();
        return false
    }
    var mail = $('input[name=email]')
    if( !email_regex.test( mail.val() ) ){
        alert('邮箱格式不正确');
        mail.focus();
        return false
    }
    return true;
}
</script>
    </body>
</html>