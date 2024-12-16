/* Create a library for this class */
libname ProData '~/Project';


/* Final Project: Hypothesis Testing
   Hypothesis: Average body temperature is 98.6 degrees Fahrenheit. */
  
  
proc IMPORT 
	datafile='/home/u63749594/Tempdata.csv'
	out=ProData.TempData
	dbms=CSV
	replace;
	getnames=YES;
RUN;


/* simple statistics */
* mean, std, median, up/low quantile, IQR;
proc means data=ProData.TempData mean median std min max Q1 Q3 QRANGE maxdec=3;
  class Gender;
  var BodyTemp HeartRate;
  title "Simple Descriptive Stats for TempData";
run;


* Calculates simple descriptive statistics for categorical data;
proc freq data=ProData.TempData;
  tables Gender BodyTemp HeartRate/ nocum;
run;


/* Plot BodyTemp against HeartRate */
* Scatter plot;
symbol1 v=circle color=red;
symbol2 v=triangle color=black;
proc gplot data=ProData.TempData;
  title "Scatter Plot using PROC GPLOT of BodyTemp by HeartRate";
  plot BodyTemp*HeartRate=Gender; *Plot statement represents the variable before asterisk on the y-axis;
run;

 
* Generate barchart;
proc gchart data=ProData.TempData;
  title "Bar Chart for BodyTemp";
  VBAR BodyTemp;
run;
proc gchart data=ProData.TempData;
  title "Bar Chart for HeartRate";
  VBAR HeartRate;
run;


* Box plot on BodyTemp for Male & Female;
PROC BOXPLOT DATA = ProData.TempData;
	TITLE "Distribution of Body Temperature by Gender";
	PLOT BodyTemp*Gender;	
RUN;



/* Correlation function */
proc corr data=ProData.TempData;
	var BodyTemp HeartRate;
run;



/* Simple Linear Regression to find normality */
proc reg data=ProData.TempData;
	model BodyTemp = HeartRate;
	title "Example of SLR using Proc REG";
run;
quit;


symbol V=star I=RL;
proc gplot data=ProData.TempData;
	plot BodyTemp*HeartRate;
run;
	











/* Elle */
/* Get file info */
PROC CONTENTS DATA = ProData.TempData;
RUN;

/* Confidence Interval of the Mean - default is 95% confidence interval */
TITLE 'Analysis of Body Temperature';
ODS SELECT BasicIntervals;
PROC UNIVARIATE DATA = ProData.TempData CIBASIC;
   VAR BodyTemp;
RUN;

/* Conclusion: 
- The 95% confidence interval is 98.12 to 98.38 degrees Fahrenheit.
- We are 95% confident that the true mean body temperature for the population is between 98.12 and 98.38 degrees. */

/* One-Sample t-Test */
ODS GRAPHICS ON;
PROC TTEST H0 = 98.6 PLOTS(SHOWH0);
	VAR BodyTemp;
RUN;
ODS GRAPHICS OFF;

/* Conclusion:
- The t statistic is -5.45 and the corresponding p-value is < .0001
- Hence, we reject the null hypothesis since the p-value is less than the default alpha level of .05.
- Meaning: Average body temperature is indeed 98.6 degrees Fahrenheit.

/* Produce more distributions and descriptive statistics */
PROC UNIVARIATE DATA = ProData.TempData NORMAL MU0 = 98.6;
	VAR BodyTemp HeartRate;
	HISTOGRAM;
	PROBPLOT;
RUN;




/* Chiq test & ANOVA for heartRate on three specific BodyTemp */

/* ANOVA */
data freqtemp;
INPUT @1 BodyTemp 4.  @6 HeartRate 2.;
CARDS;
98   78
98   71
98   74
98   67
98   64
98   78
98   76
98   87
98   78
98   73
98   89
98.2 73
98.2 64
98.2 65
98.2 73
98.2 69
98.2 57
98.2 66
98.2 64
98.2 71
98.2 72
98.4 79
98.4 81
98.4 73
98.4 74
98.4 84
98.4 68
98.4 70
98.4 82
98.4 84
98.6 77
98.6 78
98.6 83
98.6 66
98.6 70
98.6 82
98.6 82
98.6 85
98.6 86
98.6 77
98.8 64
98.8 70
98.8 83
98.8 89
98.8 69
98.8 73
98.8 84
98.8 78
98.8 81
98.8 78 
;

PROC ANOVA DATA=freqtemp;
	CLASS BodyTemp;
	MODEL HeartRate=BodyTemp;
	MEANS BodyTemp/TUKEY; 
	* use CLDIFF to make comparisons significant at the 0.05 level are indicated by ***;
	TITLE 'COMPARE HeartRate ACROSS BodyTemp - ANOVA EXAMPLE';
RUN; 
QUIT;













