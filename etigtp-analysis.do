cd "~/OneDrive/code/articles/etig-term-paper-presentation-images"
use "~/datafiles/patents/etig.master.dta", clear

sutex regionchange countrychange lnc inventor_pool team_highest_noninventor, labels

eststo clear

reg lnc regionchange countrychange 
estadd local Groups `e(N_clust)'
estadd local R-Sq `e(r2)'
estadd local SE "No"
estadd local Year "No"
estadd local Sample "All Obs"
est store model1a

reg lnc regionchange countrychange ipr_score 
estadd local Groups `e(N_clust)'
estadd local R-Sq `e(r2)'
estadd local SE "No"
estadd local Year "No"
estadd local Sample "All Obs"
est store model1b

reg lnc regionchange countrychange ipr_score regionipr countryipr
estadd local Groups `e(N_clust)'
estadd local R-Sq `e(r2)'
estadd local SE "No"
estadd local Year "No"
estadd local Sample "All Obs"
est store model1c

esttab model1a model1b model1c using model1a1b1c.tex, ///
		title("Preliminary Regression of Mobility of Inventors on Complexity of Inventions \label{model1a1b1c}") ///
		label longtable replace p(3) noomitted compress nogaps ///
		drop (_*) nocon scalars(r2 "SE" "Year" "Sample") addnotes("None of the models include fixed effects, or technology subcategory controls")
filefilter model1a1b1c.tex amodel1a1b1c.tex, from("r2") to("\$R^2$") replace
filefilter amodel1a1b1c.tex model1a1b1c.tex, from("Year") to("Year Dummies") replace
filefilter model1a1b1c.tex amodel1a1b1c.tex, from("SE") to("Clustered SE") replace
!mv amodel1a1b1c.tex model1a1b1c.tex

// Clustered standard errors at region assignee level

reg lnc regionchange countrychange ipr_score regionipr countryipr, vce(cluster region_assignee)
estadd local Groups `e(N_clust)'
estadd local RSquare `e(r2)'
estadd local Clustered "Region Assignee"
estadd local Year "No"
estadd local Sample "All Obs"
est store model2a

reg lnc regionchange countrychange ipr_score regionipr countryipr d19* d20*, vce(cluster region_assignee)
estadd local Groups `e(N_clust)'
estadd local RSquare `e(r2)'
estadd local Clustered "Region Assignee"
estadd local Year "Yes"
estadd local Sample "All Obs"
est store model2b


reg lnc regionchange countrychange dstrongipr intr_region_dstrongipr intr_country_dstrongipr d19* d20*, vce(cluster region_assignee)
estadd local Groups `e(N_clust)'
estadd local RSquare `e(r2)'
estadd local Clustered "Region Assignee"
estadd local Year "Yes"
estadd local Sample "All Obs"
est store model2c

esttab model2a model2b model2c using model2a2b2c.tex, ///
		title("IPR Strength and Mobility of Inventors on Complexity of Inventions \label{model2a2b2c}") ///
		label longtable replace p(3) noomitted compress nogaps ///
		drop (_* d19* d20*) nocon scalars(r2 N_clust Clustered Year Sample) sfmt(%9.3fc %9.0fc %9s %9s %9s) addnotes("None of the models include fixed effects, or technology subcategory controls")

filefilter model2a2b2c.tex amodel2a2b2c.tex, from("r2") to("\$R^2$") replace
filefilter amodel2a2b2c.tex model2a2b2c.tex, from("Year") to("Year Dummies") replace
filefilter model2a2b2c.tex amodel2a2b2c.tex, from("N\BS_clust") to("Clusters") replace
filefilter amodel2a2b2c.tex model2a2b2c.tex, from("Clustered") to("Clustered SE") replace		
rm amodel2a2b2c.tex


// Different measures of dependent variable

reg lnc2 regionchange countrychange dstrongipr intr_region_dstrongipr intr_country_dstrongipr d19* d20*, vce(cluster region_assignee)
estadd local Groups `e(N_clust)'
estadd local RSquare `e(r2)'
estadd local Clustered "Region Assignee"
estadd local Year "Yes"
estadd local Sample "All Obs"
est store model3a

reg lnc3 regionchange countrychange dstrongipr intr_region_dstrongipr intr_country_dstrongipr d19* d20*, vce(cluster region_assignee)
estadd local Groups `e(N_clust)'
estadd local RSquare `e(r2)'
estadd local Clustered "Region Assignee"
estadd local Year "Yes"
estadd local Sample "All Obs"
est store model3b

