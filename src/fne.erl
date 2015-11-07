-module(fne).

-export([curry/1]).
-export([compose/0, compose/1]).

curry(F) when is_function(F) -> curry(F, []).
curry(F, Args) when is_function(F), is_list(Args)->
  {arity,Arity} = erlang:fun_info(F, arity),
  case length(Args) >= Arity of
    true  -> apply(F, lists:sublist(Args, Arity));
    false -> fun(Arg) -> curry(F, lists:flatten([Args, Arg])) end
  end.

compose()   -> compose([]).
compose([]) -> fun(X) -> X end;
compose(L)  -> fun(X) -> lists:foldr(fun(F, V) -> F(V) end, X, L) end.
