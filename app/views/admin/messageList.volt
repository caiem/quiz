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
                消息发送
                <small>系统管理</small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
                <li><a href="#">系统管理</a></li>
                <li class="active">消息发送</li>
            </ol>
        </section>

        <!-- Main content -->
        <section class="content">

            <div class="row">
                <div class="col-xs-12">
                    <div class="box">
                        <div class="box-header">
                            <div class="user-add text-left">
                                <a class="btn btn-info" data-target="#modal-addPage" data-toggle="modal">新建系统提示消息<i class="fa fa-plus"></i></a>
                            </div>
                        </div>
                        <!-- /.box-header -->
                        <div class="box-body table-responsive no-padding">
                            <table class="table table-hover">
                                <tr>
                                    <th>ID</th>
                                    <th>消息详情</th>
                                    <th>创建时间</th>
                                    <th>提示时间段</th>
                                    <th>状态</th>
                                    <th>操作</th>
                                </tr>
                                {% if data['data'] is not empty %}
                                {% for index, val in data['data'] %}
                                <tr>
                                    <td>{{ val['id'] }}</td>
                                    <td title="{{ val['content']|e }}" id="{{val['id']}}_con">
                                        <?php echo mb_substr($val['content'],0,400,'utf-8'); ?>
                                    </td>
                                    <td>{% if val['create_time'] is not empty %}{{ date('Y-m-d H:i:s',val['create_time']) }}{% endif %}</td>
                                    <td><span id="{{val['id']}}_st">{{ date('Y-m-d H:i:s',val['start_time']) }}</span><br/>-<span id="{{val['id']}}_et">{{ date('Y-m-d H:i:s',val['end_time']) }}</span></td>
                                    <td>
                                        {% if val['status'] == '1' %}
                                            <!--<span class="label label-info">上线</span>-->
                                            {% if val['start_time'] > nowtime %}
                                                <span class="label label-default">未提示</span>
                                            {% else %}
                                                <span class="label label-success">完成</span>
                                            {% endif %}
                                        {% else %}
                                            <span class="label label-default">下线</span>
                                        {% endif %}
                                    </td>
                                    <td>
                                        {% if val['status'] == '1' %}
                                        <button class="btn btn-default btn-xs edit_" data-id="{{val['id']}}">修改</button>
                                        <button class="btn btn-warning btn-xs change_status " data-id="{{val['id']}}" data-status="{{ val['status'] }}">删除</button>{% endif %}
                                    </td>
                                </tr>
                                {% endfor %}
                                {% endif %}
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
                <h4 class="modal-title">新建系统提示消息</h4><small>创建广告主后台系统提示信息，根据提示的时间段来做显示，对所有广告主即时生效。</small>
            </div>
            <div class="modal-body">
                <form id="form_add" action="/manage/Index/message" method="POST">
                    <table class="table table-bordered">
                        <tbody>
                        <tr>
                            <td>消息正文</td>
                            <td>
                                <textarea class="form-control" id="content_" name="content"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td>提示时间段</td>
                            <td>
                                <input name="start_time" readonly id="start_time" type="datetime" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" class="form-control Wdate" placeholder="">
                                到
                                <input name="end_time" readonly id="end_time" type="datetime" onClick="WdatePicker({minDate:'#F{$dp.$D(\'start_time\')}',dateFmt:'yyyy-MM-dd HH:mm:ss'})" class="form-control Wdate" placeholder="">
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="_sub_">提交</button>
            </div>
        </div>
    </div>
</div>

<div id="modal-editPage" class="modal fade modal-form">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">修改系统提示消息</h4><small>修改广告主后台系统提示信息，根据提示的时间段来做显示，对所有广告主即时生效。</small>
            </div>
            <div class="modal-body">
                <form id="form_edit" action="/manage/Index/message" method="POST">
                    <table class="table table-bordered">
                        <tbody>
                        <tr>
                            <td>消息正文
                                <input type="hidden" name="id" id="id_e">
                                <input type="hidden" name="ac" value="modify">
                            </td>
                            <td>
                                <textarea class="form-control" id="content_e" name="content"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td>提示时间段</td>
                            <td>
                                <input name="start_time" readonly id="start_time_e" type="datetime" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" class="form-control Wdate" placeholder="">
                                到
                                <input name="end_time" readonly id="end_time_e" type="datetime" onClick="WdatePicker({minDate:'#F{$dp.$D(\'start_time\')}',dateFmt:'yyyy-MM-dd HH:mm:ss'})" class="form-control Wdate" placeholder="">
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="_sub_e">提交</button>
            </div>
        </div>
    </div>
</div>
{{ partial('common/footer') }}
<script src="/plugins/my97DatePicker/WdatePicker.js"></script>
<script>
    var do_ = {
        init: function () {
            $(function () {

                $("#_sub_").click(function () {

                    if (!$('#content_').val() || !$('#start_time').val() || !$('#end_time').val()) {
                        alert('请填入完整信息');
                        return false;
                    }

                    var query = $("#form_add").serialize();
                    var url = $("#form_add").attr("action");
                    ajaxDev(url, query, '');
                });

                $('.change_status').click(function () {
                    if (!confirm('确定删除?')) {
                        return false;
                    }
                    var cho = $(this);
                    $.post({
                        url: '/manage/Index/message',
                        data: {ac: 'up_status', id: cho.data('id'), status: cho.data('status')},
                        dataType: 'json'
                    }).done(function (data) {
                        if (data.code == 200) {
                            alert(data.msg);
                            window.location.reload();
                        } else {
                            alert(data.msg);
                        }
                    });

                });

                $('.edit_').click(function () {
                    $('#form_edit')[0].reset();
                    var cho = $(this);
                    var id_ = cho.data('id');
                    $('#id_e').val(id_);
                    $('#content_e').val($('#' + id_ + '_con').prop('title'));
                    $('#start_time_e').val($('#' + id_ + '_st').html());
                    $('#end_time_e').val($('#' + id_ + '_et').html());
                    $('#modal-editPage').modal('show')
                });

                $("#_sub_e").click(function () {
                    if (!$('#content_e').val() || !$('#start_time_e').val() || !$('#end_time_e').val()) {
                        alert('请填入完整信息');
                        return false;
                    }

                    var query = $("#form_edit").serialize();
                    var url = $("#form_edit").attr("action");
                    ajaxDev(url, query, '');
                });
            });
        }
    };

    do_.init();
</script>
</body>
</html>