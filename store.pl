/* Predikat yang bisa aja masuk ke dalam inventory */
:- dynamic(generate_number/1).

generate_number(53).



potion:-
    character_gold(X),
    (
        ((X<10)->
            write('Your Gold is not enough to buy a Potion.'),nl
        );
        (
            add_potions(1),
            X1 is X-10,
            retract(character_gold(X)),
            assertz(character_gold(X1)),
            total_potions(N),
            write('You have '),write(N),write(' Potion(s).'),nl,
            write('Your gold remaining '),write(X1),nl
        )
    ).

attackPotion:-
    character_gold(X),
    (
        ((X<15)->
            write('Your Gold is not enough to buy an Attaack Potion.'),nl
        );
        (
            add_attpotions(1),
            X1 is X-15,
            retract(character_gold(X)),
            assertz(character_gold(X1)),
            total_attpotions(N),
            write('You have '),write(N),write(' Attack Potion(s).'),nl,
            write('Your gold remaining '),write(X1),nl
        )
    ).

exitShop:-
    write('Thanks for coming.').

gachaItem(1,'Sword','weapon','Swordsman',23).
gachaItem(2,'Black Sword','weapon','Swordsman',25).
gachaItem(3,'Great Sword','weapon','Swordsman',27).
gachaItem(4,'Bow','weapon','Archer',23).
gachaItem(5,'Green Bow','weapon','Archer',25).
gachaItem(6,'Long Bow','weapon','Archer',27).
gachaItem(7,'Staff','weapon','Sorcerer',23).
gachaItem(8,'Staff of Apprentice','weapon','Sorcerer',25).
gachaItem(9,'Wizard Staff','weapon','Sorcerer',27).
gachaItem(10,'Armor','armor','Swordsman',13).
gachaItem(11,'Black Armor','armor','Swordsman',15).
gachaItem(12,'King Armor','armor','Swordsman',17).
gachaItem(13,'Silk','armor','Archer',13).
gachaItem(14,'Red Silk','armor','Archer',14).
gachaItem(15,'Dark Silk','armor','Archer',15).
gachaItem(16,'Dragon Silk','armor','Archer',17).
gachaItem(17,'Robe','armor','Sorcerer',14).
gachaItem(18,'Great Robe','armor','Sorcerer',16).
gachaItem(19,'Bracelet','accesories','Swordsman',20).
gachaItem(20,'Helmet','accesories','Swordsman',40).
gachaItem(21,'Elven Quiver','accesories','Archer',19).
gachaItem(22,'Griffon Shoes','accesories','Archer',29).
gachaItem(23,'Bird Mask','accesories','Archer',40).
gachaItem(24,'Book of Apprentice','accesories','Sorcerer',15).
gachaItem(25,'Mana Ring','accesories','Sorcerer',24).
gachaItem(26,'Book of Wisdom','accesories','Sorcerer',34).
gachaItem(27,'Slytherin Cloak','accesories','Sorcerer',45).

total_Gacha_Item(27).

in_shop(false).

/*Bekas gunain list*/
/*len([],Y):- Y is 0.
len([_|Xs],Y):-
    len(Xs,M),
    Y is M+1.

front([X|_],Y):- Y is X,!.

pop([_|Xs],Y):- Y = Xs,!.

elemt(1,_A,Result):-
    front(_A,Head),
    Result is Head,!.
elemt(X,_A,Result):-
    pop(_A,TailS),
    X1 is X-1,
    !,elemt(X1,TailS,Result).
*/

gacha:-
/*  jadi gacha ini teknisnya dia bakal ngerandom list possible itemnya
    terus ntar keluarin headnya gitu*/
    character_gold(Gold),
    (
        ((Gold<100)->
            write('Your Gold is not enough to buy a gacha.'),nl
        );
        (
            Gold1 is Gold-100,
            retract(character_gold(Gold)),
            assertz(character_gold(Gold1)),
            total_Gacha_Item(Divisor),
            generate_number(M),
            Upperbound is M+1,
            retract(generate_number(M)),
            assertz(generate_number(Upperbound)),
            random(1,Upperbound,IdxRaw),
            IdxRaw1 is IdxRaw mod Divisor,
            Random_Number is IdxRaw1+1,
            gachaItem(Random_Number,Name,Type,Class,Stats),
            write('You get '),write(Name),write(' (+'),write(Stats),
            (
                ((Type=='weapon')->
                    write(' attack'),
                    add_weapon(Name,Class,Stats)
                );
                ((Type=='armor')->
                    write(' defense'),
                    add_armor(Name,Class,Stats)
                );
                ((Type=='accesories')->
                    write(' HP'),
                    add_accesories(Name,Class,Stats)
                )
            ),
            write(')'),nl,
            write('You have '),write(Gold1),write(' gold remaining.'),nl
        )
    ).

    
