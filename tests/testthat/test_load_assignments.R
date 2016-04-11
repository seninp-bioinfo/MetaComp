# load GOTTCHA assignments
#

# test folders
#
setwd("/Users/psenin/GitHub/MetaComp/tests/testthat")

# projects
#
data_file <- "../test_data/test_table.txt"

# read em
#
the_list <- load_gottcha_assignments(data_file)

# tests
#
expect_that(length(the_list), equals(12))

