#' @importFrom data.table fread
#' @importFrom phyloseq otu_table

NULL

#' Create Phyloseq format otu table
#'
#' Synthesize phyloseq format otu table from merged table for given taxonomic level.
#' OTU here corresponds to the taxonomic level. This implementation is built upon phyloseq. We recommend not to use this for strain
#' level classification as creation of taxa_table doesn't work with strain level or
#' plasmid sequences.
#'
#' @param filepath to merge table containig samples as columns and taxa as rows.
#'
#' @param TAXON A taxonomic level (phylum, class, order, family, species) to create OTU table.
#'        It has to be all small letters.
#'
#' @return phyloseq otu table
#'
#' @export

convert_to_otu_table <- function(filepath, TAXON){

  LEVEL <- NULL

  # check for the file existence
  #
  if ( !file.exists(filepath) ) {
    stop(paste("Specified file \"", filepath, "\" doesn't exist!"))
  }

  # read the merge table
  df <- data.table::fread(filepath, sep = "\t", header = T)
  df$LEVEL <- base::as.character(df$LEVEL)


  # subset to given taxa level and remove the LEVEL column
  taxa_level_table <- base::subset(df, LEVEL == TAXON, select = -c(LEVEL))


  # assign taxa names to a variable
  row_names <- taxa_level_table$TAXA
  taxa_level_table$TAXA <- NULL


  # convert to matrix
  taxa_level_mat <- base::as.matrix(base::data.frame(taxa_level_table, row.names = row_names))


  # convert to otu table object as per phyloseq
  OTU <- phyloseq::otu_table(taxa_level_mat, taxa_are_rows = T)

  OTU
}
