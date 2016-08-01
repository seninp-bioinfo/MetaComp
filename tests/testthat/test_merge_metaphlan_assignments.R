#
# load GOTTCHA assignment
#
dat1 <- data.frame(load_gottcha_assignment(
  "../test_data/SSputum-no-cDNA/metaphlan/allReads-metaphlan.list.txt"))

# extract species list
#
species <- dplyr::filter(dat1, LEVEL == "species")
expect_that(length(species$TAXA), equals(30))
#
# all the rest we will keep the same
#
gottcha_assignment1 <- dplyr::filter(dat1, LEVEL != "species")
gottcha_assignment2 <- dplyr::filter(dat1, LEVEL != "species")
#
species1 <- species[1:10, ]
species2 <- species[11:30, ]
#
expect_that(dim(species1)[1], equals(10))
expect_that(dim(species2)[1], equals(20))
#
#
gottcha_assignment1 <- rbind(gottcha_assignment1, species1)
gottcha_assignment2 <- rbind(species2, gottcha_assignment2)
#
#
input <- list("project1" = gottcha_assignment1, "project2" = gottcha_assignment2)
#
#
merged <- merge_metaphlan_assignments(input)
#
expect_that(dim(merged)[1], equals(dim(dat1)[1]))
