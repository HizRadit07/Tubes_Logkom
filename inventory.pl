:- dynamic(item_storage/1).
:- dynamic(total_potions/1).
:- dynamic(total_attpotions/1).
:- dynamic(avail_slot/1).
:- dynamic(bag/1).
:- dynamic(weapon/4).
:- dynamic(armor/4).
:- dynamic(accesories/4).

bag([]).

/*  weapon(ID,Nama,Class,Stat)
    armor(ID,Nama,Class,Stat)
    accesories(ID,Nama,Class,Stat)
*/
id_item(1,'pedang').

/*gachaWeaponSwordsman([pedang,pedanghitam,pedangbiru]).
gachaWeaponArcher([panah,panahijo,panahmerah]).
gachaWeaponSorcerer([staff,staffijo,staffcoklat]).
gachaArmorSwordsman([kingarmor,redarmor,blackarmor]).
gachaArmorArcher([silk,redsilk,bluesilk,darksilk]).
gachaArmorSorcerer([robe,greatrobe]).
gachaAccSwordsman([shield,bracelet,helmet]).
gachaAccArcher([elvenquiver,griffonshoes,birdmask]).
gachaAccSorcerer([manaring,bookofwisdom]).
*/

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

addS(X,[],[X]): true,!.
addS(X,[H|T],[H|T1]):-
    addS(X,T,T1).

remove(X,[X|Xs],Xs):- !.
remove(X,[_|Xs],Result):-
    remove(X,Xs,Tmp),
    addS(X,Tmp,Result).

add_weapon(Name,Class,Stats):-
    item_storage(N),
    N1 is N+1,
    retract(item_storage(N)),
    assertz(item_storage(N1)),
    id_item(ID,Name),
    assertz(weapon(ID,Name,Class,Stats)).
    bag(Bag),
    addS(ID,Bag,Resbag),
    retract(bag(Bag)),
    assertz(bag(Resbag)).

add_armor(Name,Class,Stats):-
    item_storage(N),
    N1 is N+1,
    retract(item_storage(N)),
    assertz(item_storage(N1)),
    id_item(ID,Name),
    assertz(armor(ID,Name,Class,Stats)).
    bag(Bag),
    addS(ID,Bag,Resbag),
    retract(bag(Bag)),
    assertz(bag(Resbag)).

add_accesories(Name,Class,Stats):-
    item_storage(N),
    N1 is N+1,
    retract(item_storage(N)),
    assertz(item_storage(N1)),
    id_item(ID,Name),
    assertz(accesories(ID,Name,Class,Stats)).
    bag(Bag),
    addS(ID,Bag,Resbag),
    retract(bag(Bag)),
    assertz(bag(Resbag)).

remove_weapon(ID):-
    item_storage(N),
    N1 is N-1,
    retract(item_storage(N)),
    assertz(item_storage(N1)),
    retract(weapon(ID,_,_,_)),
    bag(Bag),
    remove(ID,Bag,Resbag),
    retract(bag(Bag)),
    assertz(bag(Resbag)).

remove_armor(ID):-
    item_storage(N),
    N1 is N-1,
    retract(item_storage(N)),
    assertz(item_storage(N1)),
    retract(armor(ID,_,_,_)),
    bag(Bag),
    remove(ID,Bag,Resbag),
    retract(bag(Bag)),
    assertz(bag(Resbag)).

remove_accesories(ID):-
    item_storage(N),
    N1 is N-1,
    retract(item_storage(N)),
    assertz(item_storage(N1)),
    retract(accesories(ID,_,_,_)),
    bag(Bag),
    remove(ID,Bag,Resbag),
    retract(bag(Bag)),
    assertz(bag(Resbag)).

show_bag([]).
show_bag([H|T]);-
    id_item(H,Nama),
    (weapon(H,Nama,Class,_),!;armor(H,Nama,Class,_),!;accesories(H,Nama,Class,_),!),
    write(Nama),write(' ('),write(Class),write(')'),nl,
    show_bag(T),!.

inventory:-
    bag(Bag),
    show_bag(Bag),
    total_potions(N),
    write('you have '),write(N),write(' potion(s).'),nl,
    total_attpotions(N),
    write('you have '),write(N),write(' attack potion(s).'),nl,!.