{{ partial('common/header') }}
<link rel="stylesheet" href="/plugins/select2/select2.min.css">
<style>
pre{
    border:none;
    background:none;
    padding:0px;
    white-space:pre-wrap;
    word-wrap: break-word;
}
</style>
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
        开户详情
        <small>开户审核</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">用户管理</a></li>
        <li><a href="#">开户审核</a></li>
        <li class="active">开户详情</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">

      <div class="row">
        <div class="col-xs-12">
            <div class="box">
                <div class="box-header">
                    <h3 class="box-title">账号基本信息</h3>
                </div>
                <div class="box-body">
                    <table class="table table-hover">
                        <tr><td>账户类型: <b>{{Account['utype_str']}}</b></td><td>开户类型: <b>{{Account['type']}}</b></td></tr>
                        <tr><td colspan="2">企业名称: <b>{{Account['name']}}</b></td></tr>
                        <tr><td colspan="2">对公银行卡号/支付宝: <b>{{Account['bank_no']}}</b></td></tr>
                        <tr><td>合作联系人: <b>{{Account['contact']}}</b></td><td>联系人地址: <b>{{Account['address']}}</b></td></tr>
                        <tr><td>联系人手机: <b>{{Account['phone']}}</b></td><td>联系人邮箱: <b>{{Account['email']}}</b></td></tr>
                    </table>
                </div>
            </div>
            <div class="box">
                <div class="box-header">
                    <h3 class="box-title">企业资质文件</h3>
                </div>
                <div class="box-body">
                    <table class="table table-hover">
                        <tr><td colspan="2">推广项目: <b>{{Account['item']}}</b></td></tr>
                        <tr><td colspan="2">推广网址: <b>{{Account['site']}}</b></td></tr>
                        <tr><td colspan="2">资质文件:  <small>（审核提示： 三证合一企业需要：营业执照、开户许可证、一般纳税人证明； 非三证合一企业需要：营业执照、税务登记证、组织机构代码证、开户许可证、一般纳税人证明）</small></td></tr>
                        <tr><td colspan="2">
                            {% for index,file in Account['files'] %}
                                {% if index AND index == "zip" %}
                                <a><a href="/upload/{{file}}" download="资质文件">点击下载附件</a>
                                {% else %}
                                <a data-fancybox="gallery{{Account['user_id']}}" class="viewImg" href="/upload/{{file}}"><img style="max-height:100px;max-width:100px;padding-right:10px" src ="/upload/{{file}}"/></a>
                                {% endif %}
                            {% endfor %}
                        </td></tr>
                    </table>
                </div>
            </div>
            <div class="box">
                <div class="box-header">
                    <h3 class="box-title">{{Account['utype'] !=0 ? "代投信息":"行业资质文件"}}</h3>
                </div>
                <div class="box-body">
                    {% if Qualifys is not empty %}
                    {% for Qualify in Qualifys %}
                    <table class="table">
                        <tr>
                            {% if Account['utype'] !=0 %}
                                <td>代投企业名称: <b>{{Qualify['company']}}</b></td>
                            {% else %}
                                <td>一级行业: <b>{{Qualify['pri_industry']}}</b></td>
                            {% endif %}
                            <td width="480" rowspan="{{Account['utype'] !=0 ? 6 : 5 }}">
                            <div>
                                <h4>对应行业所需行业资质说明: </h4>
                                {% if Account['utype'] !=0 %}
                                    <div>代投企业基本资质文件: 
                                        <p><strong class="red"><ol><li>营业执照</li><li>授权代理证明</li></ol></strong></p>
                                    </div>
                                {% endif %}
                                <div>基础必须行业资质文件: 
                                    <p><pre><strong class="red">{{Qualify['qualify_file_str']}}</strong></pre></p>
                                </div>
                                <div>特殊业务需补充: 
                                    <p><strong class="red">
                                        <ol>
                                        {% for key,item in Qualify['special_business']%}
                                            <li>{{item}}</li>
                                        {% endfor %}
                                        </ol></strong>
                                    </p>
                                </div>
                                <div>准入规则: <strong class="red">{{Qualify['access_rule']}}</strong></div>
                            </div>
                            </td>
                        </tr>
                        {% if Account['utype'] !=0 %}
                            <tr><td>一级行业: <b>{{Qualify['pri_industry']}}</b></td></tr>
                        {% endif %}
                        <tr><td>二级行业: <b>{{Qualify['sub_industry']}}</b></td></tr>
                        <tr><td>涉及特殊业务范围: <b>
                            <ol>
                            {% for key,item in Qualify['special_business']%}
                                <li>{{key}}</li>
                            {% endfor %}
                            </ol>
                            </b></td></tr>
                        <tr><td>行业资质文件: </td></tr>
                        <tr><td>
                            {% for index,file in Qualify['qualify_file'] %}
                                {% if index AND index is "zip" %}
                                <a><a href="/upload/{{file}}" download="资质文件">点击下载附件</a>
                                {% else %}
                                <a data-fancybox="gallery{{Account['user_id']}}" class="viewImg" href="/upload/{{file}}"><img style="max-height:100px;max-width:100px;padding-right:10px" src ="/upload/{{file}}"/></a>
                                {% endif %}
                            {% endfor %}
                        </td></tr>
                    </table>
                    {% endfor %}
                    {% else %}
                        待补充
                    {% endif %}
                </div>
            </div>
            <form action="/manage/User/audit" method="POST" class="form-inline auditAccount" role="form">
                <div class="form-group">
                  <select name="val" class="form-control">
                    <option value="">选择操作</option>
                    <option value="1">审核通过</option>
                    <option value="2">审核不通过</option>
                  </select>
                  <select data-toggle="tooltip" title="选择销售人员" name="saler" class="form-control select2">
                    <option value="">选择销售人员</option>
                    {% for index,saler in Salers %}
                        <option value="{{index}}">{{saler}}</option>
                    {% endfor %}
                  </select>
                  <input name="reason" class="form-control" size="80" placeholder="请输入审核不通过理由">
                </div>
                <input id="audit_uid" name="uid" type="hidden" class="form-control" value="{{Account['user_id']}}"/>
                <button type="button" class="btn btn-primary"/>审核</button>
            </form>
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
<script type="text/javascript" src="/plugins/fancybox/jquery.fancybox.min.js"></script>
<script src="/plugins/select2/select2.full.min.js"></script>
<script>
    $(function(){
        $(".select2").select2();
        $('.viewImg').fancybox();
        $(".auditAccount .btn-primary").click(function(){
            var form = $(".auditAccount");
            var opt = form.find('select').val();
            var reason = form.find('input[name=reason]').val();
            if( !opt || opt=='' ){
                alert('请选择操作项');
                return;
            }
            if(opt==2 && reason==''){
                alert('请输入审核不通过原因');
                return;
            }
            var query = $(".auditAccount").serialize();
            var url = $(".auditAccount").attr("action");
            $.post({
                url: url,
                data: query,
                dataType: 'json'
            }).done(function (data) {
                alert(data.msg);
                if (data.code == 200) {
                  window.location.href="/manage/User/auditlist";
                }
            });
        });
    })
</script>
</body>
</html>