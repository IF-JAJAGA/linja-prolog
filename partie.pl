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
plat([[6,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,6]]).

tour(_,0).
tour(J, N) :- 	N \== 0,
		plat(P),

		%%Jeu du joueur 0
		coupIA_random(P,J,LTodo),
		print(LTodo),
		modifier(P,J,LTodo,Pbuf),
		
		write('\nPlateau après un coup du joueur 0.'),
		print_plateau_tour(Pbuf, N),
		%sleep(3),

		%%Jeu du joueur 1
		%coupIA_...(Pbuf,J,LTodo)
		%modifier(Pbuf,J,LTodo,Pbuf2).

		retract(plat(P)), assert(plat(Pbuf)),
		N1 is N-1,
		JNext is -(J-1),
		!,	%On ne peut pas modifier les tours une fois qu'ils sont joués
		tour(JNext, N1).
