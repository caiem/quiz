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
        代投企业账户
        <small></small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li class="active">代投企业账户</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">
        <div class="row">
        <div class="col-xs-12">
          <div class="box">
            <form onsubmit="return check();" class="form-horizontal" method="POST">
            <!-- /.box-header -->
            <div class="box-body" style="background-color:#FFFFD7">
                <h4>操作说明：</h4>
                <p>1、请为代投企业分配投放总额（若为多次充值请直接叠加）、设置登录账号</p>
                <p>2、设置了账号密码后方可登录；设置了投放总额后，页面才计算和显示投放余额。</p>
                <p>3、代投企业登录后台尽可查看数据，不可投放或修改。登录地址：http://ad.service.mama.cn</p>
            </div>
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover">
                <tr>
                  <th>代投企业名称</th>
                  <th>投放总额</th>
                  <th>投放消耗</th>
                  <th>投放余额</th>
                  <th>代投企业账号名</th>
                  <th>代投企业密码</th>
                </tr>
                {% set sum =0 %}
                {% for index, item in List %}
                {% set sum += item['total']|default(0) %}
                <tr>
                  <td>
                        {{ item['realname'] }}
                        <input type="hidden" name="data[{{index}}][uid]" value="{{ item['user_id']|default(0) }}">
                        <input type="hidden" name="data[{{index}}][name]" value="{{ item['realname'] }}">
                        <input type="hidden" name="data[{{index}}][qid]" value="{{ item['qid'] }}">
                  </td>
                  <td class="edit_total"><input class="form-control" name="data[{{index}}][total]" value="{{item['total']|default('')}}"></td>
                  <td class="edit_expend">{{ item['expend']|default('0') }}</td>
                  <td class="edit_rest">{{ item['total'] is not empty and item['total'] is not empty and item['total']> item['expend']? item['total'] - item['expend'] : '-' }}</td>
                  <td><input class="form-control" name="data[{{index}}][uname]" value="{{ item['username']|default('') }}" placeholder="输入登录用户名"></td>
                  <td><input class="form-control" name="data[{{index}}][pwd]" placeholder="{{item['password'] is not empty ? '重新输入可修改登录密码' : '输入登录密码'}}"></td>
                </tr>
                {% endfor %}
                <tr style="color:red"><td class="edit_totals"><label data-toggle="tooltip" title="累计账户总额 = 累计充值金额 + 累计赠送金额">累计账户总金额：</label><span>{{Totals}}</span></td><td class="edit_sum"><label>投放总额之和：</label><span>{{sum|default(0)}}</span></td><td colspan="4"></td></tr>
              </table>
            </div>
            <!-- /.box-body -->
            <div class="box-footer clearfix">
                <input class="btn btn-primary" type="submit" value="保存">
            </div>
            </form>
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
    $(function(){
        $('.edit_total input').change(function(){
            var total = parseFloat( $(this).val() );
            var expend = parseFloat( $(this).closest('tr').find('.edit_expend').html() );
            var rest = 0;
            if(!isNaN(total) && !isNaN(expend)){
                rest = total - expend;
            }
            $(this).closest('tr').find('.edit_rest').html(rest|'-');
            var sum = 0;
            $('.edit_total input').each(function(){
                var total = parseFloat( $(this).val() );
                sum += isNaN(total) ? 0 : total;
            });
            $('.edit_sum span').html(sum);
            var total = parseFloat( $('.edit_totals span').html() );
            if(total < sum){
                alert('投放总额之和大于累计账户总额，请检查后重新设置');
            }
            
        })
    })
    function check(){
        var total = parseFloat( $('.edit_totals span').html() );
        var sum = parseFloat( $('.edit_sum span').html() );
        if(total < sum){
            alert('投放总额之和大于累计账户总额，请检查后重新设置');
            return false;
        }
        return true
    }
    </script>
    </body>
</html>