plateau([[12,0],[2,1],[0,0],[2,4],[1,0],[0,6],[3,0],[0,12]]).
%plateau([[4,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,4]]).
:-dynamic(ref_cercles/1).
ref_cercles([]).

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
	create_GUI_components,
	plateau(X).
	%print_GUI_Jetons(X).
	%free_GUI_components.
	
	
init:-
	create_plateau,
	plateau(X),
	print_GUI_Jetons(X,1),
	get(@p, confirm, @nil),
	ref_cercles(LC),
	free_GUI_pions(LC),
	send(@p,flush).
	
nextStep(X):-
	print_GUI_Jetons(X,1),
	get(@p, confirm, @nil),
	ref_cercles(LC),
	free_GUI_pions(LC),
	send(@p,flush).

print_GUI_Jetons([],_).
print_GUI_Jetons([T|Q],NumLine):-
	print_GUI_line(T,NumLine),
	Num2 is NumLine + 1,
	print_GUI_Jetons(Q,Num2).
	
print_GUI_line([],_).
print_GUI_line([T1,T2|_],NumLine) :-
	print_GUI_pion(T1,0,NumLine,colour(red)),
	print_GUI_pion(T2,T1,NumLine,colour(black)).
	
print_GUI_pion(0,_,_,_).
print_GUI_pion(N,M,NumLine,Color):-
	N \==0,
	%Ajoute le cercle à l'image
	new(C,circle(25)),
	ref_cercles(LC),
	append(LC,[C],NLC),
	retract(ref_cercles(LC)),
	assert(ref_cercles(NLC)),
	send(C,fill_pattern, Color),
	send(@p, display, C, point(12.5+(50*(NumLine-1)),25+(N*30)+(M*30))),
	N1 is N -1,
	print_GUI_pion(N1,M,NumLine,Color).
	

create_GUI_components :-
	new(@p, picture('Test 1')),
	send(@p,open),
	send(@p, display, new(@b, circle(25)),point(12.5,25)),
	send(@p, display, new(@r, circle(25)), point(12.5,75)),
	send(@p, display, new(@l1, line(50,0,50,750,none))),
	send(@p, display, new(@l2, line(100,0,100,750,none))),
	send(@p, display, new(@l3, line(150,0,150,750,none))),
	send(@p, display, new(@l4, line(200,0,200,750,none))),
	send(@p, display, new(@l5, line(250,0,250,750,none))),
	send(@p, display, new(@l6, line(300,0,300,750,none))),
	send(@p, display, new(@l7, line(350,0,350,750,none))),
	send(@p, display, new(button(nextStep, message(@p,return,@nil))), point(550,25)),
	%send(@r, fill_pattern, colour(red)),
	send(@b, fill_pattern, colour(black)),
	get(@p, confirm, @nil),
	move.
	
create_plateau :-
	new(@p, picture('Test 1')),
	send(@p,open),
	send(@p, display, new(@l1, line(50,0,50,750,none))),
	send(@p, display, new(@l2, line(100,0,100,750,none))),
	send(@p, display, new(@l3, line(150,0,150,750,none))),
	send(@p, display, new(@l4, line(200,0,200,750,none))),
	send(@p, display, new(@l5, line(250,0,250,750,none))),
	send(@p, display, new(@l6, line(300,0,300,750,none))),
	send(@p, display, new(@l7, line(350,0,350,750,none))),
	send(@p, display, new(button(nextStep, message(@p,return,@nil))), point(550,25)).
	
move :-
	free(@b),
	send(@p, display, new(@b, circle(25)),point(62.5,25)),
	send(@b, fill_pattern, colour(black)).

free_GUI_components :-
	free(@b),
	free(@r),
	free(@l),
	free(@p),
	free(@l1),
	free(@l2),
	free(@l3),
	free(@l4),
	free(@l5),
	free(@l6),
	free(@l7).
	
free_GUI_pions([]):-
	ref_cercles(Cercles),
	retract(ref_cercles(Cercles)),
	assert(ref_cercles([])).
free_GUI_pions([T|Q]) :- 
	free(T),
	free_GUI_pions(Q).