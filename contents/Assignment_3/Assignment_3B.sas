proc import datafile = '/folders/myfolders/contents/carotenoid_data.xlsx' dbms = xlsx out = carot replace;
run;

data carot2; set carot;
	if fiber  = ' ' then delete;
	if food = ' ' then food = 'No Food';
run;

data carot3; set carot2;
	rep = 1; conc = rep1; output;
	rep = 2; conc = rep2; output;
	rep = 3; conc = rep3; output;
	rep = 4; conc = rep4; output;
	rep = 5; conc = rep5; output;
	rep = 6; conc = rep6; output;
	rep = 7; conc = rep7; output;
	rep = 8; conc = rep8; output;
	rep = 9; conc = rep9; output;
	rep = 10; conc = rep10; output;
	rep = 11; conc = rep11; output;
run;

data carot4; set carot3;
	if conc = . then delete;
run;

data carot5; set carot4;
	keep Fiber Level Food Enzyme Carotenoid rep conc;
run;

data carot5; set carot5;
	if carotenoid = 'AC' then ac = conc;
	else if carotenoid = 'BC' then bc = conc;
	else lt = conc;
run;


/* data carot5; set carot5; */
/*   if carotenoid = 'AC' then ac = conc; */
/*   if carotenoid = 'BC' then bc = conc; */
/*   if carotenoid = 'lutein' then lt = conc; */
/* run; */

proc sort data=carot5; by fiber level food enzyme rep; run;

proc means noprint data=carot5;
	by fiber level food enzyme rep;
	var ac bc lt;
	output out = carot6 max =;
run;

data carot6; set carot6;
	if ac ne .;
run;

proc sort data= carot2; by fiber level food enzyme; run;

proc transpose data = carot2 out = carot6;
	by fiber level food enzyme;
	var rep1 - rep11;
	id carotenoid;
run;

data carot6; set carot6;
  where ac ~= .;
run;

proc print data = carot6; run;

data carot6; set carot6;
  if food = 'ripe banana' then food = 'Ripe banana';
run;

proc plot data=carot6;
	plot ac*(bc lutein) = food;
	plot bc*lutein = food;
run;

proc chart data = carot6;
	vbar fiber;
run;

proc sort data = carot6; by enzyme; run;

proc means mean min max std n data = carot6;
	by enzyme;
	var ac bc lutein;
run;



	



	


	