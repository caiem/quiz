{{ partial('common/header',["title":"Log in"]) }}
</head>
<body class="hold-transition login-page">
<div class="login-box">
  <div class="login-logo">
    <b>广告自助投放系统</b>
  </div>
  <!-- /.login-logo -->
  <div class="login-box-body">
    <p class="login-box-msg">用户登录</p>

    <form action="/index/login" method="post">
      <div class="form-group has-feedback">
        <input type="text" class="form-control" value="{{post_username|default('')}}" placeholder="Username" name="username">
        <span class="glyphicon glyphicon-user form-control-feedback"></span>
      </div>
      <div class="form-group has-feedback">
        <input type="password" class="form-control" value="{{post_password|default('')}}" placeholder="Password" name="password">
        <span class="glyphicon glyphicon-lock form-control-feedback"></span>
      </div>
      <div class="form-group has-feedback">
        <input type="text" class="form-control" placeholder="Captcha" name="vcode">
        <img onclick="javascript:this.src='/index/captcha?_='+Math.random()" style="width:80px;z-index:1000;pointer-events:auto;cursor:pointer;" src="/index/captcha" class="glyphicon glyphicon-code form-control-feedback"/>
      </div>
      {%if error_msg|default('') %}
      <div class="form-group has-feedback error_notice" style="text-align:center;color:red;">
        {{ error_msg }}
      </div>
      {%endif%}
      <div class="row">
        <!-- /.col -->
        <div class="col-xs-4">
          <button type="submit" class="btn btn-primary btn-block btn-flat">登录</button>
        </div>
        <!-- /.col -->
      </div>
    </form>
  </div>
  <!-- /.login-box-body -->
</div>
<!-- /.login-box -->
    {{ partial('common/footer') }}
    <script>
    function hide_div(){
        $('.error_notice').remove();
    }
    $(function(){
        setTimeout('hide_div()',3000 );
    })
    </script>
    </body>
</html>