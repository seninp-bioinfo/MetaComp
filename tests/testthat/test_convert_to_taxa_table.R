#
# convert merged table to phylum level otu_table
#

phylum_otu <- convert_to_otu_table("../test_data/merged_table.tsv", "phylum")

# extract taxa_table from class level otu_table

taxdat <- convert_to_taxa_table(phylum_otu, "Phylum")

#
# rows test
expect_that(row.names(taxdat)[1], equals("Actinobacteria"))
#
#

#
# test the failures
#
# when given non existing level of taxonomy
expect_that(convert_to_taxa_table_table(phylum_otu, "non_existent_level"), throws_error())
#
# when taxonomic level is not formatted correctly
#
expect_that(convert_to_taxa_table_table(phylum_otu, "class"), throws_error())
#
# when wrong taxonomic level is given to convert an otu table
expect_that(convert_to_taxa_table_table(phylum_otu, "Class"), throws_error())
#