#' @useDynLib MetaComp
NULL

#' Efficiently loads the table from a file.
#'
#' This is implementation relies on the read.table function from data.table package.
#'
#' @param filepath The tab-delimeted taxonomy assignment file
#'
#' @return the data frame corresponding to the read assignment file.
#'
#' @examples
#' DF_BWA <- load_assignment( "inst/test_data/allReads-bwa.list.txt" )
#' @export
load_assignment <- function(filepath) {

  print(paste("loading", filepath))

  DF <- read.table(filepath, header = TRUE, sep = "\t", quote = "",
                    stringsAsFactors = FALSE, comment.char = ""
                   #, nrows=n,
                   # colClasses=c("integer","integer","numeric",
                   #              "character","numeric","integer")
                  )
  DF
}
