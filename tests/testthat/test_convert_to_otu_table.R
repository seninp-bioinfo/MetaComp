#
# convert merge table to otu table
#
dat <- convert_to_otu_table("../test_data/merged_table.tsv", "class")

# columns import test
expect_that(dim(dat)[1], equals(10))

#rows import test
expect_that(dim(dat)[2], equals(12))

# col names test
expect_that(colnames(dat), equals(c("Project_100187", "Project_100197",
                                     "Project_100198", "Project_100218",
                                     "Project_100236", "Project_100237",
                                     "Project_100301", "Project_100400",
                                     "Project_100404", "Project_100455",
                                     "Project_100456", "Project_248")))

# check if relative abundance add up to 1
expect_that(sum(dat[,1]), equals(1.0))

#
# test the failures
#
expect_that(convert_to_otu_table("../test_data/merged_table.tsv", "non_existent_taxa_level"), throws_error())
