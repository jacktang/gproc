%%%-------------------------------------------------------------------
%%% @author Chen Slepher <slepher@issac.local>
%%% @copyright (C) 2016, Chen Slepher
%%% @doc
%%%
%%% @end
%%% Created : 22 Feb 2016 by Chen Slepher <slepher@issac.local>
%%%-------------------------------------------------------------------
-module(performance_test).

%% API

-export([register/1, send/0]).

%%%===================================================================
%%% API
%%%===================================================================

register(N) ->
    Self = self(),
    lists:foreach(
      fun(_) ->
      spawn(
        fun() ->
                gproc:reg({p, l, loop}),
                Self ! booted,
                loop()
        end)
      end, lists:seq(1, N)),
    Now = os:timestamp(),
    wait_reply(N),
    timer:now_diff(os:timestamp(), Now).

wait_reply(0) ->
    ok;
wait_reply(N) ->
    receive
        booted ->
            wait_reply(N - 1)
    end.

send() ->
    Now = os:timestamp(),
    gproc:send({p, l, loop}, hello),
    timer:now_diff(os:timestamp(), Now).

loop() ->
    receive 
        _X ->
            loop()
    end.

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

%%%===================================================================
%%% Internal functions
%%%===================================================================
