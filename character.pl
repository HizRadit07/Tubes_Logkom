:- dynamic(current_class/2).
:- dynamic(character_status/4).
:- dynamic(base_stat/3).
:- dynamic(character_level/1).
:- dynamic(character_xp/1).
:- dynamic(character_gold/1).
:- dynamic(current_weapon/1).
:- dynamic(current_armor/1).
:- dynamic(current_accesories/1).

% current_class(ID,Nama)
current_class(1,'Swordsman').
current_class(2,'Archer').
current_class(3,'Sorcerer').

character_class(1, 90, 20, 30). % /*classID, hp, atk, def*/
character_class(2, 80, 30, 30).
character_class(3, 80, 40, 20).

character_status(none, 0, 0, 0). % /*class, hp, atk, def*/
base_stat(0, 0, 0). % /*hp, atk, def*/

character_level(1).

character_xp(0).

character_gold(5000).


/*Menambah Gold*/
add_gold(X):-
  character_gold(Y),
  Z is X + Y,
  retract(character_gold(Y)),
  assertz(character_gold(Z)),!.
/*Menambah Xp Player*/
add_xp(X):-
  character_xp(Y),
  Z is X + Y,
  retract(character_xp(Y)),
  assertz(character_xp(Z)),
  levelup(Z),!.

/*Level up player*/
levelup(A) :-
  A >= 400,
  Y is A - 400,
  retract(character_xp(A)),
  assertz(character_xp(Y)),
  character_level(Z),
  X is Z + 1,
  retract(character_level(Z)),
  assertz(character_level(X)),
  add_base_stat(10, 10, 10), % /*Semua stat ditambah 10*/
  levelup(Y).

levelup(A) :-
  A < 400.

/*Memilih class player*/
choose_class(X) :-
  character_class(X, A, B, C),
  retract(base_stat(0, 0, 0)),
  assertz(base_stat(A, B, C)),
  retract(character_status(none, 0, 0, 0)),
  assertz(character_status(X, A, B, C)).

/*Menambah player hp*/
add_char_hp(X) :-
  character_status(A, B, C, D),
  Y is X + B,
  retract(character_status(A, B, C, D)),
  assertz(character_status(A, Y, C, D)),!.

set_char_hp(X) :-
  character_status(A, B, C, D),
  retract(character_status(A, B, C, D)),
  assertz(character_status(A, X, C, D)),!.

/*Menambah player, attack*/
add_char_atk(X) :-
  character_status(A, B, C, D),
  Y is X + C,
  retract(character_status(A, B, C, D)),
  assertz(character_status(A, B, Y, D)),!.

/*Menambah player defense*/
add_char_def(X) :-
  character_status(A, B, C, D),
  Y is X + D,
  retract(character_status(A, B, C, D)),
  assertz(character_status(A, B, C, Y)),!.

set_char_def(X) :-
  character_status(A, B, C, D),
  retract(character_status(A, B, C, D)),
  assertz(character_status(A, B, C, X)),!.

/*Menambah Base stat*/
add_base_stat(X, Y, Z) :-
  base_stat(Hp, Atk, Def),
  Hp1 is Hp + X,
  Atk1 is Atk + Y,
  Def1 is Def + Z,
  character_status(Class, A, B, C),
  A1 is Hp1,
  B1 is B + Y,
  C1 is C + Z,
  retract(base_stat(Hp, Atk, Def)),
  assertz(base_stat(Hp1, Atk1, Def1)),
  retract(character_status(Class, A, B, C)),
  assertz(character_status(Class, A1, B1, C1)),!.




/*Equipment*/
current_weapon(none).
current_armor(none).
current_accesories(none).


equip_weapon(Weapon) :-
  weapon(_, Weapon, Class, Atk),
  current_class(ClassID, Class),
  character_status(ClassID, _, _, _),
  current_weapon(X),
  weapon(_, X, _, A),
  Y is A * -1,
  add_char_atk(Y),
  retract(current_weapon(X)),
  assertz(current_weapon(Weapon)),
  add_char_atk(Atk),!.

equip_armor(Armor) :-
  armor(_, Armor, Class, Def),
  current_class(ClassID, Class),
  character_status(ClassID, _, _, _),
  current_armor(X),
  armor(_, X, _, A),
  Y is A * -1,
  add_char_def(Y),
  retract(current_armor(X)),
  assertz(current_armor(Armor)),
  add_char_def(Def),!.

equip_accesories(Accesories) :-
  accesories(_, Accesories, Class, HP),
  current_class(ClassID, Class),
  character_status(ClassID, _, _, _),
  current_accesories(X),
  accesories(_, X, _, A),
  Y is A * -1,
  add_base_stat(Y,0,0),
  retract(current_accesories(X)),
  assertz(current_accesories(Accesories)),
  add_base_stat(HP,0,0),!.

equip(X) :-
  weapon(_, X, _, _),
  equip_weapon(X),!.

equip(X) :-
  armor(_, X, _, _),
  equip_armor(X),!.

equip(X) :-
    accesories(_, X, _, _),
    equip_accesories(X),!.

status :-
  character_status(Class, HP, Atk, Def),
  base_stat(HP1, _, _),
  current_class(Class, ClassName),
  character_level(Level),
  character_xp(Xp),
  character_gold(Gold),
  format('Class : ~w ~n', [ClassName]),
  format('Level : ~w ~n', [Level]),
  format('Health : ~w/~w ~n', [HP, HP1]),
  format('Attack : ~w ~n', [Atk]),
  format('Defense : ~w ~n', [Def]),
  Exp is (Level-1)*400 + Xp,
  Y is Level * 400,
  format('Exp : ~w/~w ~n', [Exp, Y]),
  format('Gold : ~w ~n', [Gold]), !.
