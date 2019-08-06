-module(client_utils).

-include("output.hrl").

-export([print_userlist/1]).

print_userlist([]) -> ok;
print_userlist([User | Users]) ->
	?ITM__USERLIST(User),
	print_userlist(Users).
