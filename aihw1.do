// 18-Sep-2016 Ashwin Iyenggar's Solution to Advanced Econometrics Homework 1

//-----------------------------------------------------------------
// Question 1
//-----------------------------------------------------------------
use german, clear
reg lnw ed
outreg2 using  /Users/aiyenggar/OneDrive/code/articles/adv-eco-hw1-images/01-lnw-ed.tex, tex(frag) replace

graph twoway (scatter lnw ed), ///
        ytitle("Low Wages") xtitle("Years of Schooling") ///
        title("Plot of log wages to years of schooling") ///
        note("Source: german.dta")
graph2tex, epsfile(/Users/aiyenggar/OneDrive/code/articles/adv-eco-hw1-images/german-lnw-ed) ht(5) caption(Plot of log wages to years of schooling)
rvfplot
graph2tex, epsfile(/Users/aiyenggar/OneDrive/code/articles/adv-eco-hw1-images/german-res-fit) ht(5) caption(Plot of residuals to fitted log wages)

reg lnw ed exp exp2 female mar, robust
outreg2 using  /Users/aiyenggar/OneDrive/code/articles/adv-eco-hw1-images/02-lnw-ed-all.tex, tex(frag) replace
rvfplot
graph2tex, epsfile(/Users/aiyenggar/OneDrive/code/articles/adv-eco-hw1-images/german-res-fit2) ht(5) caption(Plot of residuals to fitted log wages in expanded model)

//-----------------------------------------------------------------
// 1b Now apply the partialling-out method (a.k.a. Frisch-Waugh-Lovell Theorem) to the multivariate regression
// 1b1. run a regression of log-wages on a constant, experience, experience-squared, the gender indicator, and the marital status indicators
reg lnw ed exp exp2 female mar
outreg2 using  /Users/aiyenggar/OneDrive/code/articles/adv-eco-hw1-images/01-par1.tex, tex(frag) replace
// 1b2. save the residuals using STATA command [predict variable name, residual]
predict r1, resid

// 1b3. run a regression of years of schooling on a constant, experience, experience-squared, the gender indicator, and the marital status indicators
reg ed exp exp2 female mar
outreg2 using  /Users/aiyenggar/OneDrive/code/articles/adv-eco-hw1-images/01-par2.tex, tex(frag) replace
// 1b4. save the residuals; 
predict r2, resid

// 1b5. regress the residuals from (ii) on the residuals from (iv), while adjusting for heteroskedasticity.
reg r1 r2, robust
outreg2 using  /Users/aiyenggar/OneDrive/code/articles/adv-eco-hw1-images/01-par3.tex, tex(frag) replace
// 1b6. Compare this regression coefficient to the one (the coefficient on years of schooling) from the multivariate regression in part (a). Are they the same?  What about standard errors and t-statistics?  




//-----------------------------------------------------------------
// Question 2
//-----------------------------------------------------------------
use german, clear
// 2a1.	Write down the OLS estimator when the explanatory variable is binary (in a bivariate regression).  

// 2a2. Run a regression of log-wages on a constant and the computer indicator.  
reg lnw computer
outreg2 using  /Users/aiyenggar/OneDrive/code/articles/adv-eco-hw1-images/01-lnw-computer.tex, tex(frag) replace
// 2a3. Do the two sample t-test for the mean difference in log-wages between workers who use computers on the job and non-users (“ttest” command in STATA).  
ttest lnw, by(computer)
// 2a4. Compare the mean difference, standard error and t-statistic to the ones from the bivariate regression.  Are they the same?
// Mean difference is  -.2875494   Standard Error is  .0065046 95% Confidence Interval is ( -.3002989, -.2747998), t-statistic is  -44.2070 with 20040 degrees of freedom. We may reject the null hypothesis that the means are similar (pvalue is small:  Pr(|T| > |t|) = 0.0000)
// In the bivariate regression, the coefficient is  .2875494   Standard Error is .0065046    t-statistic is 44.21   pvalue (P>|t|) is 0.000    and 95% confidence interval is (.2747998, .3002989)

//-----------------------------------------------------------------

// 2b1. Now regress log-wages on a constant, the computer indicator, years of schooling, experience, experience-squared, the gender indicator, the marital status indicator, female*married, a dummy for part-time worker, living in city, and civil servants, while adjusting for heteroskedasticity.  
reg lnw computer ed exp exp2 female mar femmar part city beamter, robust
outreg2 using  /Users/aiyenggar/OneDrive/code/articles/adv-eco-hw1-images/02b1.tex, tex(frag) replace

// 2b2. How does the regression-adjusted estimate of the return to computer use compare to the one from part (a).  

// 2b3. What does this imply about the similarity in observables between computer users and non-users? 

