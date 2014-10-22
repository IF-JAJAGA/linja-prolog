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
	send(@r, fill_pattern, colour(red)),
	send(@b, fill_pattern, colour(black)),
	get(@p, confirm, @nil),
	move.
	
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

%test :-
	%send(M, x,7).
	
	
ask_name(Name) :-
	new(D, dialog('Register')),
	send(D, append(new(NameItem, text_item(name)))),
	send(D, append(button(ok, message(D, return,
									  NameItem?selection)))),
	send(D, append(button(cancel, message(D, return, @nil)))),
	send(D, default_button(ok)),
	get(D, confirm, Rval),
	free(D),
	Rval \== @nil,
	Name = Rval.
	
:- use_module(library(pce)).

:- pce_begin_class(name_asker, dialog,
                   "Modal prompter for a name").

initialise(W, Label:[name]) :->
        "Initialise the window and fill it"::
        send_super(W, initialise(Label)),
        send(W, append(text_item(name))),
        send(W, append(button(ok))),
        send(W, append(button(cancel))),
        send(W, default_button(ok)).
        
ok(W) :->
        "User pressed the OK button"::
        get(W, member(name), NameItem),
        get(NameItem, selection, Typed),
        send(W, return, Typed).

cancel(W) :->
        "User pressed the Cancel button"::
        send(W, return(@nil)).

prompt(W, Value:name) :<-
        "Open it, destroy it and return the result"::
        get(W, confirm, Value),
        free(W).

:- pce_end_class.

test(42).

test_repeat :-
	test(X),
	repeat,
	X is X-1,
	X > 0.