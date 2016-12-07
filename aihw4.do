// 05-Dec-2016 Ashwin Iyenggar's (1521001) Solution to Advanced Econometrics Homework 4

set more off
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
// Question (a)
use smoking_labels, clear
local imagepath /Users/anu/OneDrive/code/articles/adv-eco-hw4-images/

estpost ttest dbirwt, by(tobacco)
esttab using `imagepath'a1.tex, title("T-test for birth weight by maternal smoking status\label{a1}") mtitle("tobacco") replace

reg dbirwt tobacco, vce(robust)
outreg2 using  `imagepath'a2.tex, title("Maternal Smoking Effects on Birthweight\label{a2}") ctitle("Random Assignment") tex(pretty frag) dec(4) replace


estpost ttest dmage dmeduc dmar dlivord mblack fblack alcohol tripre0 tripre1 tripre2 tripre3, by(tobacco)
esttab using `imagepath'a3.tex, title("T-tests by Maternal Smoking Status\label{a3}") mtitle("Mean Difference") replace

// Question (b)
use smoking_labels, clear
local imagepath /Users/anu/OneDrive/code/articles/adv-eco-hw4-images/
set more off

local imagepath /Users/anu/OneDrive/code/articles/adv-eco-hw4-images/
reg dbirwt tobacco dmage dmeduc dmar dlivord nprevist disllb dfage dfeduc  anemia diabete phyper pre4000 preterm  alcohol drink foreignb plural deadkids mblack motherr mhispan fblack fotherr fhispan tripre1 tripre2 tripre3 tripre0 first death, vce(robust)
esttab using `imagepath'b1.tex, title("tobacco Randomly Assigned Conditional on Observables\label{b1}") mtitle("Birth Weight") longtable replace

// Question (c)
use smoking_labels, clear
local imagepath /Users/anu/OneDrive/code/articles/adv-eco-hw4-images/

gen dmeduc2 = dmeduc^2
gen dfeduc2 = dfeduc^2
gen dmage_mblack = dmage*mblack
gen dmage_dmar =dmage*dmar
gen dfage_fblack = dfage*fblack
gen dmage_alcohol = dmage*alcohol
gen dmage_drink = dmage*drink

save smoking_labels, replace
reg dbirwt tobacco dmage dmeduc dmar dlivord nprevist disllb dfage dfeduc  anemia diabete phyper pre4000 preterm  alcohol drink foreignb plural deadkids mblack motherr mhispan fblack fotherr fhispan tripre1 tripre2 tripre3 tripre0 first death dmeduc2 dfeduc2 dmage_mblack dmage_dmar dfage_fblack dmage_alcohol dmage_drink, vce(robust)
esttab using `imagepath'c1.tex, title("Flexible functional form regression\label{c1}") mtitle("Birth Weight") longtable replace

// Question (d)


// Question (e)
set more off
use smoking_labels, clear
local imagepath /Users/anu/OneDrive/code/articles/adv-eco-hw4-images/
pscore tobacco dmage dmeduc dmar dlivord nprevist disllb dfage dfeduc  anemia diabete phyper pre4000 preterm  alcohol drink foreignb plural deadkids mblack motherr mhispan fblack fotherr fhispan tripre1 tripre2 tripre3 tripre0 first death dmeduc2 dfeduc2 dmage_mblack dmage_dmar dfage_fblack dmage_alcohol dmage_drink, pscore(ps31) blockid(blo31) logit level(0.01)
save smoking.ps31.dta, replace

use smoking.ps31.dta, clear
local imagepath /Users/anu/OneDrive/code/articles/adv-eco-hw4-images/
reg dbirwt tobacco ps31, vce(robust)
esttab using `imagepath'e1.tex, title("Control for Propensity Score (ps31)\label{e1}") mtitle("Birth Weight") replace

egen mean = mean(ps31)
gen subclass = round(100 * tobacco * (ps31-mean))
drop mean
reg dbirwt tobacco ps31 subclass, vce(robust)
esttab using `imagepath'e2.tex, title("Regression with Subclassification on Propensity Score (subclass)\label{e2}") mtitle("Birth Weight") replace

graph box ps31, over(tobacco)
graph2tex, epsfile(`imagepath'e3) ht(5) caption(Distribution of Predicted Propensity Scores)

sort blo31
by blo31, sort: egen smoke=count(tobacco) if tobacco==1
by blo31, sort: egen total=count(tobacco)
gen fraction=smoke/total
//drop if smoke==.
//duplicates drop blo31, force
graph twoway (scatter fraction ps31) (function y=x, range(0 1)), ytitle("Predicted Propensity Score") xtitle("Fraction Treated") ///
	title("Distribution of Propensity Scores Across Bins") legend(label(1 Propensity Score) label(2 45-Line))
graph2tex, epsfile(`imagepath'e4) ht(5) caption(Fraction treated by bin)

// Question (f)
use smoking_labels, clear
local imagepath /Users/anu/OneDrive/code/articles/adv-eco-hw4-images/
set more off
set more off
use smoking_labels, clear
pscore tobacco dmage dmeduc dmar dlivord nprevist disllb dfage dfeduc  anemia diabete phyper pre4000 preterm  alcohol drink foreignb plural deadkids mblack motherr mhispan fblack fotherr fhispan tripre1 tripre2 tripre3 tripre0 first death dmeduc2 dfeduc2 dmage_mblack dmage_dmar dfage_fblack dmage_alcohol dmage_drink, pscore(ps200) blockid(blo200) logit level(0.005) numblo(201)
save smoking.ps200.dta, replace

// Question (g)
use smoking_labels, clear
local imagepath /Users/anu/OneDrive/code/articles/adv-eco-hw4-images/
set more off
use smoking_labels, clear
pscore tobacco dmage dmeduc dmar dlivord nprevist disllb dfage dfeduc  anemia diabete phyper pre4000 preterm  alcohol drink foreignb plural deadkids mblack motherr mhispan fblack fotherr fhispan tripre1 tripre2 tripre3 tripre0 first death dmeduc2 dfeduc2 dmage_mblack dmage_dmar dfage_fblack dmage_alcohol dmage_drink, pscore(ps100) blockid(blo100) logit level(0.001) numblo(101)
save smoking.ps100.dta, replace


// Question (h)
use smoking_labels, clear
local imagepath /Users/anu/OneDrive/code/articles/adv-eco-hw4-images/





// Question (i)
use smoking_labels, clear
local imagepath /Users/anu/OneDrive/code/articles/adv-eco-hw4-images/


// Question (j)

log close
