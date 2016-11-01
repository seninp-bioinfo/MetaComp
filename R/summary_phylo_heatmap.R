#' @importFrom phyloseq plot_heatmap
#' @importFrom cowplot plot_grid
#'
#'

NULL

#' Summarize taxonomic assignments.
#'
#'
#' Creates a cowplot object with summary heatmaps (derived from phyloseq) of
#' specific taxonomic order (when given) or all possible taxonomic order
#'
#'
#' @param filepath path to merged_table (a tsv file) containing samples as column
#' @param LEVEL A taxonomic level (phylum, class, order, family, species) to create OTU table.
#'
#'
#' @return A cowplot object
#'
#' @export


summary_phylo_heatmap <- function(filepath, LEVEL = NULL){

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
      plots[[tax_level]] <- phyloseq::plot_heatmap(otables[[tax_level]],
                                                   low = "#e66101", high = "#5e3c99") +
        ggplot2::labs(title = tax_level) + ggplot2::ylab(tax_level)

    }


    # return a cowplot object
    #
    final_plot <- cowplot::plot_grid(plots[['phylum']],
                                     plots[['class']],
                                     plots[['family']],
                                     plots[['order']],
                                     plots[['genus']],
                                     plots[['species']],
                                     labels = paste(LETTERS, ".", SEP = ""),
                                     nrow = 2, ncol = 3)


  }
  # if the specific LEVEL is specified
  else {
    otuStable <- MetaComp::convert_to_otu_table(filepath, LEVEL)
    taxAtable <- MetaComp::convert_to_taxa_table(otuStable, LEVEL)
    base::row.names(otuStable) <- base::gsub("[ -]", ".", row.names(otuStable))
    otables <- phyloseq::phyloseq(otuStable, taxAtable)
    #
    # create a phyloseq heatmap
    plots <- phyloseq::plot_heatmap(otables, low = "#e66101", high = "#5e3c99") +
      ggplot2::labs(title = LEVEL) + ggplot2::ylab(LEVEL)



    # convert to a cowplot object
    #
    final_plot <- cowplot::plot_grid(plots, labels = paste(LETTERS, ".", SEP = ""))


  }
  final_plot
}