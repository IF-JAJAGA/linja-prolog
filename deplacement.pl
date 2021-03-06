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
:- module(deplacement, [copy/2,decrement/4,increment/4,trouverCP/4,modifier/4]).


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

%Ajout du pion joué par le joueur J de la colonne C du plateau.
increment(0,[Ho|Q],[Hn|Q]) :- Hn is Ho+1.		%Joueur1
increment(1,[H|Qo],[H|Qn]) :- increment(0, Qo, Qn).	%Joueur2
increment(0,J,[Vo|O],[Vn|N]) :- increment(J,Vo,Vn), copy(O,N).	%On arrive à la bonne colonne.
increment(C,J,[H|O],[H|N]) :- C1 is C-1, increment(C1,J,O,N).

%Liste de test pour increment/decrement	[[1,2], [3,4], [5,6], [7,8]]


%% trouverCP : trouve le nombre de pions à la colonne voulue et ajuste le nombre CP de coups restants. Si la colonne vaut 0 ou 8 (bases), CP vaut 1.
% !!! Bien utiliser trouverCP et pas findCP (problème pour la colonne 0 car utilisation par findCP dans la récursivité).
%trouverCP(Colonne, Joueur, Plateau, CP).
trouverCP(0, 0, _, 0).
trouverCP(0, 1, _, 1).
trouverCP(7, 1, _, 0).
trouverCP(7, 0, _, 1).
trouverCP(C, _, P, CP) :- 	C \== 0, C\==7,
			findCP(C,P,CP).
findCP([CP1,CP2|[]], CP) :- CP is CP1+CP2. %Calcul du nombre de pions avant le premier coup (sinon rajouter -1)
findCP(0, [H|_], CP) :- findCP(H, CP).
findCP(7, [H|_], CP) :- findCP(H, CP).
%findCP(-1, _, 0).
%findCP(7, _, 1).
findCP(C, [_|Q], CP) :- C > 0, C < 7, C1 is C-1, findCP(C1, Q, CP).


elem1([X|_],X).
elem2([_|Q], X) :- elem1(Q,X).

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
