use "/Users/aiyenggar/datafiles/patents/rawinventor_urban_areas.dta"
keep year patent_id inventor_id region country_loc inventorseq name_first name_last
rename country_loc country
merge m:1 patent_id using `destdir'nber.dta, keep(match master) nogen
drop uuid
save inventors.nber.dta, replace

use "~/datafiles/patents/inventors.nber.dta", clear
keep if year > 2000 & !missing(year)

compress region
sort region
egen region_id = group(region)
sort country 
egen country_id = group(country)

sort inventor_id year
bysort inventor_id: gen regionchange = region != region[_n-1] | (_n == 1) if !missing(region) & !missing(region[_n-1])
replace regionchange=0 if missing(regionchange)
bysort inventor_id year: egen temp = sum(regionchange)
replace regionchange=1 if temp >= 1
drop temp

//bysort inventor_id: egen regioncount = sum(regionchange)
bysort inventor_id: gen countrychange = country != country[_n-1] | (_n == 1) if !missing(country) & !missing(country[_n-1])
replace countrychange=0 if missing(countrychange)
bysort inventor_id year: egen temp = sum(countrychange)
replace countrychange=1 if temp >= 1
drop temp
//bysort inventor_id: egen countrycount = sum(countrychange)

bysort inventor_id year: gen inventor_year_index=_n
bysort inventor_id year: egen invpatentsyear=sum(1)
bysort inventor_id: gen inventor_pool=sum(invpatentsyear) if inventor_year_index == 1
bysort inventor_id: replace inventor_pool=inventor_pool[_n-1] if missing(inventor_pool)
replace inventor_pool=inventor_pool-invpatentsyear

sort patent_id
bysort patent_id: egen prior_inventor_rank=rank(-inventor_pool), unique
bysort patent_id: egen team_sum=sum(inventor_pool)

gen team_sum1=team_sum-inventor_pool
sort patent_id prior_inventor_rank

gen team_rank1=inventor_pool if prior_inventor_rank==1
by patent_id: replace team_rank1=team_rank1[1] if _n!=1

gen team_rank2=inventor_pool if prior_inventor_rank==2
by patent_id: replace team_rank2=team_rank2[2] if _n!=2

gen team_highest_noninventor = team_rank1 if inventor_pool != team_rank1
replace team_highest_noninventor = team_rank2 if missing(team_highest_noninventor)

keep if inventor_year_index==1
drop inventor_year_index
//drop region patent_id country

gen intr_regchg_invpool = regionchange * inventor_pool
gen intr_couchg_invpool = countrychange * inventor_pool

gen intr_regchg_teampool = regionchange * team_highest_noninventor
gen intr_couchg_teampool = countrychange * team_highest_noninventor

label variable invpatentsyear "Productivity"
label variable regionchange "Moved Region (MR)"
label variable countrychange "Moved Country (MC)"
label variable inventor_pool "Prior Patents of Inventor (PPI)"
label variable team_highest_noninventor "Prior Patents of Team (PPT)"
label variable intr_regchg_invpool "MR x PPI"
label variable intr_couchg_invpool "MC x PPI"
label variable intr_regchg_teampool "MR x PPT"
label variable intr_couchg_teampool "MC x PPT"

// Should I be adding up the invpatentsyear? Or has it already been?


save "~/datafiles/patents/mci.2001.dta", replace
use "~/datafiles/patents/mci.2001.dta", clear

local ccountry "i.year i.subcategory_id, robust cluster(country_id)"


// Region Change
reg invpatentsyear regionchange  `ccountry'
outreg2 using  "~/OneDrive/code/articles/mci-term-paper-presentation-images/RC.tex", label keep(regionchange) tex(pretty frag) dec(4) replace 	addtext(Year FE, Yes, Technology FE, Yes, Clustered SE, Country)

reg invpatentsyear regionchange  inventor_pool ///
	team_highest_noninventor `ccountry'
outreg2 using  "~/OneDrive/code/articles/mci-term-paper-presentation-images/RC.tex", label keep(regionchange inventor_pool team_highest_noninventor) tex(pretty frag) dec(4) append 	addtext(Year FE, Yes, Technology FE, Yes, Clustered SE, Country)

reg invpatentsyear regionchange  inventor_pool ///
	team_highest_noninventor intr_regchg_invpool  ///
	intr_regchg_teampool `ccountry'
