# create an outout folder
#
tmp_folder <- file.path(getwd(), "sandbox")
dir.create(path = tmp_folder, recursive = TRUE, showWarnings = FALSE)

# the file names we are going to save plots into
#
pdf_name <- file.path(tmp_folder, "test_pdf.pdf")
png_name <- file.path(tmp_folder, "test_png.png")


# generate a cowplot object
#

dat1 <- summary_pheatmap("../test_data/merged_table.tsv")

# write down the plot as PNG
#
Cairo::Cairo(width = 500, height = 500,
             file = png_name, type = "png", pointsize = 18,
             bg = "white", canvas = "white", dpi = 86)
print(dat1)
dev.off()


# when wrong taxonomic level is given, but right file
#
expect_that(summary_pheatmap("../test_data/merged_table.tsv", "man"), throws_error())


# when a merged table file that doesnt exist is given
#
expect_that(summary_pheatmap("../test_data/merged_table.csv", "class"), throws_error())

# when an option that is not part of pheatmap is given
#
expect_that(summary_pheatmap("../test_data/merged_table.csv", clustering_distance_cols = "uclidean"), throws_error())

# cleanup after the test
#
unlink(tmp_folder, recursive = T)
