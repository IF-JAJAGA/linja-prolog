plateau([[12,0],[2,1],[0,0],[2,4],[1,0],[0,6],[3,0],[0,12]]).
plateau2([[0,12],[0,1],[0,5],[0,0],[1,0],[0,6],[3,0],[0,12]]).
plateau3([[0,12],[4,1],[0,5],[3,0],[0,0],[7,0],[26,0],[4,0]]).
plateau4([[0,12],[4,1],[0,5],[3,0],[0,0],[7,0],[26,0],[4,2]]).
plateau5([[0,12],[4,1],[0,5],[3,0],[0,0],[7,0],[26,6],[4,0]]).
plateau6([[0,12],[4,1],[0,5],[3,0],[0,0],[7,8],[26,0],[4,0]]).

comp_fini([]).
comp_fini([A,B,C,D|L]) :-
	LI = [A,B,C,D],
%	inverser_thermes(L,LA),
	fini(0,LI).
%	fini(0,LA).
	
	
%inverser_thermes([],R) .
%inverser_thermes([T|Q],L) :-
%	reverse(T,R),
%	R2 = (L,R),
%	inverser_thermes(Q,R2).
	
	

fini(0,[]).
fini(0,[T|Q]) :- 
	T = [TT|TQ],
	fini(TT,Q).

% il faut appeler avec la liste 2 inversée ses thermes et elle aussi inversé.
% on compte de 5 a 2.
%compter_points(_,1,P).
%compter_points([T|Q],5,P) :-
%	T=[TT|TQ],
%	P is 5 * TT,
%	PC2 is 4,
%	compter_points(Q,PC2,P).
%compter_points([T|Q],PC,P) :-
%	T=[TT|TQ],
%	P2 is PC * TT,
%	P3 is P2 + P,
%	PC2 is PC - 1,
%	compter_points(Q,PC2,P3).

	
	
% fonction "fini" : le jeu est fini ? --> utiliser la fonction reverse deux fois (petite et grande liste)!
% fonction "gagnant" : calculer les points de chaque jou
