:- include('regles.pl').
:- include('utils.pl').
/*

				      _
0 | 1 | 2 | 3 | 4 | 5 | 6 | 7
							-

On bouge le pion qui maximise le CP
Puis; avec le plus grand CP possible, on bouge uniquement le pion le plus loin
du milieu.

*/
plateau([[6,0],[1,1],[1,1],[1,1],[1,1],[1,1],[1,1],[0,6]]).

% Prouve que le joueur J a au moins un pion sur la case NCase
joueur_a_pions(P,J,NCase) :-
	nth_element(NCase,Case,P),
	nth_element(J,Npions,Case),
	Npions > 0,!.

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

test(Max) :-
	case_cp_max([[6,0],[1,1],[0,0],[0,0],[4,0],[0,0],[0,0],[0,6]],Max).

%generer_premier_coup(P,J) :-
	% Choisit un premier coup
