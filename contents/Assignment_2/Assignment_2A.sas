filename a1 "/folders/myfolders/Assignment_1/aaup_dat.txt";
*Create a data set Salary and import external data;
data salary;
  infile a1;
  input fice 1 - 5 name $ 7 - 37 state $ 38 - 39 type $ 40 - 43 sal_full 44 - 48 Sal_assc 49 - 52 sal_asst 53 - 56 sal_all 57 - 60
		comp_full 61 - 65 comp_assc 66 - 69 comp_asst 70 - 73 comp_all 74 - 78 / num_full 1 - 4 num_assc 5 - 8 num_asst 9 - 12 num_inst 13 - 16 num_all 17 - 21;
run;

data naber; set salary;
  if state in ('CT', 'ME', 'MA', 'NH', 'RI', 'VT') then region = 'I   ';
  else if state in ('NJ', 'NY', 'PR') then region = 'II  ';
  else if state in ('DE', 'DC', 'MD', 'PA', 'VA', 'WV') then region = 'III ';
  else if state in ('IL', 'IN', 'MI', 'MN', 'OH', 'WI') then region = 'V   ';
  else if state in ('AR', 'LA', 'NM', 'OK', 'TX') then region = 'VI  ';
  else if state in ('IA', 'KS', 'MO', 'NE') then region = 'VII ';
  else if state in ('CO', 'MN', 'ND', 'SD', 'UT', 'WY') then region = 'VIII';
  else if state in ('CA', 'AZ', 'HI', 'NV') then region = 'IX  ';
  else if state in ('AK', 'ID', 'OR', 'WA') then region = 'X   ';
  else region = 'IV  ';
run;

* Step 2;

proc import datafile = "/folders/myfolders/contents/usnews.csv"
  out = usnews dbms = csv replace;
run;

data usnews; set usnews;
  name2 = name;
  drop name;
run;

proc sort data=naber; by fice; run;
proc sort data=usnews; by fice; run;

data salenroll;
  merge naber usnews;
  by fice;

  if name = '' then name = name2;
run;

* Step 3;

data salenroll; set salenroll;
  if index(name,'University') > 0 | index(name,'Univ') > 0 | index(name,'U.') > 0 or index(name,'U-') or index(name,'SUNY') > 0 then inst_type = 'U';
  else if index(name,'Coll') > 0 then inst_type = 'C';
  else inst_type = 'N';
run;

proc print data=salenroll;
  where inst_type = 'N';
run;

data salenroll2; set salenroll;
  pct_accept = 100*num_acc/num_app;
  pct_en_acc = 100*num_enr/num_acc;
  cost_diff = books+fees+Instate_Tu+Room_board-Exp_per_stud;
run;

data pub_I pub_IIA pub_IIb priv_I priv_IIA priv_IIB; set salenroll2;
	if pub_priv = 1 then do;
    if type = 'I' then output pub_I;
	else if type = 'IIA' then output pub_IIA;
	else output pub_IIB;
  end;
  else do;
  if type = 'I' then output priv_I;
  else if type = 'IIA' then output priv_IIA;
  else output priv_IIB;
  end;
run;

proc contents data=pub_iia; run;

proc print data = salenroll2;
where pub_priv = 2 and type = 'IIA';
var region state name Num_FT_und num_all pct_accept pct_en_acc cost_diff gradrate;
run;

LIBNAME sd '/folders/myfolders/contents/';
data sd.pub_IIB; set pub_IIB;
keep region state name sal_all num_all num_ft_und sfratio;
run;

proc export data = pub_I outfile = '/folders/myfolders/contents/pub_I.csv' dbms = csv; run;


