
#' @importFrom data.table fread
#' @importFrom dplyr select
NULL

#' Efficiently loads a GOTTCHA (or other EDGE-like taxonomic assignment) table from a file.
#' An assumption has been made -- since GOTTCHA/EDGE tables are generated in an automated fashion,
#' they should be properly formatted -- thus the code doesn't check for any inconsistencies except
#' for the very file existence. This implementation fully relies on the read.table function
#' from data.table package gaining performance over traditional R techniques.
#'
#' @param filepath A path to EDGE-generated tab-delimeted GOTTCHA taxonomy assignment file.
#'
#' @return a data frame containing four columns: TAXA, LEVEL, COUNT, and ABUNDANCE, representing
#'         taxonomically anchored sequences from the sample.
#'
#' @export
load_gottcha_assignment <- function(filepath) {

  TAXA <- LEVEL <- COUNT <- ABUNDANCE <- NULL

  # check for the file existence
  #
  if ( !file.exists(filepath) ) {
    stop(paste("Specified file \"", filepath, "\" doesn't exist!", sep = ""))
  }

  # if file is empty, return an empty table
  #
  file_info <- file.info(filepath)
  if ( 0 == file_info$size ) {
    data.frame( LEVEL = character(), TAXA = character(), COUNT = integer(), ABUNDANCE = double())
  } else {

    # read the file
    #
    df <- data.table::fread(filepath, sep = "\t", header = T)

    # remove empty (non-assigned) lines
    #
    df <- df[df$LEVEL != "", ]

    # rename the abundance column
    #
    names(df) <- sub("READ_COUNT", "COUNT", names(df))
    names(df) <- sub("NORM_COV", "ABUNDANCE", names(df))


    # return results, "as a data frame" to avoid any confusion...
    #
    as.data.frame( dplyr::select(df, LEVEL, TAXA, COUNT, ABUNDANCE))
  }

}
