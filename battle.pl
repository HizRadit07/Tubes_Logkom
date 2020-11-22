:- dynamic(usedSpecialatk/2).
:- dynamic(turn/1).
:- dynamic(enemy_in_battle/3).
/* enemy_in_battle nanti menyesuaikan sama yang enemy */

/* Inisialisasi battle */
startBattle :-
    aserta(turn(0)),
    aserta(usedSpecialatk(0, player)),
    aserta(usedSpecialatk(0, enemy)), !.

attack :-
    enemy_in_battle(Classenemy, Lvl_Enemy, enemy),
    enemy_status(Classenemy, Lvl_Enemy, HP_enemy, Atk_enemmy, Def_enemy),
    character_class(Player),
    character_status(Player, HP_player, Atk_player, Def_player),
    character_level(Player, Lvl_player),
    equip_weapon(Weapon),
    equip_armor(Armor),
    write('Attacking enemy'),
    nl,
    /* mekanisme yang equip weapon belom dimasukkin */
    Damage is Atk_player - Def_enemy,
    ((Damage < 0) -> (Total_dmg is 0, Newdef_enemy is Def_enemy-Atk_player);(Total_dmg is Damage, Newdef_enemy is 0)),
    write(Classenemy), write(' took '), write(Total_dmg), write(' damage'),
    nl,
    NewHP is HP-Total_dmg,
    set_HP(Classenemy, NewHP), /* Ini buat ngubah HP sama Def dari enemy */
    setDef(Classenemy, Newdef_enemy),
    cekStatus, !.

special_attack :-
    useSpecialatk(0, player),
    enemy_in_battle(Classenemy, Lvl_Enemy, enemy), 
    enemy_status(Classenemy, Lvl_Enemy, HP_enemy, Atk_enemmy, Def_enemy),
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
    ((Damage < 0) -> (Total_dmg is 0, Newdef_enemy is Def_enemy-Atk_player);(Total_dmg is Damage, Newdef_enemy is 0)),
    write(Classenemy), write(' took '), write(Total_dmg), write(' damage'),
    nl,
    NewHP is HP-Total_dmg,
    set_HP(Classenemy, NewHP),
    setDef(Classenemy, Newdef_enemy),
    cekStatus, !.

special_attack :-
    useSpecialatk(_, player).


    
    
    

