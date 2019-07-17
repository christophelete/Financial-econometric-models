clear all
set more off
import excel "C:\Chris University\IBEB-3\Seminar Interest Rates and Stock Market\Assignment 1A\time2Fama_Bliss_data.xlsx", sheet("Fama_Bliss_data") clear
set more off
rename A t
rename B y1
rename C y2
rename D y3
rename E y4
rename F y5


gen logy1 = ln(1+ y1/100)
gen logy2 = ln(1+ y2/100)
gen logy3 = ln(1+ y3/100)
gen logy4 = ln(1+ y4/100)
gen logy5 = ln(1+ y5/100)

tsset t 

tsline logy1 logy2 logy3 logy4 logy5 


gen time = _n
tsset time


preserve 
set more off
local x "logy1 logy2 logy3 logy4 logy5"
stack `x', into (y)
gen n = _stack
regress y n

collapse y, by(n)

twoway (line y n)
twoway (connected y n)

restore

tsset time

gen hpr1 = L12.logy1 
gen hpr2 = -(2-1)*logy1 + 2*L12.logy2
gen hpr3 = -(3-1)*logy2 + 3*L12.logy3
gen hpr4 = -(4-1)*logy3 + 4*L12.logy4
gen hpr5 = -(5-1)*logy4 + 5*L12.logy5

tsline hpr*


preserve
set more off
local hpr "hpr1 hpr2 hpr3 hpr4 hpr5"
stack `hpr', into (hpr)
regress hpr _stack

gen n = _stack

by n, sort : summarize hpr


egen hpr_sd = sd(hpr), by(n)
egen hpr_mean = mean(hpr), by(n)

twoway (line hpr_mean n)
twoway (line hpr_sd n)
twoway (line hpr_mean n) (line hpr_sd n)
twoway (connected hpr_mean n) (connected hpr_sd n)
restore

gen rx1 = hpr1 - L12.logy1 if t>= 19640101
gen rx2 = hpr2 - L12.logy1 if t>= 19640101
gen rx3 = hpr3 - L12.logy1 if t>= 19640101
gen rx4 = hpr4 - L12.logy1 if t>= 19640101
gen rx5 = hpr5 - L12.logy1 if t>= 19640101


gen f1 = logy1
gen f2 = -(2-1)*logy1 + 2*logy2
gen f3 = -(3-1)*logy2 + 3*logy3
gen f4 = -(4-1)*logy3 + 4*logy4
gen f5 = -(5-1)*logy4 + 5*logy5


gen f1_spread = f1 - logy1
gen f2_spread = f2 - logy1 
gen f3_spread = f3 - logy1 
gen f4_spread = f4 - logy1 
gen f5_spread = f5 - logy1 


//FAMA BLISS REGRESSION

local i = 2

postfile output maturity beta stdev R_square using "famablissoutput.dta"

regress rx2 L12.f2_spread if (t>=19650101)
local r2 = e(r2)
post output (`i')  (`=_b[L12.f2_spread]') (`=_se[L12.f2_spread]') (`r2') 
local ++i

regress rx3 L12.f3_spread if (t>=19650101)
local r2 = e(r2)
post output (`i')  (`=_b[L12.f3_spread]') (`=_se[L12.f3_spread]') (`r2') 
local ++i

regress rx4 L12.f4_spread if (t>=19650101)
local r2 = e(r2)
post output (`i')  (`=_b[L12.f4_spread]') (`=_se[L12.f4_spread]') (`r2') 
local ++i

regress rx5 L12.f5_spread if (t>=19650101)
local r2 = e(r2)
post output (`i')  (`=_b[L12.f5_spread]') (`=_se[L12.f5_spread]') (`r2') 
local ++i

postclose output

use famablissoutput, clear
list
