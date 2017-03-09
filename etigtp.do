cd "~/datafiles/patents"

use "~/datafiles/patents/patent.lnmodularity.dta", clear
rename cited_complexity ct_nc2
rename patent_complexity pt_nc2

gen ct_nc3 = comb(cited_subgroups, 3)
gen pt_nc3 = comb(patent_subgroups, 3)

gen ct_nc4 = comb(cited_subgroups, 4)
gen pt_nc4 = comb(patent_subgroups, 4)

gen ct_nc5 = comb(cited_subgroups, 5)
gen pt_nc5 = comb(patent_subgroups, 5)

gen lnc2 = ln(ct_nc2/pt_nc2)
gen lnc3 = ln((ct_nc2 + ct_nc3)/(pt_nc2 + pt_nc3))
gen lnc4 = ln((ct_nc2 + ct_nc3 + ct_nc4)/(pt_nc2 + pt_nc3 + pt_nc4))
gen lnc5 = ln((ct_nc2 + ct_nc3 + ct_nc4 + ct_nc5)/(pt_nc2 + pt_nc3 + pt_nc4 + pt_nc5))
keep patent_id lnc*
save "~/datafiles/patents/etig.complexity.dta", replace

use "~/datafiles/patents/rawassignee_urban_areas.dta", clear
drop if missing(assignee_id)
duplicates drop patent_id, force
merge 1:1 patent_id using "~/datafiles/patents/etig.complexity.dta"
keep year patent_id assignee_id region assignee lnc*
rename region assignee_region
save "~/datafiles/patents/etig.ass.lnc.dta", replace
merge m:1 patent_id using "~/datafiles/patents/nber.dta"
drop if _merge==2
drop _merge
drop uuid
save "~/datafiles/patents/etig.ass.lnc.nber.dta", replace

use  "~/datafiles/patents/rawinventor_urban_areas.dta", clear
merge m:1 patent_id using "~/datafiles/patents/etig.ass.lnc.nber.dta"
drop if _merge==2
drop _merge

gen country2 = country_loc
merge m:1 country2 using "~/datafiles/patents/country2.country.ipr_score.dta"
drop if _merge==2
drop _merge

egen inventor =  group(inventor_id)
keep year patent_id inventor_id region appl_date name_first name_last assignee* lnc* category_id subcategory_id country2 country ipr_score inventor


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


gen c2 = exp(lnc2)
gen c3 = exp(lnc3)
gen c4 = exp(lnc4)
gen c5 = exp(lnc5)

bysort inventor_id year: egen ac2 = mean(c2)
bysort inventor_id year: egen ac3 = mean(c3)
bysort inventor_id year: egen ac4 = mean(c4)
bysort inventor_id year: egen ac5 = mean(c5)

replace lnc2 = ln(ac2)
replace lnc3 = ln(ac3)
replace lnc4 = ln(ac4)
replace lnc5 = ln(ac5)
replace lnc = lnc2

drop c2-c5

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

gen regionipr = regionchange * ipr_score
gen countryipr = countrychange * ipr_score


bysort inventor_id: egen count_region_change=sum(regionchange)
pctile region_quartile = count_region_change, nq(100) genp(region_percent)
egen inventor_class = group(inventor_id subcategory_id)
egen region_assignee = group(region assignee_id)
bysort subcategory_id: egen asubcategory_c2 = mean(ac2)

label variable lnc "log(complexity)"
label variable lnc2 "log(complexity) 2x"
label variable lnc3 "log(complexity) 3x"
label variable lnc4 "log(complexity) 4x"
label variable lnc5 "log(complexity) 5x"

label variable regionchange "changed region"
label variable countrychange "changed country"
label variable ipr_score "IPR score"
label variable regionipr "changed region * IPR score"
label variable countryipr "changed country * IPR score"

save "~/datafiles/patents/etig.master.dta", replace


