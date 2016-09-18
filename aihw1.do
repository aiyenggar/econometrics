// 18-Sep-2016 Ashwin Iyenggar's Solution to Advanced Econometrics Homework 1
use german, clear


//-----------------------------------------------------------------
// Question 1
//-----------------------------------------------------------------

// 1a1. Run the bivariate regression of log-wages on a constant and years of schooling.
reg lnw ed

// 1a2. Briefly interpret the “economic meaning” of slope coefficient
// The slope coefficient of years of schooling (variable ed) is .0797769 and its 95% confidence interval is (.0774622, .0820916)
// Since we are regressing log wages on ed, this means that %delta(ed) = (100*coeff of ed)*delta(ed). 
// Therefore the  economic meaning of the slope coefficient is that a unit change in number of years of education, leads to a 7.97% increase in wages

// 1a3. Show the scatter plot of log-wages on the y-axis and years of schooling on the x-axis.
graph twoway (scatter lnw ed), ///
        ytitle("Low Wages") xtitle("Years of Schooling") ///
        title("Plot of log wages to years of schooling") ///
        note("Source: German.dta")
graph2tex, epsfile(german-lnw-ed) ht(5) caption(Plot of log wages to years of schooling)

// 1a4. Based on the plot, is there any evidence of heteroskedasticity?  
// We notice in the graph that the variance in the values for each level of years of schooling is not similar. So therefore we may suspect that the level of variance in the error term may be related to the value of ed. This suggests that heteroskedasticity is a possibility.

// 1a5. Now run the multivariate regression of log-wages on a constant, years of schooling, experience, experience-squared, the gender indicator, and the marital status indicators, while adjusting for heteroskedasticity (use “robust” option in STATA).
reg lnw ed exp exp2 female mar, robust

// 1a6. Explain briefly how these estimated standard errors are corrected for heteroskedasticity. 
// Refer to heteroskedasticity note in evernote

//-----------------------------------------------------------------
// 1b Now apply the partialling-out method (a.k.a. Frisch-Waugh-Lovell Theorem) to the multivariate regression
// 1b1. run a regression of log-wages on a constant, experience, experience-squared, the gender indicator, and the marital status indicators


// 1b2. save the residuals using STATA command [predict variable name, residual]


// 1b3. run a regression of years of schooling on a constant, experience, experience-squared, the gender indicator, and the marital status indicators


// 1b4. save the residuals; 


// 1b5. regress the residuals from (ii) on the residuals from (iv), while adjusting for heteroskedasticity.


// 1b6. Compare this regression coefficient to the one (the coefficient on years of schooling) from the multivariate regression in part (a). Are they the same?  What about standard errors and t-statistics?  




//-----------------------------------------------------------------
// Question 2
//-----------------------------------------------------------------



//-----------------------------------------------------------------
// Question 3
//-----------------------------------------------------------------


use NSW_lalonde, clear
