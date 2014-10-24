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


test(CaseMax,CPMax) :-
	case_cp_max([[6,0],[1,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,6]],CaseMax,CPMax).
