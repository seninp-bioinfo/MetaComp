#' @importFrom phyloseq otu_table

NULL

#' Extracts phyloseq format otu table from merged table for given TAXA
#' otu here corresponds to TAXA
#'
#' This implementation is built upon phyloseq.
#'
#' @param filepath merge table containig samples as columns and taxa as rows.
#' @param TAXA The taxonomic level to create OTU table.
#'
#' @return phyloseq otu table
#'
#' @export

convert_to_otu_table <- function(filepath, TAXON){

  # read the merge table
  df <- data.table::fread(filepath, sep = "\t", header = T)
  df$LEVEL <- base::as.character(df$LEVEL)


  # subset to given taxa level and remove the LEVEL column
  taxa_level_table <- base::subset(df, LEVEL == TAXON, select=-c(LEVEL))


  # change TAXA as row name (required when converting to matrix)
  base::rownames(taxa_level_table) <- taxa_level_table$TAXA
  taxa_level_table$TAXA <- NULL

  # convert to matrix
  taxa_leve_mat <- base::as.matrix(taxa_level_table)

  # convert to otu table object as per phyloseq
  OTU <- phyloseq::otu_table(taxa_leve_mat, taxa_are_rows = T)
  OTU
}
