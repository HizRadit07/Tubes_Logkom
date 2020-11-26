:- dynamic(item_storage/1).
:- dynamic(total_potions/1).
:- dynamic(total_attpotions/1).
:- dynamic(avail_slot/1).
:- dynamic(bag/1).
:- dynamic(weapon/4).
:- dynamic(armor/4).
:- dynamic(accesories/4).

/*  weapon(ID,Nama,Class,Stat)
    armor(ID,Nama,Class,Stat)
    accesories(ID,Nama,Class,Stat)
*/
weapon(_, none, _, 0).

armor(_, none, _, 0).

accesories(_,none,_,0).

id_item(1,'Sword').
id_item(2,'Black Sword').
id_item(3,'Great Sword').
id_item(4,'Bow').
id_item(5,'Green Bow').
id_item(6,'Long Bow').
id_item(7,'Staff').
id_item(8,'Staff of Apprentice').
id_item(9,'Wizard Staff').
id_item(10,'Armor').
id_item(11,'Black Armor').
id_item(12,'King Armor').
id_item(13,'Silk').
id_item(14,'Red Silk').
id_item(15,'Dark Silk').
id_item(16,'Dragon Silk').
id_item(17,'Robe').
id_item(18,'Great Robe').
id_item(19,'Bracelet').
id_item(20,'Helmet').
id_item(21,'Elven Quiver').
id_item(22,'Griffon Shoes').
id_item(23,'Bird Mask').
id_item(24,'Book of Apprentice').
id_item(25,'Mana Ring').
id_item(26,'Book of Wisdom').
id_item(27,'Slytherin Cloak').

item_storage(0).
total_potions(0).
total_attpotions(0).

add_potions(X) :-
    item_storage(N),
    N1 is N+X,
    retract(item_storage(N)),
    assertz(item_storage(N1)),
    total_potions(M),
    M1 is M+X,
    retract(total_potions(M)),
    assertz(total_potions(M1)).

add_attpotions(X) :-
    item_storage(N),
    N1 is N+X,
    retract(item_storage(N)),
    assertz(item_storage(N1)),
    total_attpotions(M),
    M1 is M+X,
    retract(total_attpotions(M)),
    assertz(total_attpotions(M1)).

/*predikat yang bisa aja masuk ke battle*/
consume_potion :-
    item_storage(N),
    N1 is N-1,
    retract(item_storage(N)),
    assertz(item_storage(N1)),
    total_potions(M),
    M1 is M-1,
    retract(total_potions(M)),
    assertz(total_potions(M1)).

consume_attpotions :-
    item_storage(N),
    N1 is N-1,
    retract(item_storage(N)),
    assertz(item_storage(N1)),
    total_attpotions(M),
    M1 is M-1,
    retract(total_attpotions(M)),
    assertz(total_attpotions(M1)).


bag([]).

konsdot(X,[],[X]):-!.
konsdot(X,[H|T],[H|T1]):-
    konsdot(X,T,T1),!.

konso(X,[],[X]).
konso(X,Y,[X|Y]):- !.

remove(X,[X],[]).
remove(X,[X|Xs],Xs):- !.
remove(X,[Y|Xs],Result):-
    remove(X,Xs,Tmp),
    konso(Y,Tmp,Result),!.

add_weapon(Name,Class,Stats):-
    item_storage(N),
    N1 is N+1,
    retract(item_storage(N)),
    assertz(item_storage(N1)),
    id_item(ID,Name),!,
    assertz(weapon(ID,Name,Class,Stats)),
    bag(Bag),
    konsdot(ID,Bag,Resbag),
    retract(bag(Bag)),
    assertz(bag(Resbag)).

add_armor(Name,Class,Stats):-
    item_storage(N),
    N1 is N+1,
    retract(item_storage(N)),
    assertz(item_storage(N1)),
    id_item(ID,Name),!,
    assertz(armor(ID,Name,Class,Stats)),
    bag(Bag),
    konsdot(ID,Bag,Resbag),
    retract(bag(Bag)),
    assertz(bag(Resbag)).

add_accesories(Name,Class,Stats):-
    item_storage(N),
    N1 is N+1,
    retract(item_storage(N)),
    assertz(item_storage(N1)),
    id_item(ID,Name),!,
    assertz(accesories(ID,Name,Class,Stats)),
    bag(Bag),
    konsdot(ID,Bag,Resbag),
    retract(bag(Bag)),
    assertz(bag(Resbag)).

remove_weapon(ID):-
    item_storage(N),
    N1 is N-1,
    retract(item_storage(N)),
    assertz(item_storage(N1)),
    retract(weapon(ID,_,_,_)),
    bag(Bag),
    remove(ID,Bag,Resbag),!,
    retract(bag(Bag)),
    assertz(bag(Resbag)).

remove_armor(ID):-
    item_storage(N),
    N1 is N-1,
    retract(item_storage(N)),
    assertz(item_storage(N1)),
    retract(armor(ID,_,_,_)),
    bag(Bag),
    remove(ID,Bag,Resbag),!,
    retract(bag(Bag)),
    assertz(bag(Resbag)).

remove_accesories(ID):-
    item_storage(N),
    N1 is N-1,
    retract(item_storage(N)),
    assertz(item_storage(N1)),
    retract(accesories(ID,_,_,_)),
    bag(Bag),
    remove(ID,Bag,Resbag),!,
    retract(bag(Bag)),
    assertz(bag(Resbag)).

show_bag([]).
show_bag([H|T]):-
    id_item(H,Nama),
    (weapon(H,Nama,Class,_),!;armor(H,Nama,Class,_),!;accesories(H,Nama,Class,_),!),
    write('1 '),write(Nama),write(' ('),write(Class),write(').'),nl,
    show_bag(T),!.

inventory:-
    bag(Bag),
    show_bag(Bag),
    total_potions(N),
    write('you have '),write(N),write(' potion(s).'),nl,
    total_attpotions(N),
    write('you have '),write(N),write(' attack potion(s).'),nl,!.
