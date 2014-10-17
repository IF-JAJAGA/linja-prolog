:- dynamic plateau/1.
plateau([[12,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,12]]).

% Prouve que l'element d'indice N a pour valeur Val dans List.
nth_element(0,Val,[Val|_]).
nth_element(N,Val,List) :-
	List = [_|Tail],
	nth_element(N1,Val,Tail),
	N is N1+1.

% Prouve que la liste de coups consomme CP points de mouvement.
calcul_cp(Coups,CP) :-
	Coups = [],
	CP = 0.
calcul_cp(Coups,CP) :-
	Coups = [T|Q],
	nth_element(1,X,T),
	calcul_cp(Q,CP1),
	CP is CP1 + X.

% Prouve que tous les coups de la liste sont dans les limites du plateau.
sur_plateau(_,[]).
sur_plateau(0,Coups) :-
	Coups = [T|Q],
	nth_element(0,Depart,T),
	nth_element(1,PM,T),
	Depart >= 0,
	Depart =< 7,
	Arrivee is Depart + PM,
	Arrivee >= 0,
	Arrivee =< 7,
	sur_plateau(0,Q),!.
sur_plateau(1,Coups) :-
	Coups = [T|Q],
	nth_element(0,Depart,T),
	nth_element(1,PM,T),
	Depart >= 0,
	Depart =< 7,
	Arrivee is Depart - PM,
	Arrivee >= 0,
	Arrivee =< 7,
	sur_plateau(1,Q),!.

joueur_existe(0).
joueur_existe(1).

% Prouve que le Joueur J a au moins un pion disponible pour chaque coup.
pion_joueur(_,[]).
pion_joueur(J,Coups) :-
	joueur_existe(J),
	plateau(P),
	Coups = [T|Q],
	nth_element(0,Depart,T),
	nth_element(Depart,Case,P),
	nth_element(J,Npions,Case),
	Npions > 0,
	pion_joueur(J,Q),!.

% Prouve que les coups sont possibles pour le joueur J en CP mouvements.
est_licite(Coups,J,CP) :-
	Coups = [T|Q],
	T = [TCoup|QCoup],
	sur_plateau(J,Coups),
	pion_joueur(J,Coups),
	calcul_cp(Coups,CP).

% ======================================== TESTS ==========================================
:- begin_tests(regles).

test(calcul_cp_1) :-
	calcul_cp([],0).
test(calcul_cp_2) :-
	calcul_cp([[1,1],[1,2]],3).
test(calcul_cp_3) :-
	calcul_cp([[2,2]],2).

test(sur_plateau_1) :-
	not(sur_plateau(0,[[-1,1]])).
test(sur_plateau_2) :-
	not(sur_plateau(0,[[8,1]])).
test(sur_plateau_3) :-
	not(sur_plateau(0,[[7,1]])).
test(sur_plateau_4) :-
	not(sur_plateau(1,[[0,1]])).
test(sur_plateau_5) :-
	sur_plateau(1,[[7,1]]).
test(sur_plateau_6) :-
	sur_plateau(0,[[0,1]]).

switch_plateaux(Pold,Pnew) :-
	plateau(Pold),
	retract(plateau(Pold)),
	assert(plateau(Pnew)).

test(pion_joueur, [
										setup(switch_plateaux(Pold,[[12,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,12]])),
										cleanup(switch_plateaux([[12,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,12]],Pold))
									]) :-
	pion_joueur(0,[[0,1]]),
	pion_joueur(0,[[0,1],[0,2]]).

test(est_licite) :-
	est_licite([[0,1]],0,1).

:- end_tests(regles).
