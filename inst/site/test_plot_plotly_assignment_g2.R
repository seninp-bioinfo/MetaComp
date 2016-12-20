# load GOTTCHA 2 assignments
#
# [0.0] BOILERPLATE
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
projects <- data.frame(folder = file.path("tests/test_data",
              list_dirs(file.path("tests/test_data", sep = "")), sep = ""),
              stringsAsFactors = F)
# the weird transform...
# nolint start
projects <- data.frame(folder = projects[grep(".*SRR*", projects$folder), ], stringsAsFactors = F)
# nolint end
#
# accessions (projects_id)
#
projects$accession <- stringr::str_match(projects$folder, ".*/(.*)/")[, 2]
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
    find_file(paste(x$folder, "/", sep = ""), "allReads.summary.tsv", recursive = T)
  })
#
# cleanup those without an assignment
#
projects <- dplyr::filter(projects, !(is.na(assignment)))
#
# make a list
#
input_assignments_list <- plyr::dlply(projects, plyr::.(accession), function(x){
  dat <- load_gottcha2_assignment(x$assignment)
  dat
})
names(input_assignments_list) <- projects$accession
#
#
#
merged <- merge_gottcha_assignments(input_assignments_list)
#
# create a plot
#
library("plotly")
taxonomy_level <- "family"
#
#
# filter only the requested level
#
df <- dplyr::filter(merged, LEVEL == taxonomy_level)
df <- within(df, rm(LEVEL))
#
# rescale if needed
#
values_range <- range(df[, 2:length(names(df))])
if (values_range[2] <= 1) {
  # scale the values
  for (i in c(2:length(names(df)))) {
    df[, i] <- df[, i] * 100
  }
}
# compute row sum for each of rows
sums <- plyr::ddply(df, plyr::.(TAXA), function(x){ sum(x[-1]) / (length(x) - 1) })
names(sums) <- c("TAXA", "SUM")
df <- base::merge.data.frame(df, sums, by = c("TAXA"))
# cut the table by the threshold if too long
row_limit <- 50
if (dim(df)[1] > row_limit) {
  if (sorting_order == "alphabetical") {
    # order rows by the name
    df <- dplyr::arrange(df, TAXA)
    df <- df[1:row_limit, ]
    # inverse the order for plotting
    df <- dplyr::arrange(df, dplyr::desc(TAXA))
  } else {
    # order rows by the sum value
    df <- dplyr::arrange(df, dplyr::desc(SUM))
    df <- df[1:row_limit, ]
    # inverse the order for plotting
    df <- dplyr::arrange(df, SUM)
  }
} else {
  # sort any way ...
  if (sorting_order == "alphabetical") {
    # order rows by the name
    df <- dplyr::arrange(df, dplyr::desc(TAXA))
  } else {
    # order rows by the sum value
    df <- dplyr::arrange(df, SUM)
  }
}
df$TAXA <- factor(x = df$TAXA, levels = unique(df$TAXA), ordered = T)
project_names <- as.character(unlist(colnames(df)[2:(dim(df)[2] - 1)]))
project_names_order <- order(project_names)
column_index <- c(1, project_names_order + 1, as.numeric(dim(df)[2]) )
df <- dplyr::select(df, column_index )
x_colnames <- factor(x = colnames(df)[-1], levels = colnames(df)[-1], ordered = T)
# melt for plotting
melted_df <- reshape2::melt(within(df, rm(SUM)), id.vars = c("TAXA"))
melted_df$variable <- factor(x = as.character(melted_df$variable),
                             levels = levels(x_colnames), ordered = T)
#
plot_title <- "Test"
p <- ggplot2::ggplot( data = melted_df, ggplot2::aes(y = TAXA, x = variable, fill = value) ) +
  ggplot2::theme_bw() +
  ggplot2::geom_tile(color = "grey80", size = 0.3) +
  ggplot2::ggtitle(plot_title) +
  ggplot2::scale_x_discrete(expand = c(0, 0), position = "top") +
  ggplot2::scale_y_discrete(expand = c(0, 0)) +
  ggplot2::coord_fixed(ratio = 1) +
  ggplot2::scale_fill_gradientn(name = "Normalized abundance: ",
            limits = c(0.1, 100), trans = "log", colours =
            c("darkblue", "blue", "lightblue", "cyan2", "green",
             "yellow", "orange", "darkorange1", "red", bias = 10),
            breaks = c(0.1, 1, 10, 100),
            # nolint start
            labels = expression(10^-1, 10^0, 10^1, 10^2),
            # nolint end
            guide = ggplot2::guide_colorbar(title.theme =
            ggplot2::element_text(size = 12, angle = 0),
            title.vjust = 0.9, barheight = 0.6, barwidth = 6,
            label.theme = ggplot2::element_text(size = 9, angle = 0),
            label.hjust = 0.2)) +
  ggplot2::theme(plot.title = ggplot2::element_text(size = 14),
                 axis.title.x = ggplot2::element_text(size = 0),
                 axis.title.y = ggplot2::element_blank(),
                 axis.text.x = ggplot2::element_text(size = 10, angle = 55,
                                                     hjust = 0, vjust = 1),
                 axis.ticks.y = ggplot2::element_blank(),
                 axis.text.y = ggplot2::element_text(size = 10),
                 panel.grid.major.y = ggplot2::element_blank(),
                 panel.grid.minor.y = ggplot2::element_blank(),
                 #legend.position = c(0, 0),
                 #legend.justification = c(0, 0.3),
                 #plot.margin=grid::unit(c(0.1,0.1,3,0.1), 'lines'),
                 legend.direction = "horizontal", legend.position = "bottom")
p
filename <- "plotly_works"
Cairo::CairoPDF(file = filename, width = 0.3 * length(df[1, ]) + 6,
                height = 0.15 * length(df$TAXA) + 5,
                onefile = TRUE, family = "Helvetica",
                title = "R Graphics Output", version = "1.1",
                paper = "special", bg = "white", pointsize = 10)
print(p)
dev.off()
#
ggplotly(p)
#

dat <- within(df, rm(SUM))
r_names <- as.character(dat$TAXA)
dat <- within(dat, rm(TAXA))
c_names <- colnames(dat)
dat <- matrix(unlist(dat), nrow = length(r_names), byrow = F)
#
#


#
#
p <- plot_ly(z = dat, colors = colorRamp(c("darkblue", "blue", "lightblue", "cyan2", "green",
             "yellow", "orange", "darkorange1", "red", bias = 10)), type = "heatmap",
             x = c_names, y = r_names)
p
