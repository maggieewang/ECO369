**PART A: Question 1
**import file for top income**
import delimited "/Users/maggiewang/Downloads/TopIncome.csv"

//filtering the data//
preserve 

**listing conditions to filter data**
keep if geo == "Canada"
keep if incomeconcepts == "Market income"
keep if incomegroups == "Top 0.01 percent income group"
keep if statistics == "Share of income"

**generate chart**
graph set window fontface "Times New Roman"
twoway connected value ref_date, title("Evolution of the Top 1% Income Share in Canada") subtitle("1982-2017") xtitle("Years, 1982-2017") ytitle("Income Share, percentage") ylabel(#10) scale(0.8)

**save chart**
graph export q1graph.png, replace

restore

**PART A: Question 2
list if geo == "Canada" & incomeconcepts == "After tax income" & statistics == "Threshold value" & ref_date == 2016 & incomegroups == "Top 10 percent income group" 
//from generated table, value is 75200

list if geo == "Canada" & incomeconcepts == "After tax income" & statistics == "Threshold value" & ref_date == 2016 & incomegroups == "Top 5 percent income group" 
//from generated table, value is 93600

list if geo == "Canada" & incomeconcepts == "After tax income" & statistics == "Threshold value" & ref_date == 2016 & incomegroups == "Top 1 percent income group" 
//from generated table, value is 160600 

**PART A: Question 3 a)
//filtering the data
preserve 
keep if geo == "Canada" & incomeconcepts == "Market income with capital gains" & statistics == "Share of income" & ref_date == 2016
keep if incomegroups == "Top 0.01 percent income group" | incomegroups == "Top 0.1 percent income group" | incomegroups == "Top 1 percent income group" | incomegroups == "Top 5 percent income group" | incomegroups == "Top 10 percent income group" | incomegroups == "Bottom 50 percent income group"

//bar labels
replace incomegroups = subinstr(incomegroups, " percent", "%", .)

gen grouporder = .
replace grouporder = 6 if incomegroups == "Top 0.01% income group"
replace grouporder = 5 if incomegroups == "Top 0.1% income group"
replace grouporder = 4 if incomegroups == "Top 1% income group"
replace grouporder = 3 if incomegroups == "Top 5% income group"
replace grouporder = 2 if incomegroups == "Top 10% income group"
replace grouporder = 1 if incomegroups == "Bottom 50% income group"

//graph
graph bar value, over(incomegroups, sort(grouporder)) title ("Share of Income by Group in Canada, 2016") subtitle ("Market Income with Capital Gains") ytitle ("Income Share, %") scale (0.5) blabel(bar, format(%9.2f))
graph export income_share_group2016.png, replace

restore

**PART A: Question 3 b)
//filtering data
preserve
keep if geo == "Canada" & incomeconcepts == "Market income with capital gains" & statistics == "Share of income" & ref_date == 1982
keep if incomegroups == "Top 0.01 percent income group" | incomegroups == "Top 0.1 percent income group" | incomegroups == "Top 1 percent income group" | incomegroups == "Top 5 percent income group" | incomegroups == "Top 10 percent income group" | incomegroups == "Bottom 50 percent income group"

//bar labels
replace incomegroups = subinstr(incomegroups, " percent", "%", .)

gen grouporder = .
replace grouporder = 6 if incomegroups == "Top 0.01% income group"
replace grouporder = 5 if incomegroups == "Top 0.1% income group"
replace grouporder = 4 if incomegroups == "Top 1% income group"
replace grouporder = 3 if incomegroups == "Top 5% income group"
replace grouporder = 2 if incomegroups == "Top 10% income group"
replace grouporder = 1 if incomegroups == "Bottom 50% income group"

//graph
graph bar value, over(incomegroups, sort(grouporder)) title ("Share of Income by Group in Canada, 1982") subtitle ("Market Income with Capital Gains") ytitle ("Income Share, %") scale (0.5) blabel(bar, format(%9.2f))
graph export income_share_group1982.png, replace

restore


**PART A: Question 4
//filtering data
preserve
keep if ref_date == 2016 & incomegroups == "Top 1 percent income group" & statistics == "Share of income" & incomeconcepts == "Market income with capital gains"
keep in 3/13
drop in 7

//sorting by ascending value
egen rankedincome = rank(value)
sort rankedincome
list rankedincome geo value

restore

**PART A: Bonus Question
ssc install spmap
ssc install shp2dta
ssc install mif2dta

//convert map file, merge onto topincome dataset 
shp2dta using /Users/maggiewang/Downloads/lpr_000b21a_e/lpr_000b21a_e.shp, database(cadb) coordinates(cacoord) genid(id)

keep if ref_date == 2016 & incomegroups == "Top 1 percent income group" & statistics == "Share of income" & incomeconcepts == "Market income with capital gains"
keep in 3/13
drop in 7

rename geo PRENAME
merge 1:1 PRENAME using /Users/maggiewang/Downloads/cadb.dta

spmap value using /Users/maggiewang/Downloads/cacoord.dta, id(id) fcolor(Blues)
graph export incomesharemap.png, replace

