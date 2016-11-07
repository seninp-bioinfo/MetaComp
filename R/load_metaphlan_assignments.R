#' @importFrom data.table fread
NULL

#' Efficiently loads a METAPHLAN (or other EDGE-like taxonomic assignment) tables from a list
#' of files. Outputs a named list of assignments.
#'
#' @param filepath A path to tab delimeted, two-column file whose first column is a project_id
#' (which will be used to name this assignment) and the second column is the assignment filename.
#'
#' @return a list of all read assignments.
#'
#' @export
load_metaphlan_assignments <- function(filepath) {

  # check for the file existence
  #
  if ( !file.exists(filepath) ) {
    stop(paste("Specified file \"", filepath, "\" doesn't exist!", sep = ""))
  }

  # read the file
  #
  df <- data.table::fread(filepath, header = F)

  # read files
  #
  input_assignments_list <- list(MetaComp::load_metaphlan_assignment(df[1, ]$V2))
  if (dim(df)[1] > 1) {
    for (i in 2:(dim(df)[1])) {
      input_assignments_list <- c(input_assignments_list,
                                     list(MetaComp::load_metaphlan_assignment(df[i, ]$V2)))
    }
  }


  # name the list
  #
  names(input_assignments_list) <- df$V1

  input_assignments_list

}
