cd "/Users/aiyenggar/OneDrive/Evernoted/06-Methods for Causal Inference/"
use "/Users/aiyenggar/OneDrive/Evernoted/06-Methods for Causal Inference/APPLE.dta"
use "/Users/aiyenggar/OneDrive/Evernoted/06-Methods for Causal Inference/GPA1.dta"
use "/Users/aiyenggar/OneDrive/Evernoted/06-Methods for Causal Inference/MEAP93.dta"

use "/Users/aiyenggar/OneDrive/Evernoted/06-Methods for Causal Inference/NSS68.dta"
// uuid is the concatenation of lot hamgrpsubblk secstgstr samplehhno
summ dwage
tab gen_edu

gen dcollege = 1 if (gen_edu == 11 | gen_edu == 12 | gen_edu == 13)
replace dcollege = 0 if missing(dcollege)

// recode - why would you do this?
hist dwage if dwage < 200
gen logdwage = ln(dwage+1)
hist logdwage

reg logdwage dcollege
ttest logdwage, by(dcollege)

// The coefficient estimate on dcollege is simply the difference in the means

reg gender dcollege
reg land_owned dcollege
reg sgroup dcollege

use "/Users/aiyenggar/OneDrive/Evernoted/06-Methods for Causal Inference/lakisha_aer.dta", clear
gen black = 1 if race=="b"
replace black = 0 if race=="w"
reg call black
ttest call, by(black)

reg black education ofjobs yearsexp honors computerskills specialskills email workinschool
// Look at the F statistic is the joint probability of all of them  jointly being zero
// Always the randomized control trial experiment will need to have a balance/score table
reg call black education ofjobs yearsexp honors computerskills specialskills email workinschool

use "/Users/aiyenggar/OneDrive/Evernoted/06-Methods for Causal Inference/Washington 2008/wash_basic.dta", clear
gen srvlngsq=srvlng*srvlng
gen agesq=age*age
// for interaction you can use var1##var2
// for categorical variable i. or c.

xi: reg nowtot ngirls white female repub  age agesq srvlng srvlngsq norelig catholic othchrst otherreligion demvote i.totchi i.region if congress==105
// destring region, replace -> this will change
reg nowtot ngirls white female repub  age srvlng reld1 reld3-reld5 chid2-chid11 regd* demvote  if congress==105
// Underlying identification strategy is that having a girl child is random, given that you have controlled for having children

 reg nowtot ngirls i.totchi if congress==105
