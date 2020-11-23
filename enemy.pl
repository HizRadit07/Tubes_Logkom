:- dynamic(current_enemy/3). /*enemy yang lagi battle*/

enemy_class(1, goblin).
enemy_class(2, slime).
enemy_class(3, direwolf).
enemy_class(4, dragon).

enemy_status(goblin, 1, 10, 10, 5). /*(class, level, hp, attack,defense)*/
enemy_status(slime, 1, 20, 10, 15 ).
enemy_status(direwolf, 1, 20, 30, 10 ).
enemy_status(dragon, 15, 300, 200, 150).

enemy_status(goblin, A, B, C, D) :-
  A > 1,
  A1 is A-1,
  enemy_status(goblin, A1, B1, C1, D1),
  B is B1 + 10,
  C is C1 + 5,
  D is D1 + 5.

enemy_status(slime, A, B, C, D) :-
  A > 1,
  A1 is A-1,
  enemy_status(slime, A1, B1, C1, D1),
  B is B1 + 5,
  C is C1 + 5,
  D is D1 + 10.

enemy_status(direwolf, A, B, C, D) :-
  A > 1,
  A1 is A-1,
  enemy_status(direwolf, A1, B1, C1, D1),
  B is B1 + 5,
  C is C1 + 10,
  D is D1 + 5.

set_enemy(Class, Level) :-
  enemy_status(Class, Level, HP, Atk, Def),
  retractall(current_enemy(_,_,_)),
  assertz(current_enemy(Hp, Atk, Def)).

damage_enemy(X) :-
  current_enemy(HP, Atk, Def),
  HP1 is HP - X,
  retract(current_enemy(HP, Atk, Def)),
  assertz(HP1, Atk, Def).
