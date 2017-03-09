cd "~/datafiles/patents"
use "~/datafiles/patents/etig.master.dta", clear

drop if missing(year) |  year < 1950

reg lnc regionchange countrychange 
outreg2 using  "~/OneDrive/code/articles/etig-term-paper-presentation-images/Ia.tex", label drop (_*) tex(pretty frag) dec(4) replace

reg lnc regionchange countrychange ipr_score 
outreg2 using  "~/OneDrive/code/articles/etig-term-paper-presentation-images/Ia.tex", label drop (_*) tex(pretty frag) dec(4) append

reg lnc regionchange countrychange ipr_score regionipr countryipr
outreg2 using  "~/OneDrive/code/articles/etig-term-paper-presentation-images/Ia.tex", title("Mobility of Inventors and Complexity of Innovations") label drop (_*) tex(pretty frag) dec(4) append


xtset inventor year
xtreg lnc regionchange countrychange 
outreg2 using  "~/OneDrive/code/articles/etig-term-paper-presentation-images/IIIa.tex", label drop (_*) tex(pretty frag) dec(4) replace

xtreg lnc regionchange countrychange ipr_score 
outreg2 using  "~/OneDrive/code/articles/etig-term-paper-presentation-images/IIIa.tex", label drop (_*) tex(pretty frag) dec(4) append

xtreg lnc regionchange countrychange ipr_score regionipr countryipr
outreg2 using  "~/OneDrive/code/articles/etig-term-paper-presentation-images/IIIa.tex", title("Mobility of Inventors and Complexity of Innovations") label drop (_*) tex(pretty frag) dec(4) append



xtreg lnc2 regionchange countrychange ipr_score regionipr countryipr if subcategory_id >= 20 & subcategory_id < 30, fe
outreg2 using  "~/OneDrive/code/articles/etig-term-paper-presentation-images/IVa.tex", label drop (_*) tex(pretty frag) dec(4) replace

xtreg lnc3 regionchange countrychange ipr_score regionipr countryipr if subcategory_id >= 20 & subcategory_id < 30, fe
outreg2 using  "~/OneDrive/code/articles/etig-term-paper-presentation-images/IVa.tex", label drop (_*) tex(pretty frag) dec(4) append

xtreg lnc4 regionchange countrychange ipr_score regionipr countryipr if subcategory_id >= 20 & subcategory_id < 30, fe
outreg2 using  "~/OneDrive/code/articles/etig-term-paper-presentation-images/IVa.tex", label drop (_*) tex(pretty frag) dec(4) append

xtreg lnc5 regionchange countrychange ipr_score regionipr countryipr if subcategory_id >= 20 & subcategory_id < 30, fe
outreg2 using  "~/OneDrive/code/articles/etig-term-paper-presentation-images/IVa.tex", title("Mobility of Inventors and Complexity of Innovations") label drop (_*) tex(pretty frag) dec(4) append


Complex areas vs non-complex areas

xtreg lnc2 regionchange countrychange ipr_score regionipr countryipr if asubcategory_c2 >= 240, fe
outreg2 using  "~/OneDrive/code/articles/etig-term-paper-presentation-images/Va.tex", label drop (_*) tex(pretty frag) dec(4) addtext(Technology Complexity, High) replace

xtreg lnc2 regionchange countrychange ipr_score regionipr countryipr if asubcategory_c2 <= 40, fe
outreg2 using  "~/OneDrive/code/articles/etig-term-paper-presentation-images/Va.tex", title("Mobility of Inventors and Complexity of Innovations") label drop (_*) tex(pretty frag) dec(4) addtext(Technology Complexity, Low) append

