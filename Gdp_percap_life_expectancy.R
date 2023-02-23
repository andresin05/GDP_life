# The objective of this script in R is to compute the relationship between the
# gdp percapita and the life expectancy from the countries

# Libraries
library("tidyverse") # For data manipulation and visualization
library("gganimate") # For gif animation
library("gifski")
library("png")
library("scales")

theme_set(theme_bw()) # For theme of graphics

# Data frame is from World Bank (Databank)
setwd("~/R/Data")

gdp_life <- read_csv("gdp_percap_life_expectancy_1960_2021.csv") %>% 
  select(-c("Time Code",
            "Country Code"))

gdp_life <- as.data.frame(gdp_life) 

colnames(gdp_life) <- c("year",
                        "country",
                        "gdp_percapita",
                        "population",
                        "life_expectancy")

 # Formating the data
  # Drop NA´s
gdp_life[gdp_life == ".."] <- NA
gdp_life <- drop_na(gdp_life)
  
  # Numeric Format
gdp_life[c("year",
           "gdp_percapita",
           "population",
           "life_expectancy")] <- sapply(gdp_life[c("year",
                                                    "gdp_percapita",
                                                    "population",
                                                    "life_expectancy")], 
                                         as.numeric)

# Static plot
options(scipen = 999)

plot <- ggplot(
  data = gdp_life, 
  aes(x = gdp_percapita, 
      y= life_expectancy, 
      size = population, 
      colour = country)
  ) +
  geom_point(show.legend = FALSE, alpha = 0.7) +
  scale_color_viridis_d() +
  scale_size(range = c(2, 12)) +
  scale_x_log10(labels = scales::label_number_si()) +
  labs(x = "GDP per capita", y = "Life expectancy",
       caption = "Data source: World Bank")
plot

# Animated transitions trought time
setwd("~/R/Programs/Figures/gdp_life_population")

gdp_life_populaton <- plot + transition_time(year) +
  labs(title = "Year: {round(frame_time)}")

animate(gdp_life_populaton, duration = 20, height = 500, width = 500, renderer = gifski_renderer())
anim_save("gdp_life_population.gif")
