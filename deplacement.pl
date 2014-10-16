/*	TOREAD : tests pour modifier :
[debug]  ?- modifier([[1,2], [3,4], [5,6], [7,8]], 1, 0, [[1,1], [1,2]], 2, LNpl).
LNpl = [[1, 2], [1, 4], [6, 6], [8, 8]] .

[debug]  ?- modifier([[1,2], [3,4], [5,6], [7,8]], 1, 0, [[1,1], [1,1]], 2, LNpl).
LNpl = [[1, 2], [1, 4], [7, 6], [7, 8]] .

[debug]  ?- modifier([[1,2], [3,4], [5,6], [7,8]], 1, 0, [[1,2], [1,2], [1,2]], 3, LNpl).
LNpl = [[1, 2], [0, 4], [5, 6], [10, 8]] .

[debug]  ?- modifier([[1,2], [3,4], [5,6], [7,8]], 1, 0, [[1,2], [1,2], [1,2], [1,2]], 4, LNpl).
LNpl = [[1, 2], [-1, 4], [5, 6], [11, 8]] .

!!! On ne contrôle pas si les pions passent en négatif.
!!! Est-ce qu'on fait attention si modifier est appelée avec Ac = 0 et la liste des déplacements plus grande que 1 ?

*/

/*
On reçoit : 
	- le numéro du joueur
	- une liste de coups 
	- Le numéro de l'action à réaliser
*/

%fonction permettant l'accès à un élément précis de la liste.
accesElement(1,X,[X|_]).
accesElement(N,X,[_|Q]) :- accesElement(N1,X,Q), N is N1+1.

%copy : copie la première liste dans la deuxième.
copy([], []).
copy([H|[]], [H|[]]).
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


%modifier(Lplateau, numéro action, numéro joueur, LdéplacementTODO, CP, LNouveauPlateau)
/* modifier :-	récupérer 1e élément de LdéplacementTODO (=L1),
				récupérer 1e element de L1 (C1),
				décrémenter l'endroit d'où on part dans Lplateau (C1) pour le joueur correspondant,
				récupérer 2e element de L1 (C2),
				incrémenter l'endroit où on arrive dans Lplateau (C1+C2) pour le joueur correspondant,
				CP is CP-C2,
				appel modifier avec nouveau CP et queue de LdéplacementTODO.
exemple de LDeplacementTODO : [[0,2],[1,1]]
*/
%% findCP : trouve le nombre de pions à la colonne voulue et ajuste le nombre de coups restants.
%findCP(-2, [H|[]], H). 
findCP([CP1,CP2|[]], CP) :- CP is CP1+CP2-1.
%le "-1" est à discuter ici, si le calcul de CP se fait après le mouvement du pion ou pas
findCP(0, [H|_], CP) :- findCP(H, CP).
findCP(C, [_|Q], CP) :- C1 is C-1, findCP(C1, Q, CP).

elem1([X|_],X).
elem2([_|Q], X) :- elem1(Q,X).
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

/*
%fin de la deuxième action
modifier(_,_,_,_,0,X).

%modification de la première action
modifier(Plateau,NA,NJ,[T|Q],CP,NPlateau):-
nc==1,
!,
accesElement(1,X,T),

%calculer nouveau CP pour deuxième action

%modification de la deuxième action
modifier(plateau,na,nj,l,cp,nPlateau):-
nc==2,
!,
%décrémenter CP jusqu'à 0 en fonction du nombre de coups
*/
