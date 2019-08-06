-define(TO_LMA(Req), ?LMA ! Req).
-define(TO_CLI(Node, Req), {?CLI, Node} ! Req).
-define(TO_CLI_LST(Node, Req), {?CLI_LST, Node} ! Req).

-define(LMA_REMOVE(Node), #lma__remove_user{node=Node}).
-define(LMA_DO(What, Params), #lma__do{what=What, params=Params}).
-define(LMA_ADD(Node, Name), #lma__add_user{node=Node, name=Name}).
-define(LMA_WAIT(Event), ?LMA_WAIT(Event, self())).
-define(LMA_WAIT(Event, From), #lma__wait{event=Event, from=From}).

-define(LMA_REMOVE_EVENT(Node), #lma__remove_user_event{node=Node}).

-define(PERFORM_LMA_WAIT(Event), ?TO_LMA(?LMA_WAIT(Event))).
-define(PERFORM_LMA_REMOVE(Node), ?TO_LMA(?LMA_REMOVE(Node))).
-define(PERFORM_LMA_ADD(Node, Name), ?TO_LMA(?LMA_ADD(Node, Name))).
-define(PERFORM_LMA_DO(What, Params), ?TO_LMA(?LMA_DO(What, Params))).
