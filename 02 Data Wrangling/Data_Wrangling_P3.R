require("jsonlite")
require("RCurl")
require("dplyr")
require("tidyr")
require("ggplot2")
require("extrafont")

# Change the USER and PASS below to be your UTEid
df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from infected"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_kdk745', PASS='orcl_kdk745', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))


pcnt <- df %>% group_by(COUNTRY) %>% summarise(total=sum(DEATHS_0_TO_4_YEARS),less_1_month=sum(DEATHS_LESS_THAN_1_MONTH)) %>% filter(total>100000)

mutate(pcnt,percent_less_1_month = (less_1_month / total)*100) %>% arrange(desc(percent_less_1_month)) %>% select(COUNTRY,percent_less_1_month) %>% head(10)

mutate(pcnt, percent_less_1_month = (less_1_month / total)*100) %>% arrange(desc(percent_less_1_month)) %>% head(10) %>% ggplot(aes(x=percent_less_1_month,y=total,color=COUNTRY)) + labs(title="2000-2013") + geom_point()

