<aside class="main-sidebar">
    <!-- sidebar: style can be found in sidebar.less -->
    <section class="sidebar">
      <!-- search form -->
      <form action="#" method="get" class="sidebar-form">
        <div class="input-group">
          <input type="text" name="q" class="form-control" placeholder="Search...">
              <span class="input-group-btn">
                <button type="submit" name="search" id="search-btn" class="btn btn-flat"><i class="fa fa-search"></i>
                </button>
              </span>
        </div>
      </form>
      <!-- /.search form -->
      <!-- sidebar menu: : style can be found in sidebar.less -->
      <ul class="sidebar-menu">
        <li class="header">导航菜单</li>
        {% if IS_DEVEL %}
        <li {% if 'App' == controller and 'index' == action %}class="active"{% endif %}>
          <a href="/App/index">
            <i class="fa fa-calendar"></i> <span>应用列表</span>
          </a>
        </li>
        <li {% if 'Apppos' == controller and 'index' == action %}class="active"{% endif %}>
          <a href="/Apppos/index">
            <i class="fa fa-paw"></i> <span>广告位管理</span>
          </a>
        </li>
        <li {% if 'Statis' == controller and 'index' == action %}class="active"{% endif %}>
          <a href="/Statis/index">
            <i class="fa fa-tachometer"></i> <span>数据报表</span>
          </a>
        </li>
        {% else %}
        <li {% if 'Advertise' == controller and 'index' == action %}class="active"{% endif %}>
          <a href="/Advertise/index">
            <i class="fa fa-calendar"></i> <span>自助投放管理</span>
          </a>
        </li>
        <li {% if 'Usergroup' == controller and 'index' == action %}class="active"{% endif %}>
          <a href="/Usergroup">
            <i class="fa fa-group"></i> <span>用户分组</span>
          </a>
        </li>
        <li {% if 'Advertise' == controller and (action== 'dailyreport' or action== 'chart')%}class="active"{% endif %}>
          <a href="/Advertise"><i class="fa fa-tachometer"></i> 数据报表
            <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
          </a>
          <ul class="treeview-menu">
            <li {% if 'Advertise' == controller and 'chart' == action %}class="active"{% endif %}><a href="/Advertise/chart"><i class="fa fa-circle-o"></i>投放效果数据</a></li>
            {% if AGENT_OR_SUB !=3 %}
            <li {% if 'Advertise' == controller and 'dailyreport' == action %}class="active"{% endif %}><a href="/Advertise/dailyReport"><i class="fa fa-circle-o"></i>汇总日报表</a></li>
            {% endif %}
          </ul>
        </li>
        {% if AGENT_OR_SUB !=3 %}
        <li {% if 'Financetool' == controller %}class="active"{% endif %}>
          <a href="/Financetool"><i class="fa fa-tachometer"></i> 财务工具
            <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
          </a>
          <ul class="treeview-menu">
            <li {% if 'Financetool' == controller and 'index' == action %}class="active"{% endif %}><a href="/Financetool"><i class="fa fa-circle-o"></i>财务信息</a></li>
            <li {% if 'Financetool' == controller and 'consumption' == action %}class="active"{% endif %}><a href="/Financetool/consumption"><i class="fa fa-circle-o"></i>财务记录</a></li>
            <li {% if 'Financetool' == controller and 'invoice' == action %}class="active"{% endif %}><a href="/Financetool/invoice"><i class="fa fa-circle-o"></i>发票开具</a></li>
          </ul>
        </li>
        {% endif %}
        {% endif %}
        {% if AGENT_OR_SUB !=3 %}
        <li {% if 'Index' == controller and 'updateinfo' == action %}class="active"{% endif %}>
          <a href="/Index/updateinfo?uid={{user_id}}">
            <i class="fa fa-user"></i> <span>修改个人资料</span>
          </a>
        </li>
        {% endif %}
        {% if AGENT_OR_SUB ==1 %}
            <li {% if 'Advertise' == controller and 'accounts' == action %}class="active"{% endif %}>
                <a href="/Advertise/accounts">
                  <i class="fa fa-users"></i> <span>代投企业账户</span>
                </a>
            </li>
        {% endif %}
      </ul>
    </section>
    <!-- /.sidebar -->
  </aside>
