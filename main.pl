/*main program*/

% Initiate start flag
:- dynamic(start_flag/1).
start_flag(false).

% modules
:- include('map.pl').
:- include('character.pl').
:- include('enemy.pl').
:- include('help.pl').
:- include('inventory.pl').
:- include('store.pl').
:- include('battle.pl').
:- include('quest.pl').
:- include('encounter.pl').

start:-
    ['map.pl'],
    ['help.pl'],
    ['character.pl'],
    ['enemy.pl'],
    ['inventory.pl'],
    ['store.pl'],
    ['battle.pl'],
    ['quest.pl'],
    ['encounter.pl'],

    write('   _____                _     _         _____           _             '),nl,
    write('  / ____|              | |   (_)       |  __ \\         | |            '),nl,
    write(' | |  __  ___ _ __  ___| |__  _ _ __   | |__) | __ ___ | | ___   __ _ '),nl,
    write(' | | |_ |/ _ \\ \'_ \\/ __| \'_ \\| | \'_ \\  |  ___/ \'__/ _ \\| |/ _ \\ / _` |'),nl,
    write(' | |__| |  __/ | | \\__ \\ | | | | | | | | |   | | | (_) | | (_) | (_| |'),nl,
    write('  \\_____|\\___|_| |_|___/_| |_|_|_| |_| |_|   |_|  \\___/|_|\\___/ \\__, |'),nl,
    write('                                                                 __/ |'),nl,
    write('                                                                |___/'),nl,

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
    write('# 11. quest.      : menampilkan menu quest                                     #'),nl,
    write('################################################################################'),nl, nl,

    retract(start_flag(false)),
    !,
    asserta(start_flag(true)),

    % choose class
    repeat,
    write('Welcome traveller. please choose your class'),nl,
    write('1. Swordsman'),nl,
    write('2. Archer'),nl,
    write('3. Sorcerer'),nl,
    read(Class),
    Class =<3,
    Class >= 1,

    % choose the class
    current_class(Class,ClassName),
    assertz(current_class(Class,ClassName)),
    choose_class(Class),


    write('You choose '),
    write(ClassName),
    write(', lets explore the world!'),
    /*initialize player*/
    assertz(map_object(1,1, 'P')),

    /*initialize enemy*/
    assertz(current_enemy(0,0,0)),
    assertz(current_enemy_class(0,0)),
    assertz(current_enemy_stat(0,0,0,0,0,0)),
    setGameState(start).

exit :-
    start_flag(true),
    retract(start_flag(true)),
    assertz(start_flag(false)),
    write('Thank you, see you next time').
