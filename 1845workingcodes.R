# henter data men ikke på den både jeg skal! blot for at komme igang
library(readr)
census_1845_cleancsv <- read_csv("OneDrive - Aarhus universitet/Uni rigtig/DAM/Final project/project data/datasets-master/censuses/1845/census_1845_cleancsv.csv")
library(tidyverse)

# view data to check it is correct
view(census_1845_cleancsv)

top_occupation <- census_1845_cleancsv %>% 
  count(occupation, sort = TRUE) %>% 
  slice_max(n, n = 30)

# hutigt graf som er svær at aflæse
top_occupation %>% 
  ggplot(aes(x = reorder(occupation, n), y = n)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "De mest udbredte kvindelige erhverv i 1845",
    x = "Occupation",
    y = "Amount of women"
  )

# logaritme transformeret ikke god formidling
top_occupation %>% 
  ggplot(aes(x = reorder(occupation, n), y = n)) +
  geom_col(fill = "steelblue") +
  scale_y_log10() +
  coord_flip() +
  labs(
    title = "Hyppigste kvindelige erhverv (log-skala)",
    y = "Antal kvinder (log10)"
  )

# færre erhverv
top10 <- census_1845_cleancsv %>% 
  count(occupation, sort = TRUE) %>% 
  slice_max(n, n = 10)

ggplot(top10, aes(x = reorder(occupation, n), y = n)) +
  geom_col(fill = "darkgreen") +
  coord_flip() +
  labs(title = "Top 10 kvindelige erhverv i 1845")

# med andel
andel <- census_1845_cleancsv %>% 
  count(occupation) %>% 
  mutate(pct = n / sum(n))

ggplot(andel, aes(x = reorder(occupation, pct), y = pct)) +
  geom_col(fill = "purple") +
  scale_y_continuous(labels = scales::percent) +
  coord_flip() +
  labs(title = "Andel af kvinder i hvert erhverv (1845)")

## forsøg der virker!!
kvinder_top10 <- census_1845_cleancsv %>% 
  filter(occupation %in% top10$occupation)

kvinder_top10 %>% 
  count(occupation, alder_gruppe) %>% 
  ggplot(aes(x = reorder(occupation, n), y = n, fill = alder_gruppe)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Top 10 erhverv med aldersfordeling (1845)",
    x = "Erhverv",
    y = "Antal kvinder",
    fill = "Aldersgruppe"
  )


# et andet ikke så godt forsøg
top10 %>% 
  count(occupation) %>% 
  ggplot(aes(x = occupation, y = n)) +
  geom_col() +
  facet_wrap(~ occupation, scales = "free_y") +
  theme(axis.text.x = element_blank()) +
  labs(title = "Erhverv fordelt i separate paneler")

## noget med alder
census_1845_cleancsv <- census_1845_cleancsv %>% 
  mutate(alder_gruppe = cut(
    age,
    breaks = c(15, 25, 40, 60, Inf),
    labels = c("15-25", "26-40", "41-60", "60+"),
    right = FALSE
  ))

# alder fordeling pr. occupation
alder_fordeling <- census_1845_cleancsv %>% 
  count(occupation, alder_gruppe) %>% 
  group_by(occupation) %>% 
  mutate(pct = n / sum(n) * 100)

alder_fordeling

census_1845_cleancsv %>% 
  ggplot(aes(x = occupation, fill = alder_gruppe)) +
  geom_bar(position = "fill") +
  coord_flip() +
  scale_y_continuous(labels = scales::percent) +
  labs(
    title = "Aldersfordeling blandt kvinder i de mest udbredte erhverv (1845)",
    x = "Erhverv",
    y = "Andel"
  )
