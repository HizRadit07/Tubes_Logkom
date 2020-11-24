:- dynamic(current_enemy/3). /*enemy yang lagi battle*/
:- dynamic(current_enemy_class/2). /*class current enemy*/
:- dynamic(current_enemy_stat/6).

enemy_class(1, 'goblin'). /*Id ClassName*/
enemy_class(2, 'slime').
enemy_class(3, 'direwolf').
enemy_class(4, 'dragon').

enemy_status(1,'goblin', 1, 10, 10, 5). /*(ID,class, level, hp, attack,defense)*/
enemy_status(2,'slime', 1, 20, 10, 15 ).
enemy_status(3,'direwolf', 1, 20, 30, 10 ).
enemy_status(4,'dragon', 15, 300, 200, 150).

enemy_status(ID,'goblin', A, B, C, D) :-
  A > 1,
  A1 is A-1,
  enemy_status(ID,'goblin', A1, B1, C1, D1),
  B is B1 + 10,
  C is C1 + 5,
  D is D1 + 5.

enemy_status(ID,'slime', A, B, C, D) :-
  A > 1,
  A1 is A-1,
  enemy_status(ID,'slime', A1, B1, C1, D1),
  B is B1 + 5,
  C is C1 + 5,
  D is D1 + 10.

enemy_status(ID,'direwolf', A, B, C, D) :-
  A > 1,
  A1 is A-1,
  enemy_status(ID,'direwolf', A1, B1, C1, D1),
  B is B1 + 5,
  C is C1 + 10,
  D is D1 + 5.

set_enemy(ID, Level) :-
  enemy_status(ID,_, Level, HP, Atk, Def),
  retractall(current_enemy(_,_,_)),
  assertz(current_enemy(HP, Atk, Def)).

damage_enemy(X) :-
  current_enemy(HP, Atk, Def),
  HP1 is HP - X,
  retract(current_enemy(HP, Atk, Def)),
  assertz(HP1, Atk, Def).

set_def_enemy(X) :-
  current_enemy(HP, Atk, Def),
  retract(current_enemy(HP, Atk, Def)),
  assertz(HP, Atk, X).

generate_random_enemy :-
  % randomize ID
  random(1,4,EnemyID),
  enemy_class(EnemyID,Name),
  retract(current_enemy_class(_,_)),
  assertz(current_enemy_class(EnemyID,Name)),

  % randomize Level
  random(1,4,EnemyLvl),
  enemy_status(EnemyID,Name,EnemyLvl,HP,Atk,Def),
  retractall(current_enemy_stat(_,_,_,_,_)),
  assertz(current_enemy_stat(EnemyID,Name,EnemyLvl,HP,Atk,Def)),
  retract(current_enemy(_,_,_)),
  assertz(current_enemy(HP,Atk,Def)).
