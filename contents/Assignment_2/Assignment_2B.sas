proc import datafile='/folders/myfolders/contents/carotenoid_data.xlsx' dbms=xlsx out=carot replace;
	sheet='sheet1';
	getnames=yes;
	*mixed=yes;
run;

data carot2; set carot;
	if food='' then food='No Food';
	if fiber = '' then delete;
run;

proc sort data = carot2; by food fiber level; run;

data carot3; set carot2;
fiber_food = trim(fiber) || ' - ' || trim(food);
run;

data carot4; set carot3;
	seed = 3854454644;
	rannum = ranuni(seed);
	if rannum < 0.5 then ranrep = 1;
	else if rannum < 0.8 then ranrep = 2;
	else ranrep = 3;
	
	if ranrep = 1 then ranpm = rep1;
	else if ranrep = 2 then ranpm = rep2;
	else ranpm = rep3;
run;

proc print data=carot4;
where fiber_food = 'Control - raw banana';
var rep1 - rep11;
run;

proc print data = carot4;
where ranrep = 3;
run;

proc print data = carot4;
where ranpm<25;
run;

proc print data = carot4;
where food = 'No food' & rep1<ranpm;
run;

libname sd '/folders/myfolders/contents';
data sd.ac sd.bc sd.lutein; set carot4;
	if carotenoid = 'AC' then output sd.ac;
	else if carotenoid = 'BC' then output sd.bc;
	else output sd.lutein;
run;	




