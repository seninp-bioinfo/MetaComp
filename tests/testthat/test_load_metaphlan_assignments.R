# load GOTTCHA assignments
#

# projects
#
data_file <- "../test_data/test_table_metaphlan.txt"

# read em
#
the_list <- load_metaphlan_assignments(data_file)

# tests
#
expect_that(length(the_list), equals(8))

expect_that(names(the_list[8]), equals("SSputum-no-RAB"))

#
# test the failure
#
expect_that(load_metaphlan_assignments("../test_data/nonexistentfile.txt"), throws_error())
