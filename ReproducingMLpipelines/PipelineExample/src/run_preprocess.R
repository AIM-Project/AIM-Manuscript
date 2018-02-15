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

pwd <- get_pwd()
setwd(pwd)


########################################
# Parse input arguments
########################################

args = commandArgs(trailingOnly=TRUE)

outputfile = tempfile(pattern = "PPFS_data", 
                      tmpdir = '/tmp',
                      fileext = ".rda")

# run_classify.R <input> [output]

if (length(args)==0) {

     # Provided nothing
     inputfile = "../GolubData.rda"

} else if (length(args)==1){

     # Provided data input, no output
     inputfile = args[1]

} else {

     # Provided a data input file and output file
     inputfile=args[1]
     outputfile=args[2]

}

# Load data and required functions
load(inputfile)
set.seed(2017)

source('PPFS.R')

Paper1Selection = PPFS1(golub_train_predict, 
                        golub_train_response,
                        golub_test_predict,
                        golub_test_response)

# Save to temporary file, to pass on
saveRDS(Paper1Selection, outputfile) 
cat(outputfile)
