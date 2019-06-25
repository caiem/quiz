{{ partial('common/header') }}
</head>
<body class="hold-transition skin-blue sidebar-mini">
<div id="price_plus">
    <div class="wrapper">

      {{ partial('common/navbar',['logout':'/manage/index/logout']) }}
      <!-- Left side column. contains the logo and sidebar -->
      {{ partial('common/sidebar',['type':'/manage']) }}

      <!-- Content Wrapper. Contains page content -->
      <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
          <h1>
            费用加权配置
            <small>系统设置</small>
          </h1>
          <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a href="#">系统设置</a></li>
            <li class="active">费用加权配置</li>
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
                            <select v-model="currentData.cat" name="cat" v-on:change="resetByCat()" class="form-control">
                                <option v-for="(item,key) in Categroy" v-bind:value="key">{{'{{item.name}}'}}</option>
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
                            <th>定向分类</th>
                            <th>定向条件</th>
                            <th>CPC加权</th>
                            <th>CPM加权</th>
                            <th>操作</th>
                        </tr>
                        <tr v-for="(item,index) in List">
                            <td>{{'{{ Categroy[item.cat].name }}'}}</td>
                            <td>{{'{{ Categroy[item.cat].data[item.tag] }}'}}</td>
                            <td>{{'{{ item.cpc*100 }}'}}%</td>
                            <td>{{'{{ item.cpm*100 }}'}}%</td>
                            <td>
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
            <h4 class="modal-title">新增加权设置</h4>
          </div>
          <div class="modal-body">
          <form id="form_add" action="/manage/index/addpp" method="POST" enctype="multipart/form-data">
            <table class="table table-bordered">
              <tbody>
                <tr>
                  <td>定向分类</td>
                  <td>
                    <select v-model="currentData.cat" name="cat" v-on:change="resetByCat()" class="form-control">
                        <option v-for="(item,key) in Categroy" v-bind:value="key">{{'{{item.name}}'}}</option>
                    </select>
                  </td>
                </tr>
                <tr>
                  <td>定向条件</td>
                  <td>
                    <select v-model="currentData.tag" name="tag" class="form-control">
                        <option v-for="(item,key) in Tags" v-bind:value="key">{{'{{item}}'}}</option>
                    </select>
                  </td>
                </tr>
                <tr>
                  <td>CPC加权</td>
                  <td>
                    <div class="input-group">
                        <input type="text" name="cpc" v-model="currentData.cpc" class="form-control">
                        <span class="input-group-addon"><i>%</i></span>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td>CPM加权</td>
                  <td>
                    <div class="input-group">
                        <input type="text" name="cpm" v-model="currentData.cpm" class="form-control">
                        <span class="input-group-addon"><i>%</i></span>
                    </div>
                  </td>
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
var vueAdPreview = new Vue({
    el: '#price_plus',
    data: {
        List: {{List}},
        Categroy:{{Categroy}},
        currentData:{{qData}},
        Tags:{},
        delurl:'/manage/index/delpp'
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
        resetByCat:function(){
            if( !this.currentData.cat ){
                return;
            }
            this.Tags = this.Categroy[this.currentData.cat].data;
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
</script>
</body>
</html>