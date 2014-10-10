plateau([[12,0],[2,1],[0,0],[2,4],[1,0],[0,6],[3,0],[0,12]]).

comp_fini([]).
comp_fini(A,B,C,D|L) :-
	LI = (A,B,C,D)
	inverser_thermes(L,LA),
	fini(LI) OR fini(LA).
	%je sais pas comment écrire le OR.
	
inverser_thermes([],[]).
inverser_thermes([T|Q],L) :-
	(reverse(T),R),
	R2 = (L,R),
	inverser_thermes(Q,R2).
	
	

fini([]).
fini([T|Q]) :- 
	T = [TT|TQ],
	TT == 0,
	fini (Q).

	
%fonction "fini" : le jeu est fini ? --> utiliser la fonction reverse deux fois (petite et grande liste)!
%fonction "gagnant" : calculer les points de chaque jou
