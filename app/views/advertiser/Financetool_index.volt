{{ partial('common/header') }}
<link rel="stylesheet" href="/plugins/iCheck/all.css">
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
                财务信息
                <small>财务工具</small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
                <li><a href="/Financetool">财务工具</a></li>
                <li class="active">财务信息</li>
            </ol>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <div class="box">
                        <div class="box-body table-responsive no-padding">
                            <div class="panel panel-primary">
                                <div class="panel-heading">
                                    <h3 class="panel-title">账户信息</h3>
                                </div>
                                <div class="panel-body">
                                    <div class="form-group">
                                        <b> 账户余额：</b>{{account}}
                                    </div>
                                    <div class="form-group">
                                        <b> 今天消耗：</b>{{ count_today }}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-xs-12">
                    <div class="box">
                        <div class="box-body table-responsive no-padding">
                            <div class="panel panel-primary">
                                <div class="panel-heading">
                                    <h3 class="panel-title">账户充值</h3>
                                </div>
                                <div class="panel-body">
                                    <div class="callout callout-info" style="border-color: #75b17f !important;background-color:#75b17f !important">
                                        <h4>Tip!</h4>
                                        <p>新账户首次充值金额至少为{{first_acount}}元。充值完成后,因余额不足自动下架的广告会重新投放,请关注</p>
                                    </div>
                                </div>

                                <div class="panel-body">
                                    <form class="form-horizontal" id="form_charge">

                                        <table class="table no-border">
                                            <colgroup>
                                                <col class="col-xs-1">
                                                <col class="col-xs-9">
                                            </colgroup>

                                            <tr>
                                                <td>
                                                     充值金额
                                                </td>
                                                <td>
                                                    {% for index,item in  charge_list%}
                                                    <label>
                                                        <input type="radio" name="r3" class="flat-red" value="{{item}}"
                                                               {{index==0 ? "checked" :""}}>{{item}}&emsp;
                                                    </label>
                                                    {% endfor %}
                                                    <div class="input-group">
                                                        <span class="input-group-addon">
                                                          <input type="radio" name="r3" class="flat-red" value="other">
                                                        </span>
                                                        <input type="text" class="form-control" id="other_m"
                                                               onchange="do_.check_money(this)"
                                                               placeholder="其他金额,最低充值金额为{{min_acount}}">
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                     充值方式
                                                </td>
                                                <td>
                                                    <label>
                                                        <input type="radio" name="paytye" class="flat-red" checked
                                                               value="0">支付宝&emsp;
                                                    </label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                </td>
                                                <td>
                                                    <button type="button" class="btn btn-success" id="pay_confirm"><i
                                                            class="fa fa-credit-card"></i>
                                                        确认充值
                                                    </button>
                                                </td>
                                            </tr>

                                        </table>

                                        <!-- /.box-body -->
                                    </form>
                                </div>
                            </div>
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
<div class="modal modal-info fade" id="modal-info">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">温馨提示</h4>
            </div>
            <div class="modal-body">
                <p>请您在新打开的页面完成支付！</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline  pull-left" id="pay_success">支付成功</button>
                <button type="button" class="btn btn-outline" data-dismiss="modal">支付失败,重新支付</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
<!-- /.modal -->

{{ partial('common/footer') }}
<script src="/plugins/iCheck/icheck.min.js"></script>
<script>
    var do_ = {
        min_money:{{ min_acount }},
        check_money: function () {
            var numb = $('#other_m').val();
            if (isNaN(numb) || parseFloat(numb) < this.min_money) {
                var waring_str = isNaN(numb) ? "请填写正确的充值金额格式" : "充值金额小于最低充值金额";
                $('#modal-warning .modal-body p').html(waring_str)
                $('#modal-warning').modal('show');
                $('#other_m').val(this.min_acount);
                return false;
            }
        },
        newWin :function(url, id) {
            var a = document.createElement('a');
            a.setAttribute('href', url);
            a.setAttribute('target', '_blank');
            a.setAttribute('id', id);
            // 防止反复添加
            if(!document.getElementById(id)) {
                document.body.appendChild(a);
            }
            a.click();
        }
    };
    $(function () {

        $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
            checkboxClass: 'icheckbox_flat-green',
            radioClass: 'iradio_flat-green'
        });


        $('#pay_confirm').click(function () {
            var numb = $("input[name='r3']:checked").val();
            if (numb == 'other') {
                numb = $("#other_m").val();
            }
            if (isNaN(numb) || parseFloat(numb) < do_.min_money) {
                $('#modal-warning').modal('show');
                $('#other_m').val(do_.min_money);
                return false;
            }
            do_.newWin('/Financetool/pay_link?money=' + numb + '&pay_type=' + $("input[name='paytye']:checked").val(),'linke_pay_href');
            $('#modal-info').modal('show');
        });

        $('#pay_success').click(function () {
            window.location.reload();
        })

    });
</script>
</body>
</html>