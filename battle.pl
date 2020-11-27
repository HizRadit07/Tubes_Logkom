:- dynamic(usedSpecialatk/2).
:- dynamic(turn/1).
:- dynamic(gameState/1).
:- dynamic(turnspecial/2).

/* game state : start, meetEnemy, fight */
/* meetEnemy itu pas ketemu enemy, ada 2 pilihan command fight sama run */
/* fight itu pas gagal run atau emang milih fight ada pilihan attack, special_attack, usePotion, run */
/* use atk potion belum */

turn(-1).
gameState(notStart).
usedSpecialatk(-1,enemy).
turnspecial(0, 0).

modulo2(X,R) :-
    R is X mod 2.

/* Buat set GameState nya, baru kepikiran start, meetEnemy, fight */
setGameState(State) :-
    retract(gameState(_)),
    assertz(gameState(State)), !.

/* Inisialisasi battle */
startBattle :-
    retract(turn(_)),
    assertz(turn(0)),
    retract(turnspecial(_, _)),
    assertz(turnspecial(0, 0)),
    retract(usedSpecialatk(_, enemy)),
    assertz(usedSpecialatk(0, enemy)), !.

/* Mekanisme run */
run :-
    gameState(meetEnemy),
    random(0, 11, X),
    (X < 5 -> write('Sorry, You failed to run!'), nl, fight ;
    write('You run from battle'), nl, setGameState(start), map, nl), !.

run :-
    gameState(fight),
    random(0, 11, X),
    (X < 5 -> write('Sorry, You failed to run!'), nl, nextTurn, nextturnspecialatk, battle ;
    write('You run from battle'), nl, setGameState(start), map, nl), !.

/* Attack, specialAttack */

attack :-
    gameState(fight),
    current_enemy_stat(_,Classenemy,_,_,_,_),
    current_enemy(_, _, Def_enemy),
    character_status(Id, _, Atk_player,_),
    current_class(Id, _),
    write('Attacking enemy'),
    nl,
    /* mekanisme yang equip weapon belom dimasukkin */
    Damage is Atk_player - Def_enemy,
    (Damage < 0 -> Total_dmg is 0, Newdef_enemy is Def_enemy-1/4*Atk_player;
     Damage >= 0 -> Total_dmg is Damage, Newdef_enemy is Def_enemy-1/4*Damage),
    write(Classenemy), write(' took '), write(Total_dmg), write(' damage'),
    nl,
    damage_enemy(Total_dmg),
    set_def_enemy(Newdef_enemy),
    turnspecial(X, _),
    NewX is X+1,
    retract(turnspecial(_,_)),
    assertz(turnspecial(NewX, _)),
    cekStatus, !.

attack :-
    gameState(_),
    write('This command can only used in battle'), nl,!.

nextturnspecialatk :-
    turnspecial(X, _),
    NewX is X+1,
    retract(turnspecial(_,_)),
    assertz(turnspecial(NewX, _)).


cekSpecialatt(R) :-
    turnspecial(X,_),
    X>=3,
    retract(turnspecial(_,_)),
    assertz(turnspecial(X, 1)),
    R is 1, !.

cekSpecialatt(R) :-
    turnspecial(X,_),
    X<3,
    R is 0, !.

resetturnspecial :-
    retract(turnspecial(_,_)),
    assertz(turnspecial(0, 0)).

special_attack :-
    gameState(fight),
    cekSpecialatt(R),
    R is 1,
    current_enemy_stat(_,Classenemy,_,_,_,_),
    current_enemy(_, _, Def_enemy),
    character_status(Id, _, Atk_player, _),
    current_class(Id, _),
    Atk_player1 is 2 * Atk_player,
    write('Attacking enemy'),
    nl,
    Damage is Atk_player1 - Def_enemy,
    (Damage < 0 -> Total_dmg is 0, Newdef_enemy is Def_enemy-1/4*Atk_player1;
     Damage >= 0 -> Total_dmg is Damage, Newdef_enemy is Def_enemy-1/4*Damage),
    write(Classenemy), write(' took '), write(Total_dmg), write(' damage'),
    nl,
    damage_enemy(Total_dmg),
    set_def_enemy(Newdef_enemy),
    resetturnspecial,
    cekStatus, !.

