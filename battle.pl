:- dynamic(usedSpecialatk/2).
:- dynamic(turn/1).
:- dynamic(gameState/1).

/* game state nya itu baru kepikiran start, meetEnemy, fight */
/* meetEnemy itu pas ketemu enemy, ada 2 pilihan command fight sama run */
/* fight itu pas gagal run atau emang milih fight ada pilihan attack, specialAttack, usePotion, run */
/* use atk potion belum */
turn(-1).
gameState(notStart).
usedSpecialatk(-1,enemy).
/* Buat set GameState nya, baru kepikiran start, meetEnemy, fight */
setGameState(State) :-
    retract(gameState(_)),
    assertz(gameState(State)), !.

/* Inisialisasi battle */
startBattle :-
    retract(turn(_)),
    assertz(turn(0)),
    retract(usedSpecialatk(_, enemy)),
    assertz(usedSpecialatk(0, enemy)), !.

/* Mekanisme run */
run :-
    gameState(meetEnemy),
    random(0, 11, X),
    ((X < 5) -> fight, write('Sorry, You failed to run!'), nl ;
    map, write('You run from battle'), setGameState(start)), nl, !.

run :-
    gameState(fight),
    random(0, 11, X),
    ((X < 5) -> fight, write('Sorry, You failed to run!'), nl, nextTurn, battle ;
    map, write('You run from battle'), setGameState(start)), nl, !.

/* Attack, specialAttack */
attack :-
    gameState(fight),
    current_enemy_stat(_,Classenemy,_,_,_,_),
    current_enemy(HP_enemy, Atk_enemy, Def_enemy),
    character_status(Player, HP_player, Atk_player, Def_player),
    write('Attacking enemy'),
    nl,
    /* mekanisme yang equip weapon belom dimasukkin */
    Damage is Atk_player - Def_enemy,
    ((Damage < 0) -> (Total_dmg is 0, Newdef_enemy is Def_enemy-Atk_player));((Damage >= 0) -> (Total_dmg is Damage, Newdef_enemy is 0)),
    write(Classenemy), write(' took '), write(Total_dmg), write(' damage'),
    nl,
    damage_enemy(Total_dmg),
    set_def_enemy(Newdef_enemy),
    cekStatus, !.

attack :-
    gameState(_),
    write('This command can only used in battle'), nl,!.

special_attack :-
    gameState(fight),
    turn(X), (X+2)/2 mod 3 == 0,
    current_enemy_stat(_,Classenemy,_,_,_,_),
    current_enemy(HP_enemy, Atk_enemy, Def_enemy),
    character_status(Player, HP_player, Atk_player, Def_player),
    Atk_player1 is 2.5 * Atk_player,
    write('Attacking enemy'),
    nl,
    Damage is Atk_player1 - Def_enemy,
    ((Damage < 0) -> (Total_dmg is 0, Newdef_enemy is Def_enemy-Atk_player1));((Damage >= 0) -> (Total_dmg is Damage, Newdef_enemy is 0)),
    write(Classenemy), write(' took '), write(Total_dmg), write(' damage'),
    nl,
    damage_enemy(Total_dmg),
    set_def_enemy(Newdef_enemy),
    cekStatus, !.

special_attack :-
    gameState(fight),
    turn(X), Z is (X+2)/2 mod 3, Z =\= 0,
    write('You can use special attack '), write(Z), write(' turn left').

special_attack :-
    gameState(_),
    write('This command can only used in battle'), nl,!.

/* Enemy attack */
enemyAttack :-
    current_enemy_stat(_,Classenemy,_,_,_,_),
    current_enemy(HP_enemy, Atk_enemy, Def_enemy),
    character_status(Player, HP_player, Atk_player, Def_player),
    (((HP_player < 50) -> Atk_enemy1 is 2*Atk_enemy);
    (Atk_enemy1 is Atk_player)),
    Damage is Atk_enemy1 - Def_player,
    ((Damage < 0) -> (Total_dmg is 0, Newdef_player is Def_player-Atk_enemy1));((Damage >= 0) -> (Total_dmg is Damage, Newdef_player is 0)),
    write(Player), write(' took '), write(Total_dmg), write(' damage'),
    nl,
    NewHP is HP-Total_dmg,
    set_char_hp(NewHP),
    set_char_def(Newdef_player),
    cekStatus, !.

/* enemy & player turn */
enemyTurn :-
    write('Enemy attack'), nl,
    enemyAttack, !.

playerTurn :-
    write('Type "attack", "specialAttack", "run", or "usePotion"'), nl,
    hpStat,
    !.

/* fail and win battle */
failState :-
    current_enemy_stat(_,Classenemy,_,_,_,_),
    write('You failed to defeat the '), write(Classenemy), nl,
    halt, !.

winBattle :-
    write('You won the battle'), nl,
    current_enemy_stat(_,Classenemy,_,_,_,_),
    current_enemy(HP_enemy, Atk_enemy, Def_enemy),
    record_kill(Classenemy),
    check_quest,
    setGameState(start).


/* Next turn */
nextTurn :-
    turn(X),
    NextTurn is X+1,
    retract(turn(_)),
    asserta(turn(NextTurn)).

battle :-
    turn(X),
    ((X mod 2 == 0) -> playerTurn; (X mod 2 == 1) -> enemyTurn), !.

cekStatus :-
    current_enemy(HP_enemy,_,_),
    character_status(_,HP_player,_,_),

    ((HP_player =< 0 -> failState);
    (HP_enemy =< 0 -> winBattle; nextTurn, battle)), !.

hpStat :-
    current_enemy_stat(_,Classenemy,_,_,_,_),
    current_enemy(HP_enemy,_,_),
    character_status(Player, Hp_player,_,_),
    write('HP '), write(Player), write(' : '), write(Hp_player),
    nl,
    write('HP '), write(Classenemy), write(' : '), write(HP_enemy), !.

fight :-
    gameState(meetEnemy),
    setGameState(fight),
    startBattle,
    write('Battle begin'), nl,
    battle, !.

usePotion :-
    gameState(fight),
    total_potions(N),
    current_enemy_stat(_,Classenemy,_,_,_,_),
    current_enemy(HP_enemy, Atk_enemy, Def_enemy),
    character_status(_,HP_player,_,_),
    base_stat(BaseHP,_,_),
    ((N =\= 0) -> ((((HP_player+100 =< BaseHP) -> NewHP is HP_player+100); NewHP is BaseHP), write('You heal 100 HP'), nl, set_char_hp(NewHP), consume_potion, nextTurn, battle);write('You dont have enough potion'), nl, battle).
