#' @importFrom data.table fread
#' @importFrom dplyr filter bind_rows
NULL

#' Create a phyloseq taxon table
#'
#' Extracts taxonomic information from the otu_table and ncbi taxonomy file to
#' to create phyloseq formatted tax_table. ncbi taxonomy file is provided with the package
#' taxonomy.tsv.gz
#'
#'
#' @param OtuTable produced by convert_to_otu_table
#'
#' @param TAXON taxonomic level (First letter must be caps). It should be the same taxonomic level
#' that its corresponding otu table is at.
#'
#' @return phyloseq formatted taxonomic table
#'
#' @export
#'
#'

convert_to_taxa_table <- function(OtuTable, TAXON){

  # check if the Taxon is the right one
  #
  if ( !(TAXON %in% c("Domain", "Phylum", "Class", "Order", "Family", "Genus", "Species")) ) {
    stop(paste("Specified file \"", TAXON, "\" doesn't exist or not correctly formatted!"))
  }

  #
  # get taxa name from otu table
  taxa_name <- base::row.names(OtuTable)
  #

  #create an empty taxa table
  taxa_table <- base::data.frame(superkingdom = character(),
                                 phylum = character(),
                                 class = character(),
                                 order = character(),
                                 family = character(),
                                 genus = character(),
                                 species = character(),
                                 stringsAsFactors = F)


  #
  # get the path of the taxonomy table concatenated to command to unzip it
  ncbi_taxa_filepath <- system.file("inst/extdata/taxonomy.tsv.gz", package="MetaComp")
  #


  #
  # read in the taxonomy file.
  data <- base::as.data.frame(data.table::fread(base::sprintf('gunzip -c %s', ncbi_taxa_filepath), header=T))
  base::colnames(data) <- c("taxid", "dont_know", "parent_taxid", "LEVEL", "NAME")
  #

  # loop through name of taxa and build a taxa_table
  for (taxa in taxa_name){

    #
    taxon_level <- dplyr::filter(data, NAME == taxa)$LEVEL[1]
    #

    #
    parent_taxID <- dplyr::filter(data, NAME == taxa)$parent_taxid[1]
    #

    #
    taxID <- dplyr::filter(data, NAME == taxa)$taxid[1]
    #

    one_row <- base::data.frame(taxon_level = taxa)
    colnames(one_row) <- taxon_level
    #

    if (parent_taxID != "1") {
      while (parent_taxID != "1") {
        #
        # get taxon LEVEL of parent taxa
        taxon_level <- dplyr::filter(data, taxid == parent_taxID)$LEVEL[1]
        #

        #
        # get taxon NAME of parent taxa
        taxon_name <- dplyr::filter(data, taxid == parent_taxID)$NAME[1]
        #

        #
        # get taxid
        taxID <- dplyr::filter(data, taxid == parent_taxID)$taxid[1]
        #

        #
        # add that to the one_row data frame
        one_row[taxon_level] <- taxon_name

        #
        # get parent_taxID and loop through until parent_taxID doesnt equal to 131567 (highest classification)
        parent_taxID <- dplyr::filter(data, taxid == taxID)$parent_taxid[1]
        #

      }
      taxa_table <- dplyr::bind_rows(taxa_table, one_row)
    }
    else {
      taxa_table <- dplyr::bind_rows(taxa_table, one_row)
    }


  }

  base::colnames(taxa_table) <- c("Domain", "Phylum", "Class", "Order", "Family", "Genus", "Species")
  base::subset(taxa_table, select=c("Domain", "Phylum", "Class", "Order", "Family", "Genus", "Species"))
  base::rownames(taxa_table) <- taxa_table[, TAXON]
  phyloseq::tax_table(base::as.matrix(taxa_table))
}
