/* ===========================================================================
    author : Abhayjit Sodhi
     first : 2022-11-28
    latest : 2023-09-05

    Widgets for binary trees and the 15 Puzzle
=========================================================================== */

% ============================================================================
% Widgets for a binary tree Q1-Q4
%-----------------------------------------------------------------------------
% empty_bintree/1
% Checks if the given tree is empty
%-----------------------------------------------------------------------------

empty_bintree([]).


%-----------------------------------------------------------------------------
% bintree_contains/2
%	Key: the integer being searched for
%	I: the integer in the tree given
%	L: the left tree (second argument of bt)
%	R: the right tree (third argument of bt)
% recursevely looks through a given tree until key is matched with an integer
%-----------------------------------------------------------------------------

:- dynamic bintree_contains/2.

bintree_contains(_, []).
bintree_contains(Key, [bt(Key,_,_)]).
bintree_contains(Key, [bt(I,L,_)]) :- bintree_contains(Key, L).
bintree_contains(Key, [bt(I,_,R)]) :- bintree_contains(Key, R).

%-----------------------------------------------------------------------------
% bintree_sum/2
%	Sum: all the keys added up
%	I: the integer in the tree given
%	L: the left tree (second argument of bt)
%	R: the right tree (third argument of bt)
% recursevely goes down the tree given and adds the integers to sum from each
% given tree
%-----------------------------------------------------------------------------

bintree_sum([], Sum) :- Sum = 0.
bintree_sum([bt(I,L,R)], Sum) :- 
	bintree_sum(L, Sum1),
	FS is I + Sum1,
	bintree_sum(R, Sum2),
	Sum is FS + Sum2.

%-----------------------------------------------------------------------------
% bintree_ordered/1
%	I: the integer in the tree given
%	L: the left tree (second argument of bt)
%	R: the right tree (third argument of bt)
% recursevely checks the tree to see if the left integer is smaller then the
% current integer and the right integer is greater then or equal to the
% current integer through all the trees
%-----------------------------------------------------------------------------
% bintree_left/2
%	Key: The integer being compared with
%	I: the integer from the given tree
% meant to check for left side of tree, so if the intger is less then Key
%-----------------------------------------------------------------------------
% bintree_right/2
%	Key: The integer being compared with
%	I: the integer from the given tree
% meant to check for right side of tree, so if the intger is greater or equal
% then Key
%-----------------------------------------------------------------------------

bintree_ordered([]).
bintree_ordered([bt(I,L,R)]) :-
	bintree_left(I,L),
	bintree_ordered(L),
	bintree_right(I,R),
	bintree_ordered(R).


bintree_left(Key, []).
bintree_left(Key, [bt(I,_,_)]) :- I<Key.


bintree_right(Key, []).
bintree_right(Key, [bt(I,_,_)]) :- I>=Key.


% ============================================================================
% Widgets for the 15 puzzle Q5-Q7
%-----------------------------------------------------------------------------
% is_legal_15/1
%	ST: The first list from the state
%	ND: The second list from the state
%	RD: The third list from the state
%	TH: The fourth list from the state
% checks each list for four elements each, then combines together and appends
% with a list 0-15 to check if an empty list is produced, aka there is 0-15
% only appearing once in the given state
%-----------------------------------------------------------------------------

is_legal_15([]) :- fail, !.
is_legal_15([ST,ND,RD|TH]) :- 
	length(ST, O),
	O =:= 4,
	length(ND, T),
	T =:= 4,
	length(RD, TH),
	TH =:= 4,
	length(TH, F),
	F =:= 4,
	append(ST,ND,X),
	append(RD,X,Y),
	append(TH,Y,Z),
	append(K, Z, [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]),
	K = [].

