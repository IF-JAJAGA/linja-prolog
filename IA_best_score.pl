:- use_module(library(lists)).


%fonctions banales pour générer un plateau de ce type
test(P) :- P = [[2,1],[1,0],[3,1],[3,3],[1,2],[1,0],[1,4],[0,1]].
plateau(X) :- X = ([[5,0],[0,1],[2,0],[2,1],[1,3],[5,1],[2,3],[0,12]]).


/*
Ensemble des fonctions annulerCP qui va annuler le CP dans la liste renvoyée par genererliste dans les cas où aucun pion n'arrive à ce point
ou si la colonne est totalement pleine (6 pions dans la colonne)
*/

annulerCP(_,_,_,[],[]).
annulerCP(_,6,0). % annule le CP si le CP calculé est de 6
annulerCP(0,_,0). % annule le CP s'il n'y a pas de pions à la colonne précédente
annulerCP(PJ,T,T) :- PJ\=0.

%règle le cas du CP de la base adverse pour le joueur 0
annulerCP([PJ1,_],[_|QL],0,[_|Q],[L2|Q]) :- QL==[], PJ1==0, L2 is 0.
annulerCP([PJ1,_],[_|QL],0,[_|Q],[L2|Q]) :- QL==[], PJ1\=0, L2 is 1.

%Appel récursif du calcul de CP pour le joueur 0
annulerCP([PJ1,_],_,0,[T|Q],[L2|Q]) :- annulerCP(PJ1,T,L2).

%règle le cas du CP de la base du joueur 1
annulerCP(_,[_|[]],1,[_|Q],[L2|Q]) :- 
	L2 is 0. % annule le CP si ça correspond au départ du deuxième joueur.

%Appel récursif du calcul de CP pour le joueur 1
annulerCP(_,[_|Q2],1,[T|Q],[L2|Q]) :- 
	Q2=[Q3|_],
	Q3=[_,PJ2],
	annulerCP(PJ2,T,L2).

	
%fonction neutre de ajusterTetePlateau qui renvoie PJTA = PJT (on est pas en tête de liste)

ajusterTetePlateau(N,PJT,_,_,PJT) :- N\=0.
	
%ajuste le CP de la base du joueur 0
ajusterTetePlateau(0,_,_,0,PJTA) :-	PJTA is 0.	
	
%ajuste le CP du camp adverse pour le joueur 1
ajusterTetePlateau(0,_,Q,1,PJTA) :-
	Q=[T|_],
	T=[_,T1],
	T1==0,
	PJTA is 0.
	
ajusterTetePlateau(0,_,Q,1,PJTA) :-
	Q=[T|_],
	T=[_,T1],
	T1\=0,
	PJTA is 1.

	
/*
Fonction qui génère une liste de CP correspondant aux colonnes du plateau
Chaque CP est calculé et ajusté en fonction que la colonne est déjà pleine ou si, en fonction du joueur, aucun pion ne peut arriver sur cette case.
On gère également les CPs pour les bases adversaires ou de soi-même.
Elle prend en paramètre le numéro de l'action en cours (donc, à l'appel de la fonction N=0,
la liste de liste qui compose le plateau,
le numéro du joueur J (0 ou 1),
et renvoie la liste L de CPs

Type d'appel : genererliste(0,Plateau,Joueur,ListeRetounée).
*/

genererliste(_,[],_,[]).
genererliste(N, Plateau, J, L) :-
	Plateau = [T|Q],
	T=[PJ1,PJ2],
	PJT is PJ1+PJ2,
	N1 is N+1,
	genererliste(N1,Q,J,L1),
	annulerCP(T,Q,J,L1,L2),
	ajusterTetePlateau(N,PJT,Q,J,PJTA),
	L = [PJTA|L2],!.			


/* Il trouve la case où on obtient un Capital de Points plus grand. Il retourne une liste avec la liste de mouvements (soit 1 mouvement) à faire (listeTODO) et le capital de points à obtenir */
	
%trouvermax(ListeCP,Joueur,CPresultat,ListeTODO)
trouvermax([],_,_,_).
trouvermax(L,J,CP,LTODO) :-
	trouvermaxA(L,CP,I,0),
	( J == 0 ->
		I2 is I - 1,
		D is 1;
		I2 is I + 1,
		D is - 1
	),
	LTODO = [[I2,D]].


/*Dit la case a bouger.*/

trouvermaxA([],CP,I,_) :-
	CP = -1,
	IP = -1.
trouvermaxA([T|Q],CP,I,N) :-
	N1 is N +1,
	trouvermaxA(Q,CP1,I1,N1),
	
	(J == 0 ->
		(T >= CP1 ->
			CP = T,
			I = N;
			CP = CP1,
			I = I1);
		(T > CP1 ->
			CP = T,
			I = N;
			CP = CP1,
			I = I1)).						
						

/*
chercherPlusEloigne permet de trouver le pion du joueur se trouvant le plus près de la base adverse et renvoie sa position.
*/
%chercherPlusEloigne(plateau, position)

chercherPlusEloigne([_|[]],1,N,N).
chercherPlusEloigne([_|[]],0,N,PO) :-
	PO is -1.
chercherPlusEloigne([T|Q],0,N,PO) :-
	T=[T1|_],
	N1 is N + 1,
	chercherPlusEloigne(Q,0,N1,PO1),!,
	(PO1 > 0 ->
		PO = PO1;
		( T1 > 0 ->
		PO = N;
		PO is PO1)).
		
chercherPlusEloigne([T|Q],1,N,PO) :-
	T=[_|Q1],
	N1 is N + 1,
	chercherPlusEloigne(Q,1,N1,PO1),!,
	(N == 0 ->
		PO = PO1;
		(Q1 > 0 ->
			PO = N;
			PO = PO1)).

/*
chercherPlusProche
*/
%chercherPlusProche(plateau, Joueur, PostionDansPlateau, PositionDuPion)

chercherPlusProche([T|[]],1,N,PO) :- 
	T = [_|Q1],
	(Q1 > 0 ->
		PO is N;
		PO is -1).
	
chercherPlusProche([_|[]],0,_,_).
	
chercherPlusProche([T|Q],1,N,PO) :-
	T=[_|Q1],
	N1 is N + 1,
	chercherPlusProche(Q,1,N1,PO1),!,
	(PO1 > 0 ->
		PO = PO1;
		( Q1 > 0 ->
		PO = N;
		PO is PO1)).
	
chercherPlusProche([T|Q],0,N,PO) :-
	T=[T1|_],
	(T1 == 0 ->
		N1 is N + 1,
		chercherPlusProche(Q,0,N1,PO1),!,
		PO = PO1;
		PO = N).
		

/*
supplementaireFinal(Plateau, CP, Joueur, CoupAFaire)
Renvoie la liste CoupAFaire de type [Depart,Avancée]
*/

supplementaireFinal(P, CP, 0,[T,Q]) :- 
	C is 7-CP,
	nth0(C, P, Val),
	Val=[TV,_],
	TV\=0,
	T is (C), Q is CP,
	CP is 0, !.
	
supplementaireFinal(P, CP, 1,[T,Q]) :- 
	nth0(CP, P, Val),
	Val=[_,QV],
	QV\=0,
	T is (CP), Q is (-CP),
	CP is 0, !.

	
%supplementaireFinalBis(P,CP, 0, [T|Q]) :-
	

%Un seul coup qui amène un pion au bout avec tout le CP.
%IA_best_supplementaire(P, J, [C,L|[]], CP) :-