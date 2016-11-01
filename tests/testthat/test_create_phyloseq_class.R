#
# convert merged table and metadata table to phyloseq object
#

phylum_phyloseq <- create_phyloseq_class(merge_table = "../test_data/merged_table.tsv",
                                    meta_table = "../test_data/mock_metadata.tsv",
                                    taxon = "phylum")

#
# create phyloseq object when just merge table is given without problem
#
phyloseq_obj <- create_phyloseq_class(merge_table = "../test_data/merged_table.tsv")


#
# test the failures
#
# when given non existing level of taxonomy
expect_that(create_phyloseq_class(merge_table = "../test_data/merged_table.tsv",
                                  "non_existent_level"), throws_error())

#
# when wrongly formatted metadata table is given
expect_that(create_phyloseq_class(merge_table = "../test_data/merged_table.tsv",
                                  meta_table = "../test_data/merged_table.tsv"), throws_error())
#
