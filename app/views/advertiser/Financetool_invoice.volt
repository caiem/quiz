{{ partial('common/header') }}
<link rel="stylesheet" href="/plugins/iCheck/all.css">
<link rel="stylesheet" href="/plugins/bootstrap-select/bootstrap-select.min.css">
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
                发票开具
                <small>财务工具</small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
                <li><a href="/Financetool">财务工具</a></li>
                <li class="active">发票开具</li>
            </ol>
        </section>

        <!-- Main content -->
        <section class="content">

            <div class="row">
                <div class="col-xs-12">
                    <div class="box">
                        <!-- /.box-header -->
                        <div class="box-body table-responsive no-padding">
                            <table class="table table-hover">
                                <tr>
                                    <th>申请时间</th>
                                    <th>发票项目</th>
                                    <th>申请金额（元）</th>
                                    <th>备注</th>
                                    <th>状态</th>
                                    <th>操作</th>
                                </tr>
                                {% for index, item in List %}
                                <tr>
                                    <td>{% if item['created'] is not empty %}{{ date('Y-m-d H:i:s',item['created']) }}{%
                                        endif %}
                                    </td>
                                    <td>{{ item_list[item['item']] }}</td>
                                    <td>{{ item['amount'] }}</td>
                                    <td>{%if item['mark'] is not empty%}{{item['status']==2?'发票凭证：':(item['status']==-1?'不通过理由：':'')}}{{ item['mark'] }}{% endif %}</td>
                                    <td>{{ invoice_status[item['status']] }}</td>
                                    <td>
                                        {% if item['status'] is empty %}
                                        <!--<button class="btn btn-default btn-xs cancel_" data-id="{{item['id']}}">取消</button>-->
                                        {% endif %}
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

            <div class="row">
                <div class="col-xs-12">
                    <div class="box">
                        <div class="box-body no-padding">
                            <div class="panel panel-primary">
                                <div class="panel-heading">
                                    <h3 class="panel-title">发票申请</h3>
                                </div>

                                <div class="panel-body">
                                    {% if !is_cert %}
                                    <div style="padding:20px;background-color: #FFFFD7">您未上传“一般纳税人证书，无法申请”增值税专票“。如需申请，请补充上传： <a href="javascrip::void();" data-target="#modal-editDoc" data-toggle="modal">点击补充上传</a></div>
                                    {% endif %}
                                    <form id="sub_form" class="form-inline" action="/Financetool/invoice"
                                          enctype="multipart/form-data" onsubmit="return do_.checkform();" role="form"
                                          method="post">
                                        <table class="table no-border" style="margin-left:30px">
                                            <colgroup>
                                                <col class="col-xs-1">
                                                <col class="col-xs-9">
                                            </colgroup>
                                            <tr>
                                                <td>
                                                    <span class="input_require">发票类型</span>
                                                </td>
                                                <td>
                                                    {% for k,v in invoice_type %}
                                                    {% if k!=1 OR is_cert %}
                                                    <label>
                                                        <input onchange="do_.changeType({{ k }})" type="radio" name="type" class="flat-red" value="{{ k }}"
                                                               {% if k==2 %}
                                                               checked
                                                               {% endif %}
                                                        >{{ v }}&emsp;
                                                    </label>
                                                    {% endif %}
                                                    {% endfor %}
                                                    <i data-toggle="tooltip" title="普票默认为电子发票形式"
                                                       class="fa fa-fw fa-question-circle"></i>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="input_require">发票抬头</span>
                                                </td>
                                                <td>
                                                    <label>
                                                        {{ formData['title'] }}
                                                    </label>
                                                    <i data-toggle="tooltip"
                                                       title="发票抬头要求跟营业执照和汇款账户一致，默认填写开户的企业账号。如需修改，请重新填写开户申请"
                                                       class="fa fa-fw fa-question-circle"></i>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="input_require">发票项目</span>
                                                </td>
                                                <td>
                                                    <label>
                                                        <span>{{ formData['item_list'] }}</span>
                                                    </label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="input_require">发票金额</span>
                                                </td>
                                                <td>
                                                    <div class="col-xs-5" style="padding-left: 0;">
                                                        <input name="money_select" type="hidden" id="money_select_hi">
                                                        <select class="form-control" id="money_select"
                                                                multiple="multiple">
                                                            {% if charge_list %}
                                                            {% for key,val in charge_list %}
                                                            <option value="{{ key }}">{{ val }}</option>
                                                            {% endfor %}
                                                            {% endif %}
                                                        </select>
                                                    </div>
                                                    &emsp;<i data-toggle="tooltip"
                                                             title="可申请的发票金额为 = 已消耗未开票的充值金额，如有多个已消耗未开票的充值金额，可合并开一张票。当前勾选总共最大值不能超过{{ left }}。"
                                                             class="fa fa-fw fa-question-circle"></i>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="input_require">纳税人识别号</span>
                                                </td>
                                                <td>
                                                    <label>
                                                        <input type="text" class="form-control"  placeholder="请输入纳税人识别号" required name="identify" id="identify" value="{{ formData['identify'] }}">
                                                    </label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="input_require">邮寄信息</span>
                                                </td>
                                                <td>
                                                    <p class="help-block">(发票接收地址,请保证准确性)</p>
                                                    <p>收件人姓名:
                                                    <input type="text" class="form-control" name="name" value="{{ formData['name'] }}" required id="name" >
                                                    &emsp;&emsp;收件人电话:
                                                    <input type="text" name="phone" class="form-control" value="{{ formData['phone'] }}" required id="phone">
                                                    </p>
                                                        收件地址:
                                                    <input type="text" name="address"  class="form-control " size="100" value="{{ formData['address'] }}" required id="address">
                                                </td>
                                            </tr>
                                            <tr class="p_tax">
                                                <td>
                                                    <span class="input_require">税务备案电话</span>
                                                </td>
                                                <td>
                                                    <label>
                                                        <input type="text" class="form-control"  placeholder="请输入税务备案电话" name="tax_phone" id="tax_phone" value="{{ formData['tax_phone'] is empty ? '' : formData['tax_phone'] }}">
                                                    </label>
                                                </td>
                                            </tr>
                                            <tr class="p_tax">
                                                <td>
                                                    <span class="input_require">税务备案地址</span>
                                                </td>
                                                <td>
                                                    <label>
                                                        <input type="text" class="form-control" size="100" placeholder="请输入税务备案地址" name="tax_addr" id="tax_addr" value="{{ formData['tax_addr'] is empty ? '' : formData['tax_addr']}}">
                                                    </label>
                                                </td>
                                            </tr>
                                            <tr class="p_tax">
                                                <td>
                                                    <span class="input_require">开户行</span>
                                                </td>
                                                <td>
                                                    <label>
                                                        <input type="text" class="form-control" size="100" placeholder="请输入开户行" name="bank" id="bank" value="{{ formData['bank'] is empty ? '' : formData['bank']}}">
                                                    </label>
                                                </td>
                                            </tr>
                                            <tr class="p_tax">
                                                <td>
                                                    <span class="input_require">开户账号</span>
                                                </td>
                                                <td>
                                                    <label>
                                                        <input type="text" class="form-control" size="100" placeholder="请输入开户账号" name="bank_no" id="bank_no" value="{{ formData['bank_no'] is empty ? '' : formData['bank_no']}}">
                                                    </label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="input_require">开票资料</span>
                                                </td>
                                                <td>
                                                    <div class="col-sm-12" >(请根据 <a target="_blank" href="/Financetool/document">开票资料模板</a> 来填写，并加盖公章后拍照上传。已经上传过的，可以直接使用。)&emsp;
                                                    </div>
                                                    <div class="col-sm-4" style="padding-left: 0;">
                                                        <input class="form-control" id="pic_up" data-toggle="tooltip"
                                                               title="图片格式仅限jpg,jpeg,png" type="file" name="pic">
                                                    </div>
                                                    {% if formData['pic'] is not empty %}
                                                    <div class="col-sm-1">
                                                         或者
                                                         </div>
                                                    <div class="col-sm-7" style="padding-left: 0;">
                                                       <input type="checkbox" name="use_old_pic" id="use_old_pic" value="1">
                                                        &emsp;<a href="{{ formData['pic'] }}" target="_blank"><img id="show_pic" src="{{ formData['pic'] }}" width="60" height="60"></a>
                                                    </div>
                                                    {% endif %}
                                                </td>
                                            </tr>
                                            <tr>
                                                <td></td>
                                                <td>
                                                    <button type="submit" class="btn btn-success" id="confirm">
                                                        提交申请
                                                    </button>
                                                </td>
                                            </tr>
                                        </table>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /.content -->
        </section>
        <!-- /.content-wrapper -->
    </div>
    {{ partial('common/copyright') }}

    <!-- ./wrapper -->
