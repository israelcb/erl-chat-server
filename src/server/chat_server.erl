-module(chat_server).

-include("../chat_config.hrl").
-include("../chat_interface.hrl").
-include("output.hrl").
-include("server_utils.hrl").
-include("server_config.hrl").
-include("server_interface.hrl").

-import(server_utils, [logout/2]).
-import(server_utils, [userlist/1]).
-import(server_utils, [remove_event_waits/2]).

-export([start/0]).
-export([server/0]).
-export([list_manager/1]).

start() ->
	case whereis(?SRV) of
		undefined ->
			register(?SRV, spawn(?MODULE, server, [])),
			register(?LMA, spawn(?MODULE, list_manager, [#lma__data{}])),
			?OUT__SERVER_RUNNING();
		_ ->
			?ERR__SERVER_ALREADY_UP()
	end.

server() ->
	receive
		#srv__request{node=Node, request=Req} ->
			case Req of
				#srv__logout{} ->
					?PERFORM_LMA_REMOVE(Node),
					?TO_CLI(Node, #cli__logout_succeded{});

				#srv__im_alive{pid=PID} ->
					PID ! true;

				#srv__register{name=Name} ->
					?PERFORM_LMA_DO(register, [Node, Name]);

				#srv__userlist_request{} ->
					?PERFORM_LMA_DO(userlist_request, [Node]);

				#srv__message_send{name=Name, msg=Msg} ->
					?PERFORM_LMA_DO(message_send, [Node, Name, Msg])
			end
	end,
	server().

list_manager(Data = #lma__data{users=Users, event_waits=EventWaits}) ->
	receive
		?LMA_ADD(Node, Name) ->
			list_manager(Data#lma__data{users=[{Node, Name} | logout(Node, Users)]});

		?LMA_REMOVE(Node) ->
			list_manager(
				Data#lma__data{
					users=logout(Node, Users),
					event_waits=remove_event_waits(?LMA_REMOVE_EVENT(Node), EventWaits)
				}
			);

		?LMA_DO(What, Params) ->
			spawn(server_actions, What, [Users | Params]),
			list_manager(Data);

		EventWait = ?LMA_WAIT(_Event, _From) ->
			list_manager(Data#lma__data{event_waits=[EventWait | EventWaits]})
	end.
