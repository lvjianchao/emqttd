%%-----------------------------------------------------------------------------
%% Copyright (c) 2012-2015, Feng Lee <feng@emqtt.io>
%% 
%% Permission is hereby granted, free of charge, to any person obtaining a copy
%% of this software and associated documentation files (the "Software"), to deal
%% in the Software without restriction, including without limitation the rights
%% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%% copies of the Software, and to permit persons to whom the Software is
%% furnished to do so, subject to the following conditions:
%% 
%% The above copyright notice and this permission notice shall be included in all
%% copies or substantial portions of the Software.
%% 
%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
%% SOFTWARE.
%%------------------------------------------------------------------------------


%%------------------------------------------------------------------------------
%%
%% The Session state in the Server consists of:
%% The existence of a Session, even if the rest of the Session state is empty.
%% The Client’s subscriptions.
%% QoS 1 and QoS 2 messages which have been sent to the Client, but have not been completely
%% acknowledged.
%% QoS 1 and QoS 2 messages pending transmission to the Client.
%% QoS 2 messages which have been received from the Client, but have not been completely
%% acknowledged.
%% Optionally, QoS 0 messages pending transmission to the Client.
%%
%%------------------------------------------------------------------------------

-module(emqtt_sm).

%%emqtt session manager...

%%cleanSess: true | false

-include("emqtt.hrl").

-behaviour(gen_server).

-define(SERVER, ?MODULE).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start_link/1]).

-export([lookup/1, register/2, resume/2, destroy/1]).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-record(state, { expires = 24, %hours 
                 max_queue = 1000 }).


%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link(SessOpts) ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [SessOpts], []).

lookup(ClientId) -> ok.

register(ClientId, Pid) -> ok.

resume(ClientId, Pid) -> ok.

destroy(ClientId) -> ok.

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

init(SessOpts) ->
    State = #state{ expires = proplists:get_value(expires, SessOpts, 24) * 3600, 
                    max_queue = proplists:get_value(max_queue, SessOpts, 1000) },
    {ok, State}.


handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

