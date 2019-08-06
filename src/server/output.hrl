-include("../output.hrl").

-define(OUT__USER_EXIT(Node), ?LOG(?OUT, "~p exited", [Node])).
-define(OUT__SERVER_RUNNING(), ?LOG(?OUT, "Server is now running")).
-define(OUT__USER_RELOG(Node, Name), ?LOG(?OUT, "~p relog as ~p", [Node, Name])).
-define(OUT__USERLIST_REQUEST(Node), ?LOG(?OUT, "~p requested the userlist", [Node])).
-define(OUT__USER_LOGON(Name, Node), ?LOG(?OUT, "~p(~p) has logged in", [Name, Node])).
-define(OUT__MESSAGE_SEND(From, To), ?LOG(?OUT, "~p have sent a message to ~p", [From, To])).

-define(NOT__USER_EXISTS(Node, Name), ?LOG(?NOT, "~p tried to log with a existing name: ~p", [Node, Name])).
-define(NOT__UNKNOWN_USERLIST_REQUEST(Node), ?LOG(?NOT, "Unknown client(~p) tried to view the userlist", [Node])).
-define(NOT__UNKNOWN_MESSAGE_SENDER(From, To), ?LOG(?NOT, "Unknown client(~p) tried to send a message to ~p", [From, To])).
-define(NOT__UNKNOWN_MESSAGE_RECEIVER(From, To), ?LOG(?NOT, "~p tried to send a message to a unknown user (~p)", [From, To])).

-define(ERR__SERVER_ALREADY_UP(), ?LOG(?ERR, "Server already up")).
