cd "/Users/anu/OneDrive/Evernoted/06-Methods for Causal Inference/"

use "/Users/anu/OneDrive/Evernoted/06-Methods for Causal Inference/carddata.dta", clear

reg lwage educ
gen exper2=(exper^2)/100
reg lwage educ exper exper2 black south smsa i.region smsa66

reg lwage nearc4  exper exper2 black south smsa i.region smsa66
reg educ nearc4  exper exper2 black south smsa i.region smsa66
ivregress 2sls lwage (educ=nearc4) exper exper2 black south smsa i.region smsa66

drop educhat
reg educ nearc4 exper exper2 black south smsa i.region smsa66
predict educhat, resid

reg lwage educ educhat exper exper2 black south smsa i.region smsa66


ivregress 2sls lwage (educ=nearc4) exper exper2 black south smsa i.region smsa66
reg lwage educhat

estimates store abc
hausman <coeff1> <coeff2>, constant sigmamore
