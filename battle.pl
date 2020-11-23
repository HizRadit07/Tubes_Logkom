:- dynamic(usedSpecialatk/2).
:- dynamic(turn/1).
:- dynamic(enemy_in_battle/3).
/* enemy_in_battle nanti menyesuaikan sama yang enemy */
/* Harus ada game statenya lagi explore di map, ketemu enemy, fight */
/* Tinggal pake state game, use healing&atk potion, mekanisme run, fight */


/* Inisialisasi battle */
startBattle :-
    aserta(turn(0)),
    aserta(usedSpecialatk(0, player)),
    aserta(usedSpecialatk(0, enemy)), !.

attack :-
    enemy_in_battle(Classenemy, Lvl_Enemy, enemy),
    enemy_status(Classenemy, Lvl_Enemy, HP_enemy, Atk_enemy, Def_enemy),
    character_class(Player),
    character_status(Player, HP_player, Atk_player, Def_player),
    character_level(Player, Lvl_player),
    equip_weapon(Weapon),
    equip_armor(Armor),
    write('Attacking enemy'),
    nl,
    /* mekanisme yang equip weapon belom dimasukkin */
    Damage is Atk_player - Def_enemy,
    ((Damage < 0) -> (Total_dmg is 0, Newdef_enemy is Def_enemy-Atk_player));((Damage >= 0) -> (Total_dmg is Damage, Newdef_enemy is 0)),
    write(Classenemy), write(' took '), write(Total_dmg), write(' damage'),
    nl,
    NewHP is HP-Total_dmg,
    set_HP(Classenemy, NewHP), /* Ini buat ngubah HP sama Def dari enemy */
    setDef(Classenemy, Newdef_enemy),
    cekStatus, !.

special_attack :-
    turn(X), (X+2)/2 mod 3 == 0,
    enemy_in_battle(Classenemy, Lvl_Enemy, enemy), 
    enemy_status(Classenemy, Lvl_Enemy, HP_enemy, Atk_enemy, Def_enemy),
    character_class(Player),
    character_status(Player, HP_player, Atk_player, Def_player),
    character_level(Player, Lvl_player),
    equip_weapon(Weapon),
    equip_armor(Armor),
    ((Player == swordsman) -> Atk_player is 0 /* Penambahan atk nya */);((Player == archer) -> Atk_player is 0);((Player == sorcerer) -> Atk_player is 0),
    write('Attacking enemy'),
    nl,
    /* mekanisme yang equip weapon belom dimasukkin */
    Damage is Atk_player - Def_enemy,
    ((Damage < 0) -> (Total_dmg is 0, Newdef_enemy is Def_enemy-Atk_player));((Damage >= 0) -> (Total_dmg is Damage, Newdef_enemy is 0)),
    write(Classenemy), write(' took '), write(Total_dmg), write(' damage'),
    nl,
    NewHP is HP-Total_dmg,
    set_HP(Classenemy, NewHP),
    setDef(Classenemy, Newdef_enemy),
    cekStatus, !.

special_attack :-
    turn(X), Z is (X+2)/2 mod 3, Z =\= 0, 
    write('You can use special attack '), write(Z), write(' turn left').

enemyAttack :-
    enemy_in_battle(Classenemy, Lvl_Enemy, enemy),
    enemy_status(Classenemy, Lvl_Enemy, HP_enemy, Atk_enemy, Def_enemy),
    character_class(Player),
    character_status(Player, HP_player, Atk_player, Def_player),
    character_level(Player, Lvl_player),
    equip_weapon(Weapon),
    equip_armor(Armor),
    /* mekanisme yang equip weapon belom dimasukkin */
    /* mekanisme special attack buat enemy belum dimasukin */
    Damage is Atk_enemy - Def_player,
    ((Damage < 0) -> (Total_dmg is 0, Newdef_player is Def_player-Atk_enemy));((Damage >= 0) -> (Total_dmg is Damage, Newdef_player is 0)),
    write(Player), write(' took '), write(Total_dmg), write(' damage'),
    nl,
    NewHP is HP-Total_dmg,
    add_char_def(Newdef_player), /* Ini buat ngubah HP sama Def dari enemy */
    add_char_hp(Classenemy, Newdef_enemy),
    cekStatus, !.
    
enemyTurn :-
    write('Enemy attack'), nl,
    enemyAttack, !.

playerTurn :-
    write('Type "attack" or "specialAttack"'), nl,
    hpStat,
    !.

failState :-
    enemy_in_battle(Classenemy, Lvl_enemy, enemy),
    write('You failed to defeat the '), write(enemy), nl,
    halt, !.

winBattle :-
    write('You won the battle'), nl.
/* Nanti update exp gold quest */

nextTurn :-
    turn(X),
    NextTurn is X+1,
    retract(turn(_)),
    asserta(turn(NextTurn)).

battle :-
    turn(X),
    ((X mod 2 == 0) -> playerTurn; (X mod 2 == 1) -> enemyTurn), !.

cekStatus :-
    enemy_in_battle(Classenemy, Lvl_enemy, enemy),
    character_status(Player, Hp_player, Atk_player, Def_player),
    enemy_status(Classenemy, Lvl_enemy, Hp_enemy, Atk_enemy, Def_enemy),
    
    (Hp_player =< 0 -> failState;
    Hp_enemy =< 0 -> winBattle; nextTurn, battle), !.

hpStat :-
    enemy_in_battle(Classenemy, Lvl_enemy, enemy),
    character_status(Player, Hp_player, Atk_player, Def_player),
    enemy_status(Classenemy, Lvl_Enemy, HP_enemy, Atk_enemy, Def_enemy),
    write('HP '), write(Player), write(' : '), write(Hp_player),
    nl,
    write('HP '), write(Classenemy), write(' : '), write(HP_enemy), !.
    
    

