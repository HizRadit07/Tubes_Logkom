/*file map.pl berisi layout map dan kode untuk gerakan*/
:- dynamic(map_object/3).

/* map_object(X, Y, Obj) = Object Obj at position (X, Y), basically map places*/
map_object(4, 3, '#').
map_object(4, 4, '#').
map_object(4, 5, '#').
map_object(5, 8, '#').
map_object(6, 8, '#').
map_object(7, 8, '#').
/*the boss tile*/
map_object(10, 10, 'D').
/*the shop tile*/
map_object(1, 10, 'S').
/* the enemy tile*/
map_object(3, 2, 'Q').
map_object(5, 5, 'Q').
map_object(8, 6, 'Q').
map_object(4, 9, 'Q').
map_object(5, 1, 'Q').
/*map size*/
map_size(10, 10).
map:-
    start_flag(true), !,
    draw_map,
	write('Legend:'),nl,
	write('P: Player'),nl,
	write('Q: Quest'),nl,
	write('D: Dragon'),nl,
	write('S: Shop'),nl,
	write('#: Border'),nl.
map:-   
	!,
    write('Please start the game. Type \'start.\'').

/*map borders*/
/*right border*/
draw_point(X,Y):- map_size(W,H),
                    X =:= W + 1,
				    Y =< H + 1,
					write('# '), nl,
					NewY is Y+1,
					draw_point(0, NewY).
/*left border*/
draw_point(X, Y) :- map_size(_, H),
					X =:= 0,
					Y =< H+1,
					write('# '),
					NewX is X+1,
					draw_point(NewX, Y).
/*Top Border*/
draw_point(X, Y) :- map_size(W, _),
					X < W + 1,
					X > 0,
					Y =:= 0,
					write('# '),
					NewX is X+1,
					draw_point(NewX, Y).
/*Bottom Border*/
draw_point(X, Y) :- map_size(W, H),
					X < W + 1,
					X > 0,
					Y =:= H + 1,
					write('# '),
					NewX is X+1,
					draw_point(NewX, Y).

/*draw player inside of map*/
draw_point(X, Y) :- map_size(W, H),
					X < W + 1,
					X > 0,
					Y < H + 1,
					Y > 0,
					map_object(X, Y, 'P'), !,
					write('P'),
					write(' '),
					NewX is X+1,
					draw_point(NewX, Y).

/*Draw inside of the map*/
draw_point(X, Y) :- map_size(W, H),
					X < W + 1,
					X > 0,
					Y < H + 1,
					Y > 0,
					map_object(X, Y, Obj), !,
					write(Obj),
					write(' '),
					NewX is X+1,
					draw_point(NewX, Y).
/*empty tile*/
draw_point(X, Y) :- map_size(W, H),
					X < W + 1,
					X > 0,
					Y < H + 1,
					Y > 0,
					(\+ map_object(X, Y, _)),
					write('- '),
					NewX is X+1,
					draw_point(NewX, Y).

draw_map :- draw_point(0, 0).


/*movement codes*/
wall_flag :-
    write('There\'s  a wall! Type \'map\' to look at your current position!').
/*w*/
w:-
	start_flag(true),
	map_object(X,Y,'P'),
    YNew is Y-1,
    (\+ map_object(X, YNew, 'Q')),
	(\+ map_object(X, YNew, '#')),
	(\+ map_object(X, YNew, 'D')),
    map_size(_, H),
    YNew > 0, YNew =< H, !,
    retract(map_object(X, Y, 'P')),
    assertz(map_object(X,YNew,'P')),
	encounter.

w:-
	start_flag(false),
    !,
    write('Please start the game. Type \'start.\'').
w:-
	 wall_flag.
/*s*/
s :-
	start_flag(true),	
	map_object(X,Y,'P'),
    YNew is Y+1,
    (\+ map_object(X, YNew, 'Q')),
	(\+ map_object(X, YNew, '#')),
	(\+ map_object(X, YNew, 'D')),
    map_size(_, H),
    YNew > 0, YNew =< H, !,
    retract(map_object(X, Y, 'P')),
    assertz(map_object(X,YNew,'P')),
	encounter.

s :- 
	start_flag(false),
    !,
    write('Please start the game. Type \'start.\'').
s:-
	wall_flag.
/*a*/
a :-
	start_flag(true),
	map_object(X,Y,'P'),
    XNew is X-1,
    (\+ map_object(XNew, Y, 'Q')),
	(\+ map_object(XNew, Y, '#')),
	(\+ map_object(XNew, Y, 'D')),
    map_size(W, _),
    XNew > 0, XNew =< W, !,
    retract(map_object(X, Y, 'P')),
    assertz(map_object(XNew,Y,'P')),
	encounter.

a :-
	start_flag(false),
    !,
    write('Please start the game. Type \'start.\'').
a:-
	wall_flag.
/*d*/
d:-
	start_flag(true),
    map_object(X,Y,'P'),
    XNew is X+1,
    (\+ map_object(XNew, Y, 'Q')),
	(\+ map_object(XNew, Y, '#')),
	(\+ map_object(XNew, Y, 'D')),
    map_size(W, _),
    XNew > 0, XNew =< W, !,
    retract(map_object(X, Y, 'P')),
    assertz(map_object(XNew,Y,'P')),
	encounter.

d :-
    start_flag(false),
    !,
    write('Please start the game. Type \'start.\'').
d:-
	wall_flag.
