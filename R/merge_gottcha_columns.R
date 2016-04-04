#' @importFrom dplyr select
NULL

#' Merges two EDGE's taxonomical assignments. The input data frames are assumed to have the
#' LEVEL column first, TAXA column second, following by a single column of abundance values.
#' Outputs a table whose first two columns, LEVEL and TAXA, contain a union of these
#' from both tables and whose second and third column contain the given abundances.
#'
#' @param assignment1 The gottcha-like, three-column assignment table.
#' @param assignment2 The gottcha-like, three-column assignment table.
#'
#' @return a merged table.
#'
#' @export
merge_gottcha_columns <- function(assignment1, assignment2) {

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
