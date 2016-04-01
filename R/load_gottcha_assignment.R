#' @useDynLib MetaComp
#' @importFrom data.table fread
NULL

#' Efficiently loads the GOTTCHA (or other EDGE taxonomic assignment) table from a file.
#'
#' This implementation fully relies on the read.table function from data.table package.
#'
#' @param filepath The tab-delimeted taxonomy assignment file
#'
#' @return the data frame corresponding to the EDGE taxonomic assignment file.
#'
#' @examples
#' DF_BWA <- load_assignment( "inst/test_data/allReads-bwa.list.txt" )
#' @export
load_gottcha_assignment <- function(filepath) {

  # check for the file existence
  #
  if ( !file.exists(filepath) ) {
    stop(paste("Specified file \"", filepath, "\" doesn't exist!"))
  }

  # read the file
  #
  df <- data.table::fread(filepath)

  # return results
  #
  df

}
