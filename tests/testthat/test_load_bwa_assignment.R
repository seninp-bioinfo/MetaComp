#
# load GOTTCHA assignment #1
#
dat <- data.frame(load_bwa_assignment("../test_data/SSputum-no-RAB/bwa/allReads-bwa.list.txt"))

# columns import test
expect_that( dim(dat)[1], equals(558) )

#rows import test
expect_that( dim(dat)[2], equals(6) )

# col names test
expect_that(colnames(dat)[1], matches("LEVEL"))

#
expect_that(colnames(dat)[ dim(dat)[2] ], matches("NORM_ROLLUP"))

# test the specific line of file

# [0.0] subset family
family_table <- dplyr::filter( dat, LEVEL == "species")

# [0.1] subset taxa
ent_row <- dplyr::filter( family_table, TAXA == "Moraxella catarrhalis")

# [0.2] test
expect_that(ent_row$ROLLUP, equals(135))
expect_that(ent_row$NORM_ROLLUP, equals(0.0034481))

#
# test the failure
#
expect_that(load_gottcha_assignment("../test_data/nonexistantfile.txt"), throws_error())
