#
# load GOTTCHA assignment #1
#
#
# load GOTTCHA assignment
#
dat1 <- data.frame(load_gottcha_assignment("../test_data/248/allReads-kraken_mini.list.txt"))
species <- dplyr::filter(dat1, LEVEL == "species")
gottcha_assignment1 <- dplyr::filter(dat1, LEVEL != "species")
gottcha_assignment2 <- dplyr::filter(dat1, LEVEL != "species")
species1 <- species[1:150,]
species2 <- species[110:214,]
gottcha_assignment1 <- rbind(gottcha_assignment1, species1)
gottcha_assignment2 <- rbind(species2, gottcha_assignment2)
gottcha_assignment1$ROLLUP <- scales::rescale(gottcha_assignment1$ROLLUP)
gottcha_assignment2$ROLLUP <- scales::rescale(gottcha_assignment2$ROLLUP)
merged <- merge_gottcha_columns(gottcha_assignment1, gottcha_assignment2, "species")
#
# create a folder
#
#tmp_folder <- file.path(getwd(), "sandbox")
#dir.create(path = tmp_folder, recursive = TRUE, showWarnings = FALSE)
#
#
#png_name <- file.path(tmp_folder, "gottcha_multicolumn_test.png")
#gplot <- plot_gottcha_columns(merged, "species")

#Cairo::Cairo(width = 600, height = 1000,
#      file = png_name, type = "png",
#      bg = "white", canvas = "white")
#print(gplot)
#dev.off()

#expect_that(file.exists(png_name), is_true())

#unlink(tmp_folder, recursive = T)
