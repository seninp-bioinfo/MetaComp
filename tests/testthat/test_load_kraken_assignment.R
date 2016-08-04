#
# load Kraken assignment #1
#
dat <- data.frame(load_kraken_assignment(
  "../test_data/SSputum-dil-DNase-cDNA/kraken_mini/allReads-kraken_mini.list.txt"))

# columns import test
expect_that( dim(dat)[1], equals(2977) )

#rows import test
expect_that( dim(dat)[2], equals(6) )

# col names test
expect_that(colnames(dat)[1], matches("LEVEL"))

#
expect_that(colnames(dat)[ dim(dat)[2] ], matches("NORM_ROLLUP"))

# [0.0] subset family
family_table <- dplyr::filter( dat, LEVEL == "family")

# [0.1] subset taxa
ent_row <- dplyr::filter( family_table, TAXA == "Propionibacteriaceae")

# [0.2] test
# family Propionibacteriaceae 4123 8 31957
expect_that(ent_row$ROLLUP, equals(4123))
expect_that(ent_row$NORM_ROLLUP, equals(0.2913297))

#
# test the failure
#
expect_that(load_metaphlan_assignment("../test_data/nonexistantfile.txt"), throws_error())
