require("jsonlite")
require("RCurl")
require("dplyr")
require("tidyr")
require("ggplot2")
require("extrafont")

# Change the USER and PASS below to be your UTEid
df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from infected"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_kdk745', PASS='orcl_kdk745', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

# shows countries in top 0.05% of total deaths
td2 <- df %>% mutate(TOTAL_DEATHS = DEATHS_LESS_THAN_1_MONTH + DEATHS_1_TO_59_MONTHS + DEATHS_0_TO_4_YEARS) %>% arrange(desc(TOTAL_DEATHS)) %>% mutate(total_deaths_percent = cume_dist(TOTAL_DEATHS)) %>% group_by(YEAR) %>% filter(total_deaths_percent > 0.95)
head(td2)
ggplot() +
  coord_cartesian()+
  scale_x_continuous()+
  scale_y_continuous()+
  layer (
    data = td2,
    mapping = aes(x=YEAR, y=TOTAL_DEATHS, color=COUNTRY),
    stat = "identity", stat_params = list(),
    geom = "point", geom_params = list(),
    position = position_jitter(width=0.3, height=0)
  ) 
