#
# load GOTTCHA assignment #1
#
dat <- data.frame(load_bwa_assignment("../test_data/SSputum-no-RAB/bwa/allReads-bwa.list.txt"))

# columns import test
expect_that( dim(dat)[1], equals(558) )

#rows import test
expect_that( dim(dat)[2], equals(4) )

# col names test
expect_that(colnames(dat), equals( c("LEVEL", "TAXA", "COUNT", "ABUNDANCE") ) )

# test the specific line of file

# [0.0] subset family
family_table <- dplyr::filter( dat, LEVEL == "species")

# [0.1] subset taxa
ent_row <- dplyr::filter( family_table, TAXA == "Moraxella catarrhalis")

# [0.2] test
expect_that(ent_row$COUNT, equals(135))
expect_that(ent_row$ABUNDANCE, equals(0.3448099714))

#
# test the failure
#
expect_that(load_bwa_assignment("../test_data/nonexistentfile.txt"), throws_error())

#
# test an empty file
#
empty_df <- load_bwa_assignment("../test_data/an_empty_file.tsv")
expect_that(colnames(empty_df), equals( c("LEVEL", "TAXA", "COUNT", "ABUNDANCE") ) )
expect_that(dim(empty_df)[1], equals(0) )