**PART B: Question 1
import delimited /Users/maggiewang/Downloads/Individual_2016.csv, clear

//run do file
*******************************************************
** GENERATE LABELS
*******************************************************

lab var agegp "Person's age group as of December 31 of refyear"		
lab var	immstp "Flag - Person is a landed immigrant"		
lab var	sex	"Sex"		
lab var	marst "Marital status"		
lab var	yrimmg "Number of years since person immigrated to Canada	, grouping"	
lab var	prov "Province"		
lab var	uszgap "Adjusted size of area of residence"		
lab var	mbmreg "Market Basket Measure (MBM) Region"		
lab var	fworke "Flag - Person was employed during the reference year"	
lab var scsum "Yearly summary of time worked during the ref year"		
lab var	alfst "Annual labour force status"		
lab var	wksem "Number of weeks employed during refyear"		
lab var	wksuem "Number of weeks unemployed during refyear"		
lab var	wksnlf "Number of weeks not in the labour force during re	fyear"	
lab var	ushrwk "Average usual hours worked per week at all jobs d	uring refyear"	
lab var	alhrwk "Total usual hours worked at all jobs during refye	ar"	
lab var	fpdwk "Flag - Person was a paid employee during refyear"		
lab var	fsemp "Flag - Person was self-employed during refyear"		
lab var	funfw "Flag - Person was an unpaid family worker during	refyear"	
lab var	alimo "Support payments received"		
lab var	alip "Support payments paid"		
lab var	atinc "After-tax income"		
lab var	capgn "Taxable capital gains"		
lab var	ccar "Child care expenses"		
lab var	chfed "Total of federal child benefits"		
lab var	chprv "Total provincial child benefits"		
lab var	chtxb "Total federal and provincial child benefits"		
lab var	cpqpp "CPP and QPP benefits"		
lab var	cqpc "Canada and Quebec Pension Plan contributions"		
lab var	earng "Earnings (employment income)"		
lab var	eipr "Employment Insurance contributions"		
lab var	fditx "Federal income tax (for Quebec, federal tax minus	Quebec abatement)"	
lab var	fmse "Farm self-employment net income"		
lab var	gi "Guaranteed Income Supplement under federal OAS"		
lab var	gstxc "Federal GST/HST Credit (excludes provincial sales	tax credit)"	
lab var	gtr "Government transfers, federal and provincial"		
lab var	inctx "Income tax, federal plus provincial"		
lab var	inva "Investment income"		
lab var	majri "Major source of income"		
lab var	mtinc "Market income"		
lab var	nfmse "Non-farm self-employment net income"		
lab var	oas "Old Age Security pension"		
lab var	oasgi "Total of Old Age Security benefits"		
lab var	ogovtr "Other government transfers"		
lab var	othinc "Other income"		
lab var	ottxm "Other taxable income"		
lab var	pen "Private retirement pensions (includes pension inc	ome splitting)"	
lab var	pengiv "Deduction for elected split-pension amount"		
lab var	penrec "Elected split-pension amount"		
lab var	phpr "Public health insurance premiums"		
lab var	prpen "Private retirement pensions"		
lab var	pvitx "Provincial income tax"		
lab var	pvtxc "Provincial tax credits"		
lab var	rppc "Registered pension plan contributions"		
lab var	rspwi "RRSP withdrawals"		
lab var	sapis "Social assistance benefits"		
lab var	semp "Self-employment net income"		
lab var	ttinc "Total income before taxes"		
lab var	uccb "Universal Child Care Benefit"		
lab var	udpd "Union dues (and other professional premiums)"		
lab var	uiben "Employment Insurance benefits"		
lab var	wgsal "Wages and salaries before deductions"		
lab var	wkrcp "Workers' compensation benefits"		


label data "Canadian Income Survey, 2016"

#delimit ;
label define wksem     96 "Valid skip" 97 "Don't know" 98 "Refusal" 
                       99 "Not stated" ;
label define wksuem    96 "Valid skip" 97 "Don't know" 98 "Refusal" 
                       99 "Not stated" ;
label define wksnlf    96 "Valid skip" 97 "Don't know" 98 "Refusal" 
                       99 "Not stated" ;
cap label define ushrwk    999.6 "Valid skip" 999.7 "Don't know" 999.8 "Refusal" 
                       999.9 "Not stated" ;
label define alhrwk    9996 "Valid skip" 9997 "Don't know" 9998 "Refusal" 
                       9999 "Not stated" ;
label define alimo     99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define alip      99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define atinc     99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define capgn     99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define ccar      99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define chfed     99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define chprv     99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define chtxb     99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define cpqpp     99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define cqpc      99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define earng     99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define eipr      99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define fditx     99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define fmse      99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define gi        99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define gstxc     99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define gtr       99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define inctx     99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define inva      99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define mtinc     99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define nfmse     99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define oas       99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define oasgi     99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define ogovtr    99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define othinc    99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define ottxm     99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define pen       99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define pengiv    99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define penrec    99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define phpr      99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define prpen     99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define pvitx     99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define pvtxc     99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define rppc      99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define rspwi     99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define sapis     99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define semp      99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define ttinc     99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define uccb      99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define udpd      99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define uiben     99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define wgsal     99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;
label define wkrcp     99999996 "Valid skip" 99999997 "Don't know" 
                       99999998 "Refusal" 99999999 "Not stated" ;


