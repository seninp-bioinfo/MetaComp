library(dtplyr)
library(RSQLite)
#
data_df <- as.data.frame(data.table::fread("cat tests/test_data/taxonomy.tsv.gz | zcat"))
data_dt <- as.data.table(data_df)
#
db <- RSQLite::dbConnect(SQLite(), dbname = ":memory:")
RSQLite::dbWriteTable(db, "taxonomy", data_df)
#
indexes <- sample(data_df$V3, 10000)
#
library(lineprof)
library(microbenchmark)
microbenchmark(
  df_selection = data_df[data_df$V3 == sample(indexes, 1), ],
  dt_selection = data_dt[data_dt$V3 == sample(indexes, 1), ],
  dp_selection = filter(data_df, V3 == sample(indexes, 1) ),
  sql_selection = dbGetQuery(db, paste(
    "select * from taxonomy where V3 == ", sample(indexes, 1) )), times = 100
)
