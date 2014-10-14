/*
On reçoit : 
	- le numéro du joueur
	- une liste de coups 
	- Le numéro de l'action à réaliser
*/


accesElement(1,X,[X|_]).
accesElement(N,X,[_|Q]) :- accesElement(N1,X,Q), N is N1+1.

%copy : copie la première liste dans la deuxième.
copy([], []).
copy([H|[]], [H|[]]).
copy([H|Qo],[H|Qn]) :- copy(-1,Qo,Qn).


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

%Placement du pion joué par le joueur J à la colonne C du plateau.
%[HO|O] représente le plateau avant déplacement du pion joué
%[Hn|N] représente le plateau après ajout du pion à l'endroit voulu.
%increment(0,[Ho,Qo],[Hn,Qn]) :- Hn is Ho+1, Qn is Qo.
%increment(1,[Ho,Qo],[Hn,Qn]) :- Qn is Qo+1, Hn is Ho.
%increment(0,J,[Vo|O],[Vn|N]) :- increment(J,Vo,Vn), N is O.
%increment(C,J,[Ho|O],[Hn|N]):- C1 is C-1, increment(C1,J,O,N), Hn is Ho.


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
elem1([X|_],X).
elem2([_|Q], X) :- elem1(Q,X).
modifier(Lpl, 0, J, [L1|Qtodo], CP, LNpl) :- 	elem1(L1,C1),
						decrement(C1, J, Lpl, Lbuf),
						elem2(L1, C2),
						increment(C1+C2, J, Lbuf, LNpl),
						CP is CP-C2.

modifier(Lpl, Ac, J, [L1|Qtodo], CP, LNpl) :-	elem1(L1,C1),
						decrement(C1, J, Lpl, Lbuf1),
						elem2(L1, C2),
						increment(C1+C2, J, Lbuf1, Lbuf2),
						CP is CP-C2.
						modifier(Lbuf2, ).

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
