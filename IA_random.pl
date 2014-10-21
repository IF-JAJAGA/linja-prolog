:- include('regles.pl').

/*
	###	IA Random	###
	- premier coup : random sur les pions que l'on peut déplacer (= random sur la colonne)
	- coup supplémentaire : random sur la colonne puis sur la longueur de déplacement avec la fonction findCP

	Les deux fonctions appellent modifier à chaque fois.
*/

pionsJ(0, [X|_], X).
pionsJ(1,[_|Q], X) :- pionsJ(0, Q, X).
%coupsPossibles renvoie la listes des colonnes qui contiennent au moins un pion du joueur J qui est possible à déplacer.
coupsPossibles(J, [H|LPlQ], L) :- coupsPossibles(J, [H|LPlQ], L, 0).	%Initialisation

coupsPossibles(_, [], [], _).
%Joueur 0 : coup impossible en colonne 0
coupsPossibles(J, [H|[]], [], NCol) :-	J == 0,
						pionsJ(J, H, P),	%P Nb de pions pour J
						P>0,
						NCol == 7.

coupsPossibles(J, [H|LPlQ], [NCol|LTodo], NCol) :-	J == 0,
						pionsJ(J, H, P),	%P Nb de pions pour J
						P>0,
						NCol \== 7,
						NCol1 is NCol+1,
						coupsPossibles(J, LPlQ, LTodo, NCol1).
%Joueur 1 : coup impossible en colonne 7
coupsPossibles(J, [H|LPlQ], LTodo, NCol) :-	J == 1,
						pionsJ(J, H, P),	%P Nb de pions pour J
						P>0,
						NCol == 0,
						NCol1 is NCol+1,
						coupsPossibles(J, LPlQ, LTodo, NCol1).
coupsPossibles(J, [H|LPlQ], [NCol|LTodo], NCol) :-	J == 1,
						pionsJ(J, H, P),	%P Nb de pions pour J
						P>0,
						NCol \== 0,
						NCol1 is NCol+1,
						coupsPossibles(J, LPlQ, LTodo, NCol1).
%Pour les cas où J n'a pas de pion dans la colonne NCol.
coupsPossibles(J, [H|LPlQ], LTodo, NCol) :-		pionsJ(J, H, P),	%Nb de pions
						P=0,
						NCol1 is NCol+1,
						coupsPossibles(J, LPlQ, LTodo, NCol1).
%Agit sur la longueur du déplacement pour ne pas dépasser la longueur du plateau.
%Si Lenght est à 0, on parle du joueur 1 dont les pions s'arrêtent à la colonne 0.
pasDepasserPlateau(0, C, L1, L) :- 	Exedent is C-L1,
					Exedent < 0,
					L is L1+Exedent.
pasDepasserPlateau(0, C, L1, L) :- 	C-L1 >= 0,
					L is L1.

pasDepasserPlateau(Lenght, C, L1, L) :- Lenght \==0,
					Exedent is C+L1-Lenght,
					Exedent >= 0,
					L is L1-Exedent.
pasDepasserPlateau(Lenght, C, L1, L) :- Lenght \==0,
					C+L1 < Lenght,
					L is L1.

%premierCoupIA_random doit renvoyer une liste TODO et CP (nombre de mouvements supplémentaires)
%Aucun mouvement possible pour J.
premierCoupIA_random(LPl, J, [], 0) :-			coupsPossibles(J, LPl, LCols),
							length(LCols, Lenght),
							Lenght == 0.


premierCoupIA_random(LPl, J, [[C,L|[]]], CP) :- 	J == 0,
							coupsPossibles(J, LPl, LCols),
							length(LCols, Lenght),
							Col is random(Lenght),	%On trouve le pion
							nth_element(Col,C,LCols),
							Carrivee is C+1,
							findCP(Carrivee, LPl, CP),	%Calcul de CP à l'endroit où j'arrive.
							L is 1.
premierCoupIA_random(LPl, J, [[C,L|[]]], CP) :- 	J == 1,
							coupsPossibles(J, LPl, LCols),
							length(LCols, Lenght),
							Col is random(Lenght),	%On trouve le pion
							nth_element(Col,C,LCols),
							Carrivee is C-1,
							findCP(Carrivee, LPl, CP),	%Calcul de CP à l'endroit où j'arrive.
							L is -1.


supplementaireCoupIA_random(_, _, [], 0).
%Aucun mouvement possible pour J.
supplementaireCoupIA_random(LPl, J, [], _) :-		coupsPossibles(J, LPl, LCols),
							length(LCols, Lenght),
							Lenght == 0.


supplementaireCoupIA_random(Lpl, J, [[C,L]|Q],CP) :- 	J == 0,
							coupsPossibles(J, Lpl, LCols),
							length(LCols, Lenght),
							Col is random(Lenght),	%On trouve le pion
							nth_element(Col,C,LCols),
							random_between(1,CP,L1),
							pasDepasserPlateau(7, C, L1, L),
							NCP is CP - L,
							modifier(Lpl, J, [[C,L]|[]], LPlBuf),
							supplementaireCoupIA_random(LPlBuf, J, Q, NCP).

supplementaireCoupIA_random(Lpl, J, [[C,L]|Q],CP) :- 	J == 1,
							coupsPossibles(1, Lpl, LCols),
							length(LCols, Lenght),
							Col is random(Lenght),	%On trouve le pion
							nth_element(Col,C,LCols),
							random_between(1,CP,L1),
							pasDepasserPlateau(0, C, L1, L2),
							NCP is CP - L2,
							L is -L2,
							modifier(Lpl, J, [[C,L]|[]], LPlBuf),
							supplementaireCoupIA_random(LPlBuf, J, Q, NCP).
