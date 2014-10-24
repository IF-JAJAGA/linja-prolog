/*:- dynamic plateau/1.
plateau([[12,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,12]]).
:- include('deplacement.pl').
*/
:- module(regles,[est_licite/3,case_pleine/2]).
:- use_module('utils.pl').
:- use_module('deplacement.pl').


% Prouve que l'element d'indice N a pour valeur Val dans List.
% DEPRECATED !!!! Utiliser le prédicat prédéfini nth0
%nth_element(0,Val,[Val|_]).
%nth_element(N,Val,List) :-
%	List = [_|Q],
%	N1 is N-1,
%	nth_element(N1,Val,Q).

% Prouve qu'il reste CP1 points de mouvement après avoir utilisé Deplacement points sur les CP points au total
calcul_cp(Deplacement,CP,CP1) :-
	CP1 is CP - Deplacement.

% Prouve que tous les coups de la liste sont dans les limites du plateau.
sur_plateau([]).
sur_plateau(Coups) :-
	Coups = [T|Q],
	T = [Depart,PM],
	% PM peut être positif ou négatif selon le joueur
	Depart >= 0,
	Depart =< 7,
	Arrivee is Depart + PM,
	Arrivee >= 0,
	Arrivee =< 7,
	sur_plateau(Q),!.

joueur_existe(0).
joueur_existe(1).

% Prouve que le Joueur J a au moins un pion disponible pour chaque coup.
pion_joueur(_,_,[]).
pion_joueur(P,J,Coups) :-
	joueur_existe(J),
	Coups = [T|Q],
	T = [Depart,_],
	nth0(Depart,P,Case),
	nth0(J,Case,Npions),
	Npions > 0,
	pion_joueur(P,J,Q),!.


% Prouve que la case est pleine, toujours faux si l'on est dans les extrémités du plateau
case_pleine(P,Ncase) :-
	Ncase > 0,
	Ncase < 7,
	nombre_pions(P,Ncase,Npions),
	Npions >= 6.

% Prouve que les coups sont possibles pour le joueur J en CP mouvements.
intern_est_licite(P,Coups,J,CP) :-
	Coups = [Coup|[]],
	Coup = [Depart,PM],
	Arrivee is Depart + PM,
	not(case_pleine(P,Arrivee)),
	sur_plateau(Coups),
	pion_joueur(P,J,Coups),
	PM2 is PM * (1-2*J),
	calcul_cp(PM2,CP,CP2),
	Extrem is 7*(1-J),
	(Arrivee == Extrem ->
	CP2 >= 0;
	CP2 == 0).
intern_est_licite(P,Coups,J,CP) :-
	Coups = [T|Q],
	T = [Depart,Deplacement],
	Arrivee is Depart + Deplacement,
	not(case_pleine(P,Arrivee)),
	sur_plateau(Coups),
	pion_joueur(P,J,Coups),
	PM is Deplacement * (1-2*J),
	calcul_cp(PM,CP,CP2),
	intern_est_licite(P,Q,J,CP2).

est_licite(_,[],_,_).

est_licite(P,Coups,J,CP) :-
	intern_est_licite(P,Coups,J,CP).

est_licite(P,Coups,J) :-
	Coups = [T|Q],
	nth0(0,T,Depart),
	nth0(1,T,PM),
	Arrivee is Depart + PM,
	not(case_pleine(P,Arrivee)),
	sur_plateau(Coups),
	nombre_pions(P,Arrivee,CP),
	decrement(Depart,J,P,P2),
	increment(Arrivee,J,P2,P3),!,
	est_licite(P3,Q, J, CP),
	decrement(Arrivee,J,P3,P4),
	increment(Depart,J,P4,_),!.

% ======================================== TESTS ==========================================
:- begin_tests(regles).

test(calcul_cp_1) :-
	calcul_cp([],0).
test(calcul_cp_2) :-
	calcul_cp([[1,1],[1,2]],3).
test(calcul_cp_3) :-
	calcul_cp([[2,2]],2).

test(sur_plateau_1) :-
	not(sur_plateau([[-1,1]])).
test(sur_plateau_2) :-
	not(sur_plateau([[8,1]])).
test(sur_plateau_3) :-
	not(sur_plateau([[7,1]])).
test(sur_plateau_4) :-
	not(sur_plateau([[0,-1]])).
test(sur_plateau_5) :-
	sur_plateau([[7,-1]]).
test(sur_plateau_6) :-
	sur_plateau([[0,1]]).

test(case_pleine_1) :-
	not(case_pleine(0)).
test(case_pleine_2) :-
	not(case_pleine(7)).
test(case_pleine_3, [
											setup(switch_plateaux(Pold,[[3,0],[2,0],[6,0],[1,0],[0,1],[0,6],[0,3],[0,2]])),
											cleanup(switch_plateaux([[3,0],[2,0],[6,0],[1,0],[0,1],[0,6],[0,3],[0,2]],Pold))
										]) :-
	case_pleine(2).

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
