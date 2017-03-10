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


sort inventor_id appl_date
bysort inventor_id: gen regionchange = region != region[_n-1] | (_n == 1) if !missing(region) & !missing(region[_n-1])
replace regionchange=0 if missing(regionchange)
bysort inventor_id year: egen temp = sum(regionchange)
gen rtransition = 1 if regionchange == 1
replace regionchange=1 if temp >= 1
drop temp

sort inventor_id appl_date
bysort inventor_id: gen countrychange = country != country[_n-1] | (_n == 1) if !missing(country) & !missing(country[_n-1])
replace countrychange=0 if missing(countrychange)
bysort inventor_id year: egen temp = sum(countrychange)
gen ctransition = 1 if countrychange == 1
replace countrychange=1 if temp >= 1
drop temp

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

drop if (countrychange == 0 & regionchange == 0 & inventor_year_index != 1)
keep if (countrychange == 0 & regionchange == 0) | (countrychange == 1 & ctransition == 1) | (regionchange == 1 & rtransition == 1)
drop inventor_year_index

gen regionipr = regionchange * ipr_score
gen countryipr = countrychange * ipr_score


bysort inventor_id: egen count_region_change=sum(regionchange)
xtile region_quartile = count_region_change, nq(100)

bysort inventor_id: egen count_country_change=sum(countrychange)
xtile country_quartile = count_country_change, nq(100)

egen inventor_class = group(inventor_id subcategory_id)
egen region_assignee = group(region assignee_id)
bysort subcategory_id: egen asubcategory_c2 = mean(ac2)

label variable lnc "log(complexity)"
label variable lnc2 "log(complexity) 2x"
label variable lnc3 "log(complexity) 3x"
label variable lnc4 "log(complexity) 4x"
label variable lnc5 "log(complexity) 5x"

label variable regionchange "moved region"
label variable countrychange "moved country"
label variable ipr_score "IPR index"
label variable regionipr "moved region * IPR index"
label variable countryipr "moved country * IPR index"


drop if missing(year) |  year < 1950
// Strong and Weak IPR
gen dstrongipr = 1 if !missing(ipr_score) & ipr_score > 8
replace dstrongipr = 0 if !missing(ipr_score) & ipr_score <= 8

// Group by number of region moves
gen dmover0 = 1 if count_region_change == 0
replace dmover0 = 0 if count_region_change > 0

gen dmover1 = 0 if count_region_change >= 0
replace dmover1 = 1 if count_region_change == 1

gen dmover2 = 0 if count_region_change >= 0
replace dmover2 = 1 if count_region_change == 2

gen dmover3to5 = 0 if count_region_change >= 0
replace dmover3to5 = 1 if count_region_change >= 3 & count_region_change <= 5

gen dmover6to8 = 0 if count_region_change >= 0
replace dmover6to8 = 1 if count_region_change >= 6 & count_region_change <= 8

gen dmover9 = 0 if count_region_change >= 0
replace dmover9 = 1 if count_region_change >= 9

// Group by number of country moves
gen dmovec0 = 1 if count_country_change == 0
replace dmovec0 = 0 if count_country_change > 0

gen dmovec1 = 0 if count_country_change >= 0
replace dmovec1 = 1 if count_country_change == 1

gen dmovec2 = 0 if count_country_change >= 0
replace dmovec2 = 1 if count_country_change == 2

gen dmovec3 = 0 if count_country_change >= 0
replace dmovec3 = 1 if count_country_change == 3

gen dmovec4 = 0 if count_country_change >= 0
replace dmovec4 = 1 if count_country_change == 4

gen dmovec5 = 0 if count_country_change >= 0
replace dmovec5 = 1 if count_country_change >= 5

// Year dummies
levels year, local(allyears) 
foreach y of local allyears {
	gen d`y' = 1 if year == `y'
	replace d`y' = 0 if !missing(year) & missing(d`y')
}

// some dynamism in technology category
gen subcat_lnc2 = ln(asubcategory_c2)
xtile subcategory_quartile = subcat_lnc2, nq(10)
gen dcomplextech = 1 if subcategory_quartile > 5
replace dcomplextech = 0 if !missing(subcategory_quartile) & subcategory_quartile <= 5

gen intr_region_dstrongipr = regionchange * dstrongipr
gen intr_country_dstrongipr = countrychange * dstrongipr
label variable dstrongipr "strong IPR"
label variable intr_region_dstrongipr "moved region * strong IPR"
label variable intr_country_dstrongipr "moved country * strong IPR"

gen intr_region_complextech = regionchange * dcomplextech
gen intr_country_complextech = countrychange * dcomplextech

label variable dcomplextech "tech complexity"
label variable intr_region_complextech "moved region * tech complexity"
label variable intr_country_complextech "moved country * tech complexity"

    
label variable dmover1 "region moves = 1"
label variable dmover2 "region moves = 2"
label variable dmover3to5 "3 <= region moves <= 5"
label variable dmover6to8 "6 <= region moves <= 8"
label variable dmover9 "region moves >= 9"

label variable dmovec1 "country moves = 1"
label variable dmovec2 "country moves = 2"
label variable dmovec3 "country moves = 3"
label variable dmovec4 "country moves = 4"
label variable dmovec5 "country moves >= 5"

label variable inventor_class "inventor-tech class"
/*
levels country2, local(allcountries) 
foreach c of local allcountries {
	gen dcountry`c' = 1 if country2 == "`c'"
	replace dcountry`c' = 0 if !missing(country2) & missing(dcountry`c')
}
*/

levels subcategory_id, local(allsubcat) 
foreach s of local allsubcat {
	gen dsubcat`s' = 1 if subcategory_id == `s'
	replace dsubcat`s' = 0 if !missing(subcategory_id) & missing(dsubcat`s')
}


save "~/datafiles/patents/etig.master.dta", replace


