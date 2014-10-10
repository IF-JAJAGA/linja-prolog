/*
On reçoit : 
	- le numéro du joueur
	- une liste de coups 
	- Le numéro de l'action à réaliser
*/


accesElement(1,X,[X|_]).
accesElement(N,X,[T|Q]) :- accesElement(N1,X,Q), N is N1+1.

decrement(0,0,[Vo,O],[Vn,N]) :- Vn is Vo-1.
decrement(0,J,O,N) :-. % non fini
decrement(C,J,[Ho|O],[Hn,N]) :- C1 is C-1, decrement(C1,J,O,N), Hn is Ho.
%incrementList(L,M,NJ,E):-



%modifier(Lplateau, numéro action, numéro joueur, LdéplacementTODO, CP, LNouveauPlateau)
/* modifier :-	récupérer 1e élément de LdéplacementTODO (=L1),
				récupérer 1e element de L1 (C1),
				décrémenter l'endroit d'où on part dans Lplateau (C1) pour le joueur correspondant,
				récupérer 2e element de L1 (C2),
				incrémenter l'endroit où on arrive dans Lplateau (C1+C2) pour le joueur correspondant,
				CP is CP-C2,
				appel modifier avec nouveau CP et queue de LdéplacementTODO.
*/

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
