#' @importFrom phyloseq plot_richness
#' @importFrom cowplot plot_grid
#' @importFrom cowplot save_plot
#'

NULL

#' Alpha diversity
#'
#' A plot object with alpha diversity plots
#'
#'
#' @param pseq_class phyloseq class
#'
#' @return A cowplot object
#'
#' @export
#'
#'

summary_alpha_div <- function(pseq_class){

  plots <- phyloseq::plot_richness(pseq_class, measures = c("Shannon"))

  final_plot <- cowplot::plot_grid(plots, labels = paste(LETTERS, ".", SEP = ""))
  return(final_plot)
}