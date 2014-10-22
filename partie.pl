%Fichiers à charger
%consult(['IA_random.pl', 'regles.pl', 'deplacement.pl', 'partie.pl', 'ihm.pl']).

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
:-dynamic(tourNumero/1).
plat([[6,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,6]]).
tourNumero(0).

tour(_,0).
tour() :- 	plat(P),
		tourNumero(N),
		J1 is 0,
		J2 is 1,

		%%Jeu du joueur 1
		coupIA_random(P,J1,LTodo1),
		print(LTodo1),
		modifier(P,J1,LTodo1,Pbuf1),
		
		write('\nPlateau après un coup du joueur 1.'),
		print_plateau_tour(Pbuf1, N),
		%sleep(3),
		
		!,

		not(comp_fini(Pbuf1, P0, P1, G)),
		

		!,

		%%Jeu du joueur 2
		coupIA_random(Pbuf1,J2,LTodo2),
		modifier(Pbuf1,J2,LTodo2,Pbuf2),

		write('\nPlateau après un coup du joueur 2.'),
		print_plateau_tour(Pbuf2, N),
		%sleep(3),
		
		!,

		not(comp_fini(Pbuf1, P0, P1, G)),

		!,

		retract(plat(P)), assert(plat(Pbuf2)),
		N1 is N+1,
		retract(tourNumero(N)), assert(tourNumero(N1)),
		
		tour().
