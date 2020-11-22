/*help.pl file*/
/*menampilkan command yang ada*/

help:-
    write('################################################################################'),nl,
    write('#                               Available Commands                             #'),nl,
    write('# 1. start.      : untuk memulai petualanganmu                                 #'),nl,
    write('# 2. map.        : menampilkan peta                                            #'),nl,
    write('# 3. status.     : menampilkan kondisimu terkini                               #'),nl,
    write('# 4. w.          : gerak ke atas 1 langkah                                     #'),nl,
    write('# 5. s.          : gerak ke bawah 1 langkah                                    #'),nl,
    write('# 6. d.          : gerak ke kanan 1 langkah                                    #'),nl,
    write('# 7. a.          : gerak ke kiri 1 langkah                                     #'),nl,
    write('# 8. inventory.  : menampilkan inventory anda                                  #'),nl,
    write('# 10. help.      : menampilkan segala bantuan                                  #'),nl,
    write('################################################################################'),nl, nl,
    
    write('################################################################################'),nl,
    write('#                              In-Battle Commands                              #'),nl,
    write('# 1. attack.        : menyerang lawan dengan attack biasa                      #'),nl,
    write('# 2. specialAttack. : menyerang lawan dengan special attack                    #'),nl,
    write('# 3. usePotion.     : menggunakan potion yang ada untuk heal HP                #'),nl,
    write('# 4. run.           : coba meninggalkan battle                                 #'),nl,
    write('################################################################################'),nl, nl.