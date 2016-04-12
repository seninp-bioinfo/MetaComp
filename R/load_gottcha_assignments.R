#' @importFrom data.table fread
#' @importFrom plyr dlply
NULL

#' Efficiently loads a GOTTCHA (or other EDGE-like taxonomic assignment) tables from a list
#' of files. Outputs a named list of assignments.
#'
#' @param filepath A path to tab delimeted, two-column file whose first column is a project_id
#' (which will be used to name this assignment) and the second column is the assignment filename.
#'
#' @return a list of all read assignments.
#'
#' @export
load_gottcha_assignments <- function(filepath) {

  V1 <- NULL

  # check for the file existence
  #
  if ( !file.exists(filepath) ) {
    stop(paste("Specified file \"", filepath, "\" doesn't exist!"))
  }

  # read the file
  #
  df <- data.table::fread(filepath, sep = "\t", header = F)

  # read files
  #
  input_assignments_list <- plyr::dlply(df, plyr::.(V1), function(x) {
    MetaComp::load_gottcha_assignment(x$V2)
  })

  # name the list
  #
  names(input_assignments_list) <- df$V1

  input_assignments_list

}
