<div class="modal-header">
  <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
  <h4 class="modal-title">{{ role_name|e }}-用户列表</h4>
</div>

<div class="modal-body">
  <ul class="row">
    {% for index,user in user_list %}
    <li class="col-lg-4" style="margin-bottom: 6px;">
      <div class="label label-info text-ellipsis" style="width:100%;text-align:left;" title="{{user['username']}}({{user['realname']}})">{{user['username']}}({{user['realname']}})</div>
    </li>
    {% endfor %}
  </ul>
</div>

<div class="modal-footer">
  <button type="button" class="btn btn-default" data-dismiss="modal"> 关闭  </button>
</div>