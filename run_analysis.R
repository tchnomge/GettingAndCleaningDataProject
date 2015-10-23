## Data analysis script for the course project in "Getting and Cleaning Data"
## Due: 10/25/2015
## By:  Stephen Kraig

## process_subset performs the work of loading and normalizing one of the 
## datasets (train or test)...it is passed the base directory, "train" or
## "test" as 'set', the column labels vector and the vector of columns to
## be retained.  There are some complex paste instructions here that build
## the file names and paths based on the set.
process_subset <- function(dir, set, col.labels, col.retain) {
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
	
	return(dataset[col.retain])
} 

## analysis_func controls the flow of the analysis.  It is passed the directory
## containing the unzipped UCI HAR Dataset files and returns a data frame 
## containing a reduced tidy dataset for further analysis.

analysis_func <- function(dir) {
	## First load the features.txt which contains the labels for the
	## data columns in  the X_train/test files.
	cat("...loading column labels...\n")
	features <- read.table(paste(dir,"features.txt",sep="/"))

	## Use a regular expression to limit the retained columns to only
	## the mean and standard deviation observations (per project).
	col.retain <- grep("(mean|std\\(\\))",features[[2]])
	
	## Add activity and subject back to the columns.
	col.retain = c(col.retain, 562, 563)
	
	cat("...loading activity labels...\n")
	activity_labels <- read.table(paste(dir,"activity_labels.txt",sep="/"))

	## Load train data
    cat("...loading train values...\n")
    train  <- process_subset(dir,"train",features[[2]],col.retain)
	
	## Load test data
    cat("...loading test values...\n")
    test  <- process_subset(dir,"test",features[[2]],col.retain)
	
	## Combine the test and training datasets.
	cat("...combining test and train datasets...\n")
	master <- rbind(train, test, make.row.names=F)
	
	## Merge in activity labels and name the new column "activity.label"
	master <- merge(master, activity_labels, by.x = "activity", by.y = "V1", sort = F)
	names(master)[names(master) == "V2"] <- "activity.label"
	
	return(master)
}

## Prompt the user for the correct directory containing the input dataset.
default_dir <- "UCI HAR Dataset"
dir <- readline("Enter Dataset directory [Enter for 'UCI HAR Dataset'] => ")

## Default if the user hits return with no input.
if(dir == "") dir = default_dir

## Call the analysis_func
cat("\nRunning analysis...\n")
output <- analysis_func(dir)

## Display some basic diagnostic output about the returned data frame. 
cat("data reduction complete:\n\n")
cat(paste("Final dataframe is",dim(output)[1],"rows by",dim(output)[2],"columns."))
cat("=============================\n")

## Prompt for output filename.
default_fn <- "output.txt"
fn <- readline("Enter output filename [Enter for 'output.txt'] => ")
if(fn == "") fn = default_fn
write.table(output, fn, row.names = F)
