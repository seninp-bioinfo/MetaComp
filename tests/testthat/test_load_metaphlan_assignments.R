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
expect_that(length(the_list), equals(9))

expect_that(names(the_list[9]), equals("SSputum-no-RAB"))

#
# test the failure
#
expect_that(load_metaphlan_assignments("../test_data/nonexistantfile.txt"), throws_error())
