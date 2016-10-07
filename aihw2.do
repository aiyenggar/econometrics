// 28-Sep-2016 Ashwin Iyenggar's Solution to Advanced Econometrics Homework 2

cd /Users/aiyenggar/OneDrive/code/econometrics
local imagepath /Users/aiyenggar/OneDrive/code/articles/adv-eco-hw2-images/
set more off
log using aihw2.log, replace
//-----------------------------------------------------------------
// Question I INDONESIA’S SCHOOL CONSTRUCTION PROGRAM 
//-----------------------------------------------------------------
use school_const, clear

* Question I a *
* Question I a(1) Recall the wage-setting equation from the education model discussed in class: ln wi = ai+ bSi. Interpret the parameter b in this equation. *
// The coefficient on an OLS regression of log wages on years of schooling does not capture the mechanism by which years of schooling affects wages, and therefore this regression as such provides little insight. However, if were to be able to shift the effect of years of schooling on wages through a third variable, then we might be able to model and run a regression that provides some causal explanation
reg lhwage yeduc
outreg2 using  `imagepath'Ia.tex, ctitle(baseline) tex(pretty frag) dec(4) replace
* Question I a(2)  Why might the coefficient on an OLS  regression of log wages on years of schooling not be a good estimate of b? *

* Question I b 2SLS and Instrument Variables.  State the requirements for the z variables to be good instruments. Explain why the z variables would be good instruments  *

forvalues year=62/72 {
	gen d`year'= (YOB == `year')
	}

forvalues year=62/72 {
	gen z`year'= d`year' * prog_int
	}


