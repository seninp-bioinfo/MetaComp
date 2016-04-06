#
# load GOTTCHA assignment #1
#
dat <- data.frame(load_gottcha_assignment("../test_data/248/allReads-gottcha-strDB-b.list.txt"))
#dat <- data.frame(load_gottcha_assignment("tests/test_data/248/allReads-gottcha-strDB-b.list.txt"))

# create a folder
#
tmp_folder <- file.path(getwd(), "sandbox")
dir.create(path = tmp_folder, recursive = TRUE, showWarnings = FALSE)
#
#
pdf_name <- file.path(tmp_folder, "test_pdf.pdf")
png_name <- file.path(tmp_folder, "test_png.png")

gplot <- plot_gottcha_assignment(dat, "species", "Test Plot #1",
             "allReads-gottcha-strDB-b", "sandbox/test_pdf")

Cairo::Cairo(width = 400, height = 300,
      file = png_name, type = "png", pointsize = 10,
      bg = "white", canvas = "white", dpi = 72)
print(gplot)
dev.off()

expect_that(file.exists(png_name), is_true())
expect_that(file.exists(pdf_name), is_true())

unlink(tmp_folder, recursive = T)
