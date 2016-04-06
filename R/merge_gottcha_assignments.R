#' @importFrom dplyr select
NULL

#' Merges two GOTTCHA-like taxonomical assignments. The input data frames are assumed to have the
#' following columns: LEVEL, TAXA, and NORM_COV -- these will be used in the merge procedure.
#'
#' @param assignment1 The gottcha-like assignment table.
#' @param assignment2 The gottcha-like assignment table.
#'
#' @return a merged table.
#'
#' @export
merge_gottcha_assignments <- function(assignment1, assignment2) {

  # fix CRAN notes
  #
  LEVEL = TAXA = NORM_COV = NULL # fix the CRAN note

  # extract only rows wich correspond to the desired taxonomy level
  #
  sub_table1 <- dplyr::select(assignment1, LEVEL, TAXA, NORM_COV)
  sub_table2 <- dplyr::select(assignment2, LEVEL, TAXA, NORM_COV)

  dm <- merge(sub_table1, sub_table2, by = c("LEVEL", "TAXA"), all = T)

  dm[is.na(dm)] <- 0

  dm
}
