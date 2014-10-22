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