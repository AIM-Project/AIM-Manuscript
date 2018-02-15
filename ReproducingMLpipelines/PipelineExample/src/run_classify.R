#!/usr/bin/env Rscript

get_pwd = function() {
    'get the present working directory of the script, to find the files'
    initial.options <- commandArgs(trailingOnly=FALSE)
    file.arg.name <- "--file="
    script.name <- sub(file.arg.name, "", 
                       initial.options[grep(file.arg.name, initial.options)])
    script.basename <- dirname(script.name)
    return(script.basename)
}

# Required functions for PreProcessing Feature Selection
pwd <- get_pwd()
functions <- paste(sep="/", pwd, "Classifier.R")
source(functions)

# The data file is the first input
args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  stop("Please supply an input file with training and test data.", call.=FALSE)
}

tmpfile=args[1]
print('Reading in testing and training from',tmpfile)

Paper1Selection <- readRDS(tmpfile)
rslt = classifier1(Paper1Selection$train_predict, 
                   Paper1Selection$train_response,
                   Paper1Selection$test_predict, 
                   Paper1Selection$test_response)


print(rslt$train)
print(rslt$test)
unlink(tmpfile)
