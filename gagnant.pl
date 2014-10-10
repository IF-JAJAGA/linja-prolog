plateau([[12,0],[2,1],[0,0],[2,4],[1,0],[0,6],[3,0],[0,12]]).
plateau2([[0,12],[0,1],[0,5],[0,0],[1,0],[0,6],[3,0],[0,12]]).
plateau3([[0,12],[4,1],[0,5],[3,0],[0,0],[7,0],[26,0],[4,0]]).
plateau4([[0,12],[4,1],[0,5],[3,0],[0,0],[7,0],[26,0],[4,2]]).
plateau5([[0,12],[4,1],[0,5],[3,0],[0,0],[7,0],[26,6],[4,0]]).
plateau6([[0,12],[4,1],[0,5],[3,0],[0,0],[7,8],[26,0],[4,0]]).
plateau7([[0,12],[0,1],[0,5],[0,0],[0,0],[0,0],[0,0],[0,0]]).

comp_fini([]).
comp_fini([A,B,C,D|L]) :-
	LI = [A,B,C,D],
%	inverser_thermes(L,LA),
	fini(0,LI),
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

	
%fonction "fini" : le jeu est fini ? --> utiliser la fonction reverse deux fois (petite et grande liste)!
%fonction "gagnant" : calculer les points de chaque jou
