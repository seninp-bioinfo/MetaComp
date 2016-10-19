#' @importFrom pheatmap pheatmap
#' @importFrom cowplot plot_grid

NULL

#' Summarize taxonomic assignments into a pheatmap.
#'
#'
#' Returns pheatmap(s) for specific taxonomic order (when given) or all possible taxonomic order when LEVEL is not specified.
#'
#'
#' @param filepath path to merged_table (a tsv file) containing samples as column
#' @param LEVEL A taxonomic level (phylum, class, order, family, species) to create OTU table
#' @param ... origingal parameters from pheatmap
#'
#' @return A cowplot object derived from pheatmap gtable
#'
#'
#'
#' @export


summary_pheatmap <- function(filepath, LEVEL = NULL, ...){

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

    # extracts all taxa_level in the
    #
    taxa_level <- base::as.character(base::sort(base::unique(utils::read.table(filepath,
                                                                               header = T)$LEVEL)))

    # remove strain level classification
    #
    taxa_level <- taxa_level[taxa_level != 'strain']

    # create an empty list to hold all otu table objects
    #
    otables <- base::as.data.frame(base::matrix(ncol = length(taxa_level)))
    base::colnames(otables) <- taxa_level
    otables <- base::as.list(otables)

    # loop through different taxa to create phyloseq object that contains otu table and taxa table
    #
    for (taxa in taxa_level) {
      otuStable <- MetaComp::convert_to_otu_table(filepath, taxa)
      taxAtable <- MetaComp::convert_to_taxa_table(otuStable, taxa)
      base::row.names(otuStable) <- base::gsub("[ -]", ".", row.names(otuStable))
      otables[[taxa]] <- phyloseq::phyloseq(otuStable, taxAtable)
    }


    # loop through the phyloseq object list to create heatmaps of all panels
    #
    plots <- base::list()
    for (tax_level in names(otables)) {
      plots[[tax_level]] <- pheatmap::pheatmap(as.matrix(phyloseq::otu_table(otables[[tax_level]],
                                                                             taxa_are_rows = T)),
                                               main = tax_level, ...)

    }
      # create a cowplot object
      #
      final_plot <- cowplot::plot_grid(plots[['phylum']]$gtable,
                                       plots[['class']]$gtable,
                                       plots[['family']]$gtable,
                                       plots[['order']]$gtable,
                                       plots[['genus']]$gtable,
                                       plots[['species']]$gtable,
                                       labels = paste(LETTERS, ".", SEP = ""),
                                       nrow = 2, ncol = 3)

  }
  # if a LEVEL is specified
  else {
    otuStable <- MetaComp::convert_to_otu_table(filepath, LEVEL)
    taxAtable <- MetaComp::convert_to_taxa_table(otuStable, LEVEL)
    base::row.names(otuStable) <- base::gsub("[ -]", ".", row.names(otuStable))
    otables <- phyloseq::phyloseq(otuStable, taxAtable)

    #
    # create a pheatmap
    plots <- pheatmap::pheatmap(as.matrix(phyloseq::otu_table(otables, taxa_are_rows = T)), main = as.character(LEVEL), ...)$gtable
    final_plot <- cowplot::plot_grid(plots, labels = paste(LETTERS, ".", SEP = ""))
    }

final_plot
}
