{{ partial('common/header') }}
<link rel="stylesheet" href="/plugins/select2/select2.min.css">
<style>
    #select_condition{
        background-color: #FFFFD7;//gold;
        height: 60px;
        width:1100px;
        text-align: center;
        margin: 0 auto;
        margin-bottom: 15px;
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
        新增广告
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">自助投放管理</a></li>
        <li class="active">新增广告</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">
        <div class="row">
            <div class="col-xs-12">
                <div class="box">
                    <div class="box-body no-padding">
                        <form class="form-horizontal" action="/Advertise/target?id={{adId}}" id="form_post">
                          <!-- 新增广告 -->
                          <div class="panel panel-primary">
                            <div class="panel-heading">
                                <h3 class="panel-title">用户定向设置</h3>
                            </div>
                            <div class="panel-body">
                                <div id="select_condition" class="{% if ugIndex==0%}hidden{% endif %}">已选条件：<span data-content="{{formatData|default('--')}}">{{formatData|default('--')}}</span>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-1 control-label input_require" style="width:auto" for="formGroupInputLarge">快捷定向:</label>
                                    <div class="col-sm-6">
                                        <select name="ugoup_select" id="ugoup-select" class="form-control">
                                            <option value="0" {% if ugIndex==0%}selected{% endif %}>全量用户</option>
                                            <option value="-1">不使用已有分组</option>
                                            {% for key,value in ugList %}
                                            <option value="{{value['id']}}" {% if ugIndex==value['id']%}selected{% endif %}>{{value['name']}}</option>
                                            {% endfor%}
                                        </select>
                                    </div>
                                    <div class="col-sm-4 notice_gray">可以直接选择使用已有的分组或重新创建</div>
                                </div>
                                <div id="edit-ugroup" class="{% if ugIndex==0%}hidden{% endif %}">
                                {{ partial('advertiser/UsergroupFormPart') }}
                                </div>
                                <div id="new_or_update"></div>
                                <div class="form-group group-name hidden">
                                    <label class="col-sm-1 control-label input_require" style="width:auto" for="formGroupInputLarge">分组名称:</label>
                                    <div class="col-sm-6">
                                        <input name="ugroup_name" type="text" class="form-control">
                                    </div>
                                    <div class="col-sm-4 notice_gray" style="line-height:20px">使用已有分组并修改了条件，将保存并创建为新分组；如不使用已有分组并选择了相关条件，将保存为新分组。</div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="formGroupInputLarge"></label>
                                    <div class="col-sm-6">
                                        {% if refer %}
                                        <a class="btn btn-primary leavePage" url="/Advertise/update?id={{adId}}">上一步</a>
                                        <a class="btn btn-primary setting">下一步</a>
                                        {% else %}
                                        <a class="btn btn-primary setting">确定</a>
                                        <a class="btn btn-primary leavePage" url="/Advertise/update?id={{adId}}">上一步</a>
                                        <a class="btn btn-primary leavePage" url="/Advertise/source?id={{adId}}">下一步</a>
                                        {% endif %}
                                        <a url="/Advertise/index" class="btn btn-primary leavePage" >返回列表</a>
                                    </div>
                                </div>
                            </div>
                          </div>
                          <!-- 新增广告 -->
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
<script src="/plugins/select2/select2.full.min.js"></script>
<script src="/plugins/my97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/plugins/cityselect/jquery.cityselect.js"></script>
<script type="text/javascript" src="/js/advertiser/ugroup.js"></script>
<script>
$(document).ready(function(){
  $(".setting").click(function(){
    var query = $("#form_post").serialize();
    var url = $("#form_post").attr("action");
    if(checkInput()){
        $.post({
              url: url,
              data: query,
              dataType: 'json'
            })
            .done(function (data) {
              if (data.code == 200) {
                {% if refer %}
                    window.location.href="/Advertise/source?id={{adId}}";
                {% else %}
                    window.location.reload();
                {% endif %}
              } else {
                alert(data.msg);
              }
            });
    }
  });
  $('#ugoup-select').change(function(){
    var id = $(this).val();
    if( id==0 ){
        $('#select_condition').addClass('hidden');
        $('#edit-ugroup').addClass('hidden');
        $('.group-name').addClass('hidden');
    }
    $.getJSON('/Advertise/gethtml?type={{Ugtype}}&id='+id,{},function(data){
        if (data.code == 200 && data.result) {
            $('#select_condition').removeClass('hidden');
            $('#edit-ugroup').removeClass('hidden');
            if( id>0 ){
                $('.group-name').addClass('hidden');
            }else{
                $('.group-name').removeClass('hidden');
            }
            $('#new_or_update').html('');
            $('#edit-ugroup').html(data.result.data);
            var select_form =$('#select_condition span');
            select_form.html(data.result.format);
            select_form.data('content',data.result.format)
            initUgroup();
        }
    });
  });
    var doc = $(document);
    $(window).scroll(function(){
        if(doc.scrollTop()>=100){
            $('#select_condition').css({"position":"fixed","top":"0px","z-index":10000});
        }else{
            $('#select_condition').css({"position":"relative"});
        }
    })
    $('form').on('change mousemove',"div,input[name!='new_or_update'],select",function(event){
        //console.log(event.type+':'+$(this).attr('name'));
        var str = "";
        var gender = [];
        $('.ugender input:checked').each(function(){
            gender.push( $(this).next('span').text() );
        });
        var babystatus = [];
        $('.babystatus input:checked').each(function(){
            babystatus.push($(this).next('span').text());
        });
        var zones = [];
        $('.zones').each(function(){
            var prov = $(this).find(".prov").val();
            var city = $(this).find(".city").val();
            if(prov){
                city = city ? '-'+city:'';
                zones.push(prov+city);
            }
        });
        var tags = [];
        $('.utags input:checked').each(function(){
            tags.push($(this).next('span').text());
        });
        var reg_time = [];
        $('.reg_time input:checked').each(function(){
            reg_time.push( $(this).next('span').text() );
        });
        var sites = [];
        $('.sites select').each(function(){
            sites.push($(this).val());
        });
        str += gender.length > 0 ? gender.join(',')+';':'';
        str += babystatus.length > 0 ? babystatus.join(',')+';':'';
        str += zones.length > 0 ? zones.join(',')+';':'';
        str += tags.length > 0 ? tags.join(',')+';':'';
        str += reg_time.length > 0 ? reg_time.join(',')+';':'';
        str += sites.length > 0 ? sites.join(',')+';':'';
        $('#select_condition span').html(str);
        var id = $('#ugoup-select').val();
        var name = $(this).attr('name');
        if(name!='new_or_update'){
            if( id > 0 && str != $('#select_condition span').data('content') ){
                $('#new_or_update').data('ischange',1);
                if($('#new_or_update').html() == ''){
                    $('#new_or_update').html('<div class="form-group">' +
                                        '<label class="col-sm-1 control-label input_require" style="width:auto" for="formGroupInputLarge">更新分组:</label>' +
                                        '<div class="col-sm-6">' +
                                            '<label class="radio-inline"><input type="radio" name="new_or_update" value="1">是</label>' +
                                            '<label class="radio-inline"><input type="radio" name="new_or_update" value="0">否</label>' +
                                        '</div>' +
                                        '<div class="col-sm-4 notice_gray" style="line-height:20px">选择“是”，将会更新与该分组关联广告的定向设置</div>' +
                                    '</div>');
                    $('#new_or_update').on('change','input',function(){
                        var val=$('#new_or_update input:checked').val()
                        if( val =='1' ){
                            $('.group-name').css("display","none");
                        }else{
                            $('.group-name').css("display","block");
                        }
                    })                
                }
                $('.group-name').removeClass('hidden');
            }else{
                if(id > 0){
                    $('.group-name').addClass('hidden');
                }
                $('#new_or_update').data('ischange',0);
                $('#new_or_update').html('');
            }
        }
    });
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
});
function checkInput(){
    var is_change = $('#new_or_update').data('ischange');
    var obj=$('#new_or_update input:checked')
    var name = $('.group-name input').val();
    if( is_change && obj && obj.val()!='1' && name=='' ){
        alert('分组名称不能为空')
        return false;
    }
    return true;
}
</script>
    </body>
</html>
