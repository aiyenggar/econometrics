cd "/Users/aiyenggar/OneDrive/Evernoted/06-Methods for Causal Inference/"

use "/Users/aiyenggar/OneDrive/Evernoted/06-Methods for Causal Inference/FERTIL1.dta", clear


use "/Users/aiyenggar/OneDrive/Evernoted/06-Methods for Causal Inference/KIELMC.dta", clear


use "/Users/aiyenggar/OneDrive/Evernoted/06-Methods for Causal Inference/minwage.dta", clear
set more off
describe
codebook post
tab post
codebook chain

gen fte = empft + nmgrs + 0.5*emppt
twoway   (hist wage_st if post==1, bcolor(red)) (hist wage_st if post==0), by(nj)
table post nj, c(mean fte)
table post nj, c(mean wage_st)

gen w425=1 if wage_st==4.25
replace w425=0 if missing(w425)

table post nj, c(mean w425)

table post nj, c(mean fte mean wage_st mean w425 mean hrsopen)

/* This thing is not quite working 
eststo clear
esttab using myt.doc, replace

estpost ttest fte wage_st w425 hrsopen if post==0, by(nj)
estpost ttest fte wage_st w425 hrsopen if post==1, by(nj)
esttab using myt.doc, replace
*/

ttest fte if post==0, by(nj)
ttest fte if post==1, by(nj)

ttest wage_st if post==0, by(nj)
ttest wage_st if post==1, by(nj)

ttest w425 if post==0, by(nj)
ttest w425 if post==1, by(nj)

ttest hrsopen if post==0, by(nj)
ttest hrsopen if post==1, by(nj)


reg fte nj if post==1

reg fte i.post##i.nj 



