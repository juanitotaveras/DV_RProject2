require("jsonlite")
require("RCurl")
require("dplyr")
require("tidyr")
require("ggplot2")
require("extrafont")

# Change the USER and PASS below to be your UTEid
df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from infected"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_kdk745', PASS='orcl_kdk745', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

#The very interesting thing about this workflow is that there are no cumulative distribution of less than .10, or even less than .90 for that matter, meaning that no matter what country you are in, respiratory infections in babies less than one month old are a huge problem. However, the risk of death from respiratory infections does decrease as the child gets older for people in most countries, with the very apparent exception of India, where it's still a huge problem in children up to almost 5 years of age.
df %>% mutate(Percent_deaths_less_than_one_month = cume_dist(DEATHS_LESS_THAN_1_MONTH)) %>% filter(Percent_deaths_less_than_one_month <=.10 | Percent_deaths_less_than_one_month >= .90) %>% ggplot(aes(x=Percent_deaths_less_than_one_month, y=DEATHS_1_TO_59_MONTHS, color=COUNTRY)) + geom_point() + labs(x="CUMULATIVE DISTRIBUTION OF DEATHS", y="TOTAL DEATHS IN 1 TO 59 MONTHS") + labs(title="DEATHS IN BABIES LESS THAN ONE MONTH OLD")

#was trying to make histogram...basically we can see that data is pretty evenly distributed and not skewed
df %>% mutate(ntile_0_to_1_month = ntile(DEATHS_LESS_THAN_1_MONTH,200)) %>% group_by(ntile_0_to_1_month) %>% summarise(n=n()) %>% ggplot(aes(x=ntile_0_to_1_month)) + geom_bar()

df %>% mutate(TOTAL_DEATHS = DEATHS_LESS_THAN_1_MONTH + DEATHS_1_TO_59_MONTHS + DEATHS_0_TO_4_YEARS) %>% arrange(desc(TOTAL_DEATHS)) %>% group_by(YEAR) 