outreg2 using  "~/OneDrive/code/articles/mci-term-paper-presentation-images/RC.tex", ///
	title("Regional Mobility of Inventors and Productivity of Inventors") label ///
	keep(regionchange inventor_pool team_highest_noninventor intr_regchg_invpool intr_regchg_teampool) ///
	addtext(Year FE, Yes, Technology FE, Yes, Clustered SE, Country) ///
	tex(pretty frag) dec(4) append


// Country Change
reg invpatentsyear countrychange  `ccountry'
outreg2 using  "~/OneDrive/code/articles/mci-term-paper-presentation-images/CC.tex", label keep(countrychange) tex(pretty frag) dec(4) replace 	addtext(Year FE, Yes, Technology FE, Yes, Clustered SE, Country)

reg invpatentsyear countrychange inventor_pool ///
	team_highest_noninventor  `ccountry'
outreg2 using  "~/OneDrive/code/articles/mci-term-paper-presentation-images/CC.tex", label keep(countrychange inventor_pool team_highest_noninventor) tex(pretty frag) dec(4) append 	addtext(Year FE, Yes, Technology FE, Yes, Clustered SE, Country)

reg invpatentsyear countrychange inventor_pool ///
	team_highest_noninventor intr_couchg_invpool ///
	intr_couchg_teampool  `ccountry'
outreg2 using  "~/OneDrive/code/articles/mci-term-paper-presentation-images/CC.tex", ///
	title("Country Mobility of Inventors and Productivity of Inventors") label ///
	keep(countrychange inventor_pool team_highest_noninventor intr_couchg_invpool intr_couchg_teampool) ///
	addtext(Year FE, Yes, Technology FE, Yes, Clustered SE, Country) ///
	tex(pretty frag) dec(4) append


	
	
	
local cregion "i.year i.subcategory_id, robust cluster(region_id)"	
// Region Change
reg invpatentsyear regionchange  `cregion'
outreg2 using  "~/OneDrive/code/articles/mci-term-paper-presentation-images/RR.tex", label keep(regionchange) tex(pretty frag) dec(4) replace 	addtext(Year FE, Yes, Technology FE, Yes, Clustered SE, Region)

reg invpatentsyear regionchange  inventor_pool ///
	team_highest_noninventor `cregion'
outreg2 using  "~/OneDrive/code/articles/mci-term-paper-presentation-images/RR.tex", label keep(regionchange inventor_pool team_highest_noninventor) tex(pretty frag) dec(4) append 	addtext(Year FE, Yes, Technology FE, Yes, Clustered SE, Region)

reg invpatentsyear regionchange  inventor_pool ///
	team_highest_noninventor intr_regchg_invpool  ///
	intr_regchg_teampool `cregion'
outreg2 using  "~/OneDrive/code/articles/mci-term-paper-presentation-images/RR.tex", ///
	title("Regional Mobility of Inventors and Productivity of Inventors") label ///
	keep(regionchange inventor_pool team_highest_noninventor intr_regchg_invpool intr_regchg_teampool) ///
	addtext(Year FE, Yes, Technology FE, Yes, Clustered SE, Region) ///
	tex(pretty frag) dec(4) append


// Country Change
reg invpatentsyear countrychange  `cregion'
outreg2 using  "~/OneDrive/code/articles/mci-term-paper-presentation-images/CR.tex", label keep(countrychange) tex(pretty frag) dec(4) replace 	addtext(Year FE, Yes, Technology FE, Yes, Clustered SE, Region)

reg invpatentsyear countrychange inventor_pool ///
	team_highest_noninventor  `cregion'
outreg2 using  "~/OneDrive/code/articles/mci-term-paper-presentation-images/CR.tex", label keep(countrychange inventor_pool team_highest_noninventor) tex(pretty frag) dec(4) append 	addtext(Year FE, Yes, Technology FE, Yes, Clustered SE, Region)

reg invpatentsyear countrychange inventor_pool ///
	team_highest_noninventor intr_couchg_invpool ///
	intr_couchg_teampool  `cregion'
outreg2 using  "~/OneDrive/code/articles/mci-term-paper-presentation-images/CR.tex", ///
	title("Country Mobility of Inventors and Productivity of Inventors") label ///
	keep(countrychange inventor_pool team_highest_noninventor intr_couchg_invpool intr_couchg_teampool) ///
	addtext(Year FE, Yes, Technology FE, Yes, Clustered SE, Region) ///
	tex(pretty frag) dec(4) append



	
	
local csubcategory "i.year i.subcategory_id, robust cluster(subcategory_id)"
// Region Change
reg invpatentsyear regionchange  `csubcategory'
outreg2 using  "~/OneDrive/code/articles/mci-term-paper-presentation-images/RT.tex", label keep(regionchange) tex(pretty frag) dec(4) replace 	addtext(Year FE, Yes, Technology FE, Yes, Clustered SE, Technology)

