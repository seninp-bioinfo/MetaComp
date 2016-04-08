#' @importFrom dplyr select
NULL

#' Merges two GOTTCHA-like taxonomical assignments. The input data frames are assumed to have the
#' following columns: LEVEL, TAXA, and NORM_COV -- these will be used in the merge procedure.
#'
#' @param assignments A named list of assignments(name is the project ID which be used as a column name).
#'
#' @return a merged table.
#'
#' @export
merge_gottcha_assignments <- function(assignments) {

  # fix CRAN notes
  #
  LEVEL = TAXA = NORM_COV = NULL # fix the CRAN note

  # extract only rows wich correspond to the desired taxonomy level
  #
  res <- dplyr::select(assignments[[1]], LEVEL, TAXA, NORM_COV)
  names(res) <- c(names(res)[1:2], names(assignments)[1])
  #
  for (i in 2:length(assignments)) {
    res  <- merge(res, dplyr::select(assignments[[i]], LEVEL, TAXA, NORM_COV),
                  by = c("LEVEL", "TAXA"), all = T)
    names(res) <- c(names(res)[1:(length(names(res)) - 1)], names(assignments)[i])
  }

  res[is.na(res)] <- 0

  res
}
