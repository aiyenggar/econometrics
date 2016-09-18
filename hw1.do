log using c:\ECON419\hw1.log,replace

use c:\ECON419\german

su

/*PART 1*/
reg lnw ed


/*PART 2*/

reg lnw exp

predict uhat,residual

reg ed exp

predict vhat,residual

reg uhat vhat


reg lnw ed exp

log close