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
merged <- merge_gottcha_assignments(load_gottcha_assignments(srcFile))
#
#
write.table(merged, file = destFile, col.names = T, row.names = F, quote = T, sep = "\t")
#
# that's all folks...
