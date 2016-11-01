#' @importFrom phyloseq phyloseq
#' @importFrom phyloseq sample_data
#'
#'

NULL

#' Creates a phyloseq class corresponding.
#'
#' Creates a phyloseq class with taxonomy table, otu table from given merged table and metadata file.
#'
#'
#' @param merge_table Path to merged_table.
#' @param meta_table Path to metadata table with samples as rows and columns as metadata.
#' @param taxon A taxonomic level (phylum, class, order, family, species). Default is "species".
#'
#' @return phyloseq_class object
#'
#' @export
#'
#'

create_phyloseq_class <- function(merge_table, meta_table = NULL, taxon = "species"){

  # check for the merge_table file existence
  #
  if ( !file.exists(merge_table) ) {
    stop(paste("Specified file \"", merge_table, "\" doesn't exist!"))
  }


  # check for the meta_table file existence
  #
  if ( is.null(meta_table) ) {
    print("phyloseq object will be created without meta data table")
  } else if ( !file.exists(meta_table) ) {
    stop(paste("Specified file \"", merge_table, "\" doesn't exist!"))
  }


  # check if the merged file given is of right format
  #
  if ( !all((c('TAXA', 'LEVEL')  %in% colnames(utils::read.table(merge_table, header = T))))) {
    stop(paste("Specified file \"", merge_table, "\" is not of right format!"))
  }


  # generate otutable, taxatable, and metadata table
  #
  otuStable <- MetaComp::convert_to_otu_table(merge_table, taxon)
  taxAtable <- MetaComp::convert_to_taxa_table(otuStable, taxon)
  base::row.names(otuStable) <- base::gsub("[ -]", ".", row.names(otuStable))

  if ( is.null(meta_table) ) {

    # create phyloseq object with otutable and taxatable only
    #
    phylo_object <- phyloseq::phyloseq(otuStable, taxAtable)


    }
  else {

    # format the metadata table to phyloseq format
    metAtable <- phyloseq::sample_data(utils::read.table(meta_table, sep = "\t", header = T,
                                                         row.names = 1, stringsAsFactors = F))

    # generate phylo object from three
    #
    phylo_object <- phyloseq::phyloseq(otuStable, taxAtable, metAtable)
      }


  return(phylo_object)
}
