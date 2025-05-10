// Part B

// 1.

import delimited "/Users/lilahwilliamson/Downloads/Advani_et_al_1.csv", clear

twoway scatter migrant_prop pctile, title("Proportion of migrants at all percentiles of the income distribution") xtitle("Percentiles") ytitle("Proportion of Migrants") xlabel(1 20 40 60 80 100)

drop if pctile < 90

gen pctile_2 = .
replace pctile_2 = 1 if pctile == 90
replace pctile_2 = 2 if pctile == 91
replace pctile_2 = 3 if pctile == 92
replace pctile_2 = 4 if pctile == 93
replace pctile_2 = 5 if pctile == 94
replace pctile_2 = 6 if pctile == 95
replace pctile_2 = 7 if pctile == 96
replace pctile_2 = 8 if pctile == 97
replace pctile_2 = 9 if pctile == 98
replace pctile_2 = 10 if pctile == 99
replace pctile_2 = 11 if abs(pctile - 99.9) < 0.001
replace pctile_2 = 12 if abs(pctile - 99.99) < 0.001
replace pctile_2 = 13 if abs(pctile - 99.999) < 0.001

twoway scatter migrant_prop pctile_2, xline(9.5, lcolor(red)) title("Proportion of migrants within the top decile") xtitle("Percentiles") ytitle("Proportion of Migrants") xlabel(1 "90" 2 "91" 3 "92" 4 "93" 5 "94" 6 "95" 7 "96" 8 "97" 9 "98" 10 "Top 1 - 0.1" 11 "0.1 - 0.01" 12 "0.01 - 0.001" 13 "Top 0.001", angle(45)) ylabel(0.0(0.1)0.4)

// 2a.

import delimited "/Users/lilahwilliamson/Downloads/Advani_et_al_2.csv", clear

summarize prop if ts == "Top 1"
summarize prop if ts == "Top 0.1"
summarize prop if ts == "Top 0.01"
summarize prop if ts == "Top 0.001"

// 2b.

drop if prop_income == "NA"

destring prop_income, replace

twoway(connected prop_income tax_year if ts == "Top 1") (connected prop_income tax_year if ts == "Top 0.1") (connected prop_income tax_year if ts == "Top 0.01") (connected prop_income tax_year if ts == "Top 0.001"), title("Share of income in top fractiles that goes to migrants") xtitle("Years") ytitle("Share of Income") xlabel(1997(3)2018) ylabel(0.0(0.1)0.4) legend(label(1 "Top 1") label(2 "Top 0.1") label(3 "Top 0.01") label(4 "Top 0.001"))
