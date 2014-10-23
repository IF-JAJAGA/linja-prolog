/*
Les différentes fonctions implémentées dans ce fichier :
	- copy (List1, List2) : copie List1 dans List2
	- decrement (NumColonne, NumJoueur, OldPlateau, NewPlateau) : Retrait du pion joué par NumJoueur de la NumColonne du Oldplateau.
			Retourne NewPlateau, correspondant à ces changements
	- increment (NumColonne, NumJoueur, OldPlateau,NewPlateau) : idem que decrement mais en incrémentant
	- findCP (NumColonne, Plateau, CP) : Cherche le nombre de pion AVANT de joueur le premier coup
			Retourne CP, correspondant à ce nombre de pions
	- modifier (OldPlateau, NumJoueur, ListeDéplacement, NewPlateau) : Fonction principale modifiant le plateau OldPlateau en fonction de la ListeDéplacements et du NumJoueur.
			Retourne NewPlateau correspondant à la modification de OldPlateau
*/


%copy : copie la première liste dans la deuxième.
copy([], []).
copy([H|Qo],[H|Qn]) :- copy(Qo,Qn).


%Retrait du pion joué par le joueur J de la colonne C du plateau.
%[HO|O] représente le plateau avant déplacement du pion joué
%[Hn|N] représente le plateau après le retrait du pion
decrement(0,[Ho|Q],[Hn|Q]) :- Hn is Ho-1.		%Joueur1
decrement(1,[H|Qo],[H|Qn]) :- decrement(0, Qo, Qn).	%Joueur2
decrement(0,J,[Vo|O],[Vn|N]) :- decrement(J,Vo,Vn), copy(O,N).	%On arrive à la bonne colonne.
decrement(C,J,[H|O],[H|N]) :- C1 is C-1, decrement(C1,J,O,N).

%two parameters version for using retract and assert
decrement(C,J) :-
				plateau(Old),
				decrement(C,J,Old,New),
				retract(plateau(Old)),
				assert(plateau(New)).

%Ajout du pion joué par le joueur J de la colonne C du plateau.
increment(0,[Ho|Q],[Hn|Q]) :- Hn is Ho+1.		%Joueur1
increment(1,[H|Qo],[H|Qn]) :- increment(0, Qo, Qn).	%Joueur2
increment(0,J,[Vo|O],[Vn|N]) :- increment(J,Vo,Vn), copy(O,N).	%On arrive à la bonne colonne.
increment(C,J,[H|O],[H|N]) :- C1 is C-1, increment(C1,J,O,N).

%two parameters version for using retract and assert
increment(C,J) :-
				plateau(Old),
				increment(C,J,Old,New),
				retract(plateau(Old)),
				assert(plateau(New)).

%Liste de test pour increment/decrement	[[1,2], [3,4], [5,6], [7,8]]


%% trouverCP : trouve le nombre de pions à la colonne voulue et ajuste le nombre CP de coups restants. Si la colonne vaut 0 ou 8 (bases), CP vaut 1.
% !!! Bien utiliser trouverCP et pas findCP (problème pour la colonne 0 car utilisation par findCP dans la récursivité).
trouverCP(0, _, 1).
trouverCP(C, P, CP) :- 	C \== 0,
			findCP(C,P,CP).
findCP([CP1,CP2|[]], CP) :- CP is CP1+CP2. %Calcul du nombre de pions avant le premier coup (sinon rajouter -1)
findCP(0, [H|_], CP) :- findCP(H, CP).
findCP(7, [H|_], CP) :- findCP(H, CP).
%findCP(-1, _, 0).
findCP(8, _, 1).
findCP(C, [_|Q], CP) :- C > 0, C < 7, C1 is C-1, findCP(C1, Q, CP).


elem1([X|_],X).
elem2([_|Q], X) :- elem1(Q,X).

/*
modifier(Lpl, 0, J, [L1|[]], CP, LNpl) :- 	elem1(L1,C1),
						decrement(C1, J, Lpl, Lbuf),
						elem2(L1, C2),
						Cend is C1+C2,
						increment(Cend, J, Lbuf, LNpl),
						findCP(Cend, LNpl, CP).


modifier(Lpl, _, J, [L1|[]], 1, LNpl) :-	elem1(L1,C1),
						decrement(C1, J, Lpl, Lbuf1),elem2(L1, C2),
						elem2(L1, C2),
						Cend is C1+C2,
						increment(Cend, J, Lbuf1, Lbuf2),
						copy(Lbuf2, LNpl).

modifier(Lpl, Ac, J, [L1|Qtodo], CP, LNpl) :-	elem1(L1,C1),
						decrement(C1, J, Lpl, Lbuf1),
						elem2(L1, C2),
						Cend is C1+C2,
						increment(Cend, J, Lbuf1, Lbuf2),
						CP1 is CP-1,
						modifier(Lbuf2, Ac, J, Qtodo, CP1, Lbuf3),
						copy(Lbuf3, LNpl).
*/
modifier(L,_,[],L).
modifier(Lpl, J, [L1|[]], LNpl) :-	elem1(L1,C1),
						decrement(C1, J, Lpl, Lbuf1),
						elem2(L1, C2),
						Cend is C1+C2,
						increment(Cend, J, Lbuf1, Lbuf2),
						copy(Lbuf2, LNpl).

modifier(Lpl, J, [L1|Qtodo], LNpl) :-	elem1(L1,C1),
						decrement(C1, J, Lpl, Lbuf1),
						elem2(L1, C2),
						Cend is C1+C2,
						increment(Cend, J, Lbuf1, Lbuf2),
						modifier(Lbuf2, J, Qtodo, Lbuf3),
						copy(Lbuf3, LNpl).
						
/*	TOREAD : tests pour modifier :
[debug]  ?- modifier([[1,2], [3,4], [5,6], [7,8]], 1, 0, [[1,1], [1,2]], 2, LNpl).
LNpl = [[1, 2], [1, 4], [6, 6], [8, 8]] .

[debug]  ?- modifier([[1,2], [3,4], [5,6], [7,8]], 0, [[1,1], [1,1]], LNpl).
LNpl = [[1, 2], [1, 4], [7, 6], [7, 8]] .

[debug]  ?- modifier([[1,2], [3,4], [5,6], [7,8]], 0, [[1,2], [1,2], [1,2]], LNpl).
LNpl = [[1, 2], [0, 4], [5, 6], [10, 8]] .

[debug]  ?- modifier([[1,2], [3,4], [5,6], [7,8]], 1, [[1,2], [1,2], [1,2], [1,2]], LNpl).
LNpl = [[1, 2], [3, 0], [5, 6], [7, 12]] .
*/
