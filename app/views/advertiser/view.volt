<div class="info-box">
    <span class="info-box-icon" style="font-size:24px;line-height: 42px;"> 基本信息 </span>
    <div class="info-box-content">
        <table class="table no-margin">
            <tr>
                <td>{% if item['cost_type']==1%}日限额{%else%}目标值{% endif %}:</td>
                <td>
                    {% if item['cost_type']==1%}
                        {{item['day_cost_limit']|default('-')}}
                    {%else%}
                        {% if item['ios_totals'] is not empty %}
                            <p>IOS: {{item['ios_totals']}}个CPM</p>
                        {% endif %}
                        {% if item['android_totals'] is not empty %}
                            <p>Android: {{item['android_totals']}}个CPM</p>
                        {% endif %}
                        {% if  item['wap_totals'] is not empty %}
                            <p>Wap: {{item['wap_totals']}}个CPM</p>
                        {% endif %}
                    {% endif %}
                </td>
            </tr>
            <tr>
                <td>投放时间段：</td>
                <td>
                    {{ date('Y-m-d H:i',item['begin_time']) }} ~ {{ item['cost_type']==2 ? '': date('Y-m-d H:i',item['end_time']) }}<br/>时间段：{{item['begin_hour']}}:00 ~ {{item['end_hour']}}:59
                </td>
            </tr>
        </table>
    </div>
</div>
<div class="info-box">
    <span class="info-box-icon" style="font-size:24px;line-height: 42px;">用户分组条件</span>
    <p class="info-box-content">{{ugdata}}</p>
</div>
<div class="info-box">
    <span class="info-box-icon" style="font-size:24px;line-height: 42px;">广告素材信息</span>
    <div class="info-box-content">
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
    </div>
</div>