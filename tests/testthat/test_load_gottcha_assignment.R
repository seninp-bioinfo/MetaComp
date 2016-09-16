#
# load GOTTCHA assignment #1
#
dat <- data.frame(load_gottcha_assignment("../test_data/248/allReads-gottcha-strDB-b.list.txt"))

# columns import test
expect_that( dim(dat)[1], equals(42) )

#rows import test
expect_that( dim(dat)[2], equals(4) )

# col names test
expect_that(colnames(dat), equals( c("LEVEL", "TAXA", "COUNT", "ABUNDANCE") ) )

# test the specific line of file
# LEVEL	TAXA	ROLLUP	ASSIGNED	LINEAR_LENGTH	TOTAL_BP_MAPPED	HIT_COUNT	HIT_COUNT_PLASMID	READ_COUNT	LINEAR_DOC	NORM_COV
# species	Veillonella parvula	0.0375		10606	12569	396	0	198	1.18508391476523	0.0375168122114549

# [0.0] subset family
family_table <- dplyr::filter( dat, LEVEL == "species")

# [0.1] subset taxa
ent_row <- dplyr::filter( family_table, TAXA == "Veillonella parvula")

# [0.2] test
expect_that(ent_row$ABUNDANCE, equals(0.03751681))

#
# test the failure
#
expect_that(load_gottcha_assignment("../test_data/nonexistantfile.txt"), throws_error())
