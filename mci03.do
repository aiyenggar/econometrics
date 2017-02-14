cd "/Users/aiyenggar/OneDrive/Evernoted/06-Methods for Causal Inference/"

use "/Users/aiyenggar/OneDrive/Evernoted/06-Methods for Causal Inference/NSS68.dta", clear

tab gen_edu

* 4(i)
gen s = 0 if (gen_edu == 1 | gen_edu == 2 | gen_edu == 3 | gen_edu == 4)
replace s = 2.5 if gen_edu == 5
replace s = 5 if gen_edu == 6
replace s = 8 if gen_edu == 7
replace s = 10 if gen_edu == 8
replace s = 12 if (gen_edu == 10 | gen_edu == 11)
replace s = 13.5 if gen_edu == 12
replace s = 15.5 if gen_edu == 13

count if missing(s)
count if missing(gen_edu)

* 4(ii)
gen potexp = age - s - 5
count if potexp < 0
gen potexpsq = potexp*potexp

* 4(iii)
gen lndwage = ln(dwage)
reg lndwage potexp potexpsq s
*reg lndwage c.potexp##c.potexp s

* this by hand thing worked only because of the linear marginal effect
mean(potexp) if e(sample)==1

reg lndwage potexp potexpsq s
di 2*_b[potexpsq]*24.36951 
di _b[potexp] -.03213609

*ereturn list
gen returnstoexp = _b[potexp] + 2 * _b[potexpsq] * potexp
summ returnstoexp if e(sample)==1
return list
lincom _b[potexp]+2*_b[potexpsq]*`r(mean)'

* 4(iv)
* Role of potexpsq term is significant and negative

* 4(v) graph

* 4(vi)
tab marstatus
gen married=1 if marstatus==2
replace married=0 if (marstatus==1 | marstatus==3 | marstatus==4)
tab gender
gen female=1 if gender==2
replace female=0 if missing(female)
gen marfem = married*female

* alternative
* recode gender (2=1) (1=0),generate(female)
* recode marstatus (1 3 4=1) (2=2), generate(married)

*reg lndwage potexp potexpsq s female married marfem
* figure out how to calculate the lincom below here. apparently plain adding would not do, the standard errors need to be taken into account

reg lndwage c.potexp##c.potexp s female##married
lincom 1.married + 1.female#1.married

* 4(vii) margins command
margins, dydx(married) at (female=1)
// at means - this is an alternative: Vidhya says that this is a really useful command

* 4(viii) FWL theorem
reg lndwage potexp potexpsq if !missing(lndwage)
predict yuhat, resid
reg s potexp potexpsq if !missing(lndwage)
predict suhat, resid
reg yuhat suhat if !missing(lndwage), noconstant

reg lndwage potexp potexpsq s if !missing(lndwage)

* 4(ix) 

* 4 (xi)
ttest lndwage, by(female)
table female, c(mean lndwage)
* 4(xii)
reg lndwage female

* 4(xiii)
* Dummy variable trap
gen male=1 if gender==1
replace male=0 if missing(male)
reg lndwage male female
reg lndwage male female, noconstant
