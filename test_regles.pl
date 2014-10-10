:- include('regles.pl').
:- begin_tests(regles).

test(calcul_cp) :-
	calcul_cp([],0),
	calcul_cp([[1,1],[1,2]],3),
	calcul_cp([[2,2]],2).

test(sur_plateau) :-
	not(sur_plateau([-1,1])),
	not(sur_plateau([8,1])).

switch_plateaux(Pold,Pnew) :-
	plateau(Pold),
	print(Pold),
	retract(plateau(Pold)),
	assert(plateau(Pnew)).

test(pion_joueur, [P = [[12,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,12]],
										setup(switch_plateaux(Pold,P)),
										cleanup(switch_plateaux(P,Pold))
									]) :-
	pion_joueur(0,[[1,1],[2,2]]).

test(est_licite) :-
	est_licite([[0,1]],0,1).

:- end_tests(regles).
