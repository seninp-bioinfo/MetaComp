# load GOTTCHA assignments
#

# projects
#
data_file <- "../test_data/test_table_kraken.txt"

# read em
#
the_list <- load_kraken_assignments(data_file)

# tests
#
expect_that(length(the_list), equals(8))

expect_that(names(the_list[8]), equals("Project_SSputum-no-RAB"))

#
# test the failure
#
expect_that(load_kraken_assignments("../test_data/nonexistentfile.txt"), throws_error())
