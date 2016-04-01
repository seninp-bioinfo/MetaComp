#' @useDynLib MetaComp
#' @importFrom data.table fread
NULL

#' Efficiently loads the GOTTCHA (or other EDGE taxonomic assignment) table from a file.
#' The assumption has been made -- since EDGE tables are generated in automated fashion,
#' they should be properly formatted, so code doesn't check for any inconsistencies.
#' It checks for the input file existence however and throws an error if can't find it.
#'
#' This implementation fully relies on the read.table function from data.table package.
#'
#' @param filepath The EDGE-generated tab-delimeted taxonomy assignment file.
#'
#' @return the data frame corresponding to the EDGE's taxonomic assignment file.
#'
#' @examples
#' DF_GOTTCHA_STRAIN <- load_assignment( "tests/test_data/248/allReads-gottcha-strDB-b.list.txt" )
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
