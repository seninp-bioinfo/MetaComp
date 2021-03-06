#
#
# test folders
#
list_dirs <- function(path = ".", pattern = NULL, all.dirs = FALSE,
                      full.names = FALSE, ignore.case = FALSE) {
  # use full.names=TRUE to pass to file.info
  all <-  list.files(path, pattern, all.dirs, full.names = TRUE, recursive = FALSE, ignore.case)
  dirs <- all[file.info(all)$isdir]
  if (isTRUE(full.names))
    return(dirs)
  else
    return(basename(dirs))
}
#
# projects
#
projects <- data.frame(folder = file.path(dirname(getwd()), "test_data",
                list_dirs(file.path(dirname(getwd()), "test_data"))), stringsAsFactors = F)
# the weird transform...
# nolint start
HMP_pattern <- paste(.Platform$file.sep, "HMP_.+", sep = "")
test_pattern <- paste(.Platform$file.sep, "test_all_.+", sep = "")
projects <- data.frame(folder = projects[c(grep(HMP_pattern, projects$folder), grep(test_pattern, projects$folder)), ],
                       stringsAsFactors = F)
# nolint end
#
# accessions (projects_id)
#
name_pattern <- paste(".*", .Platform$file.sep, "(.*)", sep = "")
projects$accession <- paste0("Project_", gsub(name_pattern, "\\1", projects$folder, perl = T))
#
# taxonomic assignments
#
find_file <-  function(path = ".", filename = "", recursive = TRUE) {
    all <- list.files(path, filename, full.names = TRUE, recursive = recursive, ignore.case = TRUE)
    all <- all[!file.info(all)$isdir]
    if (length(all) > 0) {
      return(all)
    }else {
      return(NA)
    }
 }
#
projects$assignment <-
  plyr::daply(projects, plyr::.(accession), function(x) {
    find_file(paste(x$folder, .Platform$file.sep, sep = ""),
              "allReads-diamond.list.txt", recursive = T)
  })
#
# cleanup those without an assignment
#
projects <- dplyr::filter(projects, !(is.na(assignment)))
#
# make a list
#
input_assignments_list <- plyr::dlply(projects, plyr::.(accession), function(x){
  dat <- load_edge_assignment(x$assignment, type = 'diamond')
  dat
})
names(input_assignments_list) <- projects$accession
#
#
#
merged <- merge_edge_assignments(input_assignments_list)
#
# create a folder
#
tmp_folder <- file.path(getwd(), "sandbox")
dir.create(path = tmp_folder, recursive = TRUE, showWarnings = FALSE)
#
#
gplot <- plot_merged_assignment(assignment = merged,
                                taxonomy_level = "class",
                                sorting_order = "alphabetical",
                                row_limit = 60,
                                plot_title = "Test Plot #3",
                                filename = file.path(tmp_folder, "test_pdf3"))

expect_that(file.exists(file.path(tmp_folder, "test_pdf3.pdf")), is_true())

unlink(tmp_folder, recursive = T)
