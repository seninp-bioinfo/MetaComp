#' @importFrom data.table fread
#' @importFrom plyr ddply
NULL

#' Efficiently loads a EDGE-produced BWA taxonomic assignment from a file.
#' An assumption has been made -- since bwa/EDGE tables are generated in an automated fashion,
#' they should be properly formatted -- thus the code doesn't check for any inconsistencies except
#' for the very file existence. Note however, the unassigned to taxa entries are removed.
#' This implementation fully relies on the read.table function from data.table package
#' gaining performance over traditional R techniques.
#'
#' @param filepath A path to EDGE-generated tab-delimeted bwa taxonomy assignment file.
#'
#' @return a data frame representing the read table.
#'
#' @export
load_bwa_assignment <- function(filepath) {

  levels <- NULL
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

  # normalize ...
  #
  levels <- ddply(df, "LEVEL", function(x) { sum(x$ROLLUP) })
  names(levels) <- c("LEVEL", "SUM")

  df <- merge(df, levels)

  df$NORM_ROLLUP <- df$ROLLUP / df$SUM * 100

  # return results, "as a data frame" to avoid any confusion
  #
  as.data.frame(df)

}
