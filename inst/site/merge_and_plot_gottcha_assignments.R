#
#
require(MetaComp)
#
#
options(echo = TRUE)
args <- commandArgs(trailingOnly = TRUE)
print(paste("provided args: ", args))
#
#
srcFile <- args[1]
#
#
destFile <- args[2]
#
#
taxonomyLevelArg <- args[3]
#
#
plotTitleArg <- args[4]
#
#
plotFile <- args[5]
#
#
merged <- merge_gottcha_assignments(load_gottcha_assignments(srcFile))
#
#
write.table(merged, file = destFile, col.names = T, row.names = F, quote = T, sep = "\t")
#
#
plot_merged_assignment(merged, taxonomyLevelArg, plotTitleArg, plotFile)
#
# that's all folks...