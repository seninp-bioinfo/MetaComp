# load GOTTCHA assignments
#

# projects
#
data_file <- "../test_data/test_table_gottcha2.txt"

# read em
#
the_list <- load_gottcha2_assignments(data_file)

# tests
#
expect_that(length(the_list), equals(5))

expect_that(names(the_list[5]), equals("Anterior_nares_female_SRR353621"))

#
# test the failure
#
expect_that(load_gottcha2_assignments("../test_data/nonexistentfile.txt"), throws_error())
