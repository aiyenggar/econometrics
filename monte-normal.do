clear
set obs 100000
gen x=rnormal(2,4)
gen e=rnormal(0,1)
gen y=2+4*x+e
gen var=_n
gen var2=int((var+199)/200)
drop var
rename var2 var
gen beta0hat=-9876
gen beta1hat=-9876
forvalues index=1/500 {
		quietly reg y x if var==`index'
		replace beta0hat=_b[_cons] if  var==`index'
		replace beta1hat=_b[x] if  var==`index'
	}
duplicates drop var, force
histogram beta0hat
histogram beta1hat
