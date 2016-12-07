clear all
set mem 1g
global figures "C:\Documents and Settings\muy208\My Documents\Lehigh University\Fall2011\eco464_fall2011\problem_sets\ps7\figures"
cd "C:\Documents and Settings\muy208\My Documents\Lehigh University\Fall2011\eco464_fall2011\problem_sets\ps7"

*-------------------------------------------------------------------------------------------------------------
* data cleaning
*-------------------------------------------------------------------------------------------------------------

use lbw, clear
order dbirwt death tobacco dmage dmeduc mblack motherr mhispan dmar foreignb dfage dfeduc fblack fotherr fhispan ///
      alcohol drink tripre1 tripre2 tripre3 tripre0 nprevist first dlivord deadkids disllb preterm pre4000 plural phyper diabete anemia
label variable dbirwt "birth weight of the infant (in grams)"
label variable death "indicator=1 if the infant died within one-year of birth and zero, otherwise"
label variable tobacco "indicator=1 if the mother smoked during pregnancy and zero, otherwise"
label variable dmage "mother's age"
label variable dmeduc "mother's educational attainment"
label variable mblack "indicator=1 if mother is Black"
label variable motherr "indicator=1 if neither Black nor White"
label variable mhispan "indicator=1 if Hispanic"
label variable dmar "indicator=1 if mother is unmarried"
label variable foreignb "indicator=1 if mother is foreign born"
label variable dfage "father's age"
label variable dfeduc "father's education"
label variable fblack "indicator=1 if father is Black"
label variable fotherr "indicator=1 if neither Black nor White"
label variable fhispan "indicator=1 if Hispanic"
label variable alcohol "indicator=1 if mother drank alcohol during pregnancy"
label variable drink "number of drinks per week"
label variable tripre1 "indicator=1 if 1st prenatal care visit in 1st trimester"
label variable tripre2 "indicator=1 if 1st prenatal care visit in 2nd trimester"
label variable tripre3 "indicator=1 if 1st prenatal care visit in 3rd trimester"
label variable tripre0 "indicator=1 if no prenatal care visits"
label variable nprevist "total number of prenatal care visits"
label variable first "indicator=1 if first-born"
label variable dlivord "birth order"
label variable deadkids "number of previous births where newborn died"
label variable disllb "months since last birth"
label variable preterm "indicator=1 if previous birth premature or small for gestational age"
label variable pre4000 "indicator=1 if previously had >4000 gram newborn"
label variable plural "indicator=1 if twins or greater birth"
label variable phyper "indicator=1 if mother had pregnancy-associated hypertension"
label variable diabete "indicator=1 if mother diabetic"
label variable anemia "indicator=1 if mother anemic"
duplicates drop
save data_cleaned, replace

* part (a)

use data_cleaned, clear
reg dbirwt tobacco, vce(robust)
outtex, level

* part (b)

use data_cleaned, clear
reg dbirwt tobacco dmage dmeduc mblack motherr mhispan dmar foreignb dfage dfeduc fblack fotherr fhispan ///
    alcohol drink tripre1 tripre2 tripre3 tripre0 nprevist first dlivord deadkids disllb preterm pre4000 plural phyper diabete anemia, vce(robust)
outtex, level

* part (c)

use data_cleaned, clear
gen dmage2=dmage^2
gen dmage3=dmage^3
gen dmeduc2 = dmeduc^2
gen dfage2 = dfage^2
gen dfage3=dfage^3
gen dfeduc2 = dfeduc^2
gen dmage_dmeduc = dmage*dmeduc
gen dmage_mblack = dmage*mblack
gen dmage_motherr = dmage*motherr
gen dmage_mhispan = dmage*mhispan
gen dmage_dmar =dmage*dmar
gen dfage_dfeduc = dfage*dfeduc
gen dfage_fblack = dfage*fblack
gen dfage_fotherr = dfage*fotherr
gen dfage_fhispan = dfage*fhispan
gen dmage_alcohol = dmage*alcohol
gen dmage_drink = dmage*drink
reg dbirwt tobacco ///
    dmage dmeduc mblack motherr mhispan dmar foreignb ///
    dfage dfeduc fblack fotherr fhispan ///
    alcohol drink tripre1 tripre2 tripre3 tripre0 nprevist ///
    first dlivord deadkids disllb preterm pre4000 plural phyper diabete anemia ///
    dmage2 dmage3 dmeduc2 dfage2 dfage3 dfeduc2 ///
    dmage_dmeduc dmage_mblack dmage_motherr dmage_mhispan dmage_dmar ///
    dfage_dfeduc dfage_fblack dfage_fotherr dfage_fhispan ///
    dmage_alcohol dmage_drink, vce(robust)
