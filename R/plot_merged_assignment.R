#' @importFrom reshape2 melt
NULL

#' Generates a single column ggplot for a taxonomic assignment table.
#'
#' This implementation...
#'
#' @param assignment The gottcha-like merged assignment table.
#' @param taxonomy_level The level which need to be plotted.
#' @param label The label to put for the plotted column.
#' @param filename The PNG file name.
#'
#' @return the ggplot2 plot.
#'
#' @export
plot_merged_assignment <- function(assignment, taxonomy_level, label, filename) {

  assignment = dat
  taxonomy_level = "strain"
  label = "gottcha test"
  filename = "sandbox/test.png"

  TAXA = LEVEL = NORM_COV = dat = value = variable = NULL # fix the CRAN note

  # filter only the requested level
  df <- dplyr::filter(assignment, LEVEL == taxonomy_level)

  # select needed columns
  df <- dplyr::select(df, TAXA, NORM_COV)

  # scale the values
  df$NORM_COV = df$NORM_COV * 100

  melted_df <- reshape2::melt(df, id.vars = c("TAXA"))

  melted_df <- dplyr::arrange(melted_df, dplyr::desc(value))

  melted_df$TAXA = factor(x = melted_df$TAXA, levels = melted_df$TAXA, ordered = T)

  levels <- levels(melted_df$TAXA)

  str(melted_df)

  p <- ggplot2::ggplot( data = melted_df, ggplot2::aes(y = TAXA, x = variable, fill = value) ) +
       ggplot2::geom_tile(color = "grey", size = 0.3) +
       ggplot2::ggtitle("Single column test") +
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

     #p

     Cairo::Cairo(width = 600, height = 800, pointsize = 11,
                  file = filename, type = "png", res = 96,
                  bg = "white", canvas = "white")
     print(p)
     dev.off()

}
