/*encounter.pl*/
/*set to randomly encounter*/

encounter :-
    % Randomize encounter status
    random(1, 4, RandomEncounterStatus),
    RandomEncounterStatus == 2,

    % If encounter, generate random enemy
    generate_random_enemy,
    current_enemy_stat(_,Name,Lvl,HP,Atk,Def),
    enemy_status(_, Name, Level, HP, Atk, Def),

    write('you encountered a '),
    write(Name),nl,

    write('Level: '),
    write(Lvl), nl,
    write('Hp: '),
    write(HP),nl,
    write('Attack: '),
    write(Atk),nl,
    write('Defense: '),
    write(Def),nl.



    /*@PRANA NANTI SAMBUNGIN KE BATTLENYA DI LINE YG INI*/
