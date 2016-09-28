// 28-Sep-2016 Ashwin Iyenggar's Solution to Advanced Econometrics Homework 2

cd /Users/aiyenggar/OneDrive/code/econometrics

//-----------------------------------------------------------------
// Question I INDONESIA’S SCHOOL CONSTRUCTION PROGRAM 
//-----------------------------------------------------------------
use school_const, clear

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

