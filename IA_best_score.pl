/*IA des chefs*/
%fonction genererliste
%fonction trouvermax

test(P) :- P = [[3,0],[0,1],[3,1],[3,3],[1,2],[1,0],[1,4],[0,1]].

annulerCP(_,_,_,[],[]).
annulerCP(_,6,0). % annule le CP si le CP calculé est de 6
annulerCP(0,_,0). % annule le CP s'il n'y a pas de pions à la colonne précédente.
annulerCP(PJ,T,T) :- PJ\=0.

annulerCP([PJ1,_],_,0,[T|Q],[L2|Q]) :- annulerCP(PJ1,T,L2).
annulerCP(_,[T2|_],1,[T|Q],[L2|Q]) :- 
	T2=[_,PJ2],
	annulerCP(PJ2,T,L2).

genererliste([],_,[]).
genererliste(Plateau, J, L) :-
	Plateau = [T|Q],
	T=[PJ1,PJ2],
	PJT is PJ1+PJ2,
	genererliste(Q,J,L1),
	annulerCP(T,Q,J,L1,L2),
	L = [PJT|L2],!.
	
	
plateau([[5,0],[0,1],[2,0],[2,1],[1,3],[5,1],[2,3],[0,12]]).

/*Cette fonction genere une liste avec le nombre de coups possibles si on se déplace a chaque colonne du plateau dans le premier coup.
 Dans les colonnes où il y a déjà 6 jetons on met un 0 car on ne va pas se déplacer vers elles. On met un 0 aussi pour la colonne de départ du joueur car il ne peut pas bouger là bas.
 Dans la colonne de fin (la plus eloignée pour le joueur on met un 1 car les régles marquent que c'est le nombre de coups aditionnels qu'on reçoit si on y tombe.'
 L'ordre des élements de cette liste et le même que celle du plateau.
 R est le resultat et L la liste*/
 
genererliste([],_).
genererliste([T|Q],R) :-
    genererlisteaux(Q,R1),
	append([0],R1,R).

/*joueur2 comme genererliste mais a l'envers, avec les contraintes des cases finale et initiale*/	
genererliste2([],_).
genererliste2(L,R) :-
	reverse(L,L1),
	genererliste(L1,R).

/*aux*/

genererlisteaux([],R).
genererlisteaux([T|[]],R) :-
	R = [1].
genererlisteaux([T|Q],R) :-
	T = [TT|TQ],
	S1 is TT + TQ,
	( S1 == 6 ->
		S is 0;
		S is S1
	),
	genererlisteaux(Q,R1),
	append([S],R1,R).
	



%fonctiontrouvermax
