{{ partial('common/header') }}
<style>
pre{
    border:none;
    background:none;
    padding:0px;
    white-space:pre-wrap;
    word-wrap: break-word;
}
</style>
</head>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper">

  {{ partial('common/navbar',['logout':'/manage/index/logout']) }}
  <!-- Left side column. contains the logo and sidebar -->
  {{ partial('common/sidebar',['type':'/manage']) }}

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        {{Account is empty ? '补交' : '修改' }}开户申请
        <small>账户管理</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">用户管理</a></li>
        <li><a href="#">账户管理</a></li>
        <li class="active">{{Account is empty ? '补交' : '修改' }}开户申请</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">

      <div class="row">
        <div class="col-xs-12">
            <form id="form_addAcount" action="/manage/User/editaccount" method="POST" class="form-inline" role="form">
            <div class="box">
                <div class="box-header">
                    <h3 class="box-title">账号基本信息</h3>
                </div>
                <div class="box-body">
                    <table class="table table-hover">
                        <tr><td>账户类型: <select name="utype" id="utype" class="form-control">
                        {% for index,item in Utypes %}
                            <option value="{{index}}" {{ Account['utype'] is defined and index == Account['utype'] ? "selected" : "" }}>{{item}}</option>
                        {% endfor %}
                        </select></td><td>开户类型: <input name="type" value="1" type="radio" required="required" checked/>企业广告主</td></tr>
                        <tr><td colspan="2">企业名称: <input name="name" size="80" value="{{ Account['name'] is defined ? Account['name'] : '' }}" type="text" class="form-control" required="required"/></td></tr>
                        <tr><td colspan="2">对公银行卡号/支付宝: <input size="80" name="bank_no" value="{{ Account['bank_no'] is defined ? Account['bank_no'] : '' }}" type="text" class="form-control" required="required"/></td></tr>
                        <tr><td>合作联系人: <input name="contact" type="text" value="{{ Account['contact'] is defined ? Account['contact'] : '' }}" class="form-control" required="required"/></td><td>联系人地址: <input name="address" value="{{ Account['address'] is defined ? Account['address'] : '' }}" size="80" type="text" class="form-control" required="required"/></td></tr>
                        <tr><td>联系人手机: <input name="phone" type="text" value="{{ Account['phone'] is defined ? Account['phone'] : '' }}" class="form-control" required="required"/></td><td>联系人邮箱: <input name="email" value="{{ Account['email'] is defined ? Account['email'] : '' }}" type="text" class="form-control" required="required"/></td></tr>
                    </table>
                </div>
            </div>
            <div class="box">
                <div class="box-header">
                    <h3 class="box-title">企业资质文件</h3>
                </div>
                <div class="box-body">
                    <table class="table">
                        <tr><td colspan="2">推广项目: <input name="item" value="{{ Account['item'] is defined ? Account['item'] : '' }}" size="80" type="text" class="form-control" required="required"/></td></tr>
                        <tr><td colspan="2">推广网址: <input name="site" value="{{ Account['site'] is defined ? Account['site'] : '' }}" size="80" type="text" class="form-control" required="required"/></td></tr>
                        <tr><td colspan="2">资质文件: <small>（审核提示：三证合一企业需要：营业执照、开户许可证、一般纳税人证明； 非三证合一企业需要：营业执照、税务登记证、组织机构代码证、开户许可证、一般纳税人证明）</small></td></tr>
                        <tr><td>营业执照: <input name="licence" type="file" class="form-control" /></td><td>组织机构代码证: <input name="org" type="file" class="form-control" /></td></tr>
                        <tr><td>税务登记证: <input name="tax" type="file" class="form-control" /></td><td>开户许可证:<input name="permit" type="file" class="form-control" /> </td></tr>
                        <tr><td>增值税一般纳税人证书: <input name="cert" type="file" class="form-control" /></td></tr>
                    </table>
                </div>
            </div>
            <div class="box">
                <div class="box-header">
                    <h3 class="box-title" id="ind_title">行业资质文件</h3>
                </div>
                <div class="box-body industry_qualify">
                    <table class="table normal_info">
                        <tr><td>一级行业: <select name="qualify[0][pid]" data-value="{{ Qualifys[0]['pri_industry'] is defined ? Qualifys[0]['pri_industry'] : '' }}" class="form-control prov">
                            <option value="">-请选择-</option>
                          </select></td>
                            <td rowspan="5" width="520">
                            <div>
                                <h4>对应行业所需行业资质说明: </h4>
                                <div>基础必须行业资质文件: 
                                    <p><pre class="base_file red"></pre></p>
                                </div>
                                <div>特殊业务需补充: 
                                    <p class="special_file red">无</p>
                                </div>
                                <div>准入规则: <span class="rules red"></span></div>
                            </div>
                            </td>
                        </tr>
                        <tr><td>二级行业: <select name="qualify[0][id]" class="form-control city" data-value="{{ Qualifys[0]['sub_industry'] is defined ? Qualifys[0]['sub_industry'] : '' }}">
                            <option value="">-请选择-</option>
                          </select></td></tr>
                        <tr><td>涉及特殊业务范围: <span class="specials" data-value="{{ Qualifys[0]['special_business'] is defined ? Qualifys[0]['special_business'] : '' }}">无</span><b>
                            
                            </b></td></tr>
                        <tr><td>行业资质文件: <input name="qualify[0][zip]" type="file" class="form-control" data-toggle="tooltip" title="打包上传"/></td></tr>
                        <tr><td>
                            
                        </td></tr>
                    </table>
                    {% for index,Qualify in Qualifys %}
                    <div class="agent_info" style="display:none">
                        <input class="pk_id" name="qualify[{{index}}][pk]" type="hidden" value="{{ Qualify['id'] is defined ? Qualify['id'] : '' }}"/>
                        <div style="position: absolute;right: 10px;">
                            <button type="button" class="btn btn-default btn-sm add_item" {{ index!=0 ? 'style="display:none"':'' }}><i class="fa fa-plus text-green"></i></button>
                            <button type="button" class="btn btn-default btn-sm del_item" {{ index==0 ? 'style="display:none"':'' }}><i class="fa fa-close text-red"></i></button>
                        </div>
                        <table class="table">
                            <tr><td>代投企业名称: <input name="qualify[{{index}}][cname]" size="60" type="text" value="{{ Qualify['company'] is defined ? Qualify['company'] : '' }}" class="form-control" required="required"/></td>
                                <td rowspan="6" width="520">
                                <div>
                                    <h4>对应行业所需行业资质说明: </h4>
                                    <div>代投企业基本资质文件: 
                                        <p><strong class="red"><ol><li>营业执照</li><li>授权代理证明</li></ol></strong></p>
                                    </div>
                                    <div>基础必须行业资质文件: 
                                        <p><pre class="base_file red"></pre></p>
                                    </div>
                                    <div>特殊业务需补充: 
                                        <p class="special_file red">无</p>
                                    </div>
                                    <div>准入规则: <span class="rules red"></span></div>
                                </div>
                                </td>
                            </tr>
                            <tr><td>一级行业: <select name="qualify[{{index}}][pid]" class="form-control prov" data-value="{{ Qualify['pri_industry'] is defined ? Qualify['pri_industry'] : '' }}">
                            <option value="">-请选择-</option>
                          </select></td></tr>
                            <tr><td>二级行业: <select name="qualify[{{index}}][id]" class="form-control city" data-value="{{ Qualify['sub_industry'] is defined ? Qualify['sub_industry'] : '' }}">
                            <option value="">-请选择-</option>
                          </select></td></tr>
                            <tr><td>涉及特殊业务范围: <span class="specials" data-value="{{ Qualify['special_business'] is defined ? Qualify['special_business'] : '' }}">无</span><b>

                                </b></td></tr>
                            <tr><td>行业资质文件: <input name="qualify[{{index}}][zip]" type="file" class="form-control" data-toggle="tooltip" title="打包上传"/></td></tr>
                        </table>
                    </div>
                    {% endfor %}
                </div>
            </div>
            <input type="hidden" name="user_id" value="{{uid}}">
            <button type="button" class="btn btn-primary"/>确认提交</button>
            </form>
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
<script type="text/javascript" src="/plugins/cityselect/jquery.cityselect.js"></script>
<script src="/plugins/jQuery/jquery.form.js"></script>
<script>
    var current_agent = {{Qualifys|length}} | 1;
    var param = {
        url:{{selectJson|json_encode}},
        required:false
    };
    $(function(){
        init();
        $("#form_addAcount .btn-primary").click(function () {
            $("#form_addAcount").ajaxSubmit({dataType:'json',success:function( data ){
                alert(data.msg);
                if (data.code == 200) {
                    window.location.href = "/manage/User/viewaccount?uid={{uid}}";
                }
            }});
        });
        $("#utype").change(function(){
            var utype =  $(this).val();
            if( utype!=1 ){
                $("#ind_title").html("行业资质文件");
                $(".normal_info").css({"display":"table"});
                $(".normal_info input,.normal_info select").removeAttr("disabled")
                $(".agent_info input,.agent_info select").attr("disabled","disabled");
                $(".agent_info").css({"display":"none"});
            }else{
                $("#ind_title").html("代投信息");
                $(".normal_info").css({"display":"none"});
                $(".agent_info input,.agent_info select").removeAttr("disabled")
                $(".normal_info input,.normal_info select").attr("disabled","disabled");
                $(".agent_info").css({"display":"block"});
            }
            init()
        });
        $(".add_item").click(function(){
            var html = '<div class="agent_info">' + $(this).closest(".agent_info").html() + '</div>' ;
            html = html.replace(/qualify\[(\d+)\]/g,"qualify["+ current_agent + "]");
            current_agent++
            var html_obj = $(html)
            html_obj.find(".pk_id").remove();
            html_obj.find(".add_item").remove();
            html_obj.find(".del_item").css({"display":"block"});
            $(".industry_qualify").append( '<div class="agent_info">' + html_obj.html() + '</div>' )
            init()
        });
        
        $(".industry_qualify").on("change",".prov",function(){
            var table_obj = $(this).closest("table");
            table_obj.find(".specials").html('无');
            table_obj.find(".base_file").html('无')
            table_obj.find(".rules").html('无')
        })
        $(".industry_qualify").on("change",".city",function(){
            var table_obj = $(this).closest("table");
            var pid = parseInt( table_obj.find(".prov").val() | table_obj.find(".prov").data('value'));
            var id = parseInt( $(this).val() | $(this).data('value') );
            var html = '无';
            if( pid !=0 && pid !=NaN && id !=0 && id !=NaN ){
                for(var pk in param.url.citylist ){
                    if( param.url.citylist[pk]["pv"]==pid ){
                        for(var k in param.url.citylist[pk]["c"]){
                            if(param.url.citylist[pk]["c"][k]["nv"] == id ){
                                table_obj.find(".base_file").html(param.url.citylist[pk]["c"][k]["qualify"])
                                table_obj.find(".rules").html(param.url.citylist[pk]["c"][k]["rule"])
                                if( param.url.citylist[pk]["c"][k]["special"] ){
                                    var name = $(this).attr("name")
                                    name = name.substr(0,name.lastIndexOf("["))
                                    html = ""
                                    var selecteds = table_obj.find(".specials").data('value');
                                    var selecteds_arr = []
                                    if( selecteds ){
                                        selecteds_arr = (selecteds+'').split(',')
                                    }
                                    for(var sk in param.url.citylist[pk]["c"][k]["special"]){
                                        var is_in = false;
                                        for(var _sk in selecteds_arr){
                                            if( selecteds_arr[_sk] == sk ){
                                                is_in = true;
                                            }
                                        }
                                        html += '<label class="checkbox-inline"><input name="'+name+'[special][]" data-content="'+ param.url.citylist[pk]["c"][k]["special"][sk]['qualify']
                                              +'" type="checkbox" value="'+sk+'" '+(is_in ? 'checked': '') +'>'+ param.url.citylist[pk]["c"][k]["special"][sk]['name'] +'</label>';
                                    }
                                }
                                table_obj.find(".specials").html(html);
                                return ;
                            }
                        }
                    }
                }
            }
        });
        $("#utype").change();
        $(".industry_qualify .city").each(function(){
            $(this).change();
        });
        $(".normal_info .specials input,.agent_info .specials input").change();
    })
    function init(){
        $(".agent_info").on("click",".del_item",function(){
            $(this).closest(".agent_info").remove();
        });
        $(".normal_info,.agent_info").each(function(){
            prov = $(this).find('.prov').val() | $(this).find('.prov').data('value')
            city = $(this).find('.city').val() | $(this).find('.city').data('value')
            if(prov){
                param.prov = prov;
            }
            if(city){
                param.city = city;
            }
            $(this).citySelect(param)
        });
        $(".normal_info .specials,.agent_info .specials").on("change","input",function(){
            var html = "";
            $(this).closest("span").find("input").each(function(){
                if( $(this).is(':checked') ){
                    html += "<li>" + $(this).data("content") + "</li>";
                }
            })
            html = html!="" ? "<ol>" + html + "</ol>" : "无";
            $(this).closest("table").find(".special_file").html(html)
        })
    }
</script>
</body>
</html>