#
# load BWA assignment
#
dat <- load_edge_assignment("../test_data/SSputum-no-cDNA/bwa/allReads-bwa.list.txt", type = 'bwa')

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
gplot <- plot_edge_assignment(dat, "family", "Test Plot #1",
             "SSputum-no-cDNA", file.path(tmp_folder, "test_pdf"))

# write down the plot as PNG
#
Cairo::Cairo(width = 500, height = 500,
      file = png_name, type = "png", pointsize = 18,
      bg = "white", canvas = "white", dpi = 86)
print(gplot)
dev.off()

# check that the files has been created
#
expect_true(file.exists(png_name))
expect_true(file.exists(pdf_name))

# check that the size >0
#
expect_true(file.info(png_name)$size > 0)
expect_true(file.info(pdf_name)$size > 0)

# cleanup after the test
#
unlink(tmp_folder, recursive = T)
