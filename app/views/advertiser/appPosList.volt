{{ partial('common/header') }}
<link href="/plugins/select2/select2.min.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" href="/plugins/fancybox/jquery.fancybox.min.css" type="text/css" media="screen" />
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
        广告位管理
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li class="active">广告位管理</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">

      <div class="row">
        <div class="col-xs-12">
          <div class="box">
            <div class="box-header">
                <form id="query_form" class="form-inline" role="form">
                    <div class="form-group">
                      <label>应用名称:</label>
                      <select name="appid" style="width:260px" type="text" class="form-control" placeholder="请输入应用名称">
                        {% if searchItem['appname'] is not empty%}
                        <option value="{{searchItem['appid']|default('')}}" selected>{{searchItem['appname']|default('')}}</option>
                        {% endif %}
                      </select>
                    </div>
                    <input type="hidden" name="appname" class="btn btn-info"/>
                    <input type="submit" class="btn btn-info" value="查询"/>
                </form>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover">
                <tr>
                  <th>应用名称</th>
                  <th>点位ID</th>
                  <th>点位名称</th>
                  <th>广告类型</th>
                  <th>广告尺寸</th>
                  <th>素材要求</th>
                  <th>广告效果图</th>
                  <th>审核状态</th>
                  <th>操作</th>
                </tr>
                {% for index, item in List %}
                <tr>
                  <td>{{ item['app_name'] }}</td>
                  <td>{{ item['pos_id'] }}</td>
                  <td>{{ item['pos_name'] }}</td>
                  <td title="{{item['type']}}">{{ ADTYPE[item['type']] }}</td>
                  <td>{{ item['size'] }}</td>
                  <td>{{ item['format'] }}</td>
                  <td>
                    {% for file in item['files'] %}
                        <a class="viewImg" data-fancybox="group" href="/upload/{{ file }}"><img src="/upload/{{ file }}" style="width:80px;height:80px"/></a>
                    {% endfor %}
                  </td>
                  <td><span data-toggle="tooltip" title="{{item['mark']}}" class="label {{item['status']==1?'label-success':(item['status']==2?'label-warning':'label-default')}}">{{auditStatus[item['status']]}}</span></td>
                  <td>
                    <button class="btn btn-xs btn-warning text-fill editPos" data-content='{{item|json_encode}}'>修改</button>
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
<div id="modal-editPage" class="modal fade modal-form">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title">修改广告位</h4>
      </div>
      <div class="modal-body">
      <form id="form_edit" action="/Apppos/addedit" method="POST">
        <table class="table table-bordered">
          <tbody>
              <tr>
                <td class="input_require">应用名称</td>
                <td>
                    <select name="app_id" class="form-control appList" placeholder="请输入应用名称">
                        {% for _item in AppList%}
                        <option value="{{_item['app_id']}}">{{_item['app_name']}}</option>
                        {% endfor %}
                    </select>
                </td>
              </tr>
              <tr>
                <td class="input_require">点位名称</td>
                <td>
                    <input name="pos_name" id="edit_pos_name" type="text" class="form-control appname" placeholder="请输入点位名称">
                </td>
              </tr>
              <tr>
                <td class="input_require">广告类型</td>
                <td>
                    <select name="type" class="form-control adType" data-inflow='{{Inflow_sizes|json_encode}}' data-banner='{{Banner_sizes|json_encode}}' placeholder="请输入广告类型">
                        {% for index,text in ADTYPE%}
                        <option value="{{index}}">{{text}}</option>
                        {% endfor %}
                    </select>
                </td>
              </tr>
              <tr>
                <td class="input_require">广告尺寸</td>
                <td>
                    <select name="size" class="form-control adSize" placeholder="请输入广告尺寸">
                        {% for text in Inflow_sizes%}
                        <option value="{{text}}">{{text}}</option>
                        {% endfor %}
                    </select>
                </td>
              </tr>
              <tr>
                <td class="input_require">广告效果图</td>
                <td><input name="file" type="file" class="form-control" placeholder="请输入广告效果图"></td>
              </tr>
              <tr class="posLimit" style="display:none;">
                <td class="input_require">素材要求</td>
                <td>
                    <label class="checkbox-inline">
                      <input class="extFormat" name="ext[]" type="checkbox" value="jpg"> jpg
                    </label>
                    <label class="checkbox-inline">
                      <input class="extFormat" name="ext[]" type="checkbox" value="jpeg"> jpeg
                    </label>
                    <label class="checkbox-inline">
                      <input class="extFormat" name="ext[]" type="checkbox" value="gif"> gif
                    </label>
                    <label class="checkbox-inline">
                      <input class="extFormat" name="ext[]" type="checkbox" value="png"> png
                    </label>
                    <label class="checkbox-inline">
                      <input class="extFormat" name="ext[]" type="checkbox" value="swf"> swf
                    </label>
                </td>
              </tr>
          </tbody>
        </table>
        <input type="hidden" name="pos_id" id="edit_pos_id">
      </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="button" class="btn btn-primary">确认更新</button>
      </div>
    </div>
  </div>