estpost cor yeduc z*
esttab . using `imagepath'Ib.tex, title(Correlation of years of education to interaction of YOB dummy and Program Intensity \label{Ib})  label replace
* Question I b(i) For control variables in our regressions, we will use number of children in 1971, year-of-birth dummies, and year-of-birth dummies interacted with number of children in 1971 (“interacted with” means “multiplied by”)  *


* Question I b(ii) Calculate the 2SLS estimate of b *

* Question 1 b(ii)(1) First, use the instruments and control variables to predict years of education (i.e., run an OLS regression of years of education on the instruments and control variables, and form the predicted values of education from this regression).  *
xi: reg yeduc z* i.YOB*ch71
predict yeduchat

* Question I b(ii)(2) Regress log hourly wages on this predicted value of years of education and the control variables. The coefficient on the predicted years of education is the 2SLS estimate of b. Compute and interpret the 2SLS estimate of b. *

xi: reg lhwage yeduchat i.YOB*ch71
outreg2 using  `imagepath'Ia.tex, ctitle(man2sls) drop (_*) tex(pretty frag) dec(4) append
xi: ivregress 2sls lhwage (yeduc = z*) i.YOB*ch71
outreg2 using  `imagepath'Ia.tex, title("Comparing Baseline, Manual 2SLS, ivreg 2sls Results") ctitle(2sls) drop (_*) tex(pretty frag) dec(4) append
estat endog
estat firststage
estat overid

* Question I b(ii)(3) You are asked to write a short report on the costs versus benefits of the school construction program. What information/data might you need to write this report? *

//-----------------------------------------------------------------
// Question II AIR POLLUTION AND HOUSING PRICES
//-----------------------------------------------------------------
use pollution, clear
label variable dlhouse "change in log housing price from 1970 to 1980"
label variable dgtsp "change in annual geometric mean of TSPs 1970 (1969-72) to 1980 (1977-80)"
label variable tsp7576	"1 if the county was regulated by the EPA in either 1975 or 1976, 0 otherwise"
label variable tsp75 "1 if the county was regulated by the EPA in 1975, 0 otherwise"
label variable mtspgm74	"annual geometric mean of TSPs in 1974"
label variable mtspgm75	"annual geometric mean of TSPs in 1975"
label variable dincome	"change in income per-capita"
label variable dunemp	"change in unemployment rate"
label variable dmnfcg	"change in % manufacturing employment"
label variable ddens	"change in population density"
label variable dwhite	"change in fraction white"
label variable dfeml	"change in fraction female"
label variable dage65	"change in fraction over 65 years old"
label variable dhs		"change in fraction with at least a high school degree"
label variable dcoll	"change in fraction with at least a college degree"
label variable durban	"change in fraction living in urban area"
label variable dpoverty	"change in fraction families below the poverty level"
label variable blt1080	"% of houses built in the last 10 years as of 1980"
label variable blt2080	"% of houses built in the last 20 years as of 1980"
label variable bltold80	"% of houses built more than 20 years ago as of 1980"
label variable dplumb	"change in fraction of houses with plumbing"
label variable vacant70	"housing vacancy rate in 1970"
label variable vacant80	"housing vacancy rate in 1980"
label variable vacrnt70	"rental vacancy rate in 1970"
label variable downer	"change in fraction of houses that are owner-occupied"
label variable drevenue	"change in government revenue per-capita"
label variable dtaxprop	"change in property taxes per-capita"
label variable depend	"change in general expenditures per-capita"
label variable deduc	"change in fraction of spending on education"
label variable dwelfr	"change in % spending on public welfare"
label variable dhlth	"change in % spending on health"
label variable dhghwy	"change in % spending on highways"
save pollution_labels, replace

cd /Users/aiyenggar/OneDrive/code/econometrics
local imagepath /Users/aiyenggar/OneDrive/code/articles/adv-eco-hw2-images/
use pollution_labels, clear

* Question II a *
local mainctrl dincome dunemp dmnfcg ddens dwhite dfeml dage65 dhs ///
	dcoll durban dpoverty blt1080 blt2080 bltold80 dplumb vacant70 ///
	vacant80 vacrnt70 downer drevenue dtaxprop depend deduc dwelfr ///
	dhlth dhghwy

local polyctrl white2 coll3  vacant2 taxprop3 pcthlth2 white3 unemp2 ///
	vacant3 epend2 pcthlth3 femal2 unemp3 owner2 epend3 built102 ///
	femal3 mnfcg2 owner3 pcteduc2 built103 age2  mnfcg3 plumb2 ///
	pcteduc3 built202 pop2  age3  income2 plumb3 pcthghw2 built203 ///
	pop3  hs2  income3 revenue2 pcthghw3 builold2 urban2 hs3  ///
	poverty2 revenue3 pctwelf2 builold3 urban3 coll2  poverty3 ///
	taxprop2 pctwelf3
           
local keepmain dgtsp  tsp7576 tsp75 dincome dunemp dwhite  dpoverty downer               
local keeppoly owner2 age2 poverty2

* Question II a(1) Estimate the relationship between changes in air pollution and housing prices not adjusting for any control variables *
reg dlhouse dgtsp
outreg2 using  `imagepath'IIa.tex, ctitle(baseline) tex(pretty frag) dec(4) replace
* Question II a(2) Estimate the relationship between changes in air pollution and housing prices adjusting for the main effects of the control variables listed above *
reg dlhouse dgtsp `mainctrl'
outreg2 using  `imagepath'IIa.tex, ctitle(mainctrl) keep(`keepmain') tex(pretty frag) dec(4) append
* Question II a(3) Estimate the relationship between changes in air pollution and housing prices adjusting for the main effects and polynomials of the control variables included in the data set *
reg dlhouse dgtsp `mainctrl' `polyctrl'
outreg2 using  `imagepath'IIa.tex, ctitle(mainpoly) keep(`keepmain' `keeppoly') tex(pretty frag) dec(4) append

* Question II a(4) What do your estimates imply and do they make sense? *

* Question II a(5) Describe the potential omitted variables biases.  *

