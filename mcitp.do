use "~/datafiles/patents/rawinventor_region.2001.dta", clear
compress region
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
drop region region_source patent_id country

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
reg invpatentsyear regionchange countrychange
outreg2 using  "~/OneDrive/code/articles/mci-term-paper-images/Ia.tex", label drop (_*) tex(pretty frag) dec(4) replace

reg invpatentsyear regionchange countrychange inventor_pool ///
	team_highest_noninventor
outreg2 using  "~/OneDrive/code/articles/mci-term-paper-images/Ia.tex", label drop (_*) tex(pretty frag) dec(4) append

reg invpatentsyear regionchange countrychange inventor_pool ///
	team_highest_noninventor intr_regchg_invpool intr_couchg_invpool ///
	intr_regchg_teampool intr_couchg_teampool
outreg2 using  "~/OneDrive/code/articles/mci-term-paper-images/Ia.tex", title("Mobility of Inventors and Productivity of Inventors") label drop (_*) tex(pretty frag) dec(4) append


//keep if regionchange==1 | countrychange == 1
duplicates drop inventor_id year, force
drop patent_id region region_source country

use "/Users/aiyenggar/datafiles/patents/rawinventor_region.2001.dta", clear
sort patent_id inventor_id
bysort patent_id: egen inventorcount=sum(1)
bysort patent_id: gen inventororder=_n
tab inventorcount if inventororder==1
