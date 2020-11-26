/*encounter.pl*/
/*set to randomly encounter*/

encounter :-
    % Randomize encounter status
    random(1, 4, RandomEncounterStatus),
    RandomEncounterStatus == 2,

    % If encounter, generate random enemy
    generate_random_enemy,
    current_enemy_stat(_,Name,Lvl,HP,Atk,Def),
    enemy_status(_, Name, Level, HP, Atk, Def),

    write('you encountered a '),
    write(Name),nl,

    write('Level: '),
    write(Lvl), nl,
    write('Hp: '),
    write(HP),nl,
    write('Attack: '),
    write(Atk),nl,
    write('Defense: '),
    write(Def),nl,

    write('Type "fight" to begin battle or "run" to run'),
    setGameState(meetEnemy), !.

    /*@PRANA NANTI SAMBUNGIN KE BATTLENYA DI LINE YG INI*/
near_boss :-
  map_object(X, Y, 'P'),
  A is X + 1,
  map_object(A, Y, 'D'),!.

near_boss :-
  map_object(X, Y, 'P'),
  A is X - 1,
  map_object(A, Y, 'D'),!.

near_boss :-
  map_object(X, Y, 'P'),
  A is Y + 1,
  map_object(X, A, 'D'),!.

near_boss :-
  map_object(X, Y, 'P'),
  A is Y - 1,
  map_object(X, A, 'D'),!.


dungeon :-
  near_boss,
  character_level(Lvl),
  Lvl > 14,
  set_enemy(4, 15),
  write('Starting Boss fight.'), nl,
  setGameState(meetEnemy),
  fight, !.

dungeon :-
  near_boss,
  write('You are not ready yet, come back when you are stronger.'), nl, !.