//-----------------------------------------------------------------

// 2c1. Now compare the mean characteristics – e.g., age, gender, marital status, education (years of schooling), part-time worker, etc. – of computer users to non-users.  Are they statistically different?  
ttest exp, by(computer)
ttest exp2, by(computer)
ttest female, by(computer)
ttest mar, by(computer)
ttest ed, by(computer)
ttest part, by(computer)
ttest femmar, by(computer)
ttest city, by(computer)
ttest beamter, by(computer)


// 2c2. Why might this cast doubt on the causal interpretation of the return to computer use?  

// 2c3. Can you think of (unobserved) variables that we have not controlled for that may be related to both computer use and log-wages?  

// 2c4. Explain how this could lead to omitted variables bias in the OLS estimate of the return to computer use.  

//-----------------------------------------------------------------

// 2d1. Now add the indicators for calculator, telephone, and pencil use to the regression you ran in part (b).  
reg lnw computer ed exp exp2 female mar femmar part city beamter calc telefon pencil, robust
outreg2 using  /Users/aiyenggar/OneDrive/code/articles/adv-eco-hw1-images/02d1.tex, tex(frag) replace

// 2d2. Compare the estimated return to computer use to the one from part (b).  

// 2d3. Now run a regression that also controls for the individual’s occupation category as “fixed effects” [areg y x, absorb(occ) robust].  

// 2d4. Interpret the implications of your findings for the role of potential omitted variables bias in the OLS estimate of the effect of computer use on log-wages (see DiNardo and Pischke (1997) for their interpretation).


//-----------------------------------------------------------------

// 2e1. Now run the same regression as in part (d), while using the “cluster” option in STATA to correct the estimated standard errors for clustering at the occupation-level [areg y x, absorb(occ) cluster(occ)].  
reg lnw computer ed exp exp2 female mar femmar part city beamter calc telefon pencil, absorb(occ) cluster(occ)
outreg2 using  /Users/aiyenggar/OneDrive/code/articles/adv-eco-hw1-images/02e1.tex, tex(frag) replace
// 2e2. Explain why the standard error on the estimated return to computer use is higher (and lower t-statistic) than when clustering is not corrected for.


//-----------------------------------------------------------------

//-----------------------------------------------------------------
// Question 3
//-----------------------------------------------------------------


use NSW_lalonde, clear

// 3a1. Use experimental data [experimt==1].  Test the mean differences in characteristics (e.g., age, race, ethnicity, marital status, and years of schooling) between treatment and control group.  
use NSW_lalonde, clear
keep if experimt==1

ttest age, by(treat)
ttest educ, by(treat)
ttest black, by(treat)
ttest hispanic, by(treat)
ttest married, by(treat)
ttest nodegree, by(treat)

// 3a2. What does the result of this test imply about the identification of the causal effect of the NSW program?  

// 3a3. Estimate the average causal effect of the NSW program on earnings (re78) using a regression: i) without control variables; and ii) with control variables (age, educ, black, hispanic, married, nodegree, re75).  
reg re78 treat
outreg2 using  /Users/aiyenggar/OneDrive/code/articles/adv-eco-hw1-images/03a3-base.tex, tex(frag) replace
reg re78 treat age educ black hispanic married nodegree re75
outreg2 using  /Users/aiyenggar/OneDrive/code/articles/adv-eco-hw1-images/03a3-control.tex, tex(frag) replace

// 3a4. Interpret the results.  Are these two estimates (with and without controls) statistically same?  Why would this be the case?


//-----------------------------------------------------------------

// 3b1. Now use the non-experimental control group from the CPS data, along with the experimental treatment group [(experimt==0 & treat==0)|treat==1].  
use NSW_lalonde, clear
keep if (experimt==0 & treat==0)|treat==1

// 3b2. As you did in part (a), test the mean differences in characteristics between treatment and control group.  
ttest age, by(treat)
ttest educ, by(treat)
ttest black, by(treat)
ttest hispanic, by(treat)  // fail to reject the null hypothesis
ttest married, by(treat)
ttest nodegree, by(treat)

// 3b3. Interpret the results.  

// 3b4. Again, as you did in part (a), run a regression of earnings (re78) on treatment dummy (treat): i) without control variables; and ii) with control variables.  Interpret the results.  
reg re78 treat
outreg2 using  /Users/aiyenggar/OneDrive/code/articles/adv-eco-hw1-images/03b4-base.tex, tex(frag) replace
reg re78 treat age educ black hispanic married nodegree re75
outreg2 using  /Users/aiyenggar/OneDrive/code/articles/adv-eco-hw1-images/03b4-control.tex, tex(frag) replace

// 3b5. How do these results compare to the causal estimates using experimental data in part (a)? 


