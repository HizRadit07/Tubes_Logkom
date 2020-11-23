:-dynamic(quest_status / 1).
:-dynamic(c_quest / 3).
:-dynamic(quest / 4).

quest_status(0). /*0 : tidak ada ctive quest, 1 : sedang ada active quest*/

/*quest(Goblin, Slime, direwolf)*/

/*Membuat quest secara random*/
make_quest :-
  enemy_count(Goblin, Slime, Direwolf),
  C is Goblin+Slime+Direwolf,
  C =:= 0,
  make_quest,!.


make_quest :-
  enemy_count(Goblin, Slime, Direwolf),
  C is Goblin+Slime+Direwolf,
  Reward is 100*(C),
  D is C +1,
  random(0, D, Bonus),
  Total is Reward + Bonus*100,
  assertz(quest(Goblin, Slime, Direwolf, Total)), !.


goblin_count(X) :-
  character_level(Level),
  A is Level+1,
  random(0, A, X).

slime_count(Goblin, Slime) :-
  character_level(Level),
  goblin_count(Goblin),
  Y is Level - Goblin,
  Y =< 0,
  Slime is 0.

slime_count(Goblin, Slime) :-
  character_level(Level),
  goblin_count(Goblin),
  Y is Level - Goblin,
  Z is Y+1,
  random(0, Z, Slime), !.

enemy_count(Goblin, Slime, Direwolf) :-
  character_level(Level),
  slime_count(Goblin, Slime),
  Y is Level - Goblin - Slime,
  Y =< 0,
  Direwolf is 0, !.

enemy_count(Goblin, Slime, Direwolf) :-
  character_level(Level),
  slime_count(Goblin, Slime),
  Y is Level - Goblin -Slime,
  Z is Y + 1,
  random(0, Z, Direwolf), !.

/*Mengecek apakah player berada di dekat quest point*/
near_quest :-
  map_object(X, Y, 'P'),
  A is X + 1,
  map_object(A, Y, 'Q'),!.

near_quest :-
  map_object(X, Y, 'P'),
  A is X - 1,
  map_object(A, Y, 'Q'),!.

near_quest :-
  map_object(X, Y, 'P'),
  A is Y + 1,
  map_object(X, A, 'Q'),!.

near_quest :-
  map_object(X, Y, 'P'),
  A is Y - 1,
  map_object(X, A, 'Q'),!.

/*Player memilih akan menerima quest atau tidak*/
offer_quest(X) :-
  X =:= 2,
  retractall(quest(_,_,_,_)), !.

offer_quest(X) :-
  X =:= 1,
  assertz(c_quest(0, 0, 0)),
  retract(quest_status(0)),
  assertz(quest_status(1)), !.

/*Player belum punya quest, dan berada di dekat quest point. Player ditawari sebuah quest*/
quest :-
  near_quest,
  quest_status(S),
  S =:= 0,
  make_quest,
  quest(Goblin, Slime, Direwolf, Reward),
  format('Kill ~w Goblin(s)~n', [Goblin]),
  format('Kill ~w Slime(s)~n', [Slime]),
  format('Kill ~w Direwolf(s)~n', [Direwolf]),
  format('Reward: ~w Gold~n', [Reward]),
  write('Do you accept this quest? '),nl,
  write('1. Yes'),nl,
  write('2. No'),nl,
  read(X),
  offer_quest(X), !.

/*Player tidak punya quest dan tidak berada di quest point. Menampilkan pesan tidak ada quest*/
quest :-
  \+ near_quest,
  quest_status(S),
  S =:= 0,
  write('You have no active quest'),!.

/*Player memiliki quest active. Menampilkan quest progress*/
quest :-
  quest_status(S),
  S =:= 1,
  write('Quest Progress'), nl,
  c_quest(Goblin1, Slime1, Direwolf1),
  quest(Goblin, Slime, Direwolf, Reward),
  format('Kill Goblin(s): ~w/~w~n', [Goblin1, Goblin]),
  format('Kill Slime(s): ~w/~w~n', [Slime1, Slime]),
  format('Kill Direwolf(s): ~w/~w~n', [Direwolf1, Direwolf]),
  format('Reward: ~w Gold~n', [Reward]), !.

/*Mengecek apakah quest sudah terpenuhi, dipanggil setelah record kill*/
check_quest :-
  c_quest(Goblin1, Slime1, Direwolf1),
  quest(Goblin, Slime, Direwolf, Reward),
  Goblin =< Goblin1,
  Slime =< Slime1,
  Direwolf =< Direwolf1,
  retract(quest_status(1)),
  assertz(quest_status(0)),
  retract(c_quest(Goblin, Slime, Direwolf)),
  add_gold(Reward),!.

check_quest :-
  !.

/*Mengupdate quest jika berhasil membunuh enemy*/
record_goblin :-
  c_quest(Goblin, Slime, Direwolf),
  A is Goblin + 1,
  retract(c_quest(Goblin, Slime, Direwolf)),
  assertz(c_quest(A, Slime, Direwolf)).

record_slime :-
  c_quest(Goblin, Slime, Direwolf),
  A is Slime + 1,
  retract(c_quest(Goblin, Slime, Direwolf)),
  assertz(c_quest(Goblin, A, Direwolf)).

record_direwolf :-
  c_quest(Goblin, Slime, Direwolf),
  A is Direwolf + 1,
  retract(c_quest(Goblin, Slime, Direwolf)),
  assertz(c_quest(Goblin, Slime, A)).

/*record_kill dipanggil setiap berhasil mengalahkan enemy*/
record_kill(EnemyClass) :-
  quest_status(1),
  enemy_class(X, EnemyClass),
  X =:= 1,
  record_goblin, !.

record_kill(EnemyClass) :-
  quest_status(1),
  enemy_class(X, EnemyClass),
  X =:= 2,
  record_slime, !.

record_kill(EnemyClass) :-
  quest_status(1),
  enemy_class(X, EnemyClass),
  X =:= 3,
  record_direwolf, !.

record_kill(EnemyClass) :- !.
