<div class="box border-top">
    <div class="box-header with-border">
        <h3 class="box-title">用户基本属性</h3>
        <span class="span-padde"> </span><span class="notice_gray span-left">属性选项可以多选，选项之间为“并且”关系。</span>
        <div class="box-tools pull-right"></div>
    </div>
    <div class="box-body">
        <table class="table no-border" style="margin-left:30px">
            <colgroup><col class="col-xs-1"> <col class="col-xs-9"> </colgroup>
            {% if ( Ugtype is defined and Ugtype==1) or ( ugdata is defined and ugdata['data']['site'] is not empty )%}
            <tr rowspan="2">
                <td>地区:</td>
                <td class="notice_gray">匹配32个站点同城的地域定向投放，可多选</td>
            </tr>
            <tr>
                <td></td>
                <td class="sites">
                    {% if ugdata is defined and ugdata['data']['site'] is not empty %}
                        {% for key,value in ugdata['data']['site']%}
                            <div class="site row">
                                <div class="col-sm-4">
                                    <div class="form-group">
                                        <select name="ugdata[site][]" class="form-control">
                                            {% for item in formData['sites'] %}
                                            <option value="{{item['value']}}" {% if item['value']== value %}selected{% endif %}>{{item['show_name']}}-{{item['value']}}</option>
                                            {% endfor %}
                                        </select>
                                    </div>
                                </div>
                                {%if key==0%}<a class="btn btn-primary addSite">+</a>{%else%}<a class="btn btn-warning delSite">-</a>{%endif%}
                            </div>
                        {% endfor %}
                    {% else %}
                    <div class="site row">
                        <div class="col-sm-4">
                            <div class="form-group">
                                <select name="ugdata[site][]" class="form-control">
                                      {% for key,item in formData['sites'] %}
                                      <option value="{{item['value']}}">{{item['show_name']}}-{{item['value']}}</option>
                                      {% endfor %}
                                </select>
                            </div>
                        </div>
                        <a class="btn btn-primary addSite">+</a>
                    </div>
                    {% endif %}
                </td>
            </tr>    
            {% else %}
{#            <tr rowspan="2">
                <td>性别:</td>
                <td class="notice_gray">性别，单选</td>
            </tr>
            <tr>
                <td></td>
                <td class="ugender">
                    {% for key,item in formData['gender'] %}
                    <label class="radio-inline">
                        <input name="ugdata[gender]" type="radio" value="{{item['value']}}" {% if ugdata is defined and ugdata['data']['gender'] is not empty and ugdata['data']['gender']==item['value']%}checked{%endif%}> <span>{{item['show_name']}}</span>
                    </label>
                    {% endfor %}
                </td>
            </tr>
#}
            {% if PosType is not defined or PosType !=1 %}
            <tr rowspan="2">
                <td>状态:</td>
                <td class="notice_gray">怀孕状态。可多选，多选时选项间为“或者”关系。全选时表示所有状态，效果等同于不选择</td>
            </tr>
            <tr>
                <td></td>
                <td class="babystatus">
                    {% for key,item in formData['pstatus'] %}
                    <div>
                        {% for kv,val in item %}
                        <label class="checkbox-inline">
                            <input name="ugdata[pstatus][]" type="checkbox" value="{{val['value']}}" {% if ugdata is defined and ugdata['data']['pstatus'] is not empty and in_array(val['value'], ugdata['data']['pstatus'])%}checked{%endif%}> <span>{{val['show_name']}}</span>
                        </label>
                        {% endfor %}
                    </div>
                    {% endfor %}
                </td>
            </tr>
            {% endif %}
            <tr rowspan="2">
                <td>地域:</td>
                <td class="notice_gray">地域，适用于有地区限制的投放，可精确到城市。可多选，多个地区之间为“或者”关系</td>
            </tr>
            <tr>
                <td></td>
                <td id="zone">
                    {% if ugdata is defined and ugdata['data']['zone'] is not empty %}
                        {% for key,value in ugdata['data']['zone']%}
                            <div class="zones row" id="city_{{key}}">
                                <div class="col-sm-4">
                                    <div class="form-group">
                                        <select name="ugdata[zone][{{key}}][province]" class="form-control prov select2">
                                              <option value="{{value['province']|default('')}}" selected>{{value['province']|default('-省份-')}}</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-sm-4">
                                    <div class="form-group">
                                        <select name="ugdata[zone][{{key}}][city]" class="form-control city select2">
                                              <option value="{{value['city']|default('')}}" selected>{{value['city']|default('-城市-')}}</option>
                                        </select>
                                    </div>
                                </div>
                                {%if key==0%}<a class="btn btn-primary addZone">+</a>{%else%}<a class="btn btn-warning delZone">-</a>{%endif%}
                            </div>
                        {% endfor %}
                    {% else %}
                    <div class="zones row" id="city_1">
                        <div class="col-sm-4">
                            <div class="form-group">
                                <select name="ugdata[zone][0][province]" class="form-control prov select2">
                                      <option value="">-省份-</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <select name="ugdata[zone][0][city]" class="form-control city select2">
                                      <option value="">-城市-</option>
                                </select>
                            </div>
                        </div>
                        <a class="btn btn-primary addZone">+</a>
                    </div>
                    {% endif %}
                </td>
            </tr>
{#
            <tr rowspan="2">
                <td>兴趣标签:</td>
                <td class="notice_gray">可多选。标签之间为“或者”关系，标签选择越多，覆盖用户群体越大</td>
            </tr>
            <tr>
                <td></td>
                <td class="utags">
                    <div>
                    {% for key,item in formData['tags'] %}
                        <label class="checkbox-inline">
                            <input name="ugdata[tags][]" type="checkbox" value="{{item['value']}}" {% if ugdata is defined and ugdata['data']['tags'] is not empty and in_array(item['value'], ugdata['data']['tags'])%}checked{%endif%}> <span>{{item['show_name']}}</span>
                        </label>
                        {% if key!=0 and key % 4 ==0 %}</div><div>{% endif %}
                    {% endfor %}
                    </div>
                </td>
            </tr>
#}
            {% if PosType is not defined or PosType !=1 %}
            <tr rowspan="2">
                <td>用户类型:</td>
                <td class="notice_gray">根据需要选择定向的用户类型</td>
            </tr>
            <tr>
                <td></td>
                <td class="reg_time">
                    <div>
                    {% for key,item in formData['reg_time'] %}
                        <label class="checkbox-inline">
                            <input name="ugdata[reg_time][]" type="checkbox" value="{{item['value']}}" {% if ugdata is defined and ugdata['data']['reg_time'] is not empty%}checked{%endif%}> <span>{{item['show_name']}}</span>
                        </label>
                    {% endfor %}
                    </div>
                </td>
            </tr>
            {% endif %}
            {% endif %}
        </table>
    </div>
</div>