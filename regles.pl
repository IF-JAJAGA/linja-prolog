:- dynamic plateau/1.
plateau([[12,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,12]]).

% Prouve que l'element d'indice N a pour valeur Val dans List.
nth_element(0,Val,[Val|_]).
nth_element(N,Val,List) :-
	List = [_|Q],
	N1 is N-1,
	nth_element(N1,Val,Q).

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
sur_plateau([]).
sur_plateau(Coups) :-
	Coups = [T|Q],
	nth_element(0,X,T),
	!,
	X >= 0,
	X =< 7,
	sur_plateau(Q),!.

joueur_existe(0).
joueur_existe(1).

% Prouve que le Joueur J a au moins un pion disponible pour chaque coup.
pion_joueur(_,[]).
pion_joueur(J,Coups) :-
	joueur_existe(J),
	Coups = [T|Q],
	plateau(P),
	nth_element(0,Depart,T),
	nth_element(Depart,Case,P),
	nth_element(J,Npions,Case),
	!,
	Npions > 0,
	pion_joueur(J,Q),!.

% Prouve que les coups sont possibles pour le joueur J en CP mouvements.
est_licite(Coups,J,CP) :-
	Coups = [T|Q],
	T = [TCoup|QCoup],
	sur_plateau(Coups),
	pion_joueur(J,Coups),
	calcul_cp(Coups,CP).

% ======================================== TESTS ==========================================
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
	retract(plateau(Pold)),
	assert(plateau(Pnew)).

test(pion_joueur, [
										setup(switch_plateaux(Pold,[[12,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,12]])),
										cleanup(switch_plateaux([[12,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,12]],Pold))
									]) :-
	pion_joueur(0,[[0,1],[0,2]]).

test(est_licite) :-
	est_licite([[0,1]],0,1).

:- end_tests(regles).
