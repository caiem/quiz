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
        汇总日报表
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li class="active">汇总日报表</li>
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
                      <label>开始时间:</label>
                      <input name="begin_time" value="{{searchItem['begin_time']|default('')}}" type="date" onClick="WdatePicker()" class="form-control Wdate" placeholder="">
                    </div>
                    <div class="form-group">
                      <label>结束时间:</label>
                      <input name="end_time" value="{{searchItem['end_time']|default('')}}" type="date" onClick="WdatePicker()" class="form-control Wdate" placeholder="">
                    </div>
                    <input type="submit" class="btn btn-info" value="查询"/>
                    <span style="float:right;margin-right:40px"><a href="javascript:void(0);" class="btn btn-info download">下载</a></span>
                </form>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover">
                <tr>
                  <th>日期</th>
                  <th>总PV/总点击量</th>
                  <th>账面消耗</th>
                  <th>IOS PV</th>
                  <th>IOS点击量</th>
                  <th>IOS账面消耗</th>
                  <th>Android PV</th>
                  <th>Android点击量</th>
                  <th>Android账面消耗</th>
                  <th>网页PV</th>
                  <th>网页点击量</th>
                  <th>网页账面消耗</th>
            {#      <th>账户余额</th> #}
                </tr>
                {% if totalList is not empty%}
                  <td>汇总</td>
                  <td>{{ totalList['total_pv'] }}/{{ totalList['click_times'] }}</td>
                  <td>{{ totalList['total_cost'] }}</td>
                  <td>{{ totalList['ios_pv']|default('-') }}</td>
                  <td>{{ totalList['ios_times']|default('-') }}</td>
                  <td>{{ (totalList['ios_cost']+0)|default('-') }}</td>
                  <td>{{ totalList['android_pv']|default('-') }}</td>
                  <td>{{ totalList['android_times']|default('-') }}</td>
                  <td>{{ (totalList['android_cost']+0)|default('-') }}</td>
                  <td>{{ totalList['wap_pv']|default('-') }}</td>
                  <td>{{ totalList['wap_times']|default('-') }}</td>
                  <td>{{ (totalList['wap_cost']+0)|default('-') }}</td>
            {#      <td>-</td> #}
                {%endif%}
                {% for index, item in userList %}
                <tr>
                  <td>{{ item['date'] }}</td>
                  <td>{{ item['total_pv'] }}/{{ item['click_times'] }}</td>
                  <td>{{ item['total_cost'] }}</td>
                  <td>{{ item['ios_pv']|default('-') }}</td>
                  <td>{{ item['ios_click_times']|default('-') }}</td>
                  <td>{{ (item['ios_cost']+0)|default('-') }}</td>
                  <td>{{ item['android_pv']|default('-') }}</td>
                  <td>{{ item['android_click_times']|default('-') }}</td>
                  <td>{{ (item['android_cost']+0)|default('-') }}</td>
                  <td>{{ item['wap_pv']|default('-') }}</td>
                  <td>{{ item['wap_click_times']|default('-') }}</td>
                  <td>{{ (item['wap_cost']+0)|default('-') }}</td>
            {#      <td>{{ item['account']|default('') }}</td> #}
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
<!-- ./wrapper -->
{{ partial('common/footer') }}
<script src="/plugins/my97DatePicker/WdatePicker.js"></script>
<script>
$(document).ready(function(){
  $(".download").click(function(){
    var form = $("#query_form");
    form.attr("action","/Advertise/downloadReport");
    form.submit();
    form.attr("action","");
  });
});
</script>
</body>
</html>