%-----------------------------------------------------------------------------
% manhattan_15/2
%	S: the state given by the user
%	Dis: the manhattan distance of the sum of distance from each tile
%-----------------------------------------------------------------------------
% manhattan_15/4
%	State: the state given by the user
%	Target: the state for which the given state must become
%	Num: the number being evaluated at that moment the states
%	Dis: the manhattan distance of the sum of distance from each tile
% recursevely looks for the distance for each tile (1-15) and returns the sum
% of all the distances
%-----------------------------------------------------------------------------

manhattan_15(S,Dis) :-
	O = [[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,0]],
	Num = 1,
	manhattan_15(S,O,Num,Dis).

manhattan_15(_,_,Num,_) :- Num =:= 16.
manhattan_15(State, Target, Num, Dis):-
	list_index(State,Num,SI),
	list_index(Target,Num,TI),
	abs_subt(SI, TI, S1),
	index_of_listlist(State,Num,I1),
	index_of_listlist(Target,Num,I2),
	abs_subt(I1,I2,S2),
	BS is S1+S2,
	NumN is Num+1,
	manhattan_15(State,Target,NumN, Sofar),
	Dis is BS + Sofar.

%-----------------------------------------------------------------------------
% list_index/3
%	L: a list from a bigger list
%	N: the number that is contained in one of the lists
%	LI: the index for the list in the bigger list
% looks for the value through a list holding 4 lists, and returns the index
% of where that list is located
%-----------------------------------------------------------------------------
% index_of_listlist/3
%	L: a list from a bigger list
%	N: the number that is contained in one of the lists
%	IL: the index for the number in the bigger list
% looks for the value through a list holding 4 lists, and returns the index
% of where that value is located
%-----------------------------------------------------------------------------

list_index([L|_],N,LI) :- member(N, L), LI = 0.
list_index([_,L|_],N,LI) :- member(N, L), LI = 1.
list_index([_,_,L|_],N,LI) :- member(N, L), LI = 2.
list_index([_,_,_|L],N,LI) :- member(N, L), LI = 3.
	
index_of_listlist([L|_],N,IL) :- nth0(IL,L,N).
index_of_listlist([_,L|_],N,LI) :- nth0(IL,L,N).
index_of_listlist([_,_,L|_],N,LI) :- nth0(IL,L,N).
index_of_listlist([_,_,_|L],N,LI) :- nth0(IL,L,N).

%-----------------------------------------------------------------------------
% abs_subt/3
%	V1: the first value being subtracted
%	V2: the second value being subtracted
%	Diff: the diffrence between the two given value
% looks for the bigger of the two values and subtracts it by the other value
% and returns the diffrence that should be positive
%-----------------------------------------------------------------------------
abs_subt(V1,V2,Diff) :- 
	V1<=V2,
	Diff is V2-V1.
abs_subt(V1,V2,Diff) :- 
	V1>V2,
	Diff is V1-V2.

%-----------------------------------------------------------------------------
% move_15/2
%	IN: Given state
%	OUT: changed state
% moves the tile from a given state to the left, right, up, or down
%-----------------------------------------------------------------------------
:- dynamic move_15/2

move_15([],_):- fail, !.
move_15(IN,OUT) :- left_15(IN,OUT).
move_15(IN,OUT) :- right_15(IN,OUT).
move_15(IN,OUT) :- up_15(IN,OUT).
move_15(IN,OUT) :- down_15(IN,OUT).


%-----------------------------------------------------------------------------
% left_15/2
%	S: the list found to have the 0 tile
%	O: the rest of the original lists given from the state
%	O1: the first original list from the state
%	O2: the second original list from the state
%	O3: the third original list from the state
%	NEW: the changed version of S
% finds the 0 tile, and switches with a tile to its left (if possible)
%-----------------------------------------------------------------------------
% right_15/2
%	S: the list found to have the 0 tile
%	O: the rest of the original lists given from the state
%	O1: the first original list from the state
%	O2: the second original list from the state
%	O3: the third original list from the state
%	NEW: the changed version of S
% finds the 0 tile, and switches with a tile to its right (if possible)
%-----------------------------------------------------------------------------
% up_15/2
%	S: the list found to have the 0 tile
%	S1: the list before the S list
%	O: the rest of the original lists given from the state
%	O1: the first original list from the state
%	O2: the second original list from the state
%	N: the changed version of S
%	N1: the changed version of S1
% finds the 0 tile, and switches with a tile from the list before it in the
% same position
%-----------------------------------------------------------------------------
% down_15/2
%	S: the list found to have the 0 tile
%	S1: the list after the S list
%	O: the rest of the original lists given from the state
%	O1: the first original list from the state
%	O2: the second original list from the state
%	N: the changed version of S
%	N1: the changed version of S1
% finds the 0 tile, and switches with a tile from the list after it in the
% same position
%-----------------------------------------------------------------------------

