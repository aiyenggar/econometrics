// Example 1 Nearest neighbour and propensity score using teffects
//webuse cattaneo2.dta, clear
save cattaneo2.dta
teffects nnmatch (bweight mmarried mage fage medu prenatal1) (mbsmoke)
teffects nnmatch (bweight mmarried mage fage medu prenatal1) (mbsmoke), ematch(mmarried prenatal1)
teffects nnmatch (bweight mmarried mage fage medu prenatal1) (mbsmoke), ematch(mmarried prenatal1) biasadj(mage fage medu)
teffects psmatch (bweight) (mbsmoke mmarried mage fage medu prenatal1 )

clear all
//use http://www.ssc.wisc.edu/sscc/pubs/files/psm
use psm.dta

ttest y, by(t)
reg y x1 x2 t

psmatch2 t x1 x2, out(y)
teffects psmatch (y) (t x1 x2, probit), atet 

teffects psmatch (y) (t x1 x2)
psmatch2 t x1 x2, out(y) logit ate
teffects psmatch (y) (t x1 x2), atet

//use http://www.ssc.wisc.edu/sscc/pubs/files/psm, replace
use psm.dta, replace
teffects psmatch (y) (t x1 x2), gen(match)

predict ps0 ps1, ps
predict y0 y1, po
predict te
l if _n==1 | _n==467

//use http://www.ssc.wisc.edu/sscc/pubs/files/psm, replace
use psm.dta, replace

psmatch2 t x1 x2, out(y) logit
reg y x1 x2 t [fweight=_weight]

gen ob=_n
save fulldata,replace

teffects psmatch (y) (t x1 x2), gen(match)
keep if t
keep match1
bysort match1: gen weight=_N
by match1: keep if _n==1
ren match1 ob

merge 1:m ob using fulldata
replace weight=1 if t

assert weight==_weight

reg y x1 x2 t [fweight=weight]
reg y x1 x2 t

teffects ra (y x1 x2) (t)
teffects ipw (y) (t x1 x2)
teffects aipw (y x1 x2) (t x1 x2)
teffects ipwra (y x1 x2) (t x1 x2)
teffects nnmatch (y x1 x2) (t)
