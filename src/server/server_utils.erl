-module(server_utils).

-include("../chat_config.hrl").
-include("../chat_interface.hrl").
-include("output.hrl").
-include("server_utils.hrl").
-include("server_config.hrl").
-include("server_interface.hrl").

-export([logout/2]).
-export([userlist/1]).
-export([remove_event_waits/2]).
-export([search_user_by_name/2]).
-export([search_user_by_node/2]).

-define(TIMEOUT, 10).

search_user_by_name(_, []) -> undefined;
search_user_by_name(Name, [User = {UserNode, UserName} | Rest]) ->
	NodeCheck = check_node(UserNode),
	if
		Name == UserName andalso NodeCheck ->
			User;

		true ->
			search_user_by_name(Name, Rest)
	end.


search_user_by_node(_, []) -> undefined;
search_user_by_node(Node, [User = {UserNode, _} | Rest]) ->
	NodeCheck = check_node(UserNode),
	if
		Node == UserNode andalso NodeCheck ->
			User;

		true ->
			search_user_by_node(Node, Rest)
	end.


logout(Node, Users) -> logout(Node, Users, []).

logout(_, [], New_List) -> New_List;
logout(Node, [User = {UserNode, _} | Users], New_List) ->
	if
		Node == UserNode ->
			?OUT__USER_EXIT(Node),
			logout(Node, Users, New_List);

		true ->
			logout(Node, Users, [User | New_List])
	end.


userlist(Users) -> userlist(Users, []).

userlist([], Names) -> Names;
userlist([{Node, Name} | Users], Names) ->
	case check_node(Node) of
		true -> userlist(Users, [Name | Names]);
		_ -> userlist(Users, Names)
	end.

check_node(Node) ->
	?TO_CLI_LST(Node, #cli__is_alive{pid=self()}),
	receive
		_ -> true
	after ?TIMEOUT ->
		Event = ?LMA_REMOVE_EVENT(Node),
		?PERFORM_LMA_WAIT(Event),
		?PERFORM_LMA_REMOVE(Node),
		receive Event -> false end
	end.

remove_event_waits(Event, EventWaits) ->
	remove_event_waits(Event, EventWaits, []).

remove_event_waits(_, [], Result) -> Result;
remove_event_waits(
	Event,
	[EventWait = ?LMA_WAIT(CurrentEvent, From)
	| EventWaits],
	Remaining
) ->
	if
		Event == CurrentEvent ->
			From ! Event,
			remove_event_waits(Event, EventWaits, Remaining);
		true ->
			remove_event_waits(Event, EventWaits, [EventWait | Remaining])
	end.