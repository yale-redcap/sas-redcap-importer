# SAS Importer for REDCap API Data

This repository documents a SAS code snippet that imports the flat REDCap database into a SAS readable dataset.

One can utilize the built-in export functions within REDCap to create a SAS-readable dataset, but this requires many manual manipulations and does not lend well to automation. Utilizing the API will allow a user to programmatically retrieve data from their REDCap database and use the data in SAS without accessing the REDCap web interface.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- REDCap database
- SAS installed on system
- Your unique API token provided by REDCap (do not share this with anyone!)
- A directory to house all files created by importer

### Installing

1. Download a copy of the enclosed .sas file to the directory where you would like to save the data and resulting SAS datasets. Make sure to modify the filenames and directories within the program to locations of your choosing.
```sas
*** Text file for API parameters that define the request sent to REDCap API will be created in a DATA step ***;
filename my_in "your-directory\api_parameter.txt";

*** .CSV output file for the exported data ***;
filename my_out "your-directory\redcap_data.csv";

*** Output file of PROC HTTP status information returned from REDCap API (this is optional) ***;
filename status "your-directory\redcap_status.txt";
```
2. Copy your API token into the required location for this SAS program.
```sas
*** Project- and user-specific token obtained from REDCap ***;
%let mytoken = ######; /*replace this with your token*/
```
3. Replace the URL with the url for your REDCap instance.
```sas
url ="https://poa-redcap.med.yale.edu/api/" /*this can be modified to accomodate other servers/instances*/
```
4. Download the SAS code from the REDCap web application and paste into the SAS program, replacing the existing template.
```sas
%macro removeOldFile(bye); %if %sysfunc(exist(&bye.)) %then %do; proc delete data=&bye.; run; %end; %mend removeOldFile; %removeOldFile(work.redcap); data REDCAP; %let _EFIERR_ = 0;
infile my_out delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;
	informat ... ;
	======================================;
	Code continues;
	======================================;
	format ...;
	run;
```
5. Make the required modifications to the copied portion of the code.
```sas
*** Change INFILE name to data named in PROC HTTP OUT =, in this case my_out ***;
*** Change FIRSTOBS=1 to FIRSTOBS=2 to indicate that a header row exists ***;
*** Id desired, comment out or delete proc contents and run statement in middle of importer to prevent table being printed. ***;
```

## Built With

* SAS
* REDCap API

## Authors

- Sumon Chattopadhyay - *Initial work* - [REDCap@Yale](https://github.com/yale-redcap)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

This code snippet is adapted from the following publication:

Sarah Worley, Dongsheng Yang,
SAS and REDCap API: Efficient and Reproducible Data Import and Export,
MWSUG-2013-RX02  (https://www.mwsug.org/proceedings/2013/RX/MWSUG-2013-RX02.pdf)
