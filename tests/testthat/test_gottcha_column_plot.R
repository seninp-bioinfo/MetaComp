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
png_name <- file.path(tmp_folder, "gottcha_column_test.png")
gplot <- plot_gottcha_as_column(dat, "species")

Cairo::Cairo(width = 600, height = 1000,
      file = png_name, type = "png",
      bg = "white", canvas = "white")
print(gplot)
dev.off()

expect_that(file.exists(png_name), is_true())

unlink(tmp_folder, recursive = T)
