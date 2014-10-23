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

/*	----- Jérôme -----
 * */

 /*Cette fonction genere une liste avec le nombre de coups possibles si on se déplace a chaque colonne du plateau dans le premier coup.
 Dans les colonnes où il y a déjà 6 jetons on met un 0 car on ne va pas se déplacer vers elles. On met un 0 aussi pour la colonne de départ du joueur car il ne peut pas bouger là bas.
 Dans la colonne de fin (la plus eloignée pour le joueur on met un 1 car les régles marquent que c'est le nombre de coups aditionnels qu'on reçoit si on y tombe.'*/

%getNbPionsColonne(Plateau, ColonneVOulue, Joueur, NbSortie)
getNbPionsColonne([H|_], 0, J, Nb) :- 	pionsJ(J, H, Nb).	
getNbPionsColonne([H|Q], C, J, Nb)	:-	C \==0,
						C1 is C-1,
						getNbPionsColonne(Q, C1, J, Nb).


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
						
						
/*Suite des fonctions pas finies.*/

%supplementaireFinal(Plateau, CP, Joueur, CoupAFaire) : correspond au premier si de l'algo : on amène le pion au final avec tout le cp
supplementaireFinal(P, CP, 0,[T,Q]) :- 
	C is 7-CP,
	nth0(C, P, Val),
	Val=[TV,_],
	TV\=0,
	T is (C), Q is CP,!.
	
supplementaireFinal(P, CP, 1,[T,Q]) :- 
	nth0(CP, P, Val),
	Val=[_,QV],
	QV\=0,
	T is (CP), Q is (-CP),!.

%Un seul coup qui amène un pion au bout avec tout le CP.
%IA_best_supplementaire(P, J, [C,L|[]], CP) :-
