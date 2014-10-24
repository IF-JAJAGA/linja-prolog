%Fichiers à charger
:- include('IA_random.pl').
:- include('ihm.pl').
:- use_module('gagnant.pl').
:- use_module('regles.pl').
:- use_module('utils.pl').
:- use_module('deplacement.pl').
:- include('ia_rapide.pl').
:- include('IA_best_score.pl').

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
:-dynamic(joueurGagnant/1).
plat([[6,0],[1,1],[1,1],[1,1],[1,1],[1,1],[1,1],[0,6]]).
tourNumero(0).
joueurGagnant(0).

jeu:-
	create_plateau,
	tour,
	free_GUI_components.

tour(_,0).
tour :- 	plat(P),
			
		%nextStep(P),
		tourNumero(N),
		J1 is 0,
		J2 is 1,

		%%Jeu du joueur 1
		%coup_rapide(P, J1, LTodo1),
		%write('avant J1'),
		coupIA_ToTheEnd(P, J1, LTodo1),
		%write('après J1'),
		%coupIA_random(P,J1,LTodo1),
		print(LTodo1),
		modifier(P,J1,LTodo1,Pbuf1),
		
		write('\nPlateau après un coup du joueur 1.'),
		print(Pbuf1),
		print_plateau_tour(Pbuf1, N),
		%nextStep(Pbuf1),
		%sleep(3),
		
		!,

		not(comp_fini(Pbuf1, P0, P1, G)),

		!,

		%%Jeu du joueur 2
		coup_rapide(Pbuf1, J2, LTodo2),
		%coupIA_random(Pbuf1,J2,LTodo2),
		%coupIA_ToTheEnd(Pbuf1, J2, LTodo2),
		print(LTodo2),
		modifier(Pbuf1,J2,LTodo2,Pbuf2),

		write('\nPlateau après un coup du joueur 2.'),
		print(Pbuf2),
		print_plateau_tour(Pbuf2, N),
		
		%sleep(3),
		
		!,

		not(comp_fini(Pbuf1, P0, P1, G)),

		!,

		retract(plat(P)), assert(plat(Pbuf2)),
		N1 is N+1,
		retract(tourNumero(N)), assert(tourNumero(N1)),
		
		tour.
%incrementStat(NP0, NP1, 0)
incrementStat(1, 0, 0). 
incrementStat(0, 1, 1).
incrementStat(0, 0, 2).
statistiques(0,0,0).
statistiques(NP0, NP1, NBParties) :-	not(tour),
					!,

					joueurGagnant(G),
					incrementStat(NP0Buf, NP1Buf, G),
					NBPartiesNew is NBParties-1,

					%retract(plat(P)), assert(plat([[6,0],[1,1],[1,1],[1,1],[1,1],[1,1],[1,1],[0,6]])),

					statistiques(NP0New, NP1New, NBPartiesNew),
					NP0 is NP0New + NP0Buf,
					NP1 is NP1New + NP1Buf.
