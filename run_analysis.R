## Data analysis script for the course project in "Getting and Cleaning Data"
## Due: 10/25/2015
## By:  Stephen Kraig

## process_subset performs the work of loading and normalizing one of the 
## datasets (train or test)...it is passed the base directory, "train" or
## "test" as 'set', and the column labels vector.  There are some complex paste 
## instructions here that build the file names and paths based on the set.

library(plyr)

process.subset <- function(dir, set, col.labels) {
	xfn = paste(dir,set,paste("X_",set,".txt",sep=""),sep="/")
	cat(paste("...loading X values from:",xfn,"\n"))
	dataset <- read.table(xfn, col.names=col.labels)

	yfn = paste(paste(dir,set,paste("y_",set,".txt",sep=""),sep="/"))
    cat(paste("...loading Y values from:",yfn,"\n"))
	y <- read.table(yfn)
	dataset$activity <- y[[1]]

	sfn = paste(paste(dir,set,paste("subject_",set,".txt",sep=""),sep="/"))
	cat(paste("...loading subject values from:",sfn,"\n"))
	s <- read.table(sfn)
	dataset$subject <- s[[1]]
	
	## Use a regular expression to limit the retained columns to only
	## the mean and standard deviation observations (per project).
	col.retain <- grep("(mean|std|activity|subject)",colnames(dataset))
	
	return(dataset[col.retain])
} 

## build.master loads the master combined dataset.  It is passed the directory
## containing the unzipped UCI HAR Dataset files.
build.master <- function(dir) {
	## First load the features.txt which contains the labels for the
	## data columns in  the X_train/test files.
	cat("...loading column labels...\n")
	features <- read.table(paste(dir,"features.txt",sep="/"))
	
	cat("...loading activity labels...\n")
	activity_labels <- read.table(paste(dir,"activity_labels.txt",sep="/"))

	## Load train data
    cat("...loading train values...\n")
    train  <- process.subset(dir,"train",features[[2]])
	#print(str(train))
	
	## Load test data
    cat("...loading test values...\n")
    test  <- process.subset(dir,"test",features[[2]])
	#print(str(test))
	
	## Combine the test and training datasets.
	cat("...combining test and train datasets...\n")
	master <- rbind(train, test, make.row.names=F)
	
	## Merge in activity labels and name the new column "activity.label"
	master <- merge(master, activity_labels, by.x = "activity", by.y = "V1", sort = F)
	names(master)[names(master) == "V2"] <- "activity.label"
	
	return(master)
}

## Build a tidy subset of the data based on the assignment.  This calculates the
## mean values for each  variable, grouped by subject then activity.
tidy.set <- function(master) {
	## Get a list of the observed variables in the master dataframe.
	obs <- grep("(mean|std)",colnames(master))

	## Group by the subject and activity.label, applying the mean to the observations
	cat("...generating summary data frame...\n")
	output <- aggregate(master[obs]
	                   ,list(subject=master$subject,activity=master$activity.label)
					   ,mean)
	
	cat("...sorting by subject, then activity...\n")
	output <- arrange(output, subject, activity)
	
	return(output)
}

## Prompt the user for the correct directory containing the input dataset.
default_dir <- "../UCI HAR Dataset"
dir <- readline("Enter Dataset directory [Enter for '../UCI HAR Dataset'] => ")
## Default if the user hits return with no input.
if(dir == "") dir = default_dir

cat("\nBuilding the Master Dataset...\n")
master <- build.master(dir)

cat("\n\nBuilding the tidy subset...\n")
output <- tidy.set(master)

## Display some basic diagnostic output about the returned data frame. 
cat("data reduction complete:\n\n")
cat(paste("Final dataframe is",dim(output)[1],"rows by",dim(output)[2],"columns."))
cat("=============================\n")

## Prompt for output filename.
default_fn <- "output.txt"
fn <- readline("Enter output filename [Enter for 'output.txt'] => ")
if(fn == "") fn = default_fn
write.table(output, fn, row.names = F)
