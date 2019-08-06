-module(server_actions).

-include("../chat_config.hrl").
-include("../chat_interface.hrl").
-include("output.hrl").
-include("server_utils.hrl").
-include("server_config.hrl").
-include("server_interface.hrl").

-export([register/3]).
-export([message_send/4]).
-export([userlist_request/2]).

-import(server_utils, [userlist/1]).
-import(server_utils, [search_user_by_name/2]).
-import(server_utils, [search_user_by_node/2]).

register(Users, Node, Name) ->
	case search_user_by_name(Name, Users) of
		undefined ->
			?PERFORM_LMA_ADD(Node, Name),
			?OUT__USER_LOGON(Name, Node),
			?TO_CLI(Node, #cli__login_succeded{});

		{Node, Name} ->
			?OUT__USER_RELOG(Node, Name),
			?TO_CLI(Node, #cli__already_logged{name=Name});

		_ ->
			?NOT__USER_EXISTS(Node, Name),
			?TO_CLI(Node, #cli__username_taken{})
	end.


message_send(Users, From, To, Msg) ->
	case search_user_by_node(From, Users) of
		undefined ->
			?NOT__UNKNOWN_MESSAGE_SENDER(From, To),
			?TO_CLI(From, #cli__unknown_sender{});

		{_, From_Name} ->
			case search_user_by_name(To, Users) of
				undefined ->
					?NOT__UNKNOWN_MESSAGE_RECEIVER(From, To),
					?TO_CLI(From, #cli__unknown_user{who_name=To});

				{To_Node, To_Name} ->
					?OUT__MESSAGE_SEND(From, To),
					?TO_CLI_LST(To_Node, #cli__message_receive{from_name=From_Name, msg=Msg}),
					?TO_CLI(From, #cli__message_sended{to=To_Name})
			end
	end.

userlist_request(Users, Node) ->
	case search_user_by_node(Node, Users) of
		undefined ->
			?NOT__UNKNOWN_USERLIST_REQUEST(Node),
			?TO_CLI(Node, #cli__unknown_sender{});

		{_, Name} ->
			?TO_CLI(Node, #cli__userlist{usernames=userlist(Users)}),
			?OUT__USERLIST_REQUEST(Name)
	end.