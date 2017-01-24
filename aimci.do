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
use d_p.dta, clear
gen exp2=(exp^2)/100
gen femmar=female*married
gen d1985 = 1 if year==1985
replace d1985 = 0 if missing(d1985)
gen computer1985 = computer * d1985

label variable computer "Computer User (Dummy)"
label variable school "Years of Schooling"
label variable exp "Experience"
label variable exp2 "Experience Squared"
label variable female "Female (Dummy)"
label variable married "Married (Dummy)"
label variable femmar "Female * Married (Dummy)"
label variable lnw "Log (Wage)"
label variable d1985 "1985 (Dummy)"
label variable computer1985 "Computer User * 1985 (Dummy)" 
label variable german "German Grade"
label variable math "Math Grade"
label variable occ "Occupation"
label variable father "Father Occupation"
label variable pencil "Pencil User (Dummy)"
label variable teleph "Telephone User (Dummy)"
label variable calc "Calculator User (Dummy)"
label variable hammer "Physical Tools User (Dummy)"
label variable sit "Sedantary Worker (Dummy)"

// Question 1(a)
desc year
tab year
estpost ttest lnw if year==1979, by(computer)
esttab using `imagepath'1a.tex, title("T-test of log wages in 1979 by computer usage\label{1a}") mtitle("Mean Difference") se label replace

reg lnw computer if year==1979
outreg2 using `imagepath'1a1.tex, title("Regression of log wages in 1979 on computer usage\label{1a1}")  tex(pretty frag) label replace

summ lnw if year==1979 & computer==1
ttest lnw if year==1985, by(computer)

// Question 1(b)
// Question 1(c)

estpost ttest german math school exp female married lnw sit pencil teleph calc hammer city civser father occ if year==1979, by(computer)
esttab using `imagepath'1c.tex, title("T-tests by computer usage\label{1c}") mtitle("Mean Difference") se  label replace

// Question 1(d)
// Question 1(e)


reg lnw computer school exp exp2 female married femmar if year==1985
outreg2 using `imagepath'1e.tex, title("The effect of computer use on log wages\label{1e}")  nocons tex(pretty frag) label replace

// Question 1(f)

reg lnw computer school exp exp2 female married femmar d1985 computer1985
outreg2 using `imagepath'1e.tex, title("The effect of computer use on log wages\label{1e}")  nocons tex(pretty frag) label append

// Question 1(g)
// Question 1(h)(I)
areg lnw computer school exp exp2 female married femmar if year==1979, absorb(occ)
outreg2 using `imagepath'1hI.tex,  nocons tex(pretty frag) addtext(Occupation dummies, Yes, German and Math Score Dummies, No, Father Occupation Dummies, No) label replace

// Question 1(h)(II)
xi: areg lnw computer school exp exp2 female married femmar i.german i.math i.father if year==1979, absorb(occ)
outreg2 using `imagepath'1hI.tex,  drop(_*) nocons tex(pretty frag) addtext(Occupation dummies, Yes, German and Math Score Dummies, Yes, Father Occupation Dummies, Yes) label append

// Question 1(h)(III)
xi: areg lnw calc school exp exp2 female married femmar i.german i.math i.father if year==1979, absorb(occ)
outreg2 using `imagepath'1hIIIa.tex,  drop(_*) nocons tex(pretty frag) addtext(Occupation dummies, Yes, German and Math Score Dummies, Yes, Father Occupation Dummies, Yes) label replace

xi: areg lnw teleph school exp exp2 female married femmar i.german i.math i.father if year==1979, absorb(occ)
outreg2 using `imagepath'1hIIIa.tex,  drop(_*) nocons tex(pretty frag) addtext(Occupation dummies, Yes, German and Math Score Dummies, Yes, Father Occupation Dummies, Yes) label append

xi: areg lnw pencil school exp exp2 female married femmar i.german i.math i.father if year==1979, absorb(occ)
outreg2 using `imagepath'1hIIIa.tex,  drop(_*) nocons tex(pretty frag) addtext(Occupation dummies, Yes, German and Math Score Dummies, Yes, Father Occupation Dummies, Yes) label append

xi: areg lnw sit school exp exp2 female married femmar i.german i.math i.father if year==1979, absorb(occ)
outreg2 using `imagepath'1hIIIa.tex,  drop(_*) nocons tex(pretty frag) addtext(Occupation dummies, Yes, German and Math Score Dummies, Yes, Father Occupation Dummies, Yes) label append

xi: areg lnw hammer school exp exp2 female married femmar i.german i.math i.father if year==1979, absorb(occ)
outreg2 using `imagepath'1hIIIa.tex,  drop(_*) nocons tex(pretty frag) addtext(Occupation dummies, Yes, German and Math Score Dummies, Yes, Father Occupation Dummies, Yes) label append

/*
xi: areg lnw computer school exp exp2 female married femmar i.german i.math i.father if year==1979, absorb(occ)
outreg2 using `imagepath'1hIIIa.tex,  drop(_*) nocons tex(pretty frag) addtext(Occupation dummies, Yes, German and Math Score Dummies, Yes, Father Occupation Dummies, Yes) label  append
*/

areg lnw calc school exp exp2 female married femmar if year==1985, absorb(occ)
outreg2 using `imagepath'1hIIIb.tex,  drop(_*) nocons tex(pretty frag) addtext(Occupation dummies, Yes, German and Math Score Dummies, No, Father Occupation Dummies, No) label replace

areg lnw teleph school exp exp2 female married femmar if year==1985, absorb(occ)
outreg2 using `imagepath'1hIIIb.tex,  drop(_*) nocons tex(pretty frag) addtext(Occupation dummies, Yes, German and Math Score Dummies, No, Father Occupation Dummies, No) label append

areg lnw pencil school exp exp2 female married femmar if year==1985, absorb(occ)
outreg2 using `imagepath'1hIIIb.tex,  drop(_*) nocons tex(pretty frag) addtext(Occupation dummies, Yes, German and Math Score Dummies, No, Father Occupation Dummies, No) label append

areg lnw sit school exp exp2 female married femmar if year==1985, absorb(occ)
outreg2 using `imagepath'1hIIIb.tex,  drop(_*) nocons tex(pretty frag) addtext(Occupation dummies, Yes, German and Math Score Dummies, No, Father Occupation Dummies, No) label append

areg lnw hammer school exp exp2 female married femmar if year==1985, absorb(occ)
outreg2 using `imagepath'1hIIIb.tex,  drop(_*) nocons tex(pretty frag) addtext(Occupation dummies, Yes, German and Math Score Dummies, No, Father Occupation Dummies, No) label append

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
