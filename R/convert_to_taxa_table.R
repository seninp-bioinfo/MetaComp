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
#' @param LEVEL taxonomic level. It should be the same taxonomic level
#' that its corresponding otu table is at.
#'
#' @return phyloseq formatted taxonomic table
#'
#' @export
#'
#'

convert_to_taxa_table <- function(OtuTable, LEVEL){

  NAME <- taxid <- NULL

  # convert the first letter to uppercase and rest to smaller case
  #
  LEVEL <- paste(toupper(substring(LEVEL, 1, 1)), tolower(substring(LEVEL, 2)),
                 sep = "", collapse = " ")

  # check if the Taxon is a subset of these valid ones
  #
  if ( !(LEVEL %in% c("Domain", "Phylum", "Class", "Order", "Family", "Genus", "Species")) ) {
    stop(paste("Specified \"", LEVEL, "\" doesn't exist or not correctly formatted!"))
  }

  # get taxa name from otu table
  #
  taxa_name <- base::row.names(OtuTable)
  #

  #create an empty taxa table
  #
  taxa_table <- base::data.frame(superkingdom = character(),
                                 phylum = character(),
                                 class = character(),
                                 order = character(),
                                 family = character(),
                                 genus = character(),
                                 species = character(),
                                 stringsAsFactors = F)


  # get the path of the taxonomy table which can be in two locations
  #
  ncbi_taxa_filepath <- NULL
  taxonomy_location1 <- "../../inst/extdata/taxonomy.tsv.gz"
  taxonomy_location2 <- "../../extdata/taxonomy.tsv.gz"
  if (file.exists(taxonomy_location1)) {
    ncbi_taxa_filepath <- taxonomy_location1
  } else if (file.exists(taxonomy_location2)) {
    ncbi_taxa_filepath <- taxonomy_location2
  } else {
    ncbi_taxa_filepath <- system.file("extdata", "taxonomy.tsv.gz", package = "MetaComp")
  }

  # read in the taxonomy file.
  #
  data <- base::as.data.frame(data.table::fread(base::sprintf('gunzip -c %s', ncbi_taxa_filepath),
                                                header = T))
  base::colnames(data) <- c("taxid", "dont_know", "parent_taxid", "LEVEL", "NAME")

  # loop through name of taxa and build a taxa_table
  #
  for (taxa in taxa_name) {

    # remove one_row variable if exists, its important
    # when taking into account species thats not present
    # taxonomy table
    #
    if (exists("one_row")) {
      rm(one_row)
    }

    # check if taxa exist in the taxonomy table
    #

    # if indeed it doesnt exist
    #
    if (base::nrow(dplyr::filter(data, NAME == taxa)) == 0L) {

        # check if its a two word taxa name, most likely species, start classification from genus
        #
        if (base::length(base::strsplit(taxa, " ")[[1]]) > 1) {

            #
            # Check if there is [C/c]andidatus in the name and used the second word, if present
            if (any(c("Candidatus", "candidatus") %in% base::strsplit(taxa, " ")[[1]])) {

              #
              # assign Species level taxa information
              #
              one_row <- base::data.frame(Species = taxa)

              #
              # assign genus level information to taxa
              #
              taxa <- base::strsplit(taxa, " ")[[1]][2]

            }

            # if there is no candidatus, take the first word
            #
            else {
                one_row <- base::data.frame(species = taxa)
                taxa <- base::strsplit(taxa, " ")[[1]][1]

            }

        # if no two word taxa, then probably print an error message here
        #
        }
        else {
          stop(paste("Specified \"", taxa, "\" doesn't exist in taxonomy file!"))
        }
    }
    else {
      taxa <- taxa
    }

    #
    taxon_level <- dplyr::filter(data, NAME == taxa)$LEVEL[1]
    #

    #
    parent_taxID <- dplyr::filter(data, NAME == taxa)$parent_taxid[1]
    #

    #
    taxID <- dplyr::filter(data, NAME == taxa)$taxid[1]
    #

    if (exists("one_row")) {
      one_row[[taxon_level]] <- taxa
    }
    else {
      one_row <- base::data.frame(taxon_level = taxa)
      colnames(one_row) <- taxon_level

    }

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
        # get parent_taxID and loop through until parent_taxID
        #                                     doesn't equal to 131567 (highest classification)
        parent_taxID <- dplyr::filter(data, taxid == taxID)$parent_taxid[1]
        #

      }
      taxa_table <- dplyr::bind_rows(taxa_table, one_row)
    }
    else {
      taxa_table <- dplyr::bind_rows(taxa_table, one_row)
    }


  }

  base::colnames(taxa_table) <-
                         c("Domain", "Phylum", "Class", "Order", "Family", "Genus", "Species")

  base::subset(taxa_table, select =
                         c("Domain", "Phylum", "Class", "Order", "Family", "Genus", "Species"))


  base::rownames(taxa_table) <- make.names(taxa_table[, LEVEL], unique = FALSE, allow_ = TRUE)

  phyloseq::tax_table(base::as.matrix(taxa_table))

}
