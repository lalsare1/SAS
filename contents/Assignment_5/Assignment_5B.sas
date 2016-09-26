proc chart data = carot7;
title 'Mean Lutein Percent Micellization by Fiber and Level';
block fiber / group= level sumvar=lutein type=mean;
run;