special_attack :-
    gameState(fight),
    cekSpecialatt(R),
    R is 0,
    turnspecial(X,0),
    Z is 3-X,
    write('You can use special attack '), write(Z), write(' turn left'), nl, !.

special_attack :-
    gameState(_),
    write('This command can only used in battle'), nl,!.

/* Enemy attack */
enemyAttack :-
    current_enemy_stat(_,_,_,_,_,_),
    current_enemy(_, Atk_enemy, _),
    character_status(Id, HP_player, Atk_player, Def_player),
    current_class(Id, Player),
    (HP_player < 50 -> Atk_enemy1 is 2*Atk_enemy;
     Atk_enemy1 is Atk_player),
    Damage is Atk_enemy1 - Def_player,
    (Damage < 0 -> Total_dmg is 0, Newdef_player is Def_player-Atk_enemy1;
     Damage >= 0 -> Total_dmg is Damage, Newdef_player is 0),
    write(Player), write(' took '), write(Total_dmg), write(' damage'),
    nl,
    NewHP is HP_player-Total_dmg,
    set_char_hp(NewHP),
    set_char_def(Newdef_player),
    cekStatus, !.

/* enemy & player turn */
enemyTurn :-
    write('Enemy attack'), nl,
    enemyAttack, !.

playerTurn :-
    write('Type "attack", "special_attack", "run",  "usePotion", or "useAttackPotion"'), nl,
    hpStat,
    !.

/* fail and win battle */
failState :-
    current_enemy_stat(_,Classenemy,_,_,_,_),
    write('You failed to defeat the '), write(Classenemy), nl,
    halt, !.

winBattle :-
    current_enemy_stat(4,_,_,_,_,_),
    current_enemy(_, _, _),
    write('Congratulation, you have slained the dragon and save the world!'), nl,
    setGameState(start),!.


winBattle :-
    current_enemy_stat(_,Classenemy,_,_,_,_),
    current_enemy(_, _, _),
    write('You won the battle'), nl,
    record_kill(Classenemy),
    check_quest,
    setGameState(start),
    equip_stat(Atk, Def),
    set_char_atk(Atk),
    set_char_def(Def),!.


/* Next turn */
nextTurn :-
    turn(X),
    NextTurn is X+1,
    retract(turn(_)),
    asserta(turn(NextTurn)).

battle :-
    turn(X),
    modulo2(X, R),
    (R == 0 -> playerTurn;
     R == 1 -> enemyTurn), !.

cekStatus :-
    current_enemy(HP_enemy,_,_),
    character_status(_,HP_player,_,_),

    (HP_player =< 0 -> failState;
     HP_enemy =< 0 -> winBattle; nextTurn, battle), !.

hpStat :-
    current_enemy_stat(_,Classenemy,_,_,_,_),
    current_enemy(HP_enemy,_,_),
    character_status(Id, Hp_player,_,_),
    current_class(Id, Player),
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
    /*current_enemy_stat(_,Classenemy,_,_,_,_),
    current_enemy(HP_enemy, Atk_enemy, Def_enemy),*/
    character_status(_,HP_player,_,_),
    base_stat(BaseHP,_,_),
    (N =\= 0 ->
        (HP_player+100 =< BaseHP -> NewHP is HP_player+100; NewHP is BaseHP), write('You heal 100 HP'), nl,
         set_char_hp(NewHP), consume_potion, nextTurn, battle;
         write('You dont have enough potion'), nl, battle).


usePotion :-
  gameState(start),
  total_potions(N),
  character_status(_,HP_player,_,_),
  base_stat(BaseHP,_,_),
  (N =\= 0 ->
      (HP_player+100 =< BaseHP -> NewHP is HP_player+100; NewHP is BaseHP), write('You heal 100 HP'), nl,
       set_char_hp(NewHP), consume_potion;
       write('You dont have enough potion'), nl).

useAttackPotion :-
  gameState(fight),
  total_attpotions(N),
  /*current_enemy_stat(_,Classenemy,_,_,_,_),
  current_enemy(HP_enemy, Atk_enemy, Def_enemy),*/

  (N =\= 0 ->
      (add_char_atk(15)), write('You gain 15 attack'), nl,
       consume_attpotions, nextTurn, battle;
       write('You dont have enough attack potion'), nl, battle).
