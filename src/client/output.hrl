-include("../output.hrl").

-define(ITM__USERLIST(User), ?LOG(?ITM, "~p", [User])).

-define(OUT__USERLIST(), ?LOG(?OUT, "Userlist:")).
-define(OUT__LOGGING_OUT(), ?LOG(?OUT, "Logging out...")).
-define(OUT__MSG(From, Msg), ?LOG(?OUT, "~p: ~p", [From, Msg])).
-define(OUT__LOGGIN_SUCCEDED(), ?LOG(?OUT, "Login succeded, let's chat!!")).
-define(OUT__ALREADY_LOGGED(Name), ?LOG(?OUT, "Welcome back, ~p!!", [Name])).
-define(OUT__LOGGING(), ?LOG(?OUT, "You are not logged in yet, logging...")).
-define(OUT__MESSAGE_CONFIRM(To), ?LOG(?OUT, "Your message was send to ~p!", [To])).

-define(ERR__TIMEOUT(), ?LOG(?ERR, "Sorry, server is offline, aborting...")).
-define(ERR__UNKNOWN_SENDER(), ?LOG(?ERR, "You have been disconnected, shutting down...")).
-define(ERR__UNKNOWN_USER(Who), ?LOG(?ERR, "There is no user with name ~p logged in", [Who])).
-define(ERR__USERNAME_TAKEN(), ?LOG(?ERR, "Sorry, that username is already in use, aborting...")).
-define(ERR__SERVER_BUSY(), ?LOG(?ERR, "Sorry, the server is too busy handling your last request...")).
