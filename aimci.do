// 11-Jan-2017 Ashwin Iyenggar's (1521001) Solution to MCI Assignment



//-----------------------------------------------------------------
// Question I 
//-----------------------------------------------------------------
set more off
local basepath /Users/aiyenggar/OneDrive/
local imagepath `basepath'code/articles/mci-assignment/
local datapath `basepath'code/econometrics
cd `datapath'
cap log close
log using aimci.log, replace

use d_p.dta

// Question 1(a)
desc year
tab year

ttest lnw if year==1979, by(computer)
// mean lnw for computer users = 2.553225, for non computer users = 2.419198
// difference = 0.1340268

summ lnw if year==1979 & computer==1

ttest lnw if year==1985, by(computer)

// Question 1(b)
// We would need random assignment of computer and non computer users in the sample

// Question 1(c)
// Question 1(d)
// Question 1(e)
// Question 1(f)
// Question 1(g)
// Question 1(h)(I)
// Question 1(h)(II)
// Question 1(h)(III)
// Question 1(h)(IV)

log close

//-----------------------------------------------------------------
// Question II 
//-----------------------------------------------------------------
set more off
local basepath /Users/aiyenggar/OneDrive/
local imagepath `basepath'code/articles/mci-assignment/
local datapath `basepath'code/econometrics
cd `datapath'
cap log close
log using aimci.log, replace


log close
