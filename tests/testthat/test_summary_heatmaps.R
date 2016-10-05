#
# load merged table
#

dat1 <- summary_heatmaps("../test_data/merged_table.tsv", LEVEL = NULL)


# create an outout folder
#
tmp_folder <- file.path(getwd(), "sandbox")
dir.create(path = tmp_folder, recursive = TRUE, showWarnings = FALSE)

# the file names we are going to save plots into
#
pdf_name <- file.path(tmp_folder, "test_pdf.pdf")
png_name <- file.path(tmp_folder, "test_png.png")

# generate a PDF and also get a ggplot out
#

dat1 <- summary_heatmaps("../test_data/merged_table.tsv", out_pdf = pdf_name)

# write down the plot as PNG
#
Cairo::Cairo(width = 500, height = 500,
             file = png_name, type = "png", pointsize = 18,
             bg = "white", canvas = "white", dpi = 86)
print(dat1)
dev.off()


#
# when wrong taxonomic level is given, but right file
expect_that(summary_heatmaps("../test_data/merged_table.tsv", "man"), throws_error())


#
# when a merged table file that doesnt exist is given
expect_that(summary_heatmaps("../test_data/merged_table.csv", "man"), throws_error())


# cleanup after the test
#
unlink(tmp_folder, recursive = T)
