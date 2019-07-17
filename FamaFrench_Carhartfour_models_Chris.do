clear all 
import excel "C:\Chris University\IBEB-3\Financial methods and techniques\Tutorial\A3-Data.xls", sheet("Sheet1") firstrow clear
tsset t
set more off

//Model 1
postfile estimates1 ID alpha se_alpha t_alpha using "tutorial6_1.dta"

foreach y of var mret* {
gen ex_`y'= `y' - rf
}

local i = 1

foreach x of var ex_mret* {
regress `x' mktrf

local t_alpha = abs(_b[_cons]/_se[_cons])

post estimates1 (`i')  (`=_b[_cons]') (`=_se[_cons]') (`t_alpha')
local ++i
}

postclose estimates1 

//Model 2 Fama-French


postfile estimates2 ID alpha se_alpha t_alpha  using "tutorial6_2.dta"

local i = 1

foreach x of var ex_mret* {
regress `x' mktrf hml smb

local t_alpha = abs(_b[_cons]/_se[_cons])

post estimates2 (`i')  (`=_b[_cons]') (`=_se[_cons]') (`t_alpha')
local ++i
}

postclose estimates2 

//Carhart Four-factor


postfile estimates3 ID alpha se_alpha t_alpha  using "tutorial6_3.dta"

local i = 1

foreach x of var ex_mret* {
regress `x' mktrf hml smb umd

local t_alpha = abs(_b[_cons]/_se[_cons])

post estimates3 (`i')  (`=_b[_cons]') (`=_se[_cons]') (`t_alpha')
local ++i
}

postclose estimates3 

//

use tutorial6_1, clear
*Model1
summarize  
use tutorial6_2, clear
*Model2
summarize
use tutorial6_3, clear
*Model3
summarize

//
clear all 
import excel "C:\Chris University\IBEB-3\Financial methods and techniques\Tutorial\A3-Data.xls", sheet("Sheet1") firstrow clear

//Model 1
postfile estimates_t ID alpha se_alpha t_alpha sample using "tutorial6_t.dta"

foreach y of var mret* {
gen ex_`y'= `y' - rf
}

//First half
local i = 1

foreach x of var ex_mret* {
regress `x' mktrf if t <= 120

local t_alpha = abs(_b[_cons]/_se[_cons])
local sample = 1

post estimates_t (`i')  (`=_b[_cons]') (`=_se[_cons]') (`t_alpha') (`sample')
local ++i
}
//Second half 

local i = 1

foreach x of var ex_mret* {
regress `x' mktrf if t > 120

local t_alpha = abs(_b[_cons]/_se[_cons])
local sample = 2

post estimates_t (`i')  (`=_b[_cons]') (`=_se[_cons]') (`t_alpha') (`sample')
local ++i
}
postclose estimates_t



use tutorial6_t, clear

//Winners
list if (alpha > 0 & t_alpha> 1.96 & sample==1)
list if (alpha > 0 & t_alpha> 1.96 & sample==2)
//Losers
list if (alpha < 0 & t_alpha> 1.96 & sample==1)
list if (alpha < 0 & t_alpha> 1.96 & sample==2)


////////////////////////////////////////////////////////////////////////////////////////////////////////

clear all 
import excel "C:\Chris University\IBEB-3\Financial methods and techniques\Tutorial\A3-Data.xls", sheet("Sheet1") firstrow clear
tsset t
set more off

foreach y of var mret* {
gen ex_`y'= `y' - rf
}


postfile estimates_t5 ID alpha se_alpha t_alpha sample using "tutorial6_5periods.dta"


//Sub-period1
local i = 1

foreach x of var ex_mret* {
regress `x' mktrf if t <= 48

local t_alpha = abs(_b[_cons]/_se[_cons])
local sample = 1

post estimates_t5 (`i')  (`=_b[_cons]') (`=_se[_cons]') (`t_alpha') (`sample')
local ++i
}



//Sub-period2
local i = 1

foreach x of var ex_mret* {
regress `x' mktrf if t > 48 & t <= 96

local t_alpha = abs(_b[_cons]/_se[_cons])
local sample = 2

post estimates_t5 (`i')  (`=_b[_cons]') (`=_se[_cons]') (`t_alpha') (`sample')
local ++i
}

//Sub-period3
local i = 1

foreach x of var ex_mret* {
regress `x' mktrf if t > 96 & t <=144

local t_alpha = abs(_b[_cons]/_se[_cons])
local sample = 3

post estimates_t5 (`i')  (`=_b[_cons]') (`=_se[_cons]') (`t_alpha') (`sample')
local ++i
}

//Sub-period4
local i = 1

foreach x of var ex_mret* {
regress `x' mktrf if t > 144 & t <=192

local t_alpha = abs(_b[_cons]/_se[_cons])
local sample = 4

post estimates_t5 (`i')  (`=_b[_cons]') (`=_se[_cons]') (`t_alpha') (`sample')
local ++i
}


//Sub-period5

local i = 1

foreach x of var ex_mret* {
regress `x' mktrf if t > 192

local t_alpha = abs(_b[_cons]/_se[_cons])
local sample = 5

post estimates_t5 (`i')  (`=_b[_cons]') (`=_se[_cons]') (`t_alpha') (`sample')
local ++i
}


postclose estimates_t5

use tutorial6_5periods, clear
//Winners
list if (alpha  > 0 & t_alpha> 1.96 & sample==1)
list if (alpha  > 0 & t_alpha> 1.96 & sample==2)
list if (alpha > 0 & t_alpha> 1.96 & sample==3)
list if (alpha > 0 & t_alpha> 1.96 & sample==4)
list if (alpha > 0 & t_alpha> 1.96 & sample==5)
//Losers
list if (alpha < 0 & t_alpha> 1.96 & sample==1)
list if (alpha  < 0 & t_alpha> 1.96 & sample==2)
list if (alpha  < 0 & t_alpha> 1.96 & sample==3)
list if (alpha  < 0 & t_alpha> 1.96 & sample==4)
list if (alpha  < 0 & t_alpha> 1.96 & sample==5)

////////////////////////////////////////////////////////////


clear all 
import excel "C:\Chris University\IBEB-3\Financial methods and techniques\Tutorial\A3-Data.xls", sheet("Sheet1") firstrow clear
tsset t

regress mret89 L.mret89
arima mret89, ar(1)

foreach y of var mret* {
gen ex_`y'= `y' - rf
}
regress ex_mret89 L.ex_mret89







///Unimportant

count if (p_alpha < 0.05 & alpha > 0) //number of postive abnormal returns
count if (p_alpha < 0.05 & alpha < 0) //number of negative abnormal returns

list if (p_alpha < 0.05 & alpha > 0) //Winners
list if (p_alpha < 0.05 & alpha < 0) //Losers
