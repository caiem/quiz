{{ partial('common/header') }}
<link rel="stylesheet" href="/plugins/fancybox/jquery.fancybox.min.css" type="text/css" media="screen" />
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
        开发者账号管理
        <small>用户管理</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">用户管理</a></li>
        <li class="active">开发者账号管理</li>
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
                        <div  style="float:right;margin-right:40px" class="btn-group">
                            <button title="默认为管理员账户" type="button" class="btn btn-info dropdown-toggle" data-toggle="dropdown">
                              账号类型<span class="caret"></span>
                            </button>
                            <ul class="dropdown-menu" role="menu">
                              <li><a href="/manage/User/index">管理员</a></li>
                              <li><a href="/manage/User/advertiser">广告投放商</a></li>
                              <li><a href="/manage/User/developer">开发者</a></li>
                            </ul>
                        </div>
                    </div>
                    <div class="form-group">
                      <label for="uname">账户名称:</label>
                      <input name="uname" size="45" value="{{q_data['uname']|default('')}}" type="text" class="form-control" id="uname" placeholder="请输入用户名">
                    </div>
                    <div class="form-group">
                      <label for="status">状态:</label>
                      <select name="status" class="form-control">
                        <option value="1" {% if q_data['status'] is defined and q_data['status']==1%}selected{% endif %}>正常</option>
                        <option value="0" {% if q_data['status'] is defined and q_data['status']==0%}selected{% endif %}>禁用</option>
                        <option value="-1" {% if q_data['status'] is defined and q_data['status']==-1%}selected{% endif %}>全部</option>
                      </select>
                    </div>
                    <input type="submit" class="btn btn-info" value="查询"/>
                    <a style="float:right;margin-right:40px" class="btn btn-info" data-target="#modal-addDevelop" data-toggle="modal">新增用户<i class="fa fa-plus"></i></a>
                </form>
            </div>
            <!-- /.box-header -->
            <div class="box-body no-padding">
              <table class="table table-hover">
                <tr>
                  <th>ID</th>
                  <th>账号名称</th>
                  <th>邮箱</th>
                  <th>公司名称</th>
                  <th>登录次数</th>
                  <th>最近登录时间</th>
                  <th>最近登录IP</th>
                  <th>状态</th>
                  <th width="120">操作</th>
                </tr>
                {% for index, user in userList %}
                <tr>
                  <td>{{ user['user_id'] }}</td>
                  <td>{{ user['username'] }}</td>
                  <td>{{ user['email'] }}</td>
                  <td>{{ user['realname'] }}</td>
                  <td>{{ user['login_times']|e }}</td>
                  <td>{% if user['last_login_time'] is not empty %}{{ date('Y-m-d H:i:s',user['last_login_time']) }}{% endif %}</td>
                  <td>{{ user['last_login_ip']|e }}</td>
                  <td>{% if user['status'] == '1' %}<span class="label label-success">{{accountStatus[user['status']]}}</span>{% else %}<span class="label label-default" data-toggle="tooltip" title="{{accountStatus[user['status']]}}">{{user['status']==0?'禁用':'异常'}}</span>{% endif %}</td>
                  <td>
                    <button class="btn btn-default btn-xs viewAcount" uname="{{ user['username'] }}" data-content='{{user['accounts']|json_encode}}'>详情</button>
                    <button class="btn btn-warning btn-xs user-resetpwd" uid="{{user['user_id']}}">重置密码</button>
                    <a class="btn btn-default btn-xs" href="/manage/Apppos/index?uid={{user['user_id']}}">创建应用</a>
                    <button class="btn btn-warning btn-xs user-status" user_id="{{user['user_id']}}" url="/manage/user/updatestatus?type=1" value="{% if user['status'] == '0' %}1{% else %}0{% endif %}">{% if user['status'] == '0' %}解禁{% else %}禁用{% endif %}</button>
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
<div id="modal-addDevelop" class="modal fade modal-form">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title">新增开发者用户</h4>
      </div>
      <div class="modal-body">
        <form id="form_addDevelop" action="/manage/User/adddeveloper" method="POST">
          <table class="table table-bordered">
            <tbody>
              <tr>
                <td class="input_require">帐号名称</td>
                <td><input name="username" type="text" class="form-control" placeholder="Enter username"></td>
              </tr>
              <tr>
                <td class="input_require">账号密码</td>
                <td><input name="password" type="text" class="form-control" value="{{defaultpwd}}" placeholder="Enter password" readonly></td>
              </tr>
              <tr>
                <td class="input_require">联系邮箱</td>
                <td><input name="email" type="email" class="form-control" placeholder="Enter email"></td>
              </tr>
              <tr>
                <td class="input_require">公司名称</td>
                <td><input name="name" type="text" class="form-control" placeholder="Enter Company Name"></td>
              </tr>
              <tr>
                <td class="input_require">营业执照副本</td>
                <td><input name="licence" type="file" class="form-control" placeholder="Enter SECRET"></td>
              </tr>
              <tr>
                <td>组织机构代码</td>
                <td><input name="org" type="file" class="form-control" placeholder="Enter org"></td>
              </tr>
              <tr>
                <td>税务登记证</td>
                <td><input name="tax" type="file" class="form-control" placeholder="Enter tax"></td>
              </tr>
              <tr>
                <td class="input_require">开户许可证</td>
                <td><input name="permit" type="file" class="form-control" placeholder="Enter permit"></td>
              </tr>
              <tr>
                <td class="input_require">联系人名称</td>
                <td><input name="contact" type="text" class="form-control" placeholder="Enter Name"></td>
              </tr>
              <tr>
                <td class="input_require">联系人手机号</td>
                <td><input name="phone" type="text" class="form-control" placeholder="Enter Phone"></td>
              </tr>
              <tr>
                <td class="input_require">联系地址</td>
                <td><input name="address" type="text" class="form-control" placeholder="Enter Address"></td>
              </tr>
              <tr>
                <td class="input_require">状态</td>
                <td>
                  <select name="status" class="form-control">
                    <option value="1">启用</option>
                    <option value="0">禁用</option>
                  </select>
                </td>
              </tr>
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

