#' @useDynLib MetaComp
#' @importFrom dplyr filter select
#' @importFrom ggplot2
NULL

#' Generates a single column ggplot for a taxonomic assignment table.
#'
#' This implementation...
#'
#' @param assignment_df The gottcha-like assignment table.
#' @param taxonomy_level The level which need to be plotted.
#'
#' @return the ggplot2 plot.
#' @examples
#' @export
plot_gottcha_columns <- function(assignment, taxonomy_level) {

  # the assumption is that we already have formatted table where the first column is
  # the name of species, or strandes, etc... and following columns are the ones to be plotted
  #
  #
  # need to scale the data up, column-by-column
  df <- data.frame(TAXA = assignment$TAXA)
  #
  for (j in c(2:ncol(assignment)) ) {
    df <- cbind(df, assignment[,j] * 100)
  }

  names(df) <- names(assignment)

  melted_df <- melt(df, id.vars = c("TAXA"))

  p <- ggplot2::ggplot( data = melted_df, ggplot2::aes(y = TAXA, x = variable, fill = value) ) +
       ggplot2::theme_bw() + ggplot2::geom_tile() + ggplot2::ggtitle("Single column test") +
       ggplot2::scale_x_discrete(expand = c(0, 0)) + ggplot2::scale_y_discrete(expand = c(0, 0)) +
       ggplot2::coord_fixed(ratio = 1) +
       ggplot2::scale_fill_gradientn(name = "Normalized abundance: ",
              limits = c(0.1, 100), trans = "log", colours =
               c("darkblue", "blue", "lightblue", "cyan2", "green", "yellow", "orange",
                         "darkorange1", "red", bias = 10),
              breaks = c(0.1, 1, 10, 100),
              labels = expression(10^-1, 10^0, 10^1, 10^2),
              guide = ggplot2::guide_colorbar(title.theme =
                                                ggplot2::element_text(size = 16, angle = 0),
              title.vjust = 0.9, barheight = 0.6, barwidth = 6,
              label.theme = ggplot2::element_text(size = 12, angle = 0),
              label.hjust = 0.2)) +
       ggplot2::theme(legend.position = "bottom", plot.title = ggplot2::element_text(size = 18),
            axis.title.x = ggplot2::element_blank(), axis.title.y = ggplot2::element_blank(),
            axis.text.x = ggplot2::element_text(size = 18),
            panel.grid.major.y = ggplot2::element_blank(),
            panel.grid.minor.y = ggplot2::element_blank(),
            axis.ticks.y = ggplot2::element_blank(),
            axis.text.y = ggplot2::element_text(size = 14))

     p
}
