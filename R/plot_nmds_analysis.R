#' @importFrom vegan metaMDS
#' @importFrom cowplot plot_grid
#' @importFrom ggplot2 element_text
#' @importFrom ggplot2 element_blank
#'

NULL

#' Nonmetric Multidimensional Scaling
#'
#'
#' Creates a cowplot object with annotated nmds plot
#'
#'
#' @param filepath path to merged_table (a tsv file) containing samples as column
#' @param LEVEL A taxonomic level (phylum, class, order, family, species) to create OTU table.
#' @param metadata A tab delimited metadata table with samples as rows and variables/properties as columns, no column header for sample.
#' @param shape_grp header of the metadata to refer for shape type.
#' @param col_grp header of the metadata to refer for color type.
#'
#' @return A cowplot object
#'
#' @export


plot_nmds_analysis <- function(filepath, LEVEL = NULL, metadata, shape_grp, col_grp){

  # check for the file existence
  #
  if ( !file.exists(filepath) ) {
    stop(paste("Specified file \"", filepath, "\" doesn't exist!"))
  }


  # check if the merged file given is of right format
  #
  if ( !all( (c('TAXA', 'LEVEL')  %in% colnames(utils::read.table(filepath, header = T))))) {
    stop(paste("Specified file \"", filepath, "\" is not of right format!"))
  }


  # check if LEVEL was assigned
  #
  if ( is.null(LEVEL) ) {
    stop(paste("Specify taxa LEVEL (phylum, class, order, family, species) !"))
  }

  else{

    # convert the merged table to an otu table
    #
    otuStable <- MetaComp::convert_to_otu_table(filepath, LEVEL)

    # rename/replace " -" with a "."
    #
    base::row.names(otuStable) <- base::gsub("[ -]", ".", row.names(otuStable))

    # transform otuStable to have sample as rows
    TotuStable <- t(otuStable)

    # calculate and extract nmds scores
    #
    data.scores <- vegan::metaMDS(TotuStable)
    data.scores.df <- as.data.frame(vegan::scores(data.scores))


    # read in the metadata table
    #
    meta_data <- utils::read.table(metadata, header = T)

    # join meta data with nmds scores
    #
    data.scores.df$samples <- rownames(data.scores.df)
    meta_data$samples <- rownames(meta_data)
    data.scores.plot <- dplyr::left_join(data.scores.df, meta_data, on = "samples")

    # plot nmds
    #
    nmds_plot <- ggplot2::ggplot() +
      # for plotting the hull
      ggplot2::geom_polygon(data = data.scores.plot,
                            ggplot2::aes_string(x = data.scores.plot$NMDS1, y = data.scores.plot$NMDS2, fill = shape_grp, group = shape_grp), alpha = 0.30) +
      # for plotting the points
      ggplot2::geom_point(data = data.scores.plot,
                          ggplot2::aes_string(x = data.scores.plot$NMDS1, y = data.scores.plot$NMDS2, shape = shape_grp, colour = col_grp),
                          size = 4) +
      # for adding the stress value in the plot
      ggplot2::geom_text(ggplot2::aes(x = max(data.scores.plot$NMDS1), y = min(data.scores.plot$NMDS2),
                                      label = paste("stress:", round(data.scores$stress, 3), sep = " "), hjust = "inward")) +
      ggplot2::coord_equal() +
      ggplot2::labs(x = "NMDS1", y = "NMDS2") +
      cowplot::theme_cowplot()

    # convert to a cowplot
    #
    final_plot <- cowplot::plot_grid(nmds_plot, labels = paste(LETTERS, ".", SEP = ""))

  }

final_plot

}