#delimit cr

replace wksem = . if (wksem >= 96 & wksem <= 99)
replace wksuem = . if (wksuem >= 96 & wksuem <= 99)
replace wksnlf = . if (wksnlf >= 96 & wksnlf <= 99)
replace ushrwk = . if (ushrwk >= 999.6 & ushrwk <= 999.9)
replace alhrwk = . if (alhrwk >= 9996 & alhrwk <= 9999)
replace alimo = . if (alimo >= 99999996 & alimo <= 99999999)
replace alip = . if (alip >= 99999996 & alip <= 99999999)
replace atinc = . if (atinc >= 99999996 & atinc <= 99999999)
replace capgn = . if (capgn >= 99999996 & capgn <= 99999999)
replace ccar = . if (ccar >= 99999996 & ccar <= 99999999)
replace chfed = . if (chfed >= 99999996 & chfed <= 99999999)
replace chprv = . if (chprv >= 99999996 & chprv <= 99999999)
replace chtxb = . if (chtxb >= 99999996 & chtxb <= 99999999)
replace cpqpp = . if (cpqpp >= 99999996 & cpqpp <= 99999999)
replace cqpc = . if (cqpc >= 99999996 & cqpc <= 99999999)
replace earng = . if (earng >= 99999996 & earng <= 99999999)
replace eipr = . if (eipr >= 99999996 & eipr <= 99999999)
replace fditx = . if (fditx >= 99999996 & fditx <= 99999999)
replace fmse = . if (fmse >= 99999996 & fmse <= 99999999)
replace gi = . if (gi >= 99999996 & gi <= 99999999)
replace gstxc = . if (gstxc >= 99999996 & gstxc <= 99999999)
replace gtr = . if (gtr >= 99999996 & gtr <= 99999999)
replace inctx = . if (inctx >= 99999996 & inctx <= 99999999)
replace inva = . if (inva >= 99999996 & inva <= 99999999)
replace mtinc = . if (mtinc >= 99999996 & mtinc <= 99999999)
replace nfmse = . if (nfmse >= 99999996 & nfmse <= 99999999)
replace oas = . if (oas >= 99999996 & oas <= 99999999)
replace oasgi = . if (oasgi >= 99999996 & oasgi <= 99999999)
replace ogovtr = . if (ogovtr >= 99999996 & ogovtr <= 99999999)
replace othinc = . if (othinc >= 99999996 & othinc <= 99999999)
replace ottxm = . if (ottxm >= 99999996 & ottxm <= 99999999)
replace pen = . if (pen >= 99999996 & pen <= 99999999)
replace pengiv = . if (pengiv >= 99999996 & pengiv <= 99999999)
replace penrec = . if (penrec >= 99999996 & penrec <= 99999999)
replace phpr = . if (phpr >= 99999996 & phpr <= 99999999)
replace prpen = . if (prpen >= 99999996 & prpen <= 99999999)
replace pvitx = . if (pvitx >= 99999996 & pvitx <= 99999999)
replace pvtxc = . if (pvtxc >= 99999996 & pvtxc <= 99999999)
replace rppc = . if (rppc >= 99999996 & rppc <= 99999999)
replace rspwi = . if (rspwi >= 99999996 & rspwi <= 99999999)
replace sapis = . if (sapis >= 99999996 & sapis <= 99999999)
replace semp = . if (semp >= 99999996 & semp <= 99999999)
replace ttinc = . if (ttinc >= 99999996 & ttinc <= 99999999)
replace uccb = . if (uccb >= 99999996 & uccb <= 99999999)
replace udpd = . if (udpd >= 99999996 & udpd <= 99999999)
replace uiben = . if (uiben >= 99999996 & uiben <= 99999999)
replace wgsal = . if (wgsal >= 99999996 & wgsal <= 99999999)
replace wkrcp = . if (wkrcp >= 99999996 & wkrcp <= 99999999)



 lab define prov 10  "Newfoundland and Labrador" ///
              11  "Prince Edward Island" ///
              12  "Nova Scotia" ///
              13  "New Brunswick" ///
              24  "Quebec" ///
              35  "Ontario" ///
              46 "Manitoba" ///
              47  "Saskatchewan" ///
              48  "Alberta" ///
              59  "British Columbia" ///
              96  "Valid skip" ///
              97  "Don't know" ///
              98  "Refusal" ///
              99  "Not stated" 
			  
summarize atinc
//drop if atinc == . | atinc < 0

**PART B: Question 2
summarize atinc, detail 

**PART B: Question 3
ginidesc atinc, by (prov)

**PART B: Question 4
summarize atinc if sex == 1, detail
summarize atinc if sex == 2, detail

**PART B: Bonus Question
//create dummy variable
replace sex = sex-1
regress atinc sex

