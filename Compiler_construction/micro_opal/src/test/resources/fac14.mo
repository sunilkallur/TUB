
--Interpretation started ...
--MAIN = 80

DEF MAIN:nat == fac(10,20,30)
DEF fac(n:nat,b:nat,c:nat):nat == fac1(10,add(10,20),20)
DEF fac1(n:nat,b:nat,c:nat):nat == fac2(10,add(50,20),20)
DEF fac2(n:nat,b:nat,c:nat):nat ==  add(n,b)

