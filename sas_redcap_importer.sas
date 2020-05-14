/* ================================================================================
    Title: REDCap@Yale API Data Importer
    Version: 1.0
    Last Modified: 05/14/2020
    Author: Sumon Chattopadhyay
================================================================================ */

/*
Adapted from reference:
Sarah Worley, Dongsheng Yang,
SASEEE and REDCap API: Efficient and Reproducible Data Import and Export,
MWSUG-2013-RX02  (https://www.mwsug.org/proceedings/2013/RX/MWSUG-2013-RX02.pdf)

This program leverages the REDCap API to import data from the flat REDCap database
into a CSV file that can be used by other SAS programs to create reports.
*/


/* Step 1. Define file names and macro variable for the project-specific token. */

*** Text file for API parameters that define the request sent to REDCap API will be created in a DATA step ***;
filename my_in "your-directory\api_parameter.txt";

*** .CSV output file for the exported data ***;
filename my_out "your-directory\redcap_data.csv";

*** Output file of PROC HTTP status information returned from REDCap API (this is optional) ***;
filename status "your-directory\redcap_status.txt";
*** Project- and user-specific token obtained from REDCap ***;
%let mytoken = ######; /*replace this with your token*/

/* Step 2. Request observations (CONTENT=RECORDS) with one row per record (TYPE=FLAT). */

*** Only request specific variables of interest in order to keep table clean ***;
*** Create the text file to hold the API parameters. ***;

data _null_ ;
	file my_in ;
	put "%NRStr(token=)&mytoken%NRStr(&content=record&type=flat&format=csv)&";
run;

*** PROC HTTP call. Everything except HEADEROUT= is required. ***;

proc http
   in= my_in
   out= my_out
   headerout = status
   url ="https://poa-redcap.med.yale.edu/api/" /*this can be modified to accomodate other servers/instances*/
   method="post";
run;

/* Step 2.5. Clean up .CSV file to remove CR LF that creates phantom records.
   THe following code was adapted from here: http://support.sas.com/kb/26/065.html */

/************************** CAUTION ***************************/
/*                                                            */
/* This program UPDATES IN PLACE, create a backup copy before */
/* running.                                                   */
/*                                                            */
/************************** CAUTION ***************************/

/* Replace carriage return and linefeed characters inside     */
/* double quotes with a specified character.  This sample     */
/* uses '@' and '$', but any character can be used, including */
/* spaces.  CR/LFs not in double quotes will not be replaced. */


%let repA='@';                    /* replacement character LF */
%let repD='$';                    /* replacement character CR */


%let dsnnme=my_out;      /* use full path of CSV file */

data _null_;
  /* RECFM=N reads the file in binary format. The file consists    */
  /* of a stream of bytes with no record boundaries.  SHAREBUFFERS */
  /* specifies that the FILE statement and the INFILE statement    */
  /* share the same buffer.                                        */
  infile &dsnnme recfm=n sharebuffers;
  file &dsnnme recfm=n;

  /* OPEN is a flag variable used to determine if the CR/LF is within */
  /* double quotes or not.  Retain this value.                        */
  retain open 0;

  input a $char1.;
  /* If the character is a double quote, set OPEN to its opposite value. */
  if a = '"' then open = ^(open);

  /* If the CR or LF is after an open double quote, replace the byte with */
  /* the appropriate value.                                               */
  if open then do;
    if a = '0D'x then put &repD;
    else if a = '0A'x then put &repA;
  end;
run;


/* Step 3. Read modified .CSV data file into SAS and save it.
Uses project-specific SAS code generated through the REDCap Data Export Tool
with a modification (shown below) to the first DATA step in the program to work with the REDCap API data. */

*** Code copied from the REDCap-generated SAS program (this is optional, may use PROC IMPORT or a DATA step) ***;
*** Change INFILE name to data named in PROC HTTP OUT =, in this case my_out ***;
*** Change FIRSTOBS=1 to FIRSTOBS=2 to indicate that a header row exists ***;
*** Id desired, comment out or delete proc contents and run statement in middle of importer to prevent table being printed. ***;

/* Sample REDCap-generated SAS program */
/* Remove and replace this with your own program */
%macro removeOldFile(bye); %if %sysfunc(exist(&bye.)) %then %do; proc delete data=&bye.; run; %end; %mend removeOldFile; %removeOldFile(work.redcap); data REDCAP; %let _EFIERR_ = 0;
infile my_out delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ; 
	informat ... ;
	======================================;
	Code continues;
	======================================;
	format ...;
	run;
/* Data import step using REDCap API ends here */

/* Create datasets for other programs to access */
libname export "Datasets";
data export.redcap;
	set redcap;
run;
