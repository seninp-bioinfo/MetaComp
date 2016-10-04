# load GOTTCHA assignments
#

# projects
#
data_file <- "../test_data/test_table_bwa.txt"

# read em
#
the_list <- load_bwa_assignments(data_file)

# tests
#
expect_that(length(the_list), equals(9))
#
expect_that(names(the_list[9]), equals("Project_SSputum-no-RAB"))

#
# test the failure
#
expect_that(load_bwa_assignments("../test_data/nonexistantfile.txt"), throws_error())
