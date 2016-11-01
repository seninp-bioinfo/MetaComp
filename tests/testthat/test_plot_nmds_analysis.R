#
# load merged table
#

dat1 <- plot_nmds_analysis("../test_data/merged_table.tsv", LEVEL = "class",
                           metadata = "../test_data/mock_metadata.tsv", shape_grp = "fac_category",
                           col_grp = "fac_category")


# create an outout folder
#
tmp_folder <- file.path(getwd(), "sandbox")
dir.create(path = tmp_folder, recursive = TRUE, showWarnings = FALSE)

# the file names we are going to save plots into
#
pdf_name <- file.path(tmp_folder, "test_pdf.pdf")
png_name <- file.path(tmp_folder, "test_png.png")


# write down the plot as PNG
#
Cairo::Cairo(width = 500, height = 500,
             file = png_name, type = "png", pointsize = 18,
             bg = "white", canvas = "white", dpi = 86)
print(dat1)
dev.off()


# when wrong taxonomic level is given, but right file
#
expect_that(plot_nmds_analysis("../test_data/merged_table.tsv", LEVEL = "man", metadata = "../test_data/mock_metadata.tsv", shape_grp = "fac_category",
                               col_grp = "fac_category"), throws_error())


# when a merged table file that doesnt exist is given
#
expect_that(plot_nmds_analysis("../test_data/merged_table.csv", LEVEL = "class", metadata = "../test_data/mock_metadata.tsv", shape_grp = "fac_category",
                               col_grp = "fac_category"), throws_error())

# when a wrong header is given
#
expect_that(plot_nmds_analysis("../test_data/merged_table.csv", LEVEL = "class", metadata = "../test_data/mock_metadata.tsv", shape_grp = "fac_category",
                               col_grp = "fac"), throws_error())


# cleanup after the test
#
unlink(tmp_folder, recursive = T)
