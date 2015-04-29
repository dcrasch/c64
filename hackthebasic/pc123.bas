1 rem prog 126
5 base=2*4096:poke53272,peek (53272)or8
10 poke53265,peek(53265)or32
20 fori=basetobase+7999:poke i,0:next
30 fori=1024to2023:pokei,3: next
