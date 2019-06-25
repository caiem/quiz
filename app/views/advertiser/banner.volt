{{ partial('common/header') }}
<link href="/css/img.css?v=1.1" rel="stylesheet" type="text/css">
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
        投放素材上传
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">main</a></li>
        <li class="active">投放素材上传</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">
        <div class="row">
            <div class="col-xs-12">
                <div class="box">
                    <div class="box-body table-responsive no-padding">
                        <form class="form-horizontal" method="post" action="/Advertise/source" enctype="multipart/form-data" id="form_post">
                          <!-- 投放素材上传 -->
                          <div class="panel panel-primary">
                            <div class="panel-body">
                                <div class="form-group" style="padding-top:20px">
                                    <label class="col-sm-2 control-label" for="formGroupInputLarge">广告链接：</label>
                                    <div class="col-sm-6">
                                        <input class="form-control" data-toggle="tooltip" title="建议使用https" type="text" name="link" value="{{source['link']|default('')}}">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="formGroupInputLarge">广告素材：</label>
                                    <div class="col-sm-6">
                                        <div class="upload-list">
                                            <span class="tag">点击添加</span>
                                            <input name="pic" type="file" update="" class="upload-btn J-upload" accept="image/gif,image/jpeg,image/jpg,image/png">
                                            <img class="upload-pics" src="{{source['pic']|default('')}}">
                                            <label>（创意格式要求：必传，{{image_size}}）</label>
                                            <div class="mask J-picMask"><div class="delete J-picDelete"></div></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="formGroupInputLarge">第三方监控链接：</label>
                                    <div class="col-sm-6">
                                        <input class="form-control" type="text" name="click_monitor_link" value="{{click_monitor_link|default('')}}">
                                    </div>
                                </div>
                                <input type="hidden" name="id" value="{{ad_id}}">
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="formGroupInputLarge"></label>
                                    <div class="col-sm-6">
                                        <input type="submit" class="btn btn-primary setting" value="提交"/>
                                        <a url="/Advertise/update?id={{ad_id}}" class="btn btn-primary leavePage" >返回上一步</a>
                                        <a url="/Advertise/index" class="btn btn-primary leavePage" >返回列表</a>
                                    </div>
                                </div>
                            </div>
                          </div>
                          <!-- 投放素材上传 -->
                        </form>
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
<script src="/plugins/auxiliary/auxiliary.min.js"></script>
<script src="/plugins/exif/exif.min.js"></script>
    <script>
        $(function(){
            $('form').on('change','input,select',function(){
                $('.leavePage').data('content',1);
            });
            $('.leavePage').click(function(){
                if( $(this).data('content')==1 && confirm('是否保存当前修改？')){
                    $(".setting").click();
                }else{
                    window.location.href = $(this).attr('url');
                }
            });
            $(".J-upload").on("change", function(event) {
                var file = event.target.files[0],
                        _this = this;
                if (!/\/(?:jpeg|png|jpg)/i.test(file.type)) return;
                //压缩和旋转图片
                compress(file, {
                        maxWidth: 800,
                        maxHeight: 800,
                        quality: .6,
                        type: 'jpeg'
                }, function(dataUrl) {
                        $(_this)
                                .next().attr("src", dataUrl)
                                .siblings('.J-picMask').show()
                                .parent().removeClass('error');

                        $("#picTips").text("");
                })
            });
        })
    </script>
    </body>
</html>