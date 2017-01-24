*LECTURE
use "C:\Users\vid\Desktop\causal reasoning\FERTIL1.dta", clear
reg kids i.year  educ  c.age##c.age  black  east northcen west farm othrural town smcity

use "D:\Users\Vidhya Soundararajan\Desktop\causal reasoning\NSS68.dta", clear
append using "D:\Users\Vidhya Soundararajan\Desktop\causal reasoning\NSS66.dta"
gen lndwage = ln(dwage+1)
label define voc_training 1 "yes: receiving formal vocational training" 2 "received vocational training: formal" 3 "non-formal: hereditary" 4 "non-formal:self-leanring" 5 "non-formal: learning on the job" 6 "nonforma: others" 7 "did not receive any vocational training"
label values voc_training voc_training
recode voc_training (7=1) (3 4 5 6=3) (1=4), gen(vocation_recode)
label define vocation_recode 1 "Not received vocational training" 2 "received formal vocational training" 3 "Received informal training" 4 "receiving formal vocational training"
label values vocation_recode vocation_recode

local variables "c.age##c.age i.gender i.marstatus i.gen_edu"
reg lndwage i.vocation_recode if vocation_recode!=4
outreg2 using vocationeffects, word replace
reg lndwage i.vocation_recode `variables' if vocation_recode!=4
outreg2 using vocationeffects, word append keep(2.vocation_recode 3.vocation_recode)
reg lndwage i.vocation_recode `variables' i.year if vocation_recode!=4
outreg2 using vocationeffects, word append keep(2.vocation_recode 3.vocation_recode)
reg lndwage i.vocation_recode `variables' i.year i.state if vocation_recode!=4
outreg2 using vocationeffects, word append keep(2.vocation_recode 3.vocation_recode)
reg lndwage i.vocation_recode `variables' i.year i.state i.curweek_ind_2digit if vocation_recode!=4
outreg2 using vocationeffects, word append keep(2.vocation_recode 3.vocation_recode)

use "C:\Users\vid\Desktop\causal reasoning\KIELMC.dta", clear
reg  rprice nearinc if year==1978
reg  rprice nearinc if year==1981
reg  rprice nearinc##i.year

*HANDSON
use "D:\Users\Vidhya Soundararajan\Desktop\causal reasoning\IIM course\PS3\ckminwage.dta",clear
desc
*2. Generating full time equivalent employment variable 
gen FTE = (empft+nmgrs) + emppt*0.5

*3. t-test of differnce in means 
gen earningmw = 0
replace earningmw=1 if wage_st==4.25
table post nj, c(mean FTE mean wage_st mean earningmw mean hrsopen)
*t-test of equality of means
ttest FTE if post==1, by(nj)
ttest FTE if post==0, by(nj)
ttest wage_st if post==1, by(nj)
ttest wage_st if post==0, by(nj)
ttest earningmw if post==1, by(nj)
ttest earningmw if post==0, by(nj)
ttest hrsopen if post==1, by(nj)
ttest hrsopen if post==0, by(nj)

*4. post treatment period difference in nj and penn FTE
summ FTE if post==1 & nj==1
local njpost = r(mean)
summ FTE if post==1 & nj==0
local pennpost = r(mean)
local postdiff = `njpost' - `pennpost'
di `postdiff'

*5. pre-treatment period difference in nj and penn FTE, and difference-in-difference
summ FTE if post==0 & nj==1
local njpre = r(mean)
summ FTE if post==0 & nj==0
local pennpre = r(mean)
local prediff = `njpre' - `pennpre'
*difference in difference
di `postdiff' - `prediff'

*6. 
gen njpost = nj*post
reg wage_st nj post njpost
/*The coefficient on nj is the difference in mean starting wage between states 
(nj and pa) given that the time period is 1 (i.e. post=0).  The coefficient on 
post is the difference in mean starting wage across time periods  
(period 1 and period 2) given that the state is pa (i.e. nj=0). The coefficient on
njpost is the difference between the two state differences in mean starting wage
over time (difference in difference).  The constant is the mean starting wage in
pa for time period 1 (i.e.  when post=0 and nj=0). You can easily check this 
with table 2 of the paper, which you produced in question 3*/

*7. Histogram of wages pre/post/nj/penn. Notice that there is a peak at the minimum wage in NJ at 5.25 in post=1
twoway (histogram wage_st if post==1, color(red))(histogram wage_st if post==0), by(nj)

*8. Employment effects using diff-n-diff
reg FTE nj post njpost 

*viii
/*Assuming that time trends are the same across times, NJ average FTE would have 
decreased by the same increment as PA FTE did, by 2.1, had it not been treated. 
Thus it would have ended with an average FTE of 18.3.  */

*ix
drop njpost 
reshape wide earningmw empft emppt nmgrs FTE wage_st hrsopen pentree, i(id) j(post) 
summ d_fte if nj==0
summ d_fte if nj==1
/*The average difference in NJ is .46666667, and the average difference in PA 
is -2.2833333.   Yes, this looks about the same as what I found through the 
previous method. */

*x
reg d_fte nj
/*This method (subtracting the two figures above) finds a difference in difference
effect of 2.75.  This is not far off from vi*/

*xi
/*
If the trend in emplooyment before the introduction of the minimum wage are 
similar across states, the identification is valid.  There is no test of this 
assumption, however – and probably no possible test given when the authors began
gathering data.  Therefore, it is hard to be sure that the diff-in-diff estimator 
is indeed causal.  Also, even if time trends are the same, all we know is that 
no significant change in employment happened at the particular date of the 
authors’ second survey – it is possible that employment figures took a while 
longer to adjust, in which case the effect would not be captured in this data.*/
	
*xii
/*This strengthens the validity of the paper a little bit, as the trends look 
pretty similar prior to the minimum wage increase. However, there is not a very 
long period being calculated before the policy was implemented – a longer period
would be more convincing. */






