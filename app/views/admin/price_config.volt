{{ partial('common/header') }}
</head>
<body class="hold-transition skin-blue sidebar-mini">
<div id="price_base">
    <div class="wrapper">

      {{ partial('common/navbar',['logout':'/manage/index/logout']) }}
      <!-- Left side column. contains the logo and sidebar -->
      {{ partial('common/sidebar',['type':'/manage']) }}

      <!-- Content Wrapper. Contains page content -->
      <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
          <h1>
            广告版位管理
            <small>系统设置</small>
          </h1>
          <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a href="#">系统设置</a></li>
            <li class="active">广告版位管理</li>
          </ol>
        </section>

        <!-- Main content -->
        <section class="content">

          <div class="row">
            <div class="col-xs-12">
              <div class="box">
                <div class="box-header">
                    <form class="form-inline" role="form">
                        <div class="form-group">
                            <select v-model="currentData.target" name="target" v-on:change="resetByTarget()" class="form-control">
                                <option v-for="(item,key) in AdTarget" v-bind:value="key">{{'{{item}}'}}</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <select v-model="currentData.ad_type" name="ad_type" v-on:change="resetByAdType()" class="form-control">
                                <option v-for="(item,key) in AdTypes" v-bind:value="key">{{'{{item}}'}}</option>
                            </select>
                        </div>
                        <input type="submit" class="btn btn-info" value="查询"/>
                        <a style="float:right;margin-right:40px" class="btn btn-info" v-on:click="addedit()">新增<i class="fa fa-plus"></i></a>
                    </form>
                </div>
                <!-- /.box-header -->
                <div class="box-body table-responsive no-padding">
                    <table class="table table-hover">
                        <tr>
                            <th>版位名称</th>
                            <th>版位来源</th>
                            <th>投放端</th>
                            <th>广告类型</th>
                            <th>广告尺寸</th>
                            <th>曝光量</th>
                            <th>CPC底价</th>
                            <th>CPM底价</th>
                            <th>操作</th>
                        </tr>
                        <tr v-for="(item,index) in List">
                            <td>{{'{{ item.name }}'}}</td>
                            <td>{{'{{ PosType[item.type] }}'}}</td>
                            <td>{{'{{ AdTarget[item.target] }}'}}</td>
                            <td v-if="item.target==2">{{'{{ AdTypeWap[item.ad_type] }}'}}</td><td v-else>{{'{{ AdType[item.ad_type] }}'}}</td>
                            <td>{{'{{ item.ad_size }}'}}</td>
                            <td>{{'{{ item.pv }}'}}</td>
                            <td>{{'{{ item.cpc }}'}}</td>
                            <td>{{'{{ item.cpm }}'}}</td>
                            <td>
                                <a class="btn btn-default btn-xs text-fill"  type="button" v-on:click="addedit(index)">修改</a>
                                <a class="btn btn-default btn-xs text-fill"  type="button" v-on:click="del(item.k)">删除</a>
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
            <h4 class="modal-title">新增/修改广告版位</h4>
          </div>
          <div class="modal-body">
          <form id="form_add" action="/manage/index/addposcfg" method="POST" enctype="multipart/form-data">
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
                  <td>版位名称</td>
                  <td><input v-model="currentData.name" name="name" type="text" class="form-control"></td>
                </tr>
                <tr>
                  <td>版位来源</td>
                  <td>
                    <select v-model="currentData.type" name="type" class="form-control">
                        <option v-for="(item,key) in PosType" v-bind:value="key">{{'{{item}}'}}</option>
                    </select>
                  </td>
                </tr>
                <tr>
                  <td>版位曝光</td>
                  <td><input v-model="currentData.pv" name="pv" type="number" class="form-control"></td>
                </tr>
                <tr>
                  <td>CPC底价</td>
                  <td><input v-model="currentData.cpc" name="cpc" type="text" class="form-control"></td>
                </tr>
                <tr>
                  <td>CPM底价</td>
                  <td><input v-model="currentData.cpm" name="cpm" type="text" class="form-control"></td>
                </tr>
                <input v-model="currentData.k" name="id" type="hidden" class="form-control">
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
<script src="/plugins/jQuery/jquery.form.js"></script>
<script src="/plugins/VueJs/vue.js"></script>
<script>
var vuePriceBase = new Vue({
    el: '#price_base',
    data: {
        List: {{List}},
        AdTarget:{{adTarget}},
        PosType:{{PosTypes}},
        AdTypes:{},
        AdType:{{adType}},
        AdTypeWap:{{adTypeWap}},
        SizeSet:[],
        SizeSets:{{ADSize}},
        currentData:{{qData}},
        Tags:{},
        delurl:'/manage/index/delposcfg'
    },
    methods:{
        addedit:function( id ){
            $("#form_add")[0].reset();
            this.currentData = {};
            if( id!=null || id !=undefined ){
                var data = $.extend( {},this.List[id] );
                if( data.target ==2 ){
                    this.AdTypes = this.AdTypeWap;
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
            ajaxDev(this.delurl, {id:id}, '确定要删除该设置？');
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
$(function(){
    if( vuePriceBase.currentData.target ==2 ){
        vuePriceBase.AdTypes = vuePriceBase.AdTypeWap;
    }else if(vuePriceBase.currentData.target ==1){
        vuePriceBase.AdTypes = vuePriceBase.AdType;
    }
});
</script>
</body>
</html>