#model for coding final project: 
library(tidyverse)

data_1860 <- read.csv("data/census_1860_normalized_clean_csv.csv", na= c("na"))

glimpse(data_1860)
head(data_1860)

top_occupation_data_60 <- data_1860 %>% 
  count(stilling, sort = TRUE) %>% 
  slice_max(n, n = 30)


write_csv(
  top_occupation_data_60,
  "data_output/top_occupation_data_60.csv"
)

# simple graf with too much data
top_occupation_60 <- top_occupation_data_60 %>% 
  ggplot(aes(x = reorder(stilling, n), y = n)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "De mest udbredte kvindelige erhverv i 1845",
    x = "Occupation",
    y = "Amount of women"
  )

ggsave("fig_output/top_occupation_60.tiff", top_occupation_60)

# færre erhverv
top10_60 <- data_1860 %>% 
  count(stilling, sort = TRUE) %>% 
  slice_max(n, n = 10)

write_csv(
  top10_60,
  "data_output/top10_60.csv"
)

top_10_simple_60 <- ggplot(top10, aes(x = reorder(stilling, n), y = n)) +
  geom_col(fill = "darkgreen") +
  coord_flip() +
  labs(title = "Top ti kvindelige erhverv i 1845")

ggsave("fig_output/top_10_simple_60.tiff",
       plot = top_10_simple,
       width = 10,
       height = 5
) 

## the age distributed values plotted
kvinder_top10_60 <- data_1860 %>% 
  filter(stilling %in% top10$stilling) %>%
  mutate(age_group = cut(
    alder,
    breaks = c(15, 25, 40, 60, 100),
    labels = c("15-25", "26-40", "41-60", "60+")
  ))
write_csv(
  kvinder_top10_60,
  "data_output/kvinder_top10_60.csv"
)

coloumn_occupation_60 <- kvinder_top10_60 %>% 
  count(stilling, age_group) %>% 
  ggplot(aes(x = reorder(stilling, n), y = n, fill = age_group)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Top 10 erhverv med aldersfordeling (1860)",
    x = "Erhverv",
    y = "Antal kvinder",
    fill = "Aldersgruppe"
  )

coloumn_occupation_60 

ggsave("fig_output/coloumn_occupation_60.tiff",
       plot = coloumn_occupation_60,
       width = 10,
       height = 5
)   

coloumn_occupation_60

#occupation fordelt på alder
#kvinder_top10

heatmap_data_60 <- kvinder_top10_60 %>% count(stilling, age_group)

write_csv(
  heatmap_data_60,
  "data_output/heatmap_data_60.csv"
)  

ggplot(heatmap_data_60,
       aes(x = age_group,
           y = stilling,
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

data_1860_paid <- data_1860 %>% 
  filter(!stilling %in% c(
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
    alder,
    breaks = c(15, 25, 40, 60, 100),
    labels = c("15-25", "26-40", "41-60", "60+")
  ))

write_csv(
  data_1860_paid,
  "data_output/data_1860_paid.csv"
)

coloumn_occupation_paid_60 <- data_1860_paid %>% 
  count(stilling, sort = TRUE, age_group) %>% 
  slice_max(n, n = 20) %>% 
  ggplot(aes(x = reorder(stilling, n), y = n, fill = age_group)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Top 10 erhverv med aldersfordeling (1845)",
    x = "Erhverv",
    y = "Antal kvinder",
    fill = "Aldersgruppe"
  )
print(coloumn_occupation_paid)

ggsave("fig_output/coloumn_occupation_paid_60.tiff",
       plot = coloumn_occupation_paid,
       width = 10,
       height = 5
)
