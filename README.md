# Course Project
## For Getting and Cleaning Data course offered on Coursera by John Hopkins University
## Submitted by Stephen Kraig

This project consists of a data analysis performed on data previously published as the 
Human Activity Recognition Using Smartphones Dataset

by:  
+ Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
+ Smartlab - Non Linear Complex Systems Laboratory
+ DITEN - Università degli Studi di Genova.
+ Via Opera Pia 11A, I-16145, Genoa, Italy.
+ activityrecognition@smartlab.ws
+ www.smartlab.ws

Note that this repository does NOT contain the "raw" source dataset, only the analysis product and
the script written to perform the analysis.

###Repository Contents
+ README.md : This file.
+ output.txt : File containing the "tidy dataset" produced by the analysis script.
+ CodeBook.md : Descriptive file of the variables in output.txt
+ run_analysis.R : R language script that, given the published dataset as input, produces the included output.

###Running the analysis script
To run the analysis, you must first obtain the raw source dataset, available from  
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
The default path to the data directory is in the same directory as the checked out
repository containing the above files, though this can be overriden when running the script
(you will be prompted, with the default being "../UCI HAR Dataset").  Simply run
"source(run_analysis.R)" at the R prompt with the working directory set to the repository
directory.  After answering the prompt for the data source directory, the script will
generate first a master dataset in memory, then aggregate the set into the tidy set.
You will then be prompted for the output filename (defaulting to output.txt).