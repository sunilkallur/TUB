-- result expected

--Interpretation started ...
--MAIN = false


DEF MAIN:bool  == fac(true)

DEF fac(a:bool):bool ==  fac1(true)

DEF fac1(a:bool):bool ==  and(false,true)


