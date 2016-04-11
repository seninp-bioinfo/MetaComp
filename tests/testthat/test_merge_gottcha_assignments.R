#
# load GOTTCHA assignment
#
dat1 <- data.frame(load_gottcha_assignment("../test_data/248/allReads-kraken_mini.list.txt"))
names(dat1)[3] <- "NORM_COV"

# extract species list
#
species <- dplyr::filter(dat1, LEVEL == "species")
expect_that(length(species$TAXA), equals(214))
#
# all the rest we will keep the same
#
gottcha_assignment1 <- dplyr::filter(dat1, LEVEL != "species")
gottcha_assignment2 <- dplyr::filter(dat1, LEVEL != "species")
#
species1 <- species[1:150,]
species2 <- species[110:214,]
#
expect_that(dim(species1)[1], equals(150))
expect_that(dim(species2)[1], equals(105))
#
#
gottcha_assignment1 <- rbind(gottcha_assignment1, species1)
gottcha_assignment2 <- rbind(species2, gottcha_assignment2)
#
#
input <- list("project1" = gottcha_assignment1, "project2" = gottcha_assignment2)
#
#
merged <- merge_gottcha_assignments(input)
#
expect_that(dim(merged)[1], equals(dim(dat1)[1]))
