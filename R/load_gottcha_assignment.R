#' @importFrom data.table fread
NULL

#' Efficiently loads a GOTTCHA (or other EDGE-like taxonomic assignment) table from a file.
#' An assumption has been made -- since GOTTCHA/EDGE tables are generated in an automated fashion,
#' they should be properly formatted -- so the code doesn't check for any inconsistencies except
#' for the very file existence. This implementation fully relies on the read.table function
#' from data.table package gaining performance over traditional R techniques.
#'
#' @param filepath A path to EDGE-generated tab-delimeted GOTTCHA taxonomy assignment file.
#'
#' @return a data frame representing the read table.
#'
#' @export
load_gottcha_assignment <- function(filepath) {

  # check for the file existence
  #
  if ( !file.exists(filepath) ) {
    stop(paste("Specified file \"", filepath, "\" doesn't exist!"))
  }

  # read the file
  #
  df <- data.table::fread(filepath, sep = "\t", header = T)

  # return results, "as a data frame" to avoid any confusion
  #
  as.data.frame(df)

}
