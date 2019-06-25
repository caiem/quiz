{{ partial('common/header') }}
<style>
pre{
    border:none;
    background:none;
    padding:0px;
    white-space:pre-wrap;
    word-wrap: break-word;
}
</style>
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
        行业资质列表
        <small>行业资质管理</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">行业资质管理</a></li>
        <li class="active">行业资质列表</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">

      <div class="row">
        <div class="col-xs-12">
          <div class="box">
            <div class="box-header">
                <form class="form-inline" role="form">
                    <div id="industrys" class="form-group">
                        <div class="form-group">
                          <label>一级行业:</label>
                          <select name="pid" class="form-control prov">
                            <option value="">-请选择-</option>
                          </select>
                        </div>
                        <div class="form-group">
                          <label>二级行业:</label>
                          <select name="id" class="form-control city">
                            <option value="">-请选择-</option>
                          </select>
                        </div>
                    </div>
                    <input type="submit" class="btn btn-info" value="查询"/>
                    <div style="float:right;margin-right:40px">
                        <a class="btn btn-info" data-target="#modal-addPage" data-toggle="modal">新增<i class="fa fa-plus"></i></a>
                        <a class="btn btn-info" data-target="#modal-editDoc" data-toggle="modal">更新前台文档<i class="fa fa-edit"></i></a>
                    </div>
                </form>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover">
                <tr>
                  <th width="80">一级行业</th>
                  <th width="80">二级行业</th>
                  <th width="222">行业范围说明</th>
                  <th width="80">准入规则</th>
                  <th width="320">必须资质文件</th>
                  <th width="80">特殊业务范围</th>
                  <th width="222">补充</th>
                  <th>操作</th>
                </tr>
                {% for index, item in List %}
                <tr>
                  <td>{{ item['pname'] }}</td>
                  <td>{{ item['name'] }}</td>
                  <td><pre>{{ item['description'] }}</pre></td>
                  <td><pre>{{ item['access_rule'] }}</pre></td>
                  <td><pre>{{ item['qualify_file']|e }}</pre></td>
                  <td><pre>{{ item['sname']|e }}</pre></td>
                  <td><pre>{{ item['sfile']|e }}</pre></td>
                  <td>
                    <button class="editItem btn btn-xs btn-warning text-fill" data-content='{{item|json_encode}}' item_id="{{item['id']}}">修改</button>
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
        <h4 class="modal-title">新增/修改</h4>
      </div>
      <div class="modal-body">
        <form id="form_add" action="/manage/Industry/addedit" method="POST">
          <table class="table table-bordered">
            <tbody>
              <tr>
                <td class="input_require">行业名称</td>
                <td><input name="name" id="edit_name" type="text" class="form-control" placeholder=""></td>
              </tr>
              <tr>
                <td class="input_require">上级行业</td>
                <td>
                    <select id="edit_pid" name="pid" class="form-control" >
                        <option value="0">一级行业</option>
                        {% for item in selectJson['citylist']%}
                            <option value="{{item['pv']}}">{{item['p']}}</option>
                        {% endfor %}
                    </select>
                </td>
              </tr>
              <tr>
                <td>行业范围说明</td>
                <td><textarea id="edit_desc" name="desc" rows="5" class="form-control" placeholder=""></textarea></td>
              </tr> 
              <tr>
                <td>准入规则</td>
                <td><input name="rule"id="edit_rule"  type="text" class="form-control" placeholder=""></td>
              </tr>
              <tr>
                <td>必须资质文件</td>
                <td><textarea name="files" id="edit_files" rows="5" class="form-control" placeholder=""></textarea></td>
              </tr>
              <tr>
                <td>特殊业务范围</td>
                <td><input name="special" type="text" id="edit_special" class="form-control" placeholder=""></td>
              </tr>
              <tr>
                <td>补充</td>
                <td><textarea name="remark" id="edit_remark" rows="5" class="form-control" placeholder=""></textarea></td>
              </tr>
            </tbody>
          </table>
          <input name="id" id="edit_id"  type="hidden">
          <input name="sid" id="edit_sid" type="hidden">
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="submit" class="btn btn-primary btn-info pull-right">确认提交</button>
      </div>
    </div>
  </div>
</div>

<div id="modal-editDoc" class="modal fade modal-form">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title">更新前台文档</h4>
        <small>上传后覆盖前台下载文档</small>
      </div>
      <div class="modal-body">
        <form id="form_editdoc" action="/manage/Industry/editdoc" method="POST">
            <input type="file" name="file" class="form-control">
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
<script src="/plugins/jQuery/jquery.form.js"></script>
<script type="text/javascript" src="/plugins/cityselect/jquery.cityselect.js"></script>
<script type="text/javascript">
$(function(){
    var prov = "{{q_data['pid']|default('')}}" ? "{{q_data['pid']|default('')}}" :$("#industrys").find(".prov").val();
    var city = "{{q_data['id']|default('')}}"? "{{q_data['id']|default('')}}" :$("#industrys").find(".city").val();
    var param = {
        url:{{selectJson|json_encode}},
        required:false
    };
    if(prov){
        param.prov = prov;
    }
    if(city){
        param.city = city;
    }
    $("#industrys").citySelect(param);
    $('#modal-addPage button.btn-primary').click(function () {
        var query = $("#form_add").serialize();
        var url = $("#form_add").attr("action");
        ajaxDev(url, query, '');
    });
    $(".editItem").click(function () {
        var data = $(this).data('content');
        $("#edit_name").val(data.name);
        $("#edit_pid").val(data.parent_id);
        $("#edit_desc").val(data.description);
        $("#edit_rule").val(data.access_rule);
        $("#edit_files").val(data.qualify_file);
        $("#edit_special").val(data.sname);
        $("#edit_remark").val(data.sfile);
        $("#edit_id").val(data.id);
        $("#edit_sid").val(data.sid);
        $('#modal-addPage').modal('show')
    });
    $("#modal-editDoc .btn-primary").click(function () {
        $("#form_editdoc").ajaxSubmit({dataType:'json',success:function( data ){
            alert(data.msg);
            if (data.code == 200) {
                $('#modal-editDoc').modal('hide');
                $('#form_editdoc')[0].reset();
            }
        }});
    });
});
</script>
</body>
</html>
