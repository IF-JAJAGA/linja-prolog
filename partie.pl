%consult(['deplacement.pl' ,  'gagnant.pl' , 'ihm.pl' , 'partie.pl' , 'regles.pl' , 'test_regles.pl']).
/*
Lance une partie en gérant :
	- le tour des joueurs
	- l'affichage
	- le contrôle de fin de partie
	- le rendu des résultats.
*/

:-dynamic(plat/1).
plat([[6,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,6]]).

tour(J, N) :- 	N \== 0,
		plat(P),
		print(P),
		premierCoupIA_random(P, J, LTodo1, CP), modifier(P, J, LTodo1, Pbuf1),
		%print_ihm(Pbuf1),
		%sleep(1),
		supplementaireCoupIA_random(Pbuf1, J, LTodo2, CP), modifier(Pbuf1, J, LTodo2, Pbuf2),
		%print_ihm(Pbuf2),
		%sleep(2),
		retract(plat(P)), assert(plat(Pbuf2)),
		N1 is N-1,
		JNext is -(J-1),
		tour(JNext, N1).