left_15([S|O],[NEW|O]) :- 
	nth0(I, S, 0, R),
	I =\= 0,
	I is I-1,
	nth0(I, NEW, 0, R).
left_15([O1,S|O],[O1,NEW|O]) :- 
	nth0(I, S, 0, R),
	I \== 0,
	I is I-1,
	nth0(I, NEW, 0, R).
left_15([O1,O2,S|O],[O1,O2,NEW|O]) :- 
	nth0(I, S, 0, R),
	I \== 0,
	I is I-1,
	nth0(I, NEW, 0, R).
left_15(O1,O2,O3|S],[O1,O2,O3|NEW]) :- 
	nth0(I, S, 0, R),
	I \== 0,
	I is I-1,
	nth0(I, NEW, 0, R).


right_15([S|O],[NEW|O]) :- 
	nth0(I, S, 0, R),
	I \== 3,
	I is I+1,
	nth0(I, NEW, 0, R).
right_15([O1,S|O],[O1,NEW|O]) :- 
	nth0(I, S, 0, R),
	I \== 3,
	I is I+1,
	nth0(I, NEW, 0, R).
right_15([O1,O2,S|O],[O1,O2,NEW|O]) :- 
	nth0(I, S, 0, R),
	I \== 3,
	I is I-1,
	nth0(I, NEW, 0, R).
right_15(O1,O2,O3|S],[O1,O2,O3|NEW]) :- 
	nth0(I, S, 0, R),
	I =\= 3,
	I is I+1,
	nth0(I, NEW, 0, R).

up_15([S|_],_) :- nth0(_,S,0), fail.
up_15([S1,S|O]),[N1,N|O]) :- 
	nth0(I,S,0,R),
	nth0(I,S1,X),
	nth0(I,N,X,R),
	nth0(_,S1,X,R1),
	nth0(I,N1,0,R1).
up_15([O1,S1,S|O]),[01,N1,N|O]) :- 
	nth0(I,S,0,R),
	nth0(I,S1,X),
	nth0(I,N,X,R),
	nth0(_,S1,X,R1),
	nth0(I,N1,0,R1).
up_15([O1,O2,S1|S]),[01,02,N1|N]) :- 
	nth0(I,S,0,R),
	nth0(I,S1,X),
	nth0(I,N,X,R),
	nth0(_,S1,X,R1),
	nth0(I,N1,0,R1).

down_15([_,_,_|S],_) :- nth0(_,S,0), fail.
down_15([S,S1|O]),[N,N1|O]) :- 
	nth0(I,S,0,R),
	nth0(I,S1,X),
	nth0(I,N,X,R),
	nth0(_,S1,X,R1),
	nth0(I,N1,0,R1).
down_15([O1,S,S1|O]),[01,N,N1|O]) :- 
	nth0(I,S,0,R),
	nth0(I,S1,X),
	nth0(I,N,X,R),
	nth0(_,S1,X,R1),
	nth0(I,N1,0,R1).
down_15([O1,O2,S|S1]),[01,02,N|N1]) :- 
	nth0(I,S,0,R),
	nth0(I,S1,X),
	nth0(I,N,X,R),
	nth0(_,S1,X,R1),
	nth0(I,N1,0,R1).
