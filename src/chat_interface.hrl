%% Server requests
-record(srv__request, {node, request}).

-record(srv__logout, {}).
-record(srv__im_alive, {pid}).
-record(srv__register, {name}).
-record(srv__userlist_request, {}).
-record(srv__message_send, {name, msg}).

%% Server responses
-record(cli__is_alive, {pid}).
-record(cli__login_succeded, {}).
-record(cli__unknown_sender, {}).
-record(cli__username_taken, {}).
-record(cli__logout_succeded, {}).
-record(cli__message_sended, {to}).
-record(cli__userlist, {usernames}).
-record(cli__already_logged, {name}).
-record(cli__unknown_user, {who_name}).
-record(cli__message_receive, {from_name, msg}).
