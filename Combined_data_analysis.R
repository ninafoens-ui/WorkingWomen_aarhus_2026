#This part has been coded by Luna Marie Schwartz Marcher

library(tidyverse)
library(readr)

dir.create(data)
dir.create(data_output)
dir.create(fig_output)

census_1845_cleancsv <- read_csv("data/census_1845_cleancsv.csv")
census_1860_cleancsv <- read_csv("data/census_1860_cleancsv.csv")

names(census_1845_cleancsv)
names(census_1860_cleancsv)

#loading and naming the datasets to make them ready to combine them
data_1845_small <- census_1845_cleancsv %>% 
  select(occupation, occupation_original, age, gender, county, parish, marital_status) %>% 
  mutate(year = 1845)

data_1860_small <- census_1860_cleancsv %>% 
  select(stilling, stilling_original, alder, koen, sogn, amt, civilstand) %>% 
  mutate(year = 1860)

#translation of the 1860 dataset
data_1860_small <- data_1860_small %>% 
  rename(
    occupation = stilling,
    occupation_original = stilling_original,
    age = alder,
    gender = koen,
    parish = sogn,
    county = amt,
    marital_status = civilstand
  )


#removing errors 
data_1860_small <- data_1860_small %>% 
  filter(
    occupation != "Fejldata - mænd (sønner, husfædre, tjenestekarle)", # only keeps if occupations is not "Fejlkilde"
    gender != "mand",
    age >= 15
  )

census_small <- bind_rows(data_1845_small, data_1860_small)
glimpse(census_small)

#further standardising
census_small$occupation[census_small$occupation == "fabrikshåndarbejder"] <- "fabriksarbejder"

#correction of a spelling error
census_small$occupation[census_small$occupation == "jordemoder"] <- "jordmoder"

#making the ages grouped to better the visualisation
census_small <- census_small %>% 
  mutate(age_group = cut(
    age,
    breaks = c(15, 25, 40, 60, Inf),
    labels = c("15-25", "26-40", "41-60", "60+"),
    right = TRUE 
  ))

#Removing counties that does not match the other dataset
unique(data_1860_small$county)
unique(data_1845_small$county)
table(data_1860_small$county)
table(data_1845_small$county)

census_small <- census_small %>% 
  filter(county %in% c("Århus", "Randers"))

unique(census_small$county)


#### Analysis

#only top occupations
census_small %>% 
  count(occupation, sort = TRUE)

census_small %>% 
  count(year, occupation, sort = TRUE)

 
#objects to analyse
  # made based on the most common occupations in the individual analysis
relevant_occupation <- c("jordmoder","tjenestepige", "håndarbejder", "vaskekone", "husholderske", "ejerinde", "lærerinde", "daglejer", "mejerske", "kokkepige", "amme", "handel", "modehandlerinde", "skuespillerinder", "fabriksarbejder", "fabrikshåndarbejder", "barnepige", "husbestyrerinde", "bryggerpige", "bager", "bondepige")
relevant_småerhverv <- c("jordmoder", "vaskekone", "lærerinde", "daglejer", "mejerske", "kokkepige", "amme", "handel", "modehandlerinde", "skuespillerinder", "fabriksarbejder", "fabrikshåndarbejder", "barnepige", "bryggerpige", "bager", "institutbestyrerinde")


total_pr_år <- census_small %>% 
  count(year, name = "total_kvinder")


census_small_fig <- census_small %>% 
  filter(occupation %in% relevant_småerhverv) %>%
  count(year, occupation) %>% 
  left_join(total_pr_år, by = "year") %>% 
  mutate(pct = n / total_kvinder) %>% 
  ggplot(aes(x = occupation, y = pct, fill = factor(year))) +
  geom_col(position = "dodge") +
  coord_flip() +
  scale_y_continuous(labels = scales::percent) +
  labs(
    x = "Occupation",
    y = "Proportion of women",
    fill = "Year"
  ) +
  theme(
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    axis.title = element_text(size = 16)
  )

census_small_fig
ggsave("fig_output/census_small_fig.tiff",
       plot = census_small_fig,
       width = 10,
       height = 5
)