</div>
<!-- ./wrapper -->
{{ partial('common/footer') }}
<script type="text/javascript" src="/plugins/fancybox/jquery.fancybox.min.js"></script>
<script src="/plugins/select2/select2.min.js"></script>
<script src="/plugins/jQuery/jquery.form.js"></script>
<script>
$("#query_form select[name=appid]").select2({
    ajax:{
        url:"/App/filter",
        dataType:'json',
        delay: 250,
        data:function(params){
            return {
                q:params.term,
                page:params.page
            }
        },
        processResults: function (data, params) {
            params.page = params.page || 1;

            return {
              results: data.result,
              pagination: {
                more: (params.page * 30) < data.msg
              }
            };
        },
        cache: true
    },
    language: "zh-CN",
    escapeMarkup: function (markup) { return markup; }, // 自定义格式化防止xss注入
    formatResult: function formatRepo(repo){return repo.text;}, // 函数用来渲染结果
    formatSelection: function formatRepoSelection(repo){ return repo.text;  }// 函数用于呈现当前的选择
  });
    $('#query_form select[name=appid]').on('select2:select', function (evt) {
        $("#query_form input[name=appname]").val(evt.params.data.text);
    })
  $('button.editPos').click(function () {
        var data = $(this).data('content');
        $('#modal-editPage .appList').find('option[value='+ data.app_id +']').prop('selected',true);
        $('#modal-editPage #edit_pos_name').val(data.pos_name);
        $('#modal-editPage #edit_pos_id').val(data.pos_id);
        $('#modal-editPage .adType').find('option[value="'+ data.type +'"]').prop('selected',true);
        $('select.adType').change();
        $('.extFormat').each(function(){
            if(data.format.indexOf( $(this).val() )!=-1){
                $(this).prop('checked',true)
            }else{
                $(this).prop('checked',false)
            }
        });
        
        $('#modal-editPage .adSize').find('option[value="'+ data.size +'"]').prop('selected',true);
        $('#modal-editPage').modal('show');
    });
    $('#modal-editPage button.btn-primary').click(function () {
        $("#form_edit").ajaxSubmit({dataType:'json',success:function( data ){
            if (data.code == 200) {
                window.location.reload();
            }else{
                alert(data.msg);
            }
        }});
    });
    $('select.adType').change(function(){
        var type = $(this).val();
        if(type=='inforflow'){
            $('.posLimit').css({display:"none"});
            var sizes = $(this).data('inflow');
        }else if(type=='banner'){
            $('.posLimit').attr('style','');
            var sizes = $(this).data('banner');
        }else{
            alert('广告类型异常');
            return;
        }
        var options = '';
        for(var i in sizes){
            options += '<option value="'+ sizes[i] +'">'+ sizes[i] + '</option>';
        }
        $('.adSize').html(options);
    });
    $('.viewImg').fancybox();
</script>
</body>
</html>