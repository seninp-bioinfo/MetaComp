#' @useDynLib MetaComp
#' @importFrom dplyr filter select
#' @import ggplot2
NULL

#' Merges two columns.
#'
#' This implementation...
#'
#' @param assignment_df The gottcha-like assignment table.
#' @param taxonomy_level The level which need to be plotted.
#'
#' @return the ggplot2 plot.
#' @examples
#' @export
merge_gottcha_columns <- function(assignment1, assignment2, taxonomy_level) {

  LEVEL = TAXA = ROLLUP = NULL # fix the CRAN note

  sub_table1 <- dplyr::select(dplyr::filter(assignment1, LEVEL == taxonomy_level),
                              TAXA, ROLLUP)
  sub_table2 <- dplyr::select(dplyr::filter(assignment2, LEVEL == taxonomy_level),
                              TAXA, ROLLUP)

  dm <- merge(sub_table1, sub_table2, by = c("TAXA"), all = T)

  dm[is.na(dm)] <- 0

  dm
}
