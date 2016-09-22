library(data.table)
library(RSQLite)
#
db <- RSQLite::dbConnect(SQLite(), dbname = ":memory:")
#
data <- data.table::fread("cat tests/test_data/taxonomy.tsv.gz | zcat")
#
str(data)
#
RSQLite::dbWriteTable(db, "taxonomy", data)
#
rs <- dbSendQuery(db, "select * from taxonomy")
#
str(rs)
d1 <- fetch(rs, n = 10)
str(d1)
#
#
rs <- dbGetQuery(db, "select * from taxonomy where V5 == \"Proteobacteria\"")
rs
#