reg lnc4 regionchange countrychange dstrongipr intr_region_dstrongipr intr_country_dstrongipr d19* d20*, vce(cluster region_assignee)
estadd local Groups `e(N_clust)'
estadd local RSquare `e(r2)'
estadd local Clustered "Region Assignee"
estadd local Year "Yes"
estadd local Sample "All Obs"
est store model3c

reg lnc5 regionchange countrychange dstrongipr intr_region_dstrongipr intr_country_dstrongipr d19* d20*, vce(cluster region_assignee)
estadd local Groups `e(N_clust)'
estadd local RSquare `e(r2)'
estadd local Clustered "Region Assignee"
estadd local Year "Yes"
estadd local Sample "All Obs"
est store model3d

esttab model3a model3b model3c model3d using model3a3b3c3d.tex, ///
		title("IPR Strength and Mobility of Inventors on Varying Measures of Complexity \label{model3a3b3c3d}") ///
		label longtable replace p(3) noomitted compress nogaps ///
		drop (_* d19* d20*) nocon scalars(r2 N_clust Clustered Year Sample) sfmt(%9.3fc %9.0fc %9s %9s %9s) addnotes("None of the models include fixed effects, or technology subcategory controls")

filefilter model3a3b3c3d.tex model3a3b3c3d2.tex, from("r2") to("\$R^2$") replace
filefilter model3a3b3c3d2.tex model3a3b3c3d.tex, from("Year") to("Year Dummies") replace
filefilter model3a3b3c3d.tex model3a3b3c3d2.tex, from("N\BS_clust") to("Clusters") replace
filefilter model3a3b3c3d2.tex model3a3b3c3d.tex, from("Clustered") to("Clustered SE") replace		
rm model3a3b3c3d2.tex


// Technology Complexity and technology controls

reg lnc regionchange countrychange dstrongipr intr_region_dstrongipr intr_country_dstrongipr intr_region_complextech intr_country_complextech d19* d20* dsubcat*, vce(cluster region_assignee)
estadd local Groups `e(N_clust)'
estadd local RSquare `e(r2)'
estadd local Clustered "Region Assignee"
estadd local Year "Yes"
estadd local Tech "Yes"
estadd local Sample "All Obs"
est store model4a

reg lnc regionchange countrychange dstrongipr intr_region_dstrongipr intr_country_dstrongipr intr_region_complextech intr_country_complextech d19* d20* dsubcat* if country2=="US", vce(cluster region_assignee)
estadd local Groups `e(N_clust)'
estadd local RSquare `e(r2)'
estadd local Clustered "Region Assignee"
estadd local Year "Yes"
estadd local Tech "Yes"
estadd local Sample "US inventions"
est store model4b

reg lnc regionchange countrychange dstrongipr intr_region_dstrongipr intr_country_dstrongipr intr_region_complextech intr_country_complextech d19* d20* dsubcat* if country2=="IN", vce(cluster region_assignee)
estadd local Groups `e(N_clust)'
estadd local RSquare `e(r2)'
estadd local Clustered "Region Assignee"
estadd local Year "Yes"
estadd local Tech "Yes"
estadd local Sample "Indian inventions"
est store model4c

esttab model4a model4b model4c using model4a4b4c.tex, ///
		title("Technology Complexity and Mobility of Inventors on Invention Complexity \label{model4a4b4c}") ///
		label longtable replace p(3) noomitted compress nogaps ///
		drop (_* d19* d20* dsubcat*) nocon scalars(r2 N_clust Clustered Year Tech Sample) sfmt(%9.3fc %9.0fc %9s %9s %9s %9s) addnotes("None of the models include fixed effects")

filefilter model4a4b4c.tex model4a4b4c2.tex, from("r2") to("\$R^2$") replace
filefilter model4a4b4c2.tex model4a4b4c.tex, from("Year") to("Year Dummies") replace
filefilter model4a4b4c.tex model4a4b4c2.tex, from("N\BS_clust") to("Clusters") replace
filefilter model4a4b4c2.tex model4a4b4c.tex, from("Clustered") to("Clustered SE") replace	
filefilter model4a4b4c.tex model4a4b4c2.tex, from("Tech ") to("Technology Controls ") replace
!mv model4a4b4c2.tex model4a4b4c.tex

// Number of Region Moves
reg lnc regionchange countrychange dstrongipr intr_region_dstrongipr intr_country_dstrongipr intr_region_complextech intr_country_complextech dmover1 dmover2 dmover3to5 dmover6to8 dmover9 d19* d20* dsubcat*, vce(cluster region_assignee)
estadd local Groups `e(N_clust)'
estadd local RSquare `e(r2)'
estadd local Clustered "Region Assignee"
estadd local Year "Yes"
estadd local Tech "Yes"
estadd local Sample "All Obs"
est store model5a