outtex, level

* part (e)

* (1) get propensity score (33 blocks)

use data_cleaned, clear
gen dmage2=dmage^2
gen dmeduc2 = dmeduc^2
gen dfage2 = dfage^2
gen dfeduc2 = dfeduc^2
gen dmage_dmeduc = dmage*dmeduc
gen dmage_mblack = dmage*mblack
gen dmage_motherr = dmage*motherr
gen dmage_mhispan = dmage*mhispan
gen dmage_dmar =dmage*dmar
gen dfage_dfeduc = dfage*dfeduc
gen dfage_fblack = dfage*fblack
gen dfage_fotherr = dfage*fotherr
gen dfage_fhispan = dfage*fhispan
gen dmage_alcohol = dmage*alcohol
gen dmage_drink = dmage*drink
pscore tobacco ///
       dmage dmeduc mblack motherr mhispan dmar foreignb ///
       dfage dfeduc fblack fotherr fhispan ///
       alcohol drink tripre1 tripre2 tripre3 tripre0 nprevist ///
       first dlivord deadkids disllb preterm pre4000 plural phyper diabete anemia ///
       dmage2 dmeduc2 dfage2 dfeduc2 ///
       dmage_dmeduc dmage_mblack dmage_motherr dmage_mhispan dmage_dmar ///
       dfage_dfeduc dfage_fblack dfage_fotherr dfage_fhispan ///
       dmage_alcohol dmage_drink ///
       ,pscore(pscore) blockid(block) logit level(0.01)
sort block pscore
drop dmage2 dmeduc2 dfage2 dfeduc2 ///
     dmage_dmeduc dmage_mblack dmage_motherr dmage_mhispan dmage_dmar ///
     dfage_dfeduc dfage_fblack dfage_fotherr dfage_fhispan ///
     dmage_alcohol dmage_drink
save data_pscore, replace

* (2) get propensity score (100 blocks)

use data_cleaned, clear
gen dmage2=dmage^2
gen dmeduc2 = dmeduc^2
gen dfage2 = dfage^2
gen dfeduc2 = dfeduc^2
gen dmage_dmeduc = dmage*dmeduc
gen dmage_mblack = dmage*mblack
gen dmage_motherr = dmage*motherr
gen dmage_mhispan = dmage*mhispan
gen dmage_dmar =dmage*dmar
gen dfage_dfeduc = dfage*dfeduc
gen dfage_fblack = dfage*fblack
gen dfage_fotherr = dfage*fotherr
gen dfage_fhispan = dfage*fhispan
gen dmage_alcohol = dmage*alcohol
gen dmage_drink = dmage*drink
pscore tobacco ///
       dmage dmeduc mblack motherr mhispan dmar foreignb ///
       dfage dfeduc fblack fotherr fhispan ///
       alcohol drink tripre1 tripre2 tripre3 tripre0 nprevist ///
       first dlivord deadkids disllb preterm pre4000 plural phyper diabete anemia ///
       dmage2 dmeduc2 dfage2 dfeduc2 ///
       dmage_dmeduc dmage_mblack dmage_motherr dmage_mhispan dmage_dmar ///
       dfage_dfeduc dfage_fblack dfage_fotherr dfage_fhispan ///
       dmage_alcohol dmage_drink ///
       ,pscore(pscore100) blockid(block100) logit level(0.001) numblo(101)
sort block100 pscore100
drop dmage2 dmeduc2 dfage2 dfeduc2 ///
     dmage_dmeduc dmage_mblack dmage_motherr dmage_mhispan dmage_dmar ///
     dfage_dfeduc dfage_fblack dfage_fotherr dfage_fhispan ///
     dmage_alcohol dmage_drink
save data_pscore100, replace

* (3) get propensity score (200 blocks)

