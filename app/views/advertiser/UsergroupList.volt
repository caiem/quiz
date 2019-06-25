{{ partial('common/header') }}
<style>
.show_more{
    display:none;
    color:#333;
}
.desc{
    word-break: break-all;
    word-wrap:break-word;
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
        <small></small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li class="active">用户分组</li>
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
                      <label>用户分组名:</label>
                      <input name="name" type="text" value="{{searchItem['name']|default('')}}" class="form-control"  placeholder="请输入用户分组名">
                    </div>
                    <input type="submit" class="btn btn-info" value="查询"/>
                    {% if AGENT_OR_SUB !=3 %}
                    <div style="padding:0px 20px;float:right">
                        <span style="float:right;margin:0 10px"><a href="/Usergroup/add" class="btn btn-info">新增</a></span>
                    </div>
                    {% endif %}
                </form>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover">
                <tr>
                  <th>用户分组名</th>
                  <th width="560">分组条件</th>
                  <th>创建时间</th>
                  <th>修改时间</th>
                  <th>操作</th>
                </tr>
                {% for index, item in usergroupList %}
                <tr>
                  <td><a href="/Usergroup/update?id={{item['id']}}">{{ item['name'] }}</a></td>
                  <td class="desc">{{item['condition']}}</td>
                  <td>{{ date('Y-m-d H:i:s',item['created']) }}</td>
                  <td>{{ date('Y-m-d H:i:s',item['updated']) }}</td>
                  <td>
                    <button class="btn btn-xs btn-warning text-fill viewAds" url="/Usergroup/viewads?id={{item['id']}}">查看关联广告</button>
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
<div id="modal-viewAds" class="modal fade modal-form">
  <div class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4 class="modal-title">查看关联广告</h4>
        </div>
        <div class="modal-body">
            <div id="noticeAD">暂无关联广告...</div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal"> 关闭  </button>
        </div>
    </div>
  </div>
</div>
<!-- ./wrapper -->
    {{ partial('common/footer') }}
    <script>
    $(function(){
        $('.viewAds').click(function(){
            var url = $(this).attr('url')
            $.getJSON(url,function(data){
               if( data.code=='200' && data.result ){
                   var table = "<table class=\"table\"><tr><th>广告ID</th><th>广告名称</th><th>广告状态</th><th>创建时间</th></tr>";
                   for( var i in data.result){
                        table += "<tr><td>"+ data.result[i].ad_id +"</td><td>"+ 
                                 data.result[i].ad_name +"</td><td>"+ data.result[i].status +
                                 "</td><td>"+ data.result[i].created +"</td></tr>";
                   }
                   table += "</table>";
                   $('#noticeAD').html( table );
               }else{
                   $('#noticeAD').html('暂无关联广告...');
               }
               $('#modal-viewAds').modal('show');
            });
        });
        $('.more').click(function(){
            $(this).children('.show_more').toggle();
        });
    })
    </script>
    </body>
</html>