</div>
<div class="modal modal-warning fade" id="modal-warning">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">提醒</h4>
            </div>
            <div class="modal-body">
                <p>请填写充值金额正确格式</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-dismiss="modal">关闭</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
<div id="modal-editDoc" class="modal fade modal-form">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title">补充上传</h4>
        <small>补充上传一般纳税人证明</small>
      </div>
      <div class="modal-body">
        <form id="form_editdoc" action="/Financetool/addfile" method="POST">
            <div class="form-group">
                <label for="edit_file">一般纳税人证明:</label>
                <input id="edit_file" type="file" name="file" class="form-control">
            </div>
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
<script src="/plugins/iCheck/icheck.min.js"></script>
<script src="/plugins/bootstrap-select/bootstrap-select.min.js"></script>
<script>
    var do_ = {
        max_money:{{ left }},
        list_json:$.parseJSON('{{ charge_list_json }}'),
        checkform: function () {
            if(this.max_money<=0){
                alert('当前可开发票金额为零!');
                return false;
            }

            var mon= $('#money_select').val();
            if(!mon){
                alert('请勾选金额');
                return false;
            }
            var val = $('input:radio[name="type"]:checked').val();
            if (val == null) {
                alert("请勾选发票类型!");
                return false;
            }
            if(!$('#name').val()||!$('#identify').val()||!$('#phone').val() || !$('#address').val()){
                alert('请填写完整地址信息');
                return false;
            }
            if( val==1 && (!$('#tax_phone').val()||!$('#tax_addr').val()||!$('#bank').val() || !$('#bank_no').val())){
                alert('请填写税务备案信息');
                return false;
            }
            var money=0;
            for(var i in mon){
                money += this.list_json[mon[i]]*10000;
            }
            if ((money / 10000) > this.max_money) {
                alert('合计勾选不能超过最大金额'+this.max_money);
                return false;
            }
            $('#money_select_hi').val(mon.join(','));

            if ($('#use_old_pic').prop('checked')) {
                return true;
            } else if ($("#pic_up").val() != null && $("#pic_up").val() != '' && $("#pic_up").val()) {
                return true;
            }
            alert('请添加资料模板图片');
            return false;
        },
        changeType:function(type){
            if( type && type==1 ){
                $('.p_tax').css({"display":""});
            }else{
                $('.p_tax').css({"display":"none"});
            }
        }
    };
    $(function () {
        do_.changeType($('input:radio[name="type"]:checked').val())
        $('#money_select').selectpicker({
            noneSelectedText: '请选择'
        });

        $('#use_old_pic').change(function () {
            if ($(this).prop('checked')) {
                var ie = (navigator.appVersion.indexOf("MSIE")!=-1);
                if( ie ){
                    var file = $("#pic_up");
                    file.after(file.clone().val(""));
                    file.remove();
                }else{
                    $("#pic_up").val("");
                }
            }
        });

        $('.cancel_').click(function () {
            if (!confirm('确定取消申请发票?')) {
                return false;
            }
            var cho = $(this);
            $.post({
                url: '/Financetool/cancel_invoice',
                data: {id: cho.data('id')},
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
        $("#modal-editDoc .btn-primary").click(function () {
            $("#form_editdoc").ajaxSubmit({dataType:'json',success:function( data ){
                alert(data.msg);
                if (data.code == 200) {
                    window.location.reload();
                }
            }});
        });
    });
</script>
</body>
</html>