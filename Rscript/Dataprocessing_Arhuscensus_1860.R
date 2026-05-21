#This part has been coded by Nina Føns Sørensen
library(tidyverse)


data_1860 <- read.csv("data/census_1860_cleancsv.csv", na.strings = c("", " ", "NA", "na")) %>% 
  filter(!is.na(stilling),
    stilling != "Fejldata - mænd (sønner, husfædre, tjenestekarle)", # only keeps if occupations is not "Fejlkilde"
    koen != "mand",
    alder >= 15
  ) %>%  
  filter(amt %in% c("Århus", "Randers"))

glimpse(data_1860)
head(data_1860)


top_occupation_data_60 <- data_1860 %>% 
  count(stilling, sort = TRUE) %>% 
  slice_max(n, n = 30)


write_csv(
  top_occupation_data_60,
  "data_output/top_occupation_data_60.csv"
)

# simple graph with too much data
top_occupation_60 <- top_occupation_data_60 %>% 
  ggplot(aes(x = reorder(stilling, n), y = n)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    x = "Occupation",
    y = "Amount of women"
  )

top_occupation_60

# færre erhverv
top10_60 <- data_1860 %>% 
  count(stilling, sort = TRUE) %>% 
  slice_max(n, n = 10)

write_csv(
  top10_60,
  "data_output/top10_60.csv"
)

top_10_simple_60 <- ggplot(top10_60, aes(x = reorder(stilling, n), y = n)) +
  geom_col(fill = "darkgreen") +
  coord_flip() +
  labs() +
  theme(
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    axis.title = element_text(size = 16)
  )

top_10_simple_60

## the age distributed values plotted
kvinder_top10_60 <- data_1860 %>% 
  filter(stilling %in% top10_60$stilling) %>%
  mutate(
    age_group = cut(
      alder,
      breaks = c(15, 25, 40, 60, 100),
      labels = c("15-25", "26-40", "41-60", "60+")
    ),
    
    age_group = replace_na(
      as.character(age_group),
      "Age unknown"
    )
  )
write_csv(
  kvinder_top10_60,
  "data_output/kvinder_top10_60.csv"
)

# figure 4 for final project
coloumn_occupation_60 <- kvinder_top10_60 %>% 
  count(stilling, age_group) %>% 
  ggplot(aes(x = reorder(stilling, n), y = n, fill = age_group)) +
  geom_col() +
  coord_flip() +
  labs(
    x = "Erhverv",
    y = "Antal kvinder",
    fill = "Aldersgruppe"
  ) +
  theme(
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    axis.title = element_text(size = 16)
  )

Figure_4 <- coloumn_occupation_60 

ggsave("fig_output/Figure_4.tiff",
       plot = Figure_4,
       width = 10,
       height = 5
)   

#This part has been coded by Andrea Sif Bragadóttir

# we will only look at some occupations
relevant_occupation <- c("jordmoder","tjenestepige", "håndarbejder", "vaskekone", "husholderske", "ejerinde", "lærerinde", "daglejer", "mejerske", "kokkepige", "amme", "handel", "modehandlerinde", "skuespillerinder", "fabriksarbejder", "fabrikshåndarbejder", "barnepige", "husbestyrerinde", "bryggerpige", "bager", "bondepige")

# figure 2 for final project
# figure of top 10 relevant occupations 1860
Figure_2 <- data_1860 %>%
  filter(stilling %in% relevant_occupation) %>%
  count(stilling, sort = TRUE) %>% 
  slice_max(n, n = 10) %>% 
  ggplot(aes(x = reorder(stilling, n), y = n)) +
  geom_col(fill = "lightblue") +
  coord_flip() +
  labs(
    x = "Occupation",
    y = "Number of women"
  ) +
  theme(
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    axis.title = element_text(size = 16)
  )

Figure_2

ggsave("fig_output/Figure_2.tiff",
       plot = Figure_2,
       width = 10,
       height = 5
)