esttab model5a using model5a.tex, ///
		title("Extent of Regional Mobility of Inventors on Invention Complexity \label{model5a}") ///
		label longtable replace p(3) noomitted compress nogaps ///
		drop (_* d19* d20* dsubcat*) nocon scalars(r2 N_clust Clustered Year Tech Sample) sfmt(%9.3fc %9.0fc %9s %9s %9s %9s) addnotes("None of the models include fixed effects")

filefilter model5a.tex model5a2.tex, from("r2") to("\$R^2$") replace
filefilter model5a2.tex model5a.tex, from("Year") to("Year Dummies") replace
filefilter model5a.tex model5a2.tex, from("N\BS_clust") to("Clusters") replace
filefilter model5a2.tex model5a.tex, from("Clustered") to("Clustered SE") replace	
filefilter model5a.tex model5a2.tex, from("Tech ") to("Technology Controls ") replace
!mv model5a2.tex model5a.tex


// Number of Country Moves
reg lnc regionchange countrychange dstrongipr intr_region_dstrongipr intr_country_dstrongipr intr_region_complextech intr_country_complextech dmovec1 dmovec2 dmovec3 dmovec4 dmovec5 d19* d20* dsubcat*, vce(cluster region_assignee)
estadd local Groups `e(N_clust)'
estadd local RSquare `e(r2)'
estadd local Clustered "Region Assignee"
estadd local Year "Yes"
estadd local Tech "Yes"
estadd local Sample "All Obs"
est store model5b

esttab model5b using model5b.tex, ///
		title("Extent of Country Mobility of Inventors on Invention Complexity \label{model5b}") ///
		label longtable replace p(3) noomitted compress nogaps ///
		drop (_* d19* d20* dsubcat*) nocon scalars(r2 N_clust Clustered Year Tech Sample) sfmt(%9.3fc %9.0fc %9s %9s %9s %9s) addnotes("None of the models include fixed effects")

filefilter model5b.tex model5b2.tex, from("r2") to("\$R^2$") replace
filefilter model5b2.tex model5b.tex, from("Year") to("Year Dummies") replace
filefilter model5b.tex model5b2.tex, from("N\BS_clust") to("Clusters") replace
filefilter model5b2.tex model5b.tex, from("Clustered") to("Clustered SE") replace	
filefilter model5b.tex model5b2.tex, from("Tech ") to("Technology Controls ") replace
!mv model5b2.tex model5b.tex

// Control for Inventor-Technology Class

reg lnc regionchange countrychange dstrongipr intr_region_dstrongipr intr_country_dstrongipr intr_region_complextech intr_country_complextech d19* d20* dsubcat*, vce(cluster region_assignee)
estadd local Groups `e(N_clust)'
estadd local RSquare `e(r2)'
estadd local Clustered "Region Assignee"
estadd local InventorClass "No"
estadd local Year "Yes"
estadd local Tech "Yes"
estadd local Sample "All Obs"
est store model6a

reg lnc regionchange countrychange dstrongipr intr_region_dstrongipr intr_country_dstrongipr intr_region_complextech intr_country_complextech inventor_class d19* d20* dsubcat*, vce(cluster region_assignee)
estadd local Groups `e(N_clust)'
estadd local RSquare `e(r2)'
estadd local Clustered "Region Assignee"
estadd local InventorClass "Yes"
estadd local Year "Yes"
estadd local Tech "Yes"
estadd local Sample "All Obs"
est store model6b
/*
reg lnc regionchange countrychange dstrongipr intr_region_dstrongipr intr_country_dstrongipr intr_region_complextech intr_country_complextech i.inventor_class d19* d20* dsubcat*, vce(cluster region_assignee)
estadd local Groups `e(N_clust)'
estadd local RSquare `e(r2)'
estadd local Clustered "Region Assignee"
estadd local InventorClass "Dummies"
estadd local Year "Yes"
estadd local Tech "Yes"
estadd local Sample "All Obs"
est store model6c
*/
esttab model6a model6b  using model6a6b6c.tex, ///
		title("Inventor - Technology Class Controls in Mobility of Inventors on Invention Complexity \label{model6a6b6c}") ///
		label longtable replace p(3) noomitted compress nogaps ///
		drop (_* d19* d20* dsubcat*) nocon scalars(r2 N_clust Clustered Year Tech InventorClass Sample) sfmt(%9.3fc %9.0fc %9s %9s %9s %9s %9s) addnotes("Unable to add inventor-technology class dummies since there are 4,617,880 unique inventor-technology class tuples")

