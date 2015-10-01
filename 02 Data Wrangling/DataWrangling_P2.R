require(tidyr)
require(dplyr)
require(ggplot2)

tbl_df(df)
View(df)

#The very interesting thing about this workflow is that there are no cumulative distribution of less than .10, or even less than .90 for that matter, meaning that no matter what country you are in, respiratory infections in babies less than one month old are a huge problem. However, the risk of death from respiratory infections does decrease as the child gets older for people in most countries, with the very apparent exception of India, where it's still a huge problem in children up to almost 5 years of age.
df %>% mutate(Percent_deaths_less_than_one_month = cume_dist(Deaths_less_than_1_month)) %>% filter(Percent_deaths_less_than_one_month <=.10 | Percent_deaths_less_than_one_month >= .90) %>% ggplot(aes(x=Percent_deaths_less_than_one_month, y=Deaths_1_to_59_months, color=Country)) + geom_point()

#was trying to make histogram...basically we can see that data is pretty evenly distributed and not skewed
df %>% mutate(ntile_0_to_1_month = ntile(Deaths_less_than_1_month,200)) %>% group_by(ntile_0_to_1_month) %>% summarise(n=n()) %>% ggplot(aes(x=ntile_0_to_1_month)) + geom_bar()
