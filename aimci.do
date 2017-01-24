// 11-Jan-2017 Ashwin Iyenggar's (1521001) Solution to MCI Assignment
local basepath /Users/aiyenggar/OneDrive/
local imagepath `basepath'code/articles/mci-assignment-images/
local datapath `basepath'code/econometrics
cd `datapath'
cap log close


//-----------------------------------------------------------------
// Question I 
//-----------------------------------------------------------------

log using aimciq1.log, replace
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

cap log close
log using aimciq2.log, replace

use autortempworkers.dta, clear

// Question 2(a)
desc
sort state year
list state abbrev year mico mppa mgfa thsemp, sepby(state)
tab1 mico mppa mgfa

// Question 2(b)
gen lnthsemp=ln(thsemp)
label variable lnthsemp "Log(Temporary Employment)"
label variable mico "Implied contract"
label variable mppa "Public policy"
label variable mgfa "Good faith"

reg lnthsemp mico mppa mgfa, robust
outreg2 using  `imagepath'2b.tex, title("Basic Regression\label{2b}") ctitle("ln(temporary employment)") tex(pretty frag) dec(4) label replace

// Question 2(c)
reg lnthsemp mico mppa mgfa, robust cluster(state)


// reg lnthsemp mico mppa mgfa, vce(cluster state)
outreg2 using  `imagepath'2c.tex, title("Regression with Robust Cluster SE\label{2c}") ctitle("ln(temporary employment)") tex(pretty frag) dec(4) label replace

// Question 2(d)

levelsof state, local(lstate)
foreach ls of local lstate {
	gen dstate`ls' = 1 if state==`ls'
	replace dstate`ls' = 0 if missing(dstate`ls')
}

levelsof year, local(lyear)
foreach ly of local lyear {
	gen dyear`ly' = 1 if year==`ly'
	replace dyear`ly' = 0 if missing(dyear`ly')
}

eststo clear
reg lnthsemp mico mppa mgfa dyear80-dyear95, robust cluster(state)
estadd local Model "Year Dummies"
est store model1
reg lnthsemp mico mppa mgfa dstate12-dstate95, robust cluster(state)
estadd local Model "State Dummies"
est store model2
esttab model1 model2 using `imagepath'2d.tex, title("Regression with Year and State Controls\label{2d}") longtable se not drop(d*) scalars("Model") addn("Reference Year is 79 for Year Dummies Model" "Reference State is 11 (ME) for State Dummies Model") label replace

// Question 2(e)

gen age=year-78
foreach var of varlist dstate* {
  gen tt`var' = `var'*age
}
reg lnthsemp mico mppa mgfa dyear80-dyear95 dstate12-dstate95, robust cluster(state)
outreg2 using  `imagepath'2e.tex, drop (dyear* dstate* tt*) tex(pretty frag) dec(3) addtext(State and year dummies, Yes, State * time trends, No) addn("Reference Year is 79, Reference State is 11 (ME)") label replace

reg lnthsemp mico mppa mgfa dyear80-dyear95 dstate12-dstate95 ttdstate12-ttdstate95, robust cluster(state)
outreg2 using  `imagepath'2e.tex, drop (dyear* dstate* ttdstate*) tex(pretty frag) dec(3) addtext(State and year dummies, Yes, State * time trends, Yes) label append

// Question 2(f)
gen lnannemp = ln(annemp)
label variable lnannemp "Log(Non-Farm Employment)"

foreach var of varlist dstate* {
  gen tt2`var' = `var'*age*age
}
reg lnthsemp mico lnannemp mppa mgfa dyear80-dyear95 dstate12-dstate95 ttdstate12-ttdstate95, robust cluster(state)
outreg2 using  `imagepath'2f.tex, drop (mppa mgfa dyear* dstate* tt*) tex(pretty frag) dec(3) addtext(Public policy dummy, Yes, Good faith dummy, Yes, State and year dummies, Yes, State * time trends, Yes, State * time2 trends, No) addn("Reference Year is 79, Reference State is 11 (ME)") label replace

reg lnthsemp mico lnannemp mppa mgfa dyear80-dyear95 dstate12-dstate95 ttdstate12-ttdstate95 tt2dstate12-tt2dstate95, robust cluster(state)
outreg2 using  `imagepath'2f.tex, drop (mppa mgfa dyear* dstate* tt*) tex(pretty frag) dec(3) addtext(Public policy dummy, Yes, Good faith dummy, Yes, State and year dummies, Yes, State * time trends, Yes, State * time2 trends, Yes) label append

// Question 2(g)
// Question 2(h)
// Question 2(i)
local imagepath /Users/aiyenggar/OneDrive/code/articles/mci-assignment-images/
label variable admico_2 "Law change t+2"
label variable admico_1 "Law change t+1"
label variable admico0 "Law change t0"
label variable admico1 "Law change t-1"
label variable admico2 "Law change t-2"
label variable admico3 "Law change t-3"
label variable mico4 "Implied contract law t-4 forward"
reg lnthsemp lnannemp admico* mico4 admppa* mppa4 admgfa* mgfa4 dyear80-dyear95 dstate12-dstate95 ttdstate12-ttdstate95, robust cluster(state)
outreg2 using  `imagepath'2i.tex, keep(admico_2 admico_1 admico0 admico1 admico2 admico3 mico4) tex(pretty frag) dec(3) addtext(State and year dummies, Yes, State * time trends, Yes, State * time2 trends, No) addn("Reference Year is 79, Reference State is 11 (ME)") nocon label replace

log close
