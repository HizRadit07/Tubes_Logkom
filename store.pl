/* Predikat yang bisa aja masuk ke dalam inventory */

potion:-
    add_potions(1).
    character_gold(X).
    X1 is X-20.
    retract(character_gold(X)).
    assertz(character_gold(X1)).

exitShop:-
    write('Thanks for coming').


gachaWeaponSwordsman([pedang,pedanghitam,pedangbiru]).
gachaWeaponArcher([panah,panahijo,panahmerah]).
gachaWeaponSorcerer([staff,staffijo,staffcoklat]).
gachaArmorSwordsman([kingarmor,redarmor,blackarmor]).
gachaArmorArcher([silk,redsilk,bluesilk,darksilk]).
gachaArmorSorcerer([robe,greatrobe]).
gachaAccSwordsman([shield,bracelet,helmet]).
gachaAccArcher([elvenquiver,griffonshoes,birdmask]).
gachaAccSorcerer([manaring,bookofwisdom]).

length([],Y):- Y is 0.
length([X|Xs],Y):-
    length(Xs,M),
    Y is M+1.

front([X|_],Y):- Y is X,!.

pop([_|Xs],Y):- Y = Xs,!.

elemt(1,ListA,Result):-
    front(ListA,Head),
    Result is Head,!.
elemt(X,List,Result):-
    pop(List,TailS),
    X1 is X-1,
    elemt(X1,TailS,Result).
gacha:-
/*  jadi gacha ini teknisnya dia bakal ngerandom list possible itemnya
    terus ntar keluarin headnya gitu*/
    random(1,10,Tipe),
    (
    ((Tipe==1)->
        gachaWeaponSwordsman(Item_Gacha),
        length(Item_Gacha,TotalItem)
    );
    ((Tipe==2)->
        gachaWeaponArcher(Item_Gacha),
        length(Item_Gacha,TotalItem)
    );
    ((Tipe==3)->
        gachaWeaponSorcerer(Item_Gacha),
        length(Item_Gacha,TotalItem)
    );
    ((Tipe==4)->
        gachaArmorSwordsman(Item_Gacha),
        length(Item_Gacha,TotalItem)
    );
    ((Tipe==5)->
        gachaArmorArcher(Item_Gacha),
        length(Item_Gacha,TotalItem)
    );
    ((Tipe==6)->
        gachaArmorSorcerer(Item_Gacha),
        length(Item_Gacha,TotalItem)
    );
    ((Tipe==7)->
        gachaAccSwordsman(Item_Gacha),
        length(Item_Gacha,TotalItem)
    );
    ((Tipe==8)->
        gachaArmorArcher(Item_Gacha),
        length(Item_Gacha,TotalItem)
    );
    ((Tipe==9)->
        gachaAccSorcerer(Item_Gacha),
        length(Item_Gacha,TotalItem)
    )
    ),
    Rightboundary is TotalItem+1,
    random(1,Rightboundary,GetIdx).



