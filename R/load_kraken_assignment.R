#' @importFrom data.table fread
#' @importFrom scales rescale
NULL

#' Efficiently loads a EDGE-produced Kraken taxonomic assignment from a file.
#' An assumption has been made -- since Kraken/EDGE tables are generated in an automated fashion,
#' they should be properly formatted -- thus the code doesn't check for any inconsistencies except
#' for the very file existence. Note however, the unassigned to taxa entries are removed.
#' This implementation fully relies on the read.table function from data.table package
#' gaining performance over traditional R techniques.
#'
#' @param filepath A path to EDGE-generated tab-delimeted Kraken taxonomy assignment file.
#'
#' @return a data frame representing the read table.
#'
#' @export
load_kraken_assignment <- function(filepath) {

  # check for the file existence
  #
  if ( !file.exists(filepath) ) {
    stop(paste("Specified file \"", filepath, "\" doesn't exist!"))
  }

  # read the file
  #
  df <- data.table::fread(filepath, sep = "\t", header = T)

  # remove empty (non-assigned) lines
  #
  df <- df[df$LEVEL != "", ]

  # add a normilized rollup
  #
  df$NORM_ROLLUP <- scales::rescale(df$ROLLUP)

  # return results, "as a data frame" to avoid any confusion
  #
  as.data.frame(df)

}
