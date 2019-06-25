<header class="main-header">
    <!-- Logo -->
    <a href="../index" class="logo">
      <!-- mini logo for sidebar mini 50x50 pixels -->
      <span class="logo-mini"><b>MAM</b></span>
      <!-- logo for regular state and mobile devices -->
      <span class="logo-lg"><b>广告自助投放系统</b></span>
    </a>
    <!-- Header Navbar: style can be found in header.less -->
    <nav class="navbar navbar-static-top">
      <!-- Sidebar toggle button-->
      <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </a>

      <div class="navbar-custom-menu">
        <ul class="nav navbar-nav">

          {% if IS_ADMIN is empty and IS_DEVEL is empty and AGENT_OR_SUB !=3 %}
          <li>
            <a href="/Ads/faq/#achor_31" target="_blank" title="操作指引">操作指引</a>
          </li>
          {% if short_message is not empty %}
          <!-- Notifications: style can be found in dropdown.less -->
          <li class="dropdown notifications-menu">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
              <i class="fa fa-bell-o"></i>
              <span class="label label-warning">1</span>
            </a>
            <ul class="dropdown-menu">
              <li class="header"></li>
              <li>
                <!-- inner menu: contains the actual data -->
                <ul class="menu">
                  <li>
                    <a href="/Index/main">
                      <i class="fa fa-warning text-yellow"></i>{{ short_message }}...
                    </a>
                  </li>
                </ul>
              </li>
              <li class="footer"></li>
            </ul>
          </li>
          {% endif %}{% endif %}

          <!-- User Account: style can be found in dropdown.less -->
          <li class="dropdown user user-menu">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
              <img src="/dist/img/avatar.jpg" class="user-image" alt="User Image">
              <span class="hidden-xs">{{ username }}</span>
            </a>
            <ul class="dropdown-menu">
              <!-- User image -->
              <li class="user-header">
                <img src="/dist/img/avatar.jpg" class="img-circle" alt="User Image">

                <p>
                  {{ username }}
                  <small>{{ email }}</small>
                </p>
              </li>
              <!-- Menu Footer-->
              <li class="user-footer">
                <div class="pull-left">
                  <a href="#" class="btn btn-default btn-flat">Profile</a>
                </div>
                <div class="pull-right">
                  <a href="{{logout}}" class="btn btn-default btn-flat">登出</a>
                </div>
              </li>
            </ul>
          </li>
        </ul>
      </div>
    </nav>
</header>