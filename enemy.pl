:- dynamic(current_enemy/3).

enemy_class(goblin).
enemy_class(slime).
enemy_class(direwolf).

enemy_status(goblin, 1, 5, 10, 10). /*(class, level, hp, attack,defense)*/
enemy_status(slime, 1, 10, 20, 20 ).
enemy_status(direwolf, 1, 15, 25, 25 ).

enemy_status(goblin, A, B, C, D) :-
  A > 1,
  A1 is A-1,
  enemy_status(goblin, A1, B1, C1, D1),
  B is B1 + 10,
  C is C1 + 10,
  D is D1 + 10.
