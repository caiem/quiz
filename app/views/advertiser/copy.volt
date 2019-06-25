<form id="adCopy">
<table class="table table-striped">
    <tr>
      <th>广告名称</th>
      <td>{{item['ad_name']~'-copy-'~date('ndHi')}}</td>
      <th>投放端</th>
      <td>{{advertiseTarget[item['target']]}}</td>
    </tr>
    <tr>
      <th>广告类型</th>
      <td>{% if item['target']==2%}{{item['platforms']==4 ? "PC-":"WAP-"}}{%endif%}{{ advertiseType[item['ad_type']] }}</td>
      <th>结算方式</th>
      <td>{{adCostType[item['cost_type']]}}</td>
    </tr>
    <tr>
      {% if item['target']==1%}
      <th>定向设备</th>
      <td>{{adPlatform[item['platforms']]}}</td>
      {% endif %}
      {% if item['cost_type']==1%}
      <th>日限额</th>
      <td>{{(item['day_cost_limit']+0) is empty ? '不限额':item['day_cost_limit']}}</td>
      {% endif %}
    </tr>
    <tr>
      {% if item['target']==1%}
      <th {{item['platforms']!=2?'':'style="display:none"'}}>IOS{{item['cost_type']==1?'点击单价':'目标量'}}</th>
      <td {{item['platforms']!=2?'':'style="display:none"'}}>{{item['cost_type']==1 ? item['ios_price']|default(''):item['ios_totals']|default('')}}</td>
      <th {{item['platforms']!=1?'':'style="display:none"'}}>Android{{item['cost_type']==1?'点击单价':'目标量'}}</th>
      <td {{item['platforms']!=1?'':'style="display:none"'}}>{{item['cost_type']==1 ? item['android_price']|default(''):item['android_totals']|default('')}}</td>
      {% else %}
      <th>网页{{item['cost_type']==1?'点击单价':'目标量'}}</th>
      <td>{{item['cost_type']==1 ? item['wap_price']|default(''):item['wap_totals']|default('')}}</td>
      {% endif %}
    </tr>
    <tr>
      <th>投放日期</th>
      <td><label class="radio-inline no-padding no-margin"><input class="form-control Wdate" name="btime" size="16" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'})"></label>{% if item['cost_type']!=2 %}到<label class="radio-inline no-padding no-margin"><input class="form-control Wdate" name="etime" size="16"  onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'})"></label>{% endif %}</td>
      <th>投放时间</th>
      <td>{{item['begin_hour']}}:00 ~ {{item['end_hour']}}:59</td>
    <tr>
    <tr>
      <th>素材</th>
      <td colspan="3">
        {% if item['ad_type'] =="banner" and item['source']%}
            <a target="_blank" href="{{item['source']['link']}}">{{item['source']['link']}}</a><br/>
            <img style="max-width:600px;" src="{{item['source']['pic']|default('')}}"><span><label>图片尺寸:{{item['source']['dsp_size']|default('--')}}</label></span>
        {%elseif item['ad_type'] =="inforflow" and item['source']%}
            <div>标题：{{item['source']['title']}}</div>
            <div>副标题：{{item['source']['subtitle']}}</div>
            <div><a target="{{item['source']['link']}}" href="{{item['source']['link']}}">{{item['source']['link']}}</a></div>
            <div>品牌名称：{{item['source']['brand_name']}}</div>
            <img title="品牌头像" width="150" height="150" src="{{item['source']['img']|default('')}}">
            <img title="图片一" width="150" height="150" src="{{item['source']['pic1']|default('')}}">
            <img title="图片二" width="150" height="150" src="{{item['source']['pic2']|default('')}}">
            <img title="图片三" width="150" height="150" src="{{item['source']['pic3']|default('')}}">
        {%endif%}
      </td>
    </tr>
</table>
<form>