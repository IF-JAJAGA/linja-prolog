%:- include('utils.pl').
%:- include('regles.pl').
/*
				      _
0 | 1 | 2 | 3 | 4 | 5 | 6 | 7
							-

On bouge le pion qui maximise le CP
Puis; avec le plus grand CP possible, on bouge uniquement le pion le plus loin
du milieu.

*/

:- use_module('utils.pl').
:- use_module('regles.pl').


premier_coup_rapide(P,J,Coups) :-
	joueur_a_pions(P,J,Possible),
	Deplacement is 1-2*J,
	Dest is Possible+Deplacement,
	case_cp_max(P,J,Dest,CP),

	PremierCoup = [[Possible,Deplacement]],
	est_licite(P,PremierCoup,J),
	Coups = PremierCoup,! ;

	% Si on ne trouve pas le coup qui maximise le CP, on prend le premier coup possible
	Deplacement is 1-2*J,
	joueur_a_pions(P,J,PossibleSinon),
	PremierCoup = [[PossibleSinon,Deplacement]],
	est_licite(P,PremierCoup,J),
	Coups = PremierCoup,!.

coup_rapide(P,J,Coups) :-
	premier_coup_rapide(P,J,PremierCoup),

	PremierCoup = [[Depart,Deplacement]],

	Dest is Depart+Deplacement,
	nombre_pions(P,Dest,CP),!,
	(joueur_a_pions(P,J,CasePossible),
	CPJ is CP * Deplacement,
	CoupSuivant = [[CasePossible,CPJ]],
	append(PremierCoup,CoupSuivant,CoupsPossibles),
	est_licite(P,CoupsPossibles,J),
	Coups = CoupsPossibles,!;
	Coups = PremierCoup).








intern_case_plus_avancee(P,J,NCase,NCaseFin) :-
	% Tant que le joueur n'a pas de pion du cote de son depart
	not(joueur_a_pions(P,J,NCase)) ->
	% Deplacement d'une case vers le départ
	NCase1 is NCase - (1-2*J),
	intern_case_plus_avancee(P,J,NCase1,NCaseFin) ; NCaseFin = NCase.

% Prouve que la case NCase est la case la plus proche du centre où J a au moins un pion
case_plus_avancee(P,J,NCase) :-
	%Milieu : 3 + J
	NCase1 is 3 + J,
	intern_case_plus_avancee(P,J,NCase1,NCase).


intern_case_moins_avancee(P,J,NCase,NCaseFin) :-
	% Tant que le joueur n'a pas de pion du cote de son depart
	not(joueur_a_pions(P,J,NCase)) ->
	% Deplacement d'une case vers le départ
	NCase1 is NCase + (1-2*J),
	intern_case_moins_avancee(P,J,NCase1,NCaseFin) ; NCaseFin = NCase.

% Prouve que la case NCase est la case la plus éloignée du centre où J a au moins un pion
case_moins_avancee(P,J,NCase) :-
	%Milieu : 3 + J
	NCase1 is 7*J,
	intern_case_moins_avancee(P,J,NCase1,NCase).

test(CaseMax,CPMax) :-
	case_cp_max([[6,0],[1,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,6]],CaseMax,CPMax).
