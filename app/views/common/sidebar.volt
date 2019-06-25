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
        {% for user_menu in userMenu %}
          {% if user_menu['module_name'] == "User" %}
            {% set classname = 'fa-users' %}
            {% elseif user_menu['module_name'] == "Module" %}
            {% set classname = 'fa-calendar' %}
            {% elseif user_menu['module_name'] == "Index" %}
            {% set classname = 'fa-dashboard' %}
            {% else %}
            {% set classname = 'fa-folder' %}
          {% endif %}
        <li class="treeview{% if user_menu['module_name'] == controller %} active{% endif %}">
          <a href="#">
            <i class="fa {{classname}}">
            </i> <span>{{ user_menu['title']}}</span>
            <i class="fa fa-angle-left pull-right"></i>
          </a>
          <ul class="treeview-menu">
            {% for children in user_menu['children'] %}
              <li {% if children['module_name'] == controller and children['method_name'] == action %}class="active"{% endif %}><a href="{{type}}/{{ children['module_name'] }}/{{ children['method_name'] }}"><i class="fa fa-angle-double-right"></i>{{ children['title']}}</a></li>
            {% endfor %}
          </ul>
        </li>
        {% endfor %}
      </ul>
    </section>
    <!-- /.sidebar -->
  </aside>