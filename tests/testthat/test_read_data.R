
print( getwd() )

bwa_data <- load_assignment("../test_data/allReads-bwa.list.txt")

expect_that(colnames(bwa_data)[1], matches("LEVEL"))
