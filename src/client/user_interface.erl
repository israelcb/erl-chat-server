-module(user_interface).

-include("../chat_config.hrl").
-include("../chat_interface.hrl").

-include("output.hrl").
-include("client_utils.hrl").

-define(CREATE_LISTENER(), spawn(chat_client, listen, [])).

-export([logon/1]).
-export([logout/0]).
-export([message/2]).
-export([userlist/0]).

request(Req) ->
	case whereis(?CLI) of
		undefined ->
			?PERFORM_REQUEST(Req),
			register(?CLI, ?CREATE_LISTENER());

		_ ->
			?ERR__SERVER_BUSY()
	end,
	ok.

logout() ->
	case whereis(?CLI_LST) /= undefined of
		true -> unregister(?CLI_LST);
		_ -> ok
	end,
	request(#srv__logout{}).

logon(Name) -> request(#srv__register{name=Name}).

userlist() -> request(#srv__userlist_request{}).

message(Who, Msg) -> request(#srv__message_send{name=Who, msg=Msg}).
