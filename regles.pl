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
sur_plateau([]).
sur_plateau(Coups) :-
	Coups = [T|_],
	nth_element(0,X,T),
	X >= 0,
	X =< 7.

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
	Npions > 0.

% Prouve que les coups sont possibles pour le joueur J en CP mouvements.
est_licite(Coups,J,CP) :-
	Coups = [T|Q],
	T = [TCoup|QCoup],
	sur_plateau(Coups),
	pion_joueur(J,Coups),
	calcul_cp(Coups,CP).
