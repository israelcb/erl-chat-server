-import(io, [format/1]).
-import(io, [format/2]).
-import(string,[concat/2]).

-define(MSG_FMT(Type, Msg), concat(concat(Type, concat(" ", Msg)), "~n")).

-define(LOG(Type, Msg), format(?MSG_FMT(Type, Msg))).
-define(LOG(Type, Msg, Params), format(?MSG_FMT(Type, Msg), Params)).

-define(ITM, "->").
-define(OUT, ">>").
-define(NOT, "!>").
-define(ERR, "!!").