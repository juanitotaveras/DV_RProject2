require("tidyr")
require ("dplyr")
require ("ggplot2")
setwd("/home/juanito/DataVisualization/DV_RProject2/DV_RProject2")

file_path <- "infections.csv"

df <- read.csv(file_path, stringsAsFactors = FALSE)

summary(df)

names(df)

# Replace "." (i.e., period) with "_" in the column names.
names(df) <-gsub("\\.+", "_", names(df))

#df <- rename('data (4)', tbl = table) # table is a reserved word in Oracle so rename it to tbl.

str(df) # Uncomment this and  run just the lines to here to get column types to use for getting the list of measures.

measures <- c("Year", "Deaths_less_than_1_month", "Deaths_1_to_59_months", "Deaths_0_to_4_years") 

write.csv(df, paste(gsub(".csv", "", file_path), ".reformatted.csv", sep=""), row.names=FALSE, na = "")

tableName <- gsub(" +", "_", gsub("[^A-z, 0-9, ]", "", gsub(".csv", "", file_path)))
sql <- paste("CREATE TABLE", tableName, "Respiratory_Infections")
if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    sql <- paste(sql, paste(d, "varchar2(4000),\n"))
  }
}
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    if(m != tail(measures, n=1)) sql <- paste(sql, paste(m, "number(38,4),\n"))
    else sql <- paste(sql, paste(m, "number(38,4)\n"))
  }
}
sql <- paste(sql, ");")
cat(sql)
