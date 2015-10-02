require("jsonlite")
require("RCurl")
require("dplyr")
require("tidyr")
require("ggplot2")
require("extrafont")

# Change the USER and PASS below to be your UTEid
df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from infected"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_kdk745', PASS='orcl_kdk745', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

# shows countries in top 0.05% of total deaths
td2 <- df %>% arrange(desc(DEATHS_0_TO_4_YEARS)) %>% mutate(total_deaths_percent = cume_dist(DEATHS_0_TO_4_YEARS)) %>% group_by(YEAR) %>% filter(total_deaths_percent > 0.95)
head(td2)
ggplot() +
  coord_cartesian()+
  scale_x_continuous()+
  scale_y_continuous()+
  labs(title="DEATHS IN TOP 0.05% COUNTRIES")+
  labs(x="YEAR", y="TOTAL DEATHS")+
  theme_grey()+
  layer (
    data = td2,
    mapping = aes(x=YEAR, y=DEATHS_0_TO_4_YEARS, color=COUNTRY),
    stat = "identity", stat_params = list(),
    geom = "point", geom_params = list(),
    position = position_jitter(width=0.3, height=0)
  ) 
