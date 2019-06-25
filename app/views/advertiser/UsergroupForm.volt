{{ partial('common/header') }}
<link rel="stylesheet" href="/plugins/select2/select2.min.css">
<style>
.tooltip-inner,.tooltip{
   max-width:600px;
}
</style>
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
        用户分组
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">main</a></li>
        <li class="active">用户分组</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">
        <div class="row">
            <div class="col-xs-12">
                <div class="box">
                    <div class="box-body no-padding">
                        <div class="panel panel-primary">
                            <div class="panel-heading">
                                <h3 class="panel-title">{{title}}用户分组</h3>
                            </div>
                            <div class="panel-body">
                                <form class="form-horizontal" method="post" action="/Usergroup/save" id="form_post">
                                    <div class="box no-margin">
                                        <div class="box-body">
                                            <div class="form-group">
                                                <label class="col-sm-1 control-label" style="width:auto"><span class="input_require">用户分组名</span>:</label>
                                                <div class="col-sm-6">
                                                    <input name="name" type="text" value="{{ugdata['name']|default('')}}" class="form-control"  placeholder="请输入用户分组名">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- 用户分组 -->
                                        {{ partial('advertiser/UsergroupFormPart') }}
                                    <!-- 用户分组 -->
                                    <div class="form-group">
                                        <input type="hidden" name="id" value="{{ugid|default('')}}">
                                        <label class="col-sm-1 control-label" for="formGroupInputLarge"></label>
                                        <div class="col-sm-6">
                                            <input type="submit" class="btn btn-primary" value="保存"/>
                                            <a href="/Usergroup" class="btn btn-primary">返回列表</a>
                                        </div>
                                    </div>
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
    {{ partial('common/footer') }}
    <script src="/plugins/select2/select2.full.min.js"></script>
    <script type="text/javascript" src="/plugins/cityselect/jquery.cityselect.js"></script>
    <script type="text/javascript" src="/js/advertiser/ugroup.js"></script>
    </body>
</html>