#ggplots and visualisation 

library(tidyverse) # because ggplots is part of tidyverse

#for the final project all our files must be organized and send into our github
#we will turn in our githubs for the final exams
#the Rmarkdown in the assignments is solely to check it is there - we cant see if it works
#htmlgithubreview - two files - the code + the html so others can review it

#gg plots has a special plot with +

kings <- read_csv2("data/danishmonarchscsv.csv", na= c("na")) #remember na is the native language for R

head(kings)

kings %>% 
  mutate(Duration= end_reg_y- beg_reg_y) %>% 
  mutate(Midyear= end_reg_y-Duration/2) %>% 
  ggplot(aes(x=Midyear, y=Duration)) + 
  geom_point(col = "magenta") +
  geom_smooth(col= "pink") +
  theme_classic()+ 
  labs(title = "Duration of danish monarchs",
       x = "Midyear",
       y = "Duration")


#plusses indicates more aesthetic functions 

#working with homociderates: 


