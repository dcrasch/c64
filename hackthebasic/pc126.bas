2 print chr$(147) 
5 base=2*4096:poke53272,peek (53272)or8
10 poke53265,peek(53265)or32
20 fori=basetobase+7999:poke i,0:next
50 forx=0to319step.5
60 y=int(90+80*sin(x/10))
70 ch=int(x/8)
80 ro=int(y/8)
85 ln=yand7
90 by=base+ro*320+8*ch+ln
100 bi=7-(xand7)
110 pokeby,peek(by)or(2^bi)
120 nextx
110 poke1024,16
130 goto130