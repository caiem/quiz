{{ partial('common/header') }}
<link href="/plugins/select2/select2.min.css" type="text/css" rel="stylesheet" />
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
        投放效果数据
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li class="active">投放效果数据</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">

      <div class="row">
        <div class="col-xs-12">
          <div class="box">
            <div class="box-header">
                <form id="query_form" onsubmit="return checkform();" class="form-inline" role="form">
                    <div class="form-group">
                      <label>广告名称:</label>
                      <select name="ad_id" class="form-control select2" style="width:260px">
                        {% if searchItem['ad_name'] is not empty%}
                        <option value="{{searchItem['ad_id']|default('')}}" selected>{{searchItem['ad_name']|default('')}}</option>
                        {% endif %}
                      </select>
                      <input name="ad_name" type="hidden" value="{{searchItem['ad_name']|default('')}}">
                    </div>
                    <div class="form-group">
                      <label>开始时间:</label>
                      <input name="begin_time" data-toggle="tooltip" title="{{AdBtime|default('')}}" value="{{searchItem['begin_time']|default('')}}" type="datetime" onClick="WdatePicker()" class="form-control Wdate s_btime" placeholder="">
                    </div>
                    <div class="form-group">
                      <label>结束时间:</label>
                      <input name="end_time" data-toggle="tooltip" title="{{AdEtime|default('')}}" value="{{searchItem['end_time']|default('')}}" type="datetime" onClick="WdatePicker()" class="form-control Wdate s_etime" placeholder="">
                    </div>
                    <input type="submit" class="btn btn-info" value="查询"/>
                    <span style="float:right;margin-right:40px"><a href="javascript:void(0);" class="btn btn-info download">下载</a></span>
                </form>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
                <div id="linechart" style="max-width:1155px"></div>
                <table class="table">
                    <tr><th>时间</th><th>曝光量</th><th>点击量</th><th>点击率(‰)</th><th>点击均价</th><th>花费</th><th>ECPM</th></tr>
                    <tr class="fixed_head" style="display:none;background-color: aliceblue"><th>时间</th><th>曝光量</th><th>点击量</th><th>点击率(‰)</th><th>点击均价</th><th>花费</th><th>ECPM</th></tr>
                    {% for item in tableData%}
                    <tr><td>{{item['time']|default('-')}}</td><td>{{item['pv']|default('-')}}</td><td>{{item['click']|default('-')}}</td><td>{{item['rate']|default('-')}}</td><td>{{item['avg']|default('-')}}</td><td>{{item['cost']|default('-')}}</td><td>{{item['ecpm']|default('-')}}</td></tr>
                    {% endfor %}
                </table>
            </div>
            <!-- /.box-body -->
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
<script src="/plugins/my97DatePicker/WdatePicker.js"></script>
<script src="/plugins/select2/select2.min.js"></script>
<script src="/plugins/highchart/highcharts.js"></script>
<script>
function checkform(){
    if ( $("#query_form input[name=ad_name]").val() == ''){
        alert("请选择广告");
        return false
    }
    if ( $("#query_form input[name=begin_time]").val() == ''){
        alert("请输入开始日期");
        return false
    }
    return true;
}
$(document).ready(function(){
  var widths =[];
  $('.box-body table tr:last td').each(function(){
        widths.push($(this).width())
  });
  $(window).scroll(function(){
       var top=$(this).scrollTop();
       if( top > 561 ){
            $('.fixed_head').css({position:'fixed',top:'0px',display:'block'});
            var i=0;
            $('.fixed_head th').each(function(){
                $(this).width( widths[i] )
                i++;
            })
       }else{
            $('.fixed_head').css({position:'inherit',display:'none'});
       }
  });
  $(".download").click(function(){
    var form = $("#query_form");
    form.attr("action","/Advertise/chartdownload");
    form.submit();
    form.attr("action","");
  });
  $("#query_form select[name=ad_id]").select2({
    ajax:{
        url:"/Advertise/filterad",
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
  $('#query_form select[name=ad_id]').on('select2:select', function (evt) {
        $("#query_form input[name=ad_name]").val(evt.params.data.text);
        $('.s_btime').attr('title','广告开始投放时间：' + evt.params.data.begin_time).tooltip('fixTitle');
        if( evt.params.data.end_time != '1970-01-01' ){
            $('.s_etime').attr('title', '广告结束投放时间：' + evt.params.data.end_time).tooltip('fixTitle');
        }else{
            $('.s_etime').attr('title', '').tooltip('fixTitle');
        }
  });
  Highcharts.chart('linechart', {
    chart: {
        type: 'spline'
    },
    title: {
        text: '<span style="color:red">{% if AdInfo['ad_name'] is not empty%}{{AdInfo['ad_name']}}{% endif %}</span>投放效果图'
    },
    xAxis: {
        categories: {{ChartData['xAxis']}},
        title: {
            text: '日期/时间'
        }
    },
    yAxis: {
        title: {
            text: '次数/点击率(‰)'
        },
        min: 0
    },
    tooltip: {
        shared: true
    },
    
    plotOptions: {
        spline: {
            marker: {
                enabled: true
            }
        }
    },

    series: [{
        name: '曝光量',
        data: {{ChartData['pvData']}}
    }, {
        name: '点击量',
        data: {{ChartData['clickData']}}
    }, {
        name: '点击率',
        data: {{ChartData['rateData']}}
    }]
});
});
</script>
</body>
</html>