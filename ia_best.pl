:- use_module('utils.pl').
:- use_module('regles.pl').
:- use_module('deplacement.pl').
:- use_module('IA_best_score.pl').

premier_coup_best(P,J,Coups) :-
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

coup_best(P,J,Coups) :-
	premier_coup_best(P,J,PremierCoup),

	PremierCoup = [[Depart,Deplacement]],
	Dest is Depart+Deplacement,
	nombre_pions(P,Dest,CP),!,

	modifier(P,J,PremierCoup,PBuf),
	supplementaireFinal(PBuf,CP,J,CoupsSuivants),
	append(PremierCoup,CoupsSuivants,CoupsTotal),
	est_licite(P,CoupsTotal,J),
	Coups = CoupsTotal,!.
