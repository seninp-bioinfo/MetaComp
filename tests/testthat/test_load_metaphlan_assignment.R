#
# load GOTTCHA assignment #1
#
dat <- data.frame(load_metaphlan_assignment(
  "../test_data/SSputum-dil-DNase-cDNA/metaphlan/allReads-metaphlan.list.txt"))

# columns import test
expect_that( dim(dat)[1], equals(25) )

#rows import test
expect_that( dim(dat)[2], equals(4) )

# col names test
expect_that(colnames(dat)[1], matches("LEVEL"))

#
expect_that(colnames(dat)[ dim(dat)[2] ], matches("ASSIGNED"))

# [0.0] subset family
family_table <- dplyr::filter( dat, LEVEL == "family")

# [0.1] subset taxa
ent_row <- dplyr::filter( family_table, TAXA == "Propionibacteriaceae")

# [0.2] test
expect_that(ent_row$ROLLUP, equals(15.76274))

#
# test the failure
#
expect_that(load_metaphlan_assignment("../test_data/nonexistentfile.txt"), throws_error())

#
# test an empty file
#
empty_df <- load_metaphlan_assignment("../test_data/an_empty_file.tsv")
expect_that(colnames(empty_df), equals( c("LEVEL", "TAXA", "COUNT", "ABUNDANCE") ) )
expect_that(dim(empty_df)[1], equals(0) )
