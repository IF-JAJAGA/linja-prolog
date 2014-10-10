plateau([[12,0],[2,1],[0,0],[2,4],[1,0],[0,6],[3,0],[0,12]]).


print_ihm([]).
print_ihm([T|[]]) :- 
	print_line(T),!.
print_ihm([T|Q]) :- 
	print_line(T),
	print('\n-----------------\n'),
	print_ihm(Q).
	
print_line([]).
print_line([T1,T2|_]) :-
	S is T1 + T2,
	print(S),
	print('  '),
	print_jeton(T1,'x'),
	print_jeton(T2,'o').
	
print_jeton(0,_).
print_jeton(N,M) :-
	print(M),
	N1 is N -1,
	print_jeton(N1,M).
	
