
/*On compare si le jeu est fini, donc si un des deux joeurs a deplacé tous ces pions plus loin de la moitié. Si le jeu est fini il compte les points de chaque joueur et il les retourne, en retournant aussi le numéro du joueur qui a gagné.
comp_fini(Plateau,PointsJ0,PointsJ1,Gagnant) */

:- module(gagnant,[comp_fini/4]).

comp_fini([],_,_,_).
comp_fini([A,B,C,D|LA],P0,P1,G) :-
	L = [A,B,C,D],
	inverser_termes(L,L1),
	reverse(LA,L0),
	inverser_termes(LA,L01),
	(fini(0,L) | fini(0,L01)), 
	trouver_gagnant(L0,L1,P0,P1,G),
	tourNumero(N),
	write('P0 = '),writeln(P0),
	write('P1 = '),writeln(P1),
	write('G = '),writeln(G),
	write('N = '),writeln(N),
	joueurGagnant(Buf),
	retract(joueurGagnant(Buf)), assert(joueurGagnant(G)).

/*Il trouve le gagnant parmis deux joeurs...............
trouver_gagnant(......................) */	
trouver_gagnant([],[],_,_,_).
trouver_gagnant(L0,L1,P0,P1,G) :-
	compter_points(L0,5,P0),
	compter_points(L1,5,P1),
	(P0 > P1 ->
		G is 0;
	(P1 > P0 ->
		G is 1;
	G is 2)).
	
/*Il inverse les termes des listes qui font parti d'une liste de listes.
inverser_termes(ListeInitiale,ListeResultante) */	
inverser_termes([],L) :- 
	L = [].
inverser_termes([T|Q],L) :-
	reverse(T,R),
	inverser_termes(Q,P),
	L = [R|P].

/*Ça verifie si tous les premiers termes de chaque liste incluse dans une liste de listes est 0.
fini(NombreDuTermeAnterieur,Liste) */
fini(0,[]).
fini(0,[T|Q]) :- 
	T = [TT|TQ],
	fini(TT,Q).


/*Compter_points retourne le nombre de points dans une liste de listes, pour le premier terme de chaque sou-liste, en suivant le régles du jeu.
compter_points(ListeInitiale,PointsColonne,PointsCumulés). */
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

