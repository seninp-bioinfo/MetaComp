#
# load GOTTCHA assignment
#
dat1 <- data.frame(load_gottcha_assignment("../test_data/248/allReads-kraken_mini.list.txt"))
#
# get only phylum subset
#
dat1_phylum <- dplyr::filter(dat1, LEVEL == "phylum")
dat1_phylum$ROLLUP <- scales::rescale(dat1_phylum$ROLLUP)
#
# make two pseudo sets
#
phylum <- dat1_phylum$TAXA
phylum1 <- phylum[1:8]
phylum2 <- phylum[6:15]
#
gottcha_assignment1 <- dplyr::filter(dat1_phylum, TAXA %in% phylum1)
gottcha_assignment2 <- dplyr::filter(dat1_phylum, TAXA %in% phylum2)
#
# merge stuff
#
merged_assignment <- merge_gottcha_columns(gottcha_assignment1, gottcha_assignment2)
#
#
#
gottcha_assignment2$ROLLUP <- scales::rescale(gottcha_assignment2$ROLLUP)
#merged <- merge_gottcha_columns(gottcha_assignment1, gottcha_assignment2)
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