use data_cleaned, clear
gen dmage2=dmage^2
gen dmeduc2 = dmeduc^2
gen dfage2 = dfage^2
gen dfeduc2 = dfeduc^2
gen dmage_dmeduc = dmage*dmeduc
gen dmage_mblack = dmage*mblack
gen dmage_motherr = dmage*motherr
gen dmage_mhispan = dmage*mhispan
gen dmage_dmar =dmage*dmar
gen dfage_dfeduc = dfage*dfeduc
gen dfage_fblack = dfage*fblack
gen dfage_fotherr = dfage*fotherr
gen dfage_fhispan = dfage*fhispan
gen dmage_alcohol = dmage*alcohol
gen dmage_drink = dmage*drink
pscore tobacco ///
       dmage dmeduc mblack motherr mhispan dmar foreignb ///
       dfage dfeduc fblack fotherr fhispan ///
       alcohol drink tripre1 tripre2 tripre3 tripre0 nprevist ///
       first dlivord deadkids disllb preterm pre4000 plural phyper diabete anemia ///
       dmage2 dmeduc2 dfage2 dfeduc2 ///
       dmage_dmeduc dmage_mblack dmage_motherr dmage_mhispan dmage_dmar ///
       dfage_dfeduc dfage_fblack dfage_fotherr dfage_fhispan ///
       dmage_alcohol dmage_drink ///
       ,pscore(pscore200) blockid(block200) logit level(0.005) numblo(201)
sort block200 pscore200
drop dmage2 dmeduc2 dfage2 dfeduc2 ///
     dmage_dmeduc dmage_mblack dmage_motherr dmage_mhispan dmage_dmar ///
     dfage_dfeduc dfage_fblack dfage_fotherr dfage_fhispan ///
     dmage_alcohol dmage_drink
save data_pscore200, replace

* (4) use propensity score

use data_pscore, clear
reg dbirwt tobacco pscore, vce(robust)
outtex, level

egen mpscore = mean(pscore)
gen Tpscore = tobacco*(pscore-mpscore)
reg dbirwt tobacco pscore Tpscore, vce(robust)
outtex, level

egen y0j = mean(dbirwt) if tobacco==0, by(block)
egen y1 = mean(dbirwt) if tobacco==1
egen y1_bar = mean(y1)
egen Nt = sum(tobacco)
forvalues j=1/33 {
	egen y0`j'_ = mean(dbirwt) if tobacco==0 & block==`j'
	egen y0`j' = mean(y0`j'_)
	egen Nt`j'_ = sum(tobacco) if block==`j'
	egen Nt`j' = mean(Nt`j'_)
	}
gen y0_bar = (Nt1*y01+Nt2*y02+Nt3*y03+Nt4*y04+Nt5*y05+Nt6*y06+Nt7*y07+Nt8*y08+Nt9*y09+Nt10*y010+	///
		      Nt11*y011+Nt12*y012+Nt13*y013+Nt14*y014+Nt15*y015+Nt16*y016+Nt17*y017+Nt18*y018+Nt19*y019+Nt20*y020+	///
              Nt21*y021+Nt22*y022+Nt23*y023+Nt24*y024+Nt25*y025+Nt26*y026+Nt27*y027+Nt28*y028+Nt29*y029+Nt30*y030+	///
              Nt31*y031+Nt32*y032+Nt33*y033)/Nt
gen ATT = y1_bar - y0_bar
summ ATT
** Or use this command
atts dbirwt tobacco, pscore(pscore) blockid(block)

* part (f)

use data_pscore, clear
gen y = (tobacco - pscore)*dbirwt/(1-pscore)
egen Nt = sum(tobacco)
egen y_sum = sum(y)
gen theta = y_sum/Nt
summ theta

* part (g)

use data_pscore100, clear
atts dbirwt tobacco, pscore(pscore100) blockid(block100)

use data_pscore200, clear
atts dbirwt tobacco, pscore(pscore200) blockid(block200)

* part (h)

use data_pscore100, clear
gen lbw = 1 if dbirwt <= 2500
replace lbw = 0 if dbirwt > 2500
atts lbw tobacco, pscore(pscore100) blockid(block100)

use data_pscore200, clear
gen lbw = 1 if dbirwt <= 2500
replace lbw = 0 if dbirwt > 2500
atts lbw tobacco, pscore(pscore200) blockid(block200)

* part (i)

use data_cleaned, clear
reg death tobacco, vce(robust)
outtex, level

use data_cleaned, clear
reg death tobacco ///
    dmage dmeduc mblack motherr mhispan dmar foreignb ///
    dfage dfeduc fblack fotherr fhispan ///
    alcohol drink ///
    tripre1 tripre2 tripre3 tripre0 nprevist ///
    first dlivord deadkids disllb preterm pre4000 plural phyper diabete anemia, vce(robust)
outtex, level

use data_pscore100, clear
atts death tobacco, pscore(pscore100) blockid(block100)

use data_pscore200, clear
atts death tobacco, pscore(pscore200) blockid(block200)



