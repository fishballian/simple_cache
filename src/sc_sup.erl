%% @author fishballian
%% @doc @todo Add description to sc_sup.


-module(sc_sup).
-behaviour(supervisor).
-export([init/1]).
-define(SERVER, ?MODULE).
%% ====================================================================
%% API functions
%% ====================================================================
-export([start_link/0]).

start_link() ->
	supervisor:start_link({local, ?SERVER}, ?MODULE, []).




%% ====================================================================
%% Behavioural functions 
%% ====================================================================

%% init/1
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/supervisor.html#Module:init-1">supervisor:init/1</a>
-spec init(Args :: term()) -> Result when
	Result :: {ok, {SupervisionPolicy, [ChildSpec]}} | ignore,
	SupervisionPolicy :: {RestartStrategy, MaxR :: non_neg_integer(), MaxT :: pos_integer()},
	RestartStrategy :: one_for_all
					 | one_for_one
					 | rest_for_one
					 | simple_one_for_one,
	ChildSpec :: {Id :: term(), StartFunc, RestartPolicy, Type :: worker | supervisor, Modules},
	StartFunc :: {M :: module(), F :: atom(), A :: [term()] | undefined},
	RestartPolicy :: permanent
				   | transient
				   | temporary,
	Modules :: [module()] | dynamic.
%% ====================================================================
init([]) ->
    ElementSup = {sc_element_sup, {sc_element_sup, start_link, []},
				  permanent, 2000, supervisor, [sc_element]},
	EventManager = {sc_event, {sc_event, start_link, []},
					permanent, 2000, worker, [sc_event]},
	Children = [ElementSup, EventManager],
	RestartStrategy = {one_for_one, 4, 3600},
    {ok,{RestartStrategy, Children}}.

%% ====================================================================
%% Internal functions
%% ====================================================================


