#This part has been coded by Andrea Sif Bragadóttir
#dataprocessing of the 1845 census data set 
library(tidyverse)
library(readr)

dir.create(data)
dir.create(data_output)
dir.create(fig_output)

data_1845 <- read.csv(
  "data/census_1845_cleancsv.csv",
  na.strings = c("", " ", "NA", "na")
  ) %>%  filter(!is.na(occupation))

glimpse(data_1845)
head(data_1845)

top_occupation_data_45 <- data_1845 %>% 
  count(occupation, sort = TRUE) %>% 
  slice_max(n, n = 30)

write_csv(
  top_occupation_data_45,
  "data_output/top_occupation_data_45.csv"
)

# simple graph with too much data
top_occupation_45 <- top_occupation_data_45 %>% 
  ggplot(aes(x = reorder(occupation, n), y = n)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    x = "Occupation",
    y = "Amount of women"
  )

top_occupation_45

ggsave("fig_output/top_occupation_45.tiff", top_occupation_45)

# fewer occupations
top10_45 <- data_1845 %>% 
  count(occupation, sort = TRUE) %>% 
  slice_max(n, n = 10)

write_csv(
  top10_45,
  "data_output/top10_45.csv"
)

top_10_simple_45 <- ggplot(top10_45, aes(x = reorder(occupation, n), y = n)) +
  geom_col(fill = "darkgreen") +
  coord_flip() +
  labs() +
  theme(
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    axis.title = element_text(size = 16)
  )

top_10_simple_45 

ggsave("fig_output/top_10_simple_45.tiff",
       plot = top_10_simple_45,
       width = 10,
       height = 5
) 

## the age distributed values plotted
kvinder_top10_45 <- data_1845 %>% 
  filter(occupation %in% top10_45$occupation) %>%
  mutate(
    age_group = cut(
      age,
      breaks = c(15, 25, 40, 60, 100),
      labels = c("15-25", "26-40", "41-60", "60+")
    ),
    
    age_group = replace_na(
      as.character(age_group),
      "Age unknown"
    )
  )

write_csv(
  kvinder_top10_45,
  "data_output/kvinder_top10_45.csv"
)

coloumn_occupation_45 <- kvinder_top10_45 %>% 
  count(occupation, age_group) %>% 
  ggplot(aes(x = reorder(occupation, n), y = n, fill = age_group)) +
  geom_col() +
  coord_flip() +
  labs(
    x = "Occupation",
    y = "amount of women",
    fill = "Age group"
  ) +
  theme(
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    axis.title = element_text(size = 16)
  )

coloumn_occupation_45 

ggsave("fig_output/coloumn_occupation_45.tiff",
plot = coloumn_occupation_45,
width = 10,
height = 5
)   

#This part has been coded by Nina Føns Sørensen
#trying to make the visual, but removing the unpaid labour and/or people who is not able to support themselves

data_1845_relevant <- data_1845 %>% 
  filter(!occupation %in% c(
    "familiemedlem",
    "fattiglem",
    "forsørges af familie",
    "NA",
    "husholderske",
    "huskone",
    "enke",
    "plejedatter", 
    "opholdskone", 
    "indsidderske", 
    "hustru", 
    "pension", 
    "aftægtskone",
    "lever af sine midler"
  ))

write_csv(
  data_1845_relevant,
  "data_output/data_1845_relevant.csv"
)

coloumn_occupation_relevant_45 <- data_1845_relevant %>% 
  count(occupation, sort = TRUE) %>% 
           slice_max(n, n = 10) %>% 
  ggplot(aes(x = reorder(occupation, n), y = n)) +
  geom_col(fill= "lightblue") +
  coord_flip() +
  labs(
    x = "Occupation",
    y = "Amount of Women",
  ) +
  theme(
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    axis.title = element_text(size = 16)
  )
print(coloumn_occupation_relevant_45)

ggsave("fig_output/coloumn_occupation_relevant_45.tiff",
       plot = coloumn_occupation_relevant_45,
       width = 10,
       height = 5
)
