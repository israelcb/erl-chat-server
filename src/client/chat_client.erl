-module(chat_client).

-include("../chat_config.hrl").
-include("../chat_interface.hrl").

-include("output.hrl").
-include("client_utils.hrl").

-import(client_utils, [print_userlist/1]).

-define(TIMEOUT, 5000).
-define(CREATE_LISTENER(), spawn(?MODULE, message_listen, [])).

-export([listen/0]).
-export([message_listen/0]).

listen() ->
	receive
		#cli__logout_succeded{} ->
			?OUT__LOGGING_OUT();

		#cli__unknown_sender{} ->
			?ERR__UNKNOWN_SENDER();

		#cli__message_sended{to=To} ->
			?OUT__MESSAGE_CONFIRM(To);

		#cli__unknown_user{who_name=Who} ->
			?ERR__UNKNOWN_USER(Who);

		#cli__userlist{usernames=Users} ->
			?OUT__USERLIST(),
			print_userlist(Users);

		#cli__username_taken{} ->
			?ERR__USERNAME_TAKEN();

		#cli__login_succeded{} ->
			start_listening(),
			?OUT__LOGGIN_SUCCEDED();

		#cli__already_logged{name=Name} ->
			start_listening(),
			?OUT__ALREADY_LOGGED(Name)
	end.

start_listening() ->
	case whereis(?CLI_LST) == undefined of
		true -> register(?CLI_LST, ?CREATE_LISTENER());
		_ -> ok
	end.

message_listen() ->
	receive
		#cli__message_receive{from_name=From, msg=Msg} ->
			?OUT__MSG(From, Msg);

		#cli__is_alive{pid=PID} ->
			?PERFORM_REQUEST(#srv__im_alive{pid=PID})
	end,
	message_listen().
