/*
Fonction à appeler pour lancer l'IA Best_Score
*/


:- module(ia_best_utils,[supplementaireFinal/4]).

%fonctions banales pour générer un plateau de ce type
%test(P) :- P = [[2,1],[1,0],[0,1],[0,3],[0,2],[1,1],[1,3],[0,1]].


						

/*
chercherPlusEloigne permet de trouver le pion du joueur se trouvant le plus près de la base adverse et renvoie sa position.
*/
%chercherPlusEloigne(plateau, position)

chercherPlusEloigne([_|[]],1,N,N).
chercherPlusEloigne([_|[]],0,_,PO) :-
	PO is -1.
chercherPlusEloigne([T|Q],0,N,PO) :-
	T=[T1,_],
	N1 is N + 1,
	chercherPlusEloigne(Q,0,N1,PO1),!,
	(PO1 > 0 ->
		PO = PO1;
		( T1 > 0 ->
		PO = N;
		PO is PO1)).
		
intern_chercherPlusEloigne([T|Q],1,N,PO) :-
	T=[_,Q1],
	(Q1 == 0 ->
		N1 is N + 1,
		intern_chercherPlusEloigne(Q,1,N1,PO1),!,
		PO = PO1;
		PO = N).

chercherPlusEloigne([T|Q],1,N,PO) :-
		intern_chercherPlusEloigne(Q,1,N,PO).


/*
supplementaireFinal(Plateau, CP, Joueur, CoupAFaire)
Renvoie la liste CoupAFaire de type [Depart,Avancée]
*/
supplementaireFinal(P, CP, 0, LTodo) :- 
	C is 7-CP,
	nth0(C, P, Val),!,
	Val=[TV,_],
	(TV\=0 ->
		LTodo = [[C,CP]];
		chercherPlusEloigne(P,0,0,I),
		CNE is 7 - I,
		(CNE > CP ->
			LTodo = [[I,CP]];
			CNO is CP - CNE,
			joueur_a_pions(P,0,Possible),
			Arrivee is Possible + CNO,
			not(case_pleine(P,Arrivee)),
			(Possible == I ->
			LTodo = [[I,CNE]];
			LTodo = [[Possible,CNO],[I,CNE]]))).


supplementaireFinal(P, CP, 1, LTodo) :- 
	nth0(CP, P, Val),!,
	Val=[_,QV],
	(QV\=0 ->
		LTodo = [[CP,-CP]];
		chercherPlusEloigne(P,1,0,I),!,
		I2 is I+1,
		CNE is I2,
		(CNE > CP ->
			LTodo = [[I2,-CP]];
			CNO is CP - CNE,
			joueur_a_pions(P,1,Possible),
			Arrivee is Possible - CNO,
			not(case_pleine(P,Arrivee)),
			(Possible == I2 ->
			LTodo = [[I,-CNE]];
			LTodo = [[Possible,-CNO],[I2,-CNE]]))).
			
