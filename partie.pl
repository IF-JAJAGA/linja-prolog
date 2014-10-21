%Fichiers à charger
%consult(['IA_random.pl', 'regles.pl', 'deplacement.pl', 'partie.pl', 'ihm.pl']).
:- include('IA_random.pl').
:- include('ihm.pl').

/*Lancement d'une partie à 20 itérations commencant avec le joueur 0:
	tour(0,20).
	Si on met beaucoup d'itérations, les pions passent tous de l'autre coté.
*/
/*
Lance une partie en gérant :
	- le tour des joueurs
	- l'affichage
	- le contrôle de fin de partie
	- le rendu des résultats.
*/

:-dynamic(plat/1).
plat([[6,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,6]]).

tour(_,0).
tour(J, N) :- 	N \== 0,
		plat(P),
		%print(P),
		premierCoupIA_random(P, J, LTodo1, CP), modifier(P, J, LTodo1, Pbuf1),
		write('\nPlateau après le premier coup.'),
		print_plateau_tour(Pbuf1, N),
		%sleep(1),
		supplementaireCoupIA_random(Pbuf1, J, LTodo2, CP), modifier(Pbuf1, J, LTodo2, Pbuf2),
		write('\nPlateau après les coups supplémentaires.'),
		print_plateau_tour(Pbuf2, N),
		%sleep(3),
		retract(plat(P)), assert(plat(Pbuf2)),
		N1 is N-1,
		JNext is -(J-1),
		!,	%On ne peut pas modifier les tours une fois qu'ils sont joués
		tour(JNext, N1).