<div id="modal-resetPwd" class="modal fade modal-form">
  <div class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4 class="modal-title">重置密码</h4>
        </div>
        <div class="modal-body">
            <form id="form_resetPwd" action="/manage/User/resetPasswd?type=1" role="form" method="POST">
                <table class="table table-bordered">
                    <tbody>
                        <input id="reset_uid" name="user_id" type="hidden" class="form-control"/>
                        <tr>
                            <td>新密码</td>
                            <td><input name="password" id="password" type="password" class="form-control" /></td>
                        </tr>
                        <tr>
                            <td>再次输入新密码</td>
                            <td><input name="pwdcheck" id="pwdcheck" type="password" class="form-control" /></td>
                        </tr>                           
                    </tbody>
                </table>
            </form>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal"> 关闭  </button>
            <button type="button" class="btn btn-primary" id="btn-resetPwd">确认提交</button>
        </div>
    </div>
  </div>
</div>

<div id="modal-viewAcount" class="modal fade modal-form">
  <div class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4 class="modal-title"><span class="red"></span>详情</h4>
        </div>
        <div class="modal-body">
            <div>
                <h3>资质文件</h3>
                <div class="imgs"></div>
            </div>
            <div>
                <h3>联系人信息</h3>
                <div>
                    <p class="name">联系人名称 ：<span></span></p>
                    <p class="phone">联系人手机号：<span></span></p>
                    <p class="address">联系人地址：<span></span></p>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal"> 关闭  </button>
        </div>
    </div>
  </div>
</div>
{{ partial('common/footer') }}
<script src="/js/admin/user.js"></script>
<script src="/plugins/jQuery/jquery.form.js"></script>
<script type="text/javascript" src="/plugins/fancybox/jquery.fancybox.min.js"></script>
<script>
    $('.viewAcount').click(function () {
        var name = $(this).attr('uname');
        var data = $(this).data('content');
        var fileshtml = '';
        for(var i in data.files){
            if( data.files[i] && data.files[i]!=''){
                fileshtml += '<a data-fancybox="gallery'+data.user_id+'" class="viewImg" href="'+ (data.files[i].indexOf('://')!=-1 ? data.files[i] : "/upload/" + data.files[i] )
                    +'"><img style="max-height:100px;max-width:100px;padding-right:10px" src ="'+ (data.files[i].indexOf('://')!=-1 ? data.files[i] : "/upload/" + data.files[i] ) +'"/></a>'
            }
        }
        $('#modal-viewAcount .modal-title span').html(name)
        $('#modal-viewAcount .modal-body .imgs').html(fileshtml)
        $('#modal-viewAcount .modal-body .name span').html(data.contact)
        $('#modal-viewAcount .modal-body .phone span').html(data.phone)
        $('#modal-viewAcount .modal-body .address span').html(data.address)
        $('.viewImg').fancybox();
        $('#modal-viewAcount').modal('show');
    });
    $("#modal-addDevelop .btn-primary").click(function () {
        $("#form_addDevelop").ajaxSubmit({dataType:'json',success:function( data ){
            if (data.code == 200) {
                window.location.reload();
            }else{
                alert(data.msg);
            }
        }});
    });
</script>
</body>
</html>