reg invpatentsyear regionchange  inventor_pool ///
	team_highest_noninventor `csubcategory'
outreg2 using  "~/OneDrive/code/articles/mci-term-paper-presentation-images/RT.tex", label keep(regionchange inventor_pool team_highest_noninventor) tex(pretty frag) dec(4) append 	addtext(Year FE, Yes, Technology FE, Yes, Clustered SE, Technology)

reg invpatentsyear regionchange  inventor_pool ///
	team_highest_noninventor intr_regchg_invpool  ///
	intr_regchg_teampool `csubcategory'
outreg2 using  "~/OneDrive/code/articles/mci-term-paper-presentation-images/RT.tex", ///
	title("Regional Mobility of Inventors and Productivity of Inventors") label ///
	keep(regionchange inventor_pool team_highest_noninventor intr_regchg_invpool intr_regchg_teampool) ///
	addtext(Year FE, Yes, Technology FE, Yes, Clustered SE, Technology) ///
	tex(pretty frag) dec(4) append


// Country Change
reg invpatentsyear countrychange  `csubcategory'
outreg2 using  "~/OneDrive/code/articles/mci-term-paper-presentation-images/CT.tex", label keep(countrychange) tex(pretty frag) dec(4) replace 	addtext(Year FE, Yes, Technology FE, Yes, Clustered SE, Technology)

reg invpatentsyear countrychange inventor_pool ///
	team_highest_noninventor  `csubcategory'
outreg2 using  "~/OneDrive/code/articles/mci-term-paper-presentation-images/CT.tex", label keep(countrychange inventor_pool team_highest_noninventor) tex(pretty frag) dec(4) append 	addtext(Year FE, Yes, Technology FE, Yes, Clustered SE, Technology)

reg invpatentsyear countrychange inventor_pool ///
	team_highest_noninventor intr_couchg_invpool ///
	intr_couchg_teampool  `csubcategory'
outreg2 using  "~/OneDrive/code/articles/mci-term-paper-presentation-images/CT.tex", ///
	title("Country Mobility of Inventors and Productivity of Inventors") label ///
	keep(countrychange inventor_pool team_highest_noninventor intr_couchg_invpool intr_couchg_teampool) ///
	addtext(Year FE, Yes, Technology FE, Yes, Clustered SE, Technology) ///
	tex(pretty frag) dec(4) append


use "~/datafiles/patents/mci.2001.dta", clear
sutex regionchange countrychange invpatentsyear inventor_pool team_highest_noninventor, labels
bysort region_id year: egen rr=sum(regionchange) if !missing(region_id)
bysort region_id year: egen rc=sum(countrychange) if !missing(region_id)
bysort country_id year: egen cr=sum(regionchange) if !missing(country_id)
bysort country_id year: egen cc=sum(countrychange) if !missing(country_id)
duplicates drop year region, force
keep region year rr rc cr cc

drop if year > 2012
graph twoway (connected rc year if region=="Bangalore",  msymbol(d)) (connected rc year if region=="Beijing",  msymbol(t)) ///
	(connected rc year if region=="Boston",  msymbol(x)) ///
	(connected rc year if region=="San Jose3",  msymbol(oh)), ///
	ytitle("Number of Country Moves") xtitle("Year of Patent") ///
	ylabel(, angle(horizontal)) yscale(titlegap(*+10)) ///
	title("Mobility across the years") ///
	note("Data Source: patentsview.org, Natural Earth Urban Centers Database") ///
	legend(cols(1) label(1 Bangalore) label(2 Beijing)  label(3 Boston)  label(4 San Jose))
graph export countrymoves.png, replace

graph twoway (connected rr year if region=="Bangalore",  msymbol(d)) (connected rr year if region=="Beijing",  msymbol(t)) ///
	(connected rr year if region=="Boston",  msymbol(x)) ///
	(connected rr year if region=="San Jose3",  msymbol(oh)), ///
	ytitle("Number of Region Moves") xtitle("Year of Patent") ///
	ylabel(, angle(horizontal)) yscale(titlegap(*+10)) ///
	title("Mobility across the years") ///
	note("Data Source: patentsview.org, Natural Earth Urban Centers Database") ///
	legend(cols(1) label(1 Bangalore) label(2 Beijing)  label(3 Boston)  label(4 San Jose))
graph export regionmoves.png, replace
