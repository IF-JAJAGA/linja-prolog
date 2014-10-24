:- module(utils, [nombre_pions/3,faire_liste_cp/2,case_cp_max/4,joueur_a_pions/3]).

% Pour les cases 0 et 7, les valeurs sont forcées à 1
intern_faire_liste_cp(_,[[0,1]],0).
intern_faire_liste_cp(P,Liste,NCase) :-
	nombre_pions(P,NCase,NPions),
	NCase1 is NCase - 1,
	intern_faire_liste_cp(P,SuiteListe,NCase1),
	Liste = [[NCase,NPions]|SuiteListe].

% UNIQUEMENT UTILISE PAR intern_case_cp_max
intern_set_max_cp_and_ncase(0,MaxCP,MaxNCase,CurrentCP,CurrentNCase,NewCP,NewNCase) :-
	NewCP > CurrentCP ->
	MaxCP = NewCP,
	MaxNCase = NewNCase ;
	MaxCP = CurrentCP,
	MaxNCase = CurrentNCase.
intern_set_max_cp_and_ncase(1,MaxCP,MaxNCase,CurrentCP,CurrentNCase,NewCP,NewNCase) :-
	NewCP >= CurrentCP ->
	MaxCP = NewCP,
	MaxNCase = NewNCase ;
	MaxCP = CurrentCP,
	MaxNCase = CurrentNCase.

intern_case_cp_max(_,[],_,0).
intern_case_cp_max(J,Liste,CaseMax,CPMax) :-
	Liste = [T|Q],
	T = [NCase,CP],
	intern_case_cp_max(J,Q,UnCaseMax,UnCPMax),
	intern_set_max_cp_and_ncase(J,CPMax,CaseMax,UnCPMax,UnCaseMax,CP,NCase).

intern_joueur_a_pions(P,J,NCase) :-
	NCase1 = NCase,
	nth0(NCase1,P,Case),
	nth0(J,Case,Npions),
	Npions > 0.

%============================== PUBLIC ===============================

% Prouve que la case Ncase a Npions
nombre_pions(P,Ncase,Npions) :-
	nth0(Ncase,P,Case),
	nth0(0,Case,P0),
	nth0(1,Case,P1),
	Npions is P0 + P1.

% construit la liste des CP disponibles pour chaque case du jeu du plateau P
faire_liste_cp(P,Liste) :-
	intern_faire_liste_cp(P,SuiteListe,6),
	Liste = [[7,1]|SuiteListe],!.
% Retourne la case correspondant au CP maximum sur le plateau P
case_cp_max(P,J,CaseMax,CPMax) :-
	faire_liste_cp(P,Liste),
	intern_case_cp_max(J,Liste,UnCaseMax,UnCPMax),
	CaseMax = UnCaseMax,
	CPMax = UnCPMax,!.

% Prouve que le joueur J a au moins un pion sur la case NCase
joueur_a_pions(P,0,NCase) :-
	intern_joueur_a_pions(P,0,NCase).
joueur_a_pions(P,1,NCase) :-
	reverse(P,P2),
	intern_joueur_a_pions(P2,1,NCase1),
	NCase is 7-NCase1.
