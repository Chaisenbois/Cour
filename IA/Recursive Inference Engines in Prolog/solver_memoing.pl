% gvim:  fileencoding=utf8

/** <module> Backtracking Inference Engine with (Side-effect) Memoïng

@author José Martinez
@see [[Polytechnic School of the University of Nantes][http://web.polytech.univ-nantes.fr/]]
@license All Rights Reserved

This code cannot be reproduced, copied, transmitted, etc., without the previous explicit authorisation of the author and/or the School.
It is provided only for a pedagogical usage at Polytech Nantes.

@version 1.1

__HISTORY__

   * 2014:  first version
   * June 2019:  refactoring;  documentation improvement

__USAGE__
  
To be imported by a problem (solution) module.

 */
   
:- module(solver_memoing, [ solver/4
                          ]).
:- meta_predicate solver(1, 4, ?, ?).

:- dynamic memoing/2.

%! solver(+F:  predicate(S:  state), +O:  predicate(D:  description, S:  state, NS:  state, C:  cost), +T:  state, -SS:  list(transition(D:  description, NS:  state, C:  cost))) is nondet.
%
% Backtracking solver with memoïng (and directed-cycle detection).
% It takes advantage of Prolog dynamic predicates in order to memoïse the solutions to sub-problems.
% This avoids the burden to carry on our own association list.
% Furthermore, it is much faster.
%
% This is the public predicate.
% It simply calls its internal counterpart, 'solver/5', after cleaning the memoïsing memory and with no ancestors.
%
% @arg F   The final state predicate.
% @arg O   The operation predicate where D is a description of the applied operation (basically its name), S is the original state, NS is the resulting state, and C is the cost of this transition.
% @arg I   The initial state.
% @arg SS  The path from the initial state to a final one, excluding the initial state.
%
solver(F, O, I, SS) :-
   retractall(memoing(_, _)),  % Cleaning up the memory state...
   solver(F, O, I, SS, []).    % ... before solving a new problem instance.

%! solver(+F:  predicate(S:  state), +O:  predicate(D:  description, S:  state, NS:  state, C:  cost), +S:  state, -SS:  list(transition(D:  description, NS:  state, C:  cost)), +AS:  list(state), +M:  list(solution(state, union(solution, none)))) is nondet.
%
% Backtracking solver with memoïng.
%
% This is apparently similar to the version with directed-cycle detection.
% The important difference is that all the states are recorded, not only the ones located in a path from the initial state to the current one.
% Hence, memory consumption rapidly becomes... exponential!
% No memory management is provided here.
% In other words, this version can be used only with toy applications.
%
% @arg F   The final state predicate.
% @arg O   The operation predicate where D is a description of the applied operation (basically its name), S is the original state, NS is the resulting state, and C is the cost of this transition.
% @arg S   The initial (or some) state.
% @arg SS  The path from the initial state to a final one, excluding the initial state.
% @arg AS  The ancestor states.
%
solver(F, _, S, [], _) :-     % There is no transition in the solution...
   call(F, S),                % ... should the given state already be a final one (i.e., final_state(S)).
   !.                         % And certainly do _not_ try to find redundant solutions as extensions of this one!
solver(_, _, S, _, AS) :-
   member(S, AS),             % Directed-cycle detection is enforced...
   !,                         % ... in order to avoid infinite searches...
   fail.                      % ... and, of course, there is no solution.
solver(_, _, S, SS, _) :-
   memoing(S, SS),            % If this state has already been reached and solved...
   !.                         % ... there is nothing else to do than to return the already found sub-solution.
solver(F, O, S, SS, AS) :-
   call(O, D, S, NS, C),      % In the general case, we apply a transformation...
   solver(F, O, NS, SS_NS, [S | AS]),            % ... then solve for it...
   SS = [transition(D, NS, C) | SS_NS],          % ... and extend the solution...
   memoing_shorter(S, SS).                       % ... before possibly adding or changing it in the memory state.

%! memoing_shorter(+S:  state, +SS:  list(transition(D:  description, NS:  state, C:  cost))) is det.
%
% Once a solution has been found, its association to the state to solve can be registered in the 'memoing/2' predicate.
% Furthermore, we keep track of the best solution so far, accordingly to its length not its summed up cost.
%
% @arg S   Some state.
% @arg SS  The shortest path so far from that state to a final one.
%
memoing_shorter(S, SS) :-
   \+ memoing(S, _),           % A state without previous solution...
   assert(memoing(S, SS)),     % ... is associated to its first found solution.
   !.
memoing_shorter(S, SS) :-
   memoing(S, SS_M),           % A state with already an associated solution, ...
   length(SS_M, N_SS_M),
   length(SS, N_SS),
   N_SS_M > N_SS,              % ... the length of which is strictly greater than the new one,
   retract(memoing(S, SS_M)),  % ... is replaced ...
   assert(memoing(S, SS)),     % ... by the new one.
   !.
memoing_shorter(_, _).         % Otherwise, the memory state remains (successfully) unchanged.
   











































































































/*

ANSWER TO THE LAST QUESTION

Not totally since we keep only the shortest paths.

'findall((X, Y), memoing(X, [step(_, Y)|_]), G), forall(member((X, Y), G), (write((X, Y)), nl)).' extract some edges.

*/

