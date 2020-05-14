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
2. Copy your API token into the required location for this SAS program.
3. Download the SAS code from the REDCap web application and paste into the SAS program, replacing the existing template.
4. Make the required modifications.

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

