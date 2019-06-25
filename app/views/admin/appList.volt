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
        {% if developer is not empty %}<span class="red">{{developer.username}}</span>-{% endif %}应用列表
        <small>应用点位管理</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">应用点位管理</a></li>
        <li class="active">开发者应用列表</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">

      <div class="row">
        <div class="col-xs-12">
          <div class="box">
            <div class="box-header">
                <form class="form-inline" role="form">
                    <input name="uid" type="hidden" value="{{q_data['uid']}}">
                    {% if developer is empty %}
                    <div class="form-group">
                      <label for="uname">开发者名称:</label>
                      <input name="uname" size="45" value="{{q_data['uname']|default('')}}" type="text" class="form-control" id="uname" placeholder="请输入开发者名称">
                    </div>
                    {% endif %}
                    <div class="form-group">
                      <label for="appname">应用名称:</label>
                      <input name="appname" size="45" value="{{q_data['appname']|default('')}}" type="text" class="form-control" id="appname" placeholder="请输入应用名称">
                    </div>
                    <input type="submit" class="btn btn-info" value="查询"/>
                    {% if q_data['uid'] is not empty%}
                    <a style="float:right;margin-right:40px" class="btn btn-info" data-target="#modal-addPage" data-toggle="modal">新增应用<i class="fa fa-plus"></i></a>
                    {% endif %}
                </form>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover">
                <tr>
                  {% if developer is empty %}
                  <th>开发者名称</th> 
                  {% endif %}
                  <th>应用名称</th>
                  <th>APPID</th>
                  <th>APPKEY</th>
                  <th>应用平台</th>
                  <th>行业分类</th>
                  <th>日活</th>
                  <th>适用人群</th>
                  <th>应用描述</th>
                  <th>操作</th>
                </tr>
                {% for index, item in List %}
                <tr>
                  {% if developer is empty %}
                  <td>{{ item['username']|default('') }}</td>
                  {% endif %}
                  <td>{{ item['app_name'] }}</td>
                  <td>{{ item['app_id'] }}</td>
                  <td>{{ item['app_key'] }}</td>
                  <td>{{ Platforms[item['platform']] }}</td>
                  <td>{{ Classify[ item['classify'] ]|default('') }}</td>
                  <td>{{ item['active_users'] }}</td>
                  <td>{{ item['target_user']|e }}</td>
                  <td>{{ item['description']|e }}</td>
                  <td>
                    <button class="editApp btn btn-xs btn-warning text-fill" url="/manage/Apppos/detail" data-content='{{item|json_encode}}'>修改</button>
                    <a class="btn btn-primary btn-xs" href="/manage/Apppos/poslist?uname={{developer.username|default(item['username'])}}&status=-1" >点位列表</a>
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
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title">新增开发者应用</h4>
      </div>
      <div class="modal-body">
        <form id="form_add" action="/manage/Apppos/addedit" method="POST">
          <input name="user_id" type="hidden" value="{{q_data['uid']}}">
          <input name="is_new" type="hidden" value="1">
          <table class="table table-bordered">
            <tbody>
              <tr>
                <td class="input_require">应用名称</td>
                <td><input name="app_name" type="text" class="form-control" placeholder="请输入应用名称"></td>
                <td><small>必填。应用市场可搜的应用名称</small></td>
              </tr>
              <tr>
                <td class="input_require">应用平台</td>
                <td>
                  {% for key,text in Platforms%}
                  <label class="checkbox-inline">
                    <input name="platform" type="radio" value="{{key}}"> {{text}}
                  </label>
                  {% endfor %}
                </td>
                <td><small>必填。应用的平台</small></td>
              </tr>
              <tr>
                <td class="input_require">行业分类</td>
                <td>
                    <select name="classify"  class="form-control" placeholder="请输入行业分类">
                        {% for key,text in Classify%}
                        <option value="{{key}}">{{text}}</option>
                        {% endfor %}
                    </select>
                </td>
                <td><small>必选。应用所属的行业分类</small></td>
              </tr> 
              <tr>
                <td>日活用户数</td>
                <td><input name="active_users" type="number" class="form-control" placeholder="请输入日活用户数"></td>
                <td><small>选填。日活用户数</small></td>
              </tr>
              <tr>
                <td>适用人群</td>
                <td><textarea name="target_user" class="form-control" placeholder="请输入适用人群"></textarea></td>
                <td><small>选填。适用人群说明</small></td>
              </tr>
              <tr>
                <td>应用描述</td>
                <td><textarea name="description" class="form-control" placeholder="请输入应用描述"></textarea></td>
                <td><small>选填。方便广告主对流量媒体方有个简单的了解。</small></td>
              </tr>
              <tr>
                <td class="input_require">APPID</td>
                <td>
                    <div class="input-group">
                        <input name="app_id" type="text" class="form-control" readonly>
                        <span class="input-group-btn">
                          <button url="/manage/Apppos/random?type=1" type="button" class="btn btn-warning btn-flat randomString">随机生成</button>
                        </span>
                    </div>
                </td>
                <td><small>必填。接入sdk中的appid，点击按钮随机生成</small></td>
              </tr>
              <tr>
                <td class="input_require">APPKEY</td>
                <td>
                    <div class="input-group">
                        <input name="app_key" type="text" class="form-control" readonly>
                        <span class="input-group-btn">
                          <button url="/manage/Apppos/random" type="button" class="btn btn-warning btn-flat randomString">随机生成</button>
                        </span>
                    </div>
                </td>
                <td><small>必填。接入sdk中的appkey，只可以点击按钮随机生成。</small></td>
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
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title">更新应用信息</h4>
      </div>
      <div class="modal-body">
      <form id="form_edit" action="/manage/Apppos/addedit" method="POST">
        <table class="table table-bordered">
          <tbody>
              <tr>
                <td class="input_require">应用名称</td>
                <td><input name="app_name" type="text" class="form-control appname" placeholder="请输入应用名称"></td>
                <td><small>必填。应用市场可搜的应用名称</small></td>
              </tr>
              <tr>
                <td class="input_require">行业分类</td>
                <td>
                    <select name="classify" class="form-control classify" placeholder="请输入行业分类">
                        {% for key,text in Classify%}
                        <option value="{{key}}">{{text}}</option>
                        {% endfor %}
                    </select>
                </td>
                <td><small>必选。应用所属的行业分类</small></td>
              </tr>
              <tr>
                <td>应用描述</td>
                <td><textarea name="description" class="form-control description" placeholder="请输入应用描述"></textarea></td>
                <td><small>选填。方便广告主对流量媒体方有个简单的了解。</small></td>
              </tr>
          </tbody>
        </table>
        <input type="hidden" name="app_id" value="" id="edit_app_id" />
      </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="button" class="btn btn-primary">确认更新</button>
      </div>
    </div>
  </div>
</div>
{{ partial('common/footer') }}
<script type="text/javascript">
$('#modal-addPage button.btn-primary').click(function () {
    var query = $("#form_add").serialize();
    var url = $("#form_add").attr("action");
    ajaxDev(url,query , '');
});
$('button.editApp').click(function () {
    var data = $(this).data('content');
    $('#modal-editPage .appname').val(data.app_name);
    $('#modal-editPage .classify').find("option[value='"+data.classify+"']").attr("selected",true);
    $('#modal-editPage .description').val(data.description);
    $('#modal-editPage #edit_app_id').val(data.app_id);
    $('#modal-editPage').modal('show');
});
$('#modal-editPage button.btn-primary').click(function () {
    var query = $("#form_edit").serialize();
    var url = $("#form_edit").attr("action");
    ajaxDev(url,query , '');
});
$('button.randomString').click(function () {
    var dom = $(this).closest('.input-group').find('input');
    $.getJSON($(this).attr('url'),function(data){
        dom.val( data.result );
    });
});
</script>
</body>
</html>