* Question II a(6) Provide indirect evidence on this – i.e., the association between at least observable measures of economic shocks (dincome, dunemp, dmnfcg, ddens, blt1080) and changes in air pollution.  *
estpost cor dgtsp dincome dunemp dmnfcg ddens blt1080
esttab . using `imagepath'IIa6.tex, title(Correlation of changes in pollution level to changes in economic indicators\label{IIa6})  replace
* Question II b *
* Question II b(1) To address the concern in part a), you might want to use federal EPA pollution regulation as a potential instrumental variable for pollution changes during the 1970s.*

* Question II b(2) What are the assumptions required for 1975-1976 regulatory status (tsp7576) to be a valid instrument for pollution changes when the outcome of interest is housing price changes? *
estpost cor tsp7576 dlhouse dgtsp
esttab . using `imagepath'IIb2.tex, title(Correlation of 1975-1976 regulatory status with changes in housing prices and pollution levels\label{IIb2})  replace
* Question II b(3) Provide indirect evidence on the validity of instrument – e.g., relationship between the observable measures of economic shocks and the regulatory status (tsp7576).  *
estpost cor tsp7576 dincome dunemp dmnfcg ddens blt1080
esttab . using `imagepath'IIb3.tex, title(Correlation of regulatory status to changes in economic indicators\label{IIb3})  replace
* Question II b(4) Interpret your findings. *

* Question II c *
* Question II c(1) Report the “first-stage” regression of air pollution changes on regulatory status (tsp7576) and the “reduced-form” regression of housing price changes on regulatory status (tsp7576), using the same three specifications you used in part a).   *
reg dgtsp tsp7576
outreg2 using  `imagepath'IIc1f.tex, ctitle(baseline) tex(pretty frag) dec(4) replace
reg dlhouse tsp7576
outreg2 using  `imagepath'IIc1r.tex, ctitle(baseline) tex(pretty frag) dec(4) replace

reg dgtsp tsp7576 `mainctrl'
outreg2 using  `imagepath'IIc1f.tex, ctitle(mainctrl) keep(`keepmain') tex(pretty frag) dec(4) append
reg dlhouse tsp7576 `mainctrl'
outreg2 using  `imagepath'IIc1r.tex, ctitle(mainctrl) keep(`keepmain') tex(pretty frag) dec(4) append

reg dgtsp tsp7576 `mainctrl' `polyctrl'
outreg2 using  `imagepath'IIc1f.tex, title("First Stage Regression dgtsp on Instrument tsp7576") ctitle(mainpoly) keep(`keepmain' `keeppoly') tex(pretty frag) dec(4) append
reg dlhouse tsp7576 `mainctrl' `polyctrl'
outreg2 using  `imagepath'IIc1r.tex, title("Reduced Form Regression dlhouse on Instrument tsp7576") ctitle(mainpoly) keep(`keepmain' `keeppoly') tex(pretty frag) dec(4) append


* Question II c(2) Interpret your findings *

* Question II c(3) How does two-stage least squares use these two equations? *

* Question II c(4) Now estimate the effect of air pollution changes on housing price changes by two-stage least squares using the regulatory status indicator (tsp7576) as an instrument for the three specifications.  Interpret the results.   *
ivregress 2sls dlhouse (dgtsp = tsp7576)
outreg2 using  `imagepath'IIa.tex, ctitle(baseline) tex(pretty frag) dec(4) append
outreg2 using  `imagepath'IIc.tex, ctitle(baseline) tex(pretty frag) dec(4) replace
ivregress 2sls dlhouse (dgtsp = tsp7576) `mainctrl'
outreg2 using  `imagepath'IIa.tex, ctitle(mainctrl) keep(`keepmain') tex(pretty frag) dec(4) append
outreg2 using  `imagepath'IIc.tex, ctitle(mainctrl) keep(`keepmain')  tex(pretty frag) dec(4) append
ivregress 2sls dlhouse (dgtsp = tsp7576) `mainctrl' `polyctrl'
outreg2 using  `imagepath'IIa.tex, title("Simple Regression (models 1-3) vs 2SLS Instrumenting with tsp7576 (models 4-6)") ctitle(mainpoly) keep(`keepmain' `keeppoly') tex(pretty frag) dec(4) append
outreg2 using  `imagepath'IIc.tex,  ctitle(mainpoly) keep(`keepmain' `keeppoly') tex(pretty frag) dec(4) append
estat endog
estat firststage

* Question II c(5) Now do the same analysis using the 1975 regulatory status indicator (tsp75) as an instrumental variable. *
ivregress 2sls dlhouse (dgtsp = tsp75)
outreg2 using  `imagepath'IIc.tex, ctitle(baseline) tex(pretty frag) dec(4) append
ivregress 2sls dlhouse (dgtsp = tsp75) `mainctrl'
outreg2 using  `imagepath'IIc.tex, ctitle(mainctrl) keep(`keepmain') tex(pretty frag) dec(4) append
ivregress 2sls dlhouse (dgtsp = tsp75) `mainctrl' `polyctrl'
outreg2 using  `imagepath'IIc.tex,  title("Instrument is tsp7576 for models 1-3 and tsp75 for models 4-6") ctitle(mainpoly) keep(`keepmain' `keeppoly') tex(pretty frag) dec(4) append
estat endog
estat firststage

* Question II c(6) Compare the findings. *

* Question II d  *
* Question II d(1) Provide a concise and coherent summary of your results.  *

* Question II d(2) Discuss the “credibility” of the research designs underlying the results. *


log close
