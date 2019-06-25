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
        <span style="color:red">{{AdInfo['ad_name']}}</span>流量分析-{{AnaTypeName}}
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li class="active">{{AnaTypeName}}</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">

      <div class="row">
        <div class="col-xs-12">
          <div class="box">
            <div class="box-header">
                <form id="query_form" class="form-inline" role="form">
                    <div  style="float:left;margin-right:40px" class="btn-group">
                        <button title="默认为每日流量分析" type="button" class="btn btn-info dropdown-toggle" data-toggle="dropdown">
                          分析维度<span class="caret"></span>
                        </button>
                        <ul class="dropdown-menu" role="menu">
                          <li><a href="/Advertise/analysis?id={{AdInfo['ad_id']}}">每日流量分析</a></li>
                          <li><a href="/Advertise/analysis?type=1&id={{AdInfo['ad_id']}}">用户分组流量分析</a></li>
                        </ul>
                    </div>
                </form>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover">
                {% if AdInfo['cost_type']==1 %}
                {% set difstr = 'cost_' %}
                {% else %}
                {% set difstr = '' %}
                {% endif %}
                {% if Ana_type %}
                    <tr>
                      <th width="450">用户分组条件</th>
                      <th>总PV/总点击量</th>
                      <th>IOS PV</th>
                      <th>IOS点击量</th>
                      <th>Android PV</th>
                      <th>Android点击量</th>
                      <th>网页PV</th>
                      <th>网页点击量</th>
                    </tr>
                    {% for index, item in List %}
                    <tr>
                      <td class="desc">{{ item['condition']|default('全量用户') }}</td>
                      <td>{{ (item['ios_pv'] is defined?item['ios_pv']:0)+(item['android_pv'] is defined?item['android_pv']:0)+(item['wap_pv'] is defined?item['wap_pv']:0)}}/
                          {{ (item['ios_'~ difstr ~'clicks'] is defined?item['ios_'~ difstr ~'clicks']:0)+ (item['android_'~ difstr ~'clicks'] is defined?item['android_'~ difstr ~'clicks']:0) +(item['wap_'~ difstr ~'clicks'] is defined?item['wap_'~ difstr ~'clicks']:0) }}</td>
                      <td>{{ item['ios_pv']|default('-') }}</td>
                      <td>{{ item['ios_'~ difstr ~'clicks']|default('-') }}</td>
                      <td>{{ item['android_pv']|default('-') }}</td>
                      <td>{{ item['android_'~ difstr ~'clicks']|default('-') }}</td>
                      <td>{{ item['wap_pv']|default('-') }}</td>
                      <td>{{ item['wap_'~ difstr ~'clicks']|default('-') }}</td>
                    </tr>
                    {% endfor %}
                {% else %}
                    <tr>
                      <th>日期</th>
                      <th>总PV/总点击量</th>
                      <th>IOS PV</th>
                      <th>IOS点击量</th>
                      <th>Android PV</th>
                      <th>Android点击量</th>
                      <th>网页PV</th>
                      <th>网页点击量</th>
                    </tr>
                    {% for index, item in List %}
                    <tr>
                      <td>{{ index }}</td>
                      <td>{{ (item['ios_pv'] is defined?item['ios_pv']:0)+(item['android_pv'] is defined?item['android_pv']:0)+(item['wap_pv'] is defined?item['wap_pv']:0)}}/
                          {{ (item['ios_'~ difstr ~'clicks'] is defined?item['ios_'~ difstr ~'clicks']:0)+ (item['android_'~ difstr ~'clicks'] is defined?item['android_'~ difstr ~'clicks']:0) +(item['wap_'~ difstr ~'clicks'] is defined?item['wap_'~ difstr ~'clicks']:0) }}</td>
                      <td>{{ item['ios_pv']|default('-') }}</td>
                      <td>{{ item['ios_'~ difstr ~'clicks']|default('-') }}</td>
                      <td>{{ item['android_pv']|default('-') }}</td>
                      <td>{{ item['android_'~ difstr ~'clicks']|default('-') }}</td>
                      <td>{{ item['wap_pv']|default('-') }}</td>
                      <td>{{ item['wap_'~ difstr ~'clicks']|default('-') }}</td>
                    </tr>
                    {% endfor %}
                {% endif %}
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
    <script>
    $(function(){
        $('.more').click(function(){
            $(this).children('.show_more').toggle();
        });
    })
    </script>
</body>
</html>