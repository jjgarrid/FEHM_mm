---
title : cden
layout : page_getting-started
hero_height: is-hidden
---

# cden

**Test the Concentration Dependent Brine Density Functionality**

Compares generated history files to old history files that are known to be correct. Only the density values are tested.

<pre>

***Compare wellbore module***
time
1.e-6 100 200000  1 2007 10000 0.00000

ctrl
 -20  1.00000e-05 80 150 gmres
 1 0 0 2 
 
 1.00000 2 1.00000                     
 20 1.1 1.000e-08 1.
 1  +2                                   
sol
 1 -1
iter
 1.e-06 1.e-06 1.e-1 -1.e-3 1.15
0       0       0       5       1200.
zonn
1
-0.1 100000.1 100000.1 -0.1 
-1 -1  .1 .1
2
-0.1 100000.1 100000.1 -0.1 
299.1 299.1  100000 100000 

# zone 1 = bot zone 2 = top
pres 
      1     0   0   5.   20.   1 
      -2     0   0   2.   20.   1  
          
trac  
file
../input/trac1.macro
end trac
cden multi
# co2 option in cden makes co2 solubility and water density a function of trac tds. 
carb off
4
co2pres
 1     0   0   3.   15.   4
-2     0   0   .1   15.   4  

# this is the same as the pres macro
co2frac
 1 0 0 1.0 0.0 0 1 0
-1 0 0 0.9 .1 0 1 0.  

# this gives initial conditions: fractions of water/co2
co2flow
-2   0 0  0 -20. -1.e-1 1 
-1   0 0  -.00001 -20. 0. 6

brine
end carb
# water boundary conditions -  keep top at initial pressure
rlp
17 0 1 1 0 1 1 0 0 1 1 1 0 1 0

1 0 0 1

# 40 degrees C, bottom at 25 MPa (250 bar), top at 10 MPa (100 bar) 
#  note: 1 MPA = 10 bar
perm
        1  0 0   -12. -12. -12.

rock
      1  0  0 2650. 750. 0.01

cond
  1   0     0     1 1 1     

flow
 -2   0 0  0 -20. 1.e-1
 -1   0 0  0 -20. 1.e-1

# -3   0 0  0 -20. 0.5e-1
# -4   0 0  0 -20. 0.5e-1 
#
# -1   0 0  0 -40. -1.e-4
# water boundary conditions -  keep top at initial pressure
flxz
2
1 2 
zone
1
18000 18001 18001 18000 
-1 -1  100000 100000 

node
5
1
100
400
500
601
hist
pressure
water
density
temp
co2mf
co2md
co2mt
co2ms
p
conc
end
#cont
#tec 1.e20 10
#xyz
#mat
#geom
#liquid
#so
#pressure
#temperature
#co2
#endavs
#8 
#-99 -99 -99 -99 -99 -99	-99 -99
#10000  0.     0 
#10000  100.   0 
#10000  200.   0 
#10000  300.   0 
#10000  400.   0 
#10000  500.   0 
#10000  750.   0
#10000  1000.  0
stop
3
-1 8001 8001 -1
-1 -1 100000 100000 
4
27999 100000 100000 27999 
-1 -1 100000 100000 


 </pre>