% Pour les cases 0 et 7, les valeurs sont forcées à 1
intern_faire_liste_cp(_,[[0,1]],0).
intern_faire_liste_cp(P,Liste,NCase) :-
	nombre_pions(P,NCase,NPions),
	NCase1 is NCase - 1,
	intern_faire_liste_cp(P,SuiteListe,NCase1),
	Liste = [[NCase,NPions]|SuiteListe].

% UNIQUEMENT UTILISE PAR intern_case_cp_max
intern_set_max_cp_and_ncase(MaxCP,MaxNCase,CurrentCP,CurrentNCase,NewCP,NewNCase) :-
	NewCP > CurrentCP ->
	MaxCP = NewCP,
	MaxNCase = NewNCase ;
	MaxCP = CurrentCP,
	MaxNCase = CurrentNCase.

intern_case_cp_max([],_,0).
intern_case_cp_max(Liste,CaseMax,CPMax) :-
	Liste = [T|Q],
	T = [NCase,CP],
	intern_case_cp_max(Q,UnCaseMax,UnCPMax),
	intern_set_max_cp_and_ncase(CPMax,CaseMax,UnCPMax,UnCaseMax,CP,NCase).

%============================== PUBLIC ===============================

% construit la liste des CP disponibles pour chaque case du jeu du plateau P
faire_liste_cp(P,Liste) :-
	intern_faire_liste_cp(P,SuiteListe,6),
	Liste = [[7,1]|SuiteListe],!.
% Retourne la case correspondant au CP maximum sur le plateau P
case_cp_max(P,CaseMax,CPMax) :-
	faire_liste_cp(P,Liste),
	intern_case_cp_max(Liste,UnCaseMax,UnCPMax),
	CaseMax = UnCaseMax,
	CPMax = UnCPMax,!.

