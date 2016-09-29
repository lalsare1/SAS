

proc import out = blanched file = 'e:\STAT 6740\Study 3 VOC.xlsx' dbms = xlsx; sheet = "Blanched"; run;
proc import out = green_raw file = 'e:\STAT 6740\Study 3 VOC.xlsx' dbms = xlsx; sheet = "Green Raw"; run;
proc import out = raw_sn file = 'e:\STAT 6740\Study 3 VOC.xlsx' dbms = xlsx; sheet = "Raw SnCl2"; run;
proc import out = pureed file = 'e:\STAT 6740\Study 3 VOC.xlsx' dbms = xlsx; sheet = "Pureed"; run;


data allraw; set green_raw raw_sn; run;

proc print data=allraw; 
  where compound = 'ethanol';
run;

data green_raw2; set green_raw;
  type = 'Green Raw';
run;

data raw_sn2; set raw_sn;
  type = 'Raw SnCl2';
run;

data allraw2; set green_raw2 raw_sn2; run;

proc print data=allraw2;
  where compound = 'ethanol';
run;

proc append data=raw_sn2 base=green_raw2; run;

proc print data=green_raw2; 
  where compound = 'ethanol';
run;
