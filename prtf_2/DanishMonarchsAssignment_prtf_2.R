
#loading the kings
library(tidyverse)
kings <- read_csv2("prtf_2/prtf_2_data/danishmonarchscsv.csv", na = c("na"))

class(kings)
glimpse(kings)

head(kings)
glimpse(kings)

kings <- kings %>%
  mutate(duration = if_else(
    is.na(beg_reg_y) | is.na(end_reg_y),
    NA_real_,                 
    end_reg_y - beg_reg_y 
  ))

kings %>%
  summarise(mean(duration, na.rm=TRUE)) 
avg_duration <- kings %>%
  summarise(avg = mean(duration, na.rm = TRUE)) %>%
  pull(avg) 

above_avg <- kings %>%
  filter(duration >avg_duration) %>%
  count() 

top_three <- kings %>%
  arrange(desc(duration)) %>% 
  slice_head(n = 3) 

top_three_days_simple <- top_three %>%
  mutate(Days = duration * 365L)
view(top_three)

count_leaps <- function(start_year, end_year) { 
  yrs <- seq(start_year, end_year - 1)              
  is_leap <- (yrs %% 400 == 0) | (yrs %% 4 == 0 & yrs %% 100 != 0) 
  sum(is_leap, na.rm = TRUE)
}

top_three_days_bonus <- top_three %>%
  rowwise() %>% # does it row by row
  mutate(
    LeapDays = count_leaps(beg_reg_y, end_reg_y), #counts leap years
    Days_adjusted = duration * 365L + LeapDays      # years in days + leap days 
  ) %>%
  ungroup() 

select(top_three_days_bonus, name, Days_adjusted)

#challenge: plot the duration of reign in time

kings <- kings %>%
  mutate(midyear = beg_reg_y + (duration / 2)       
  )

kings_clean <- kings %>%  
  filter(!is.na(midyear), !is.na(duration))

library(ggplot2)

Duration_over_time <- ggplot(kings_clean, aes(x = midyear, y = duration)) +
  geom_point(size = 3, alpha = 0.7) + 
  geom_smooth(method = "loess", se = FALSE, color = "blue") +
  theme_bw(base_size = 16) +     
  labs(
    title = "Duration of Reign Over Time",
    x = "Midyear of Reign",
    y = "Duration of Reign (years)") +
  theme(
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    axis.title = element_text(size = 16)
  )

Duration_over_time

ggsave("fig_output/Duration_over_time.tiff",
       plot = Duration_over_time,
       width = 10,
       height = 5
)

