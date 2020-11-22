/*main program*/

% Initiate start flag
:- dynamic(start_flag/1).
start_flag(false).

% modules
:- include('map.pl').
:- include('character.pl').
:- include('enemy.pl').
:- include('help.pl').


start:-
    ['map.pl'],
    ['help.pl'],
    ['character.pl'],
    ['enemy.pl'],

    write('################################################################################'),nl,
    write('#                               Available Commands                             #'),nl,
    write('# 1. start.      : untuk memulai petualanganmu                                 #'),nl,
    write('# 2. map.        : menampilkan peta                                            #'),nl,
    write('# 3. status.     : menampilkan kondisimu terkini                               #'),nl,
    write('# 4. w.          : gerak ke atas 1 langkah                                     #'),nl,
    write('# 5. s.          : gerak ke bawah 1 langkah                                    #'),nl,
    write('# 6. d.          : gerak ke kanan 1 langkah                                    #'),nl,
    write('# 7. a.          : gerak ke kiri 1 langkah                                     #'),nl,
    write('# 8. inventory.  : menampilkan inventory anda                                  #'),nl,
    write('# 10. help.      : menampilkan segala bantuan                                  #'),nl,
    write('################################################################################'),nl, nl,

    retract(start_flag(false)), 
    !,
    asserta(start_flag(true)),

    % choose class
    write('Welcome traveller. please choose your class'),nl,
    write('1. Swordsman'),nl,
    write('2. Archer'),nl,
    write('3. Sorcerer'),nl,
    read(Class),

    % get character stats
    character_class(Class,ClassName),
    character_status(Class,Health,Attack,SpecAttack,Defense),

    % generate player
    assertz(c_class(Class)),
    assertz(c_stat(Class,Health,Attack,SpecAttack,Defense)),
    assertz(c_gold(5000)),
    assertz(c_xp(0)),

    write('You choose '),
    write(ClassName),
    write(', lets explore the world!').

exit :-
    start_flag(true),
    retract(start_flag(true)),
    assertz(start_flag(false)),
    write('Thank you, see you next time').

