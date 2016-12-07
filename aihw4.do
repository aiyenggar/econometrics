// 05-Dec-2016 Ashwin Iyenggar's (1521001) Solution to Advanced Econometrics Homework 4


// Setting up to use propensity score tools in Stata
net describe psmatch2, from(http://fmwww.bc.edu/RePEc/bocode/p)
net describe nnmatch, from(http://fmwww.bc.edu/RePEc/bocode/n)

// st0026_2 contains pscore
net sj 5-3 st0026_2
net install st0026_2

local basepath /Users/anu/OneDrive/
local imagepath `basepath'code/articles/adv-eco-hw4-images/
set more off

cd `basepath'code/econometrics
cap log close
log using aihw4.log, replace
//-----------------------------------------------------------------
// Question I 
//-----------------------------------------------------------------
use smoking, clear

label variable dbirwt   "birth weight of infant (in grams)"
label variable death    "1 if infant died within one-year of birth, 0 otherwise"
label variable tobacco  "1 if the mother smoked during pregnancy, 0 otherwise"
label variable dmage    "mother’s age"
label variable dmeduc   "mother’s educational attainment"
label variable mblack   "1 if mother is black"
label variable mother   "1 if neither black nor white"
label variable mhispan  "1 if mother is Hispanic"
label variable dmar     "1 if mother is unmarried"
label variable foreignb "1 if mother is foreign born"
label variable dfage    "father’s age"
label variable dfeduc   "father’s education"
label variable fblack   "1 if father is black"
label variable fotherr  "1 if neither black nor white"
label variable fhispan  "1 if father is Hispanic"
label variable alcohol  "1 if mother drank alcohol during pregnancy"
label variable drink    "# of drinks per week"
label variable tripre0 "1 if no prenatal care visits"
label variable tripre1 "1 if 1st prenatal care visit in 1st trimester"
label variable tripre2 "1 if 1st prenatal care visit in 2nd trimester"
label variable tripre3 "1 if 1st prenatal care visit in 3rd trimester"
label variable nprevist " # of prenatal care visits"
label variable first    "1 if first-born"
label variable dlivord  "birth order"
label variable deadkids "# previous births where newborn died"
label variable disllb   "months since last birth"
label variable preterm  "1 if previous birth premature or small for gestational age"
label variable pre4000  "1 if previously had > 4000 gram newborn"
label variable plural   "1 if twins or greater birth"
label variable phyper   "1 if mother had pregnancy-associated hypertension"
label variable diabete  "1 if mother diabetic"
label variable anemia   "1 if mother anemic"
save smoking_labels, replace

cd `basepath'code/econometrics
use smoking_labels, clear

// Question (a)
estpost ttest dbirwt, by(tobacco)
esttab using `imagepath'a1.tex
reg dbirwt tobacco, vce(robust)
outreg2 using  `imagepath'a2.tex, title("Maternal Smoking Effects on Birthweight") ctitle("Random Assignment") tex(pretty frag) dec(4)

// Question (b)
// Question (c)
// Question (d)
// Question (e)
// Question (f)
// Question (g)
// Question (h)
// Question (i)
// Question (j)

log close
