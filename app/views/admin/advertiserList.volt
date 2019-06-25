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
        广告商账户管理
        <small>用户管理</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">用户管理</a></li>
        <li class="active">广告商账户管理</li>
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
                    <div class="form-group">
                      <label for="type">账户类型:</label>
                      <select name="type" class="form-control">
                        <option value="0" {% if q_data['type'] is defined and q_data['type']==0%}selected{% endif %}>商业</option>
                        <option value="1" {% if q_data['type'] is defined and q_data['type']==1%}selected{% endif %}>运营</option>
                        <option value="-1" {% if q_data['type'] is defined and q_data['type']==-1%}selected{% endif %}>全部</option>
                      </select>
                    </div>
                    <input type="submit" class="btn btn-info" value="查询"/>
                    <a style="float:right;margin-right:40px" class="btn btn-info" data-target="#modal-addPage" data-toggle="modal">新增用户<i class="fa fa-plus"></i></a>
                </form>
            </div>
            <!-- /.box-header -->
            <div class="box-body no-padding">
              <table class="table table-hover">
                <tr>
                  <th>ID</th>
                  <th>账号名称</th>
                  <th>邮箱</th>
                  <th>昵称</th>
                  <th>账户类型</th>
                  <th>关联合同号</th>
                  <th>开户资料</th>
                  <th>API KEY / SECRET</th>
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
                  <td><span class="label {% if user['type']==1 %}label-success{% else %}label-default{% endif %}">{{ userType[ user['type'] ] }}</span></td>
                  <td>{{ user['contract'] }}</td>
                  <td><span class="label {% if user['acc_status']==1 %}label-success{% else %}label-warning{% endif %}">{% if user['acc_status']==1 %}已提交{% else %}未提交{% endif %}</span></td>
                  <td>{{ user['api_key']|default('--') }} / {{ user['api_secret']|default('--') }}</td>
                  <td>{{ user['login_times']|e }}</td>
                  <td>{% if user['last_login_time'] is not empty %}{{ date('Y-m-d H:i:s',user['last_login_time']) }}{% endif %}</td>
                  <td>{{ user['last_login_ip']|e }}</td>
                  <td>{% if user['status'] == '1' %}<span class="label label-success">{{accountStatus[user['status']]}}</span>{% else %}<span class="label label-default" data-toggle="tooltip" title="{{accountStatus[user['status']]}}">{{user['status']==0?'禁用':'异常'}}</span>{% endif %}</td>
                  <td>
                    <button class="editUser btn btn-xs btn-warning text-fill" url="/manage/user/detail?type=1" user_id="{{user['user_id']}}">修改</button>
                    <button class="btn btn-default btn-xs user-resetpwd" uid="{{user['user_id']}}">重置密码</button>
                    <div class="btn-group nav navbar-nav navbar-right" style="float:none!important">
                        <button type="button" class="btn btn-xs btn-default text-fill">更多操作</button>
                        <button type="button" class="btn btn-xs btn-default text-fill dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                          <span class="caret"></span>
                          <span class="sr-only">Toggle Dropdown</span>
                        </button>
                        <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel" style="top:-{{ user['acc_status']==1? '774': '654' }}%;"></li>
                            <li><a href="javascript:void(0);" class="user-status" user_id="{{user['user_id']}}" url="/manage/user/updatestatus?type=1" value="{% if user['status'] == '0' %}1{% else %}0{% endif %}">{% if user['status'] == '0' %}解禁{% else %}禁用{% endif %}</a></li>
                            <li><a href="/manage/User/useroptloglist?uid={{user['user_id']}}">操作明细</a></li>
                            <li><a href="javascript:void(0);" class="user-status" user_id="{{user['user_id']}}" url="/manage/user/updatetype?type=1" value="{% if user['type'] == '1' %}0{% else %}1{% endif %}">{% if user['type'] == '1' %}设为商业账户{% else %}设为运营账户{% endif %}</a></li>
                            <li>{% if user['acc_status']==1 %}<a target="_blank" href="/manage/User/viewaccount?uid={{user['user_id']}}">查看开户资料</a><a class="addAcount" target="_blank" href="/manage/User/editaccount?uid={{user['user_id']}}">修改开户资料</a>{% else %}<a class="addAcount" target="_blank" href="/manage/User/editaccount?uid={{user['user_id']}}">补交开户资料</a>{% endif %}</li>
                            <li><a href="/manage/Advertis/index?uname={{user['username']}}">查看账户资金</a></li>
                        </ul>
                    </div>
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
<div id="modal-addPage" class="modal fade modal-form">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title">新增广告商用户</h4>
      </div>
      <div class="modal-body">
        <form id="form_add" action="/manage/User/addAdvertiser" method="POST">
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
                <td class="input_require">邮箱</td>
                <td><input name="email" type="email" class="form-control" placeholder="Enter email"></td>
              </tr>
              <tr>
                <td>API KEY</td>
                <td><input name="api_key" type="text" class="form-control" placeholder="Enter API KEY"></td>
              </tr>
              <tr>
                <td>API SECRET</td>
                <td><input name="api_secret" type="text" class="form-control" placeholder="Enter API SECRET"></td>
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
              <tr>
                <td>真实姓名</td>
                <td><input name="realname" type="text" class="form-control" placeholder="Enter realname"></td>
              </tr>
              <tr>
                <td>账户类型</td>
                <td>
                    {% for index,item in userType %}
                        <label class="radio-inline">
                            <input name="type" type="radio" value="{{index}}" {% if index==0 %}checked{% endif %}>{{item}}
                        </label>
                    {% endfor %}
                </td>
              </tr>
              <tr>
                <td>预充值</td>
                <td><input name="recharge" type="recharge" class="form-control" placeholder="Enter recharge"></td>
              </tr>
              <tr>
                <td>邮件通知</td>
                <td>
                  <label class="radio-inline">
                    <input type="radio" name="email_notify" id="email_notify1" value="1"> 是 
                  </label>
                  <label class="radio-inline">
                    <input type="radio" name="email_notify" id="email_notify2" value="0" checked> 否
                  </label>
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

<div id="modal-editPage" class="modal fade modal-form">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title">更新用户信息</h4>
      </div>
      <div class="modal-body">
      <form id="form_edit" action="/manage/User/updateAdvertiser" method="POST">
        <table class="table table-bordered">
          <tbody>
            <tr>
              <td>帐号名称</td>
              <td><span id="edit_username"></span></td>
            </tr>
            <tr>
              <td class="input_require">邮箱</td>
              <td><input name="email" id="edit_email" type="email" class="form-control"></td>
            </tr>
            <tr>
              <td>真实姓名</td>
              <td><input name="realname" id="edit_realname" type="text" class="form-control"></td>
            </tr>
            <tr>
                <td>API KEY</td>
                <td><input name="api_key" id="edit_api_key" type="text" class="form-control" placeholder="Enter API KEY"></td>
            </tr>
            <tr>
                <td>API SECRET</td>
                <td><input name="api_secret" id="edit_api_secret" type="text" class="form-control" placeholder="Enter API SECRET"></td>
            </tr>
          </tbody>
        </table>
        <input type="hidden" name="user_id" value="" id="edit_user_id" />
      </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="button" class="btn btn-primary">确认更新</button>
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
{{ partial('common/footer') }}
<script src="/js/admin/user.js"></script>
</body>
</html>