plateau([[12,0],[2,1],[0,0],[2,4],[1,0],[0,6],[3,0],[0,12]]).

print_plateau_tour(Plateau, Tour) :- 	writeln('\n Tour ' + Tour),
					print_ihm(Plateau).

print_ihm([]).
print_ihm([T|[]]) :- 
	print_line(T),!,
	writeln('').
print_ihm([T|Q]) :- 
	print_line(T),
	writeln('\n------------------------'),
	print_ihm(Q).
	
print_line([]).
print_line([T1,T2|_]) :-
	S is T1 + T2,
	tab(5),
	print_jeton(T1,'x'),
	print_jeton(T2,'o'),
	tab(5+12-S),
	print(S).

print_jeton(0,_).
print_jeton(N,M) :-
	N \== 0,
	print(M),
	N1 is N -1,
	print_jeton(N1,M).

%Supposed 
%send(button(hello, message(@prolog, format, 'Hi There˜n')), open).structure of a prolog
initialise :-
	%initialise_database,
	create_GUI_components.
	%free_GUI_components.

create_GUI_components :-
	new(@p, picture('Test 1')),
	send(@p,open),
	send(@p, display, new(@b, circle(25)),point(25,25)),
	send(@p, display, new(@r, circle(25)), point(25,75)),
	send(@p, display, new(@l, line(0,0,25,25,none))),
	send(@p, display, new(, point(5,6))),
	send(@r, fill_pattern, colour(red)),
	send(@b, fill_pattern, colour(black)).

free_GUI_components :-
	free(@b),
	free(@r),
	free(@l).

test :-
	send(M, x,7).
	