filefilter model6a6b6c.tex model6a6b6c2.tex, from("r2") to("\$R^2$") replace
filefilter model6a6b6c2.tex model6a6b6c.tex, from("Year") to("Year Dummies") replace
filefilter model6a6b6c.tex model6a6b6c2.tex, from("N\BS_clust") to("Clusters") replace
filefilter model6a6b6c2.tex model6a6b6c.tex, from("Clustered") to("Clustered SE") replace	
filefilter model6a6b6c.tex model6a6b6c2.tex, from("Tech ") to("Technology Controls ") replace
filefilter model6a6b6c2.tex model6a6b6c.tex, from("InventorClass") to("Inventor Technology") replace

// Sep 11 Effects on Mobility
gen dsep11 = 1 if (appl_date >= td(9, 11, 2001) & appl_date - td(9, 11, 2001) <= 1461)
replace dsep11 = 0 if (appl_date < td(9, 11, 2001) & td(9, 11, 2001) - appl_date <= 1461)
gen intr_region_sep11 = regionchange * dsep11
gen intr_country_sep11 = countrychange *dsep11
label variable dsep11 "9/11 Shock"
label variable intr_region_sep11 "moved region * 9/11"
label variable intr_country_sep11 "moved country * 9/11"

reg lnc regionchange countrychange dstrongipr intr_region_dstrongipr intr_country_dstrongipr intr_region_complextech intr_country_complextech inventor_class dsep11 intr_region_sep11 intr_country_sep11 d19* d20* dsubcat*, vce(cluster region_assignee)
estadd local Sample "All Obs"
est store model7a

reg lnc regionchange countrychange dstrongipr intr_region_dstrongipr intr_country_dstrongipr intr_region_complextech intr_country_complextech inventor_class dsep11 intr_region_sep11 intr_country_sep11 d19* d20* dsubcat* if country2=="US", vce(cluster region_assignee)
estadd local Sample "US Inventions"
est store model7b

reg lnc regionchange countrychange dstrongipr intr_region_dstrongipr intr_country_dstrongipr intr_region_complextech intr_country_complextech inventor_class dsep11 intr_region_sep11 intr_country_sep11 d19* d20* dsubcat* if country2!="US", vce(cluster region_assignee)
estadd local Sample "Non-US Inventions"
est store model7c

esttab model7a model7b model7c  using model7a7b7c.tex, ///
		title("Using 9/11 Shock to Estimate the effect of Mobility of Inventors on Invention Complexity \label{model7a7b7c}") ///
		label longtable replace p(3) noomitted compress nogaps ///
		drop (_* d19* d20* dsubcat*) nocon scalars(r2 N_clust Sample) sfmt(%9.3fc %9.0fc %9s) addnotes("Standard Errors are clustered at the region-assignee level" "All models include year dummies and NBER technology subcategory dummies" "Control for inventor-technology subcategory included")

filefilter model7a7b7c.tex model7a7b7c2.tex, from("r2") to("\$R^2$") replace
filefilter model7a7b7c2.tex model7a7b7c.tex, from("N\BS_clust") to("Clusters") replace

// IV regression
ivregress 2sls lnc  dstrongipr intr_region_dstrongipr intr_country_dstrongipr intr_region_complextech intr_country_complextech  inventor_class d19* d20* dsubcat*  (regionchange = dsep11), vce(cluster region_assignee)
estadd local Sample "All Obs"
est store model8a

ivregress 2sls lnc   dstrongipr intr_region_dstrongipr intr_country_dstrongipr intr_region_complextech intr_country_complextech  inventor_class d19* d20* dsubcat* (regionchange = dsep11) if country2=="US", vce(cluster region_assignee)
estadd local Sample "US Inventions"
est store model8b

ivregress 2sls lnc  dstrongipr intr_region_dstrongipr intr_country_dstrongipr intr_region_complextech intr_country_complextech  inventor_class d19* d20* dsubcat* (regionchange = dsep11) if country2!="US", vce(cluster region_assignee)
estadd local Sample "Non-US Inventions"
est store model8c

esttab model8a model8b model8c  using model8a8b8c.tex, ///
		title("Instrumenting with 9/11 Shock to Estimate the effect of Regional Mobility of Inventors on Invention Complexity \label{model8a8b8c}") ///
		label longtable replace p(3) noomitted compress nogaps ///
		drop (_* d19* d20* dsubcat* inventor_class) nocon scalars(r2 N_clust Sample) sfmt(%9.3fc %9.0fc %9s) addnotes("Standard Errors are clustered at the region-assignee level" "All models include year dummies and NBER technology subcategory dummies" "Control for inventor-technology subcategory included")

filefilter model8a8b8c.tex model8a8b8c2.tex, from("r2") to("\$R^2$") replace
filefilter model8a8b8c2.tex model8a8b8c.tex, from("N\BS_clust") to("Clusters") replace
