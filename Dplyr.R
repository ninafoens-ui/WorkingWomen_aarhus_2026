library("tidyverse")

#today the object is to learn 6 functions

#filter is for rows, where the select is for coloumns
#mutate: is to merge data and creating a new coloumn 
# = an assignment key, excacly as AND == finding specific values

interviews <- read_csv("data/SAFI_clean.csv", na = "NULL")
#NULL - is a missing value - we want it to show as "na" 

interviews$memb_assoc


# group_by(village) - splitting the data into villages
interviews %>% 
  group_by(village, memb_assoc) %>% 
  summarize(mean_no_membrs = mean(no_membrs))

#filter out missing values from the chosen data
interviews %>% 
  filter(!is.na(memb_assoc)) %>% 
    group_by(village, memb_assoc) %>% 
    summarize(mean_no_membrs = mean(no_membrs))
#here we get only six rows - the order is often irrelevant for the code, but this is perhabs more effecient

#ordering accord. to the size of something - arrange sorts daata - gives by default accending roder
interviews %>% 
  filter(!is.na(memb_assoc)) %>% 
  group_by(village, memb_assoc) %>% 
  summarize(mean_no_membrs = mean(no_membrs)) %>% 
  arrange(mean_no_membrs)

#can be made descending: 
interviews %>% 
  filter(!is.na(memb_assoc)) %>% 
  group_by(village, memb_assoc) %>% 
  summarize(mean_no_membrs = mean(no_membrs)) %>% 
  arrange(desc(mean_no_membrs))

#are the samples representative? - avr. can hide outliers

interviews %>%  
    group_by(village) %>%  
  count()

#looking more deeply at the statistics: n adds up the observations in grouping coloumns
interviews %>%  
  group_by(village) %>%  
  summarise(mean_no_membrs = mean(no_membrs),
       min_no_membrs = min(no_membrs),
       max_no_membrs = max(no_membrs),
       count = n())
#for danish monarch we need to create a new coloumn and maybe filter the monarchs that