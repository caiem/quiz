{{ partial('common/header') }}
<link rel="stylesheet" href="/plugins/fancybox/jquery.fancybox.min.css" type="text/css" media="screen" />
</head>
<body class="hold-transition skin-blue sidebar-mini">
<div id="ad_preview_list">
    <div class="wrapper">

      {{ partial('common/navbar',['logout':'/manage/index/logout']) }}
      <!-- Left side column. contains the logo and sidebar -->
      {{ partial('common/sidebar',['type':'/manage']) }}

      <!-- Content Wrapper. Contains page content -->
      <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
          <h1>
            广告效果图配置
            <small>系统设置</small>
          </h1>
          <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a href="#">系统设置</a></li>
            <li class="active">广告效果图配置</li>
          </ol>
        </section>

        <!-- Main content -->
        <section class="content">

          <div class="row">
            <div class="col-xs-12">
              <div class="box">
                <div class="box-header">
                    <div class="user-add text-right">
                        <a class="btn btn-info" v-on:click="addedit()">新增<i class="fa fa-plus"></i></a>
                    </div>
                </div>
                <!-- /.box-header -->
                <div class="box-body table-responsive no-padding">
                    <table class="table table-hover">
                        <tr>
                            <th>投放端</th>
                            <th>广告类型</th>
                            <th>广告尺寸</th>
                            <th>应用端</th>
                            <th width="220">板块</th>
                            <th>点位名称</th>
                            <th>广告效果图</th>
                            <th>操作</th>
                        </tr>
                        <tr v-for="(item,index) in List">
                            <td>{{'{{ AdTarget[item.target] }}'}}</td>
                            <td v-if="item.target==2">{{'{{ AdTypeWap[item.ad_type+"_"+item.platform] }}'}}</td><td v-else>{{'{{ AdType[item.ad_type] }}'}}</td>
                            <td>{{'{{ item.ad_size }}'}}</td>
                            <td>{{'{{ item.app_name }}'}}</td>
                            <td>{{'{{ item.section }}'}}</td>
                            <td>{{'{{ item.pos_name }}'}}</td>
                            <td><a class="viewImg" rel="group" v-bind:href="'/upload/'+item.image"><img height="80px" v-bind:src="'/upload/'+item.image" ></a></td>
                            <td>
                                <a class="btn btn-warning btn-xs text-fill"  type="button" v-on:click="addedit(index)">修改</a>
                                <a class="btn btn-default btn-xs text-fill"  type="button" v-on:click="del(item.id)">删除</a>
                            </td>
                        </tr>
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
    <div id="modal-addPage" class="modal fade modal-form">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4 class="modal-title">新增效果图</h4>
          </div>
          <div class="modal-body">
          <form id="form_add" action="/manage/index/addadpreview" method="POST" enctype="multipart/form-data">
            <table class="table table-bordered">
              <tbody>
                <tr>
                  <td>投放端</td>
                  <td>
                    <select v-model="currentData.target" name="target" v-on:change="resetByTarget()" class="form-control">
                        <option v-for="(item,key) in AdTarget" v-bind:value="key">{{'{{item}}'}}</option>
                    </select>
                  </td>
                </tr>
                <tr>
                  <td>广告类型</td>
                  <td>
                    <select v-model="currentData.ad_type" name="ad_type" v-on:change="resetByAdType()" class="form-control">
                        <option v-for="(item,key) in AdTypes" v-bind:value="key">{{'{{item}}'}}</option>
                    </select>
                  </td>
                </tr>
                <tr>
                  <td>广告尺寸</td>
                  <td>
                    <select v-model="currentData.ad_size" name="ad_size" class="form-control">
                        <option v-for="item in SizeSet" v-bind:value="item">{{'{{item}}'}}</option>
                    </select>
                  </td>
                </tr>
                <tr>
                  <td>应用端</td>
                  <td><input v-model="currentData.app_name" name="app_name" type="text" class="form-control"></td>
                </tr>
                <tr>
                  <td>板块</td>
                  <td><input v-model="currentData.section" name="section" type="text" class="form-control"></td>
                </tr>
                <tr>
                  <td>点位名称</td>
                  <td><input v-model="currentData.pos_name" name="pos_name" type="text" class="form-control"></td>
                </tr>
                <tr>
                  <td>效果图</td>
                  <td style="text-align:center;">
                    <input class="noborder" type="file" name="image" onchange="PreviewImage(this,'imgHeadPhoto','divPreview')"/>
                    <div id="divPreview" style="margin-top:15px">
                        <img id="imgHeadPhoto"  style="margin:auto auto;max-width:470px;max-height:200px" v-bind:src="currentData.image ? '/upload/'+currentData.image : '/dist/img/nopic.gif'">
                    </div>
                  </td>
                </tr>
                <input v-model="currentData.id" name="id" type="hidden" class="form-control">
              </tbody>
            </table>
          </form>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            <button type="button" class="btn btn-primary" v-on:click="submitForm()">提交</button>
          </div>
        </div>
      </div>
    </div>
</div>
{{ partial('common/footer') }}
<script type="text/javascript" src="/plugins/fancybox/jquery.fancybox.min.js"></script>
<script src="/plugins/jQuery/jquery.form.js"></script>
<script src="/plugins/VueJs/vue.js"></script>
<script>
var vueAdPreview = new Vue({
    el: '#ad_preview_list',
    data: {
        List: {{List}},
        currentData:{},
        AdTarget:{{adTarget}},
        AdTypes:{},
        AdType:{{adType}},
        AdTypeWap:{{adTypeWap}},
        SizeSet:[],
        SizeSets:{{ADSize}},
        delurl:'/manage/index/deladpreview'
    },
    methods:{
        addedit:function( id ){
            $("#form_add")[0].reset();
            this.currentData = {};
            if( id!=null || id !=undefined ){
                var data = $.extend( {},this.List[id] );
                if( data.target ==2 ){
                    this.AdTypes = this.AdTypeWap;
                    data.ad_type = data.ad_type + '_' + data.platform;
                }else{
                    this.AdTypes = this.AdType;
                }
                this.SizeSet = this.SizeSets[data.target][data.ad_type];
                this.currentData = data;
            }
            $('#modal-addPage').modal('show')
        },
        resetByTarget:function(){
            if( this.currentData.target ==2){
                this.AdTypes = this.AdTypeWap;
            }else{
                this.AdTypes = this.AdType;
            }
            this.SizeSet = [];
        },
        resetByAdType:function(){
            if(this.currentData.ad_type ==undefined || this.currentData.target==undefined){
                return 
            }
            this.SizeSet = this.SizeSets[this.currentData.target][this.currentData.ad_type];
        },
        del:function(id){
            ajaxDev(this.delurl, {id:[id]}, '确定要删除该效果图设置？');
        },
        submitForm:function(){
            $("#form_add").ajaxSubmit({dataType:'json',success:function( data ){
                if (data.code == 200) {
                    window.location.reload();
                }else{
                    alert(data.msg);
                }
            }});
        }
    }
});

$(document).ready(function(){
  $('.viewImg').fancybox();
});
</script>
</body>
</html>