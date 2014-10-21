plateau([[12,0],[2,1],[0,0],[2,4],[1,0],[0,6],[3,0],[0,12]]).
plateau2([[0,12],[0,1],[0,5],[0,0],[1,0],[0,6],[3,0],[0,12]]).
plateau3([[0,12],[4,1],[0,5],[3,0],[0,0],[7,0],[26,0],[4,0]]).
plateau4([[0,12],[4,1],[0,5],[3,0],[0,0],[7,0],[26,0],[4,2]]).
plateau5([[0,12],[4,1],[0,5],[3,0],[0,0],[7,0],[26,6],[4,0]]).
plateau6([[0,12],[4,1],[0,5],[3,0],[0,0],[7,8],[26,0],[4,0]]).
test1([[1,2],[3,4],[5, 6],[1,1]]).
lzero([[12,0],[2,1],[0,0],[2,4]]).
lun([[12,0],[0,3],[6,0],[0,1]]).

comp_fini([],_,_,_).
comp_fini([A,B,C,D|L],P0,P1,G) :-
	L0 = [A,B,C,D],
	inverser_termes(L,LA),
	reverse(LA,L1),
	fini(0,L0),
	trouver_gagnant(L0,L1,P0,P1,G).

trouver_gagnant([],[],_,_,_).
trouver_gagnant(L0,L1,P0,P1,G) :-
	compter_points(L0,5,P0),
	compter_points(L1,5,P1),
	(P0 > P1 ->
		G is 0;
	(P1 > P0 ->
		G is 1;
	G is 2)).
	
	
inverser_termes([],L) :- 
	L = [].
inverser_termes([T|Q],L) :-
	reverse(T,R),
	inverser_termes(Q,P),
	L = [R|P].
	
	

fini(0,[]) :-
	print('FINI, EO').
fini(0,[T|Q]) :- 
	T = [TT|TQ],
	fini(TT,Q).

% il faut appeler avec la liste 2 inversée ses thermes et elle aussi inversé.
% on compte de 5 a 2.

compter_points(_,1,P) :-
	P is 0.
compter_points([T|Q],5,P) :-
	T=[TT|TQ],
	P2 is 5 * TT,
	compter_points(Q,4,PA),
	P is PA + P2.
compter_points([T|Q],PC,P) :-
	T=[TT|TQ],
	P2 is PC * TT,
	PC2 is PC - 1,
	compter_points(Q,PC2,PA),
	P is PA + P2.
	
	
% fonction "fini" : le jeu est fini ? --> utiliser la fonction reverse deux fois (petite et grande liste)!
% fonction "gagnant" : calculer les points de chaque jou
