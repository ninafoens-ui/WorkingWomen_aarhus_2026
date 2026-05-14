#model for coding final project: 
library(tidyverse)

data_1845 <- read.csv("data/census_1845_cleancsv.csv", na= c("na"))

glimpse(data_1845)
head(data_1845)

top_occupation_data_45 <- data_1845 %>% 
  count(occupation, sort = TRUE) %>% 
  slice_max(n, n = 30)

write_csv(
  top_occupation_data_45,
  "data_output/top_occupation_data_45.csv"
)

# simple graf with too much data
top_occupation_45 <- top_occupation_data_45 %>% 
  ggplot(aes(x = reorder(occupation, n), y = n)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "De mest udbredte kvindelige erhverv i 1845",
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
  labs(title = "Top ti kvindelige erhverv i 1845")

top_10_simple_45 

ggsave("fig_output/top_10_simple_45.tiff",
       plot = top_10_simple_45,
       width = 10,
       height = 5
) 

## the age distributed values plotted
kvinder_top10_45 <- data_1845 %>% 
  filter(occupation %in% top10$occupation) %>%
  mutate(age_group = cut(
   age,
    breaks = c(15, 25, 40, 60, 100),
    labels = c("15-25", "26-40", "41-60", "60+")
  ))

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
    title = "Top 10 erhverv med aldersfordeling (1845)",
    x = "Erhverv",
    y = "Antal kvinder",
    fill = "Aldersgruppe"
  )
coloumn_occupation_45 

ggsave("fig_output/coloumn_occupation_45.tiff",
plot = coloumn_occupation_45,
width = 10,
height = 5
)   

coloumn_occupation_45

#occupation fordelt på alder
#kvinder_top10

heatmap_data_45 <- kvinder_top10_45 %>% count(occupation, age_group)

write_csv(
  heatmap_data_45,
  "data_output/heatmap_data_45.csv"
)  

ggplot(heatmap_data,
       aes(x = age_group,
           y = occupation,
           fill = n,)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "blue") +
  labs(
    title = "Women's occupations by age group",
    x = "Age group",
    y = "Occupation",
    fill = "Count", 
  )

#trying to make the visual, but removing the unpaid labour and/or people who is not able to support themselves

data_1845_paid <- data_1845 %>% 
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
    "indsidderske"
  )) %>% 
  mutate(age_group = cut(
    age,
    breaks = c(15, 25, 40, 60, 100),
    labels = c("15-25", "26-40", "41-60", "60+")
  ))

write_csv(
  data_1845_paid,
  "data_output/data_1845_paid.csv"
)

coloumn_occupation_paid <- data_1845_paid %>% 
  count(occupation, sort = TRUE, age_group) %>% 
           slice_max(n, n = 20) %>% 
  ggplot(aes(x = reorder(occupation, n), y = n, fill = age_group)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Top 10 erhverv med aldersfordeling (1845)",
    x = "Erhverv",
    y = "Antal kvinder",
    fill = "Aldersgruppe"
  )
print(coloumn_occupation_paid)

ggsave("fig_output/coloumn_occupation_paid.tiff",
       plot = coloumn_occupation_paid,
       width = 10,
       height = 5
)
