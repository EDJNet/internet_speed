if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, sf)

## We need to match the data at the city level with their respective regions and countries
## The dataset obtained by this matching will be used for the maps and the density plots
matcher <- read_csv("https://raw.githubusercontent.com/EDJNet/lau_centres/main/lau_nuts_concordance_by_geo/lau_2020_nuts_2021_concordance_by_geo.csv") %>%
  select(gisco_id, nuts_2) %>% 
  left_join(nuts_2 %>% 
              st_set_geometry(NULL) %>% 
              rename("nuts_2" = "id",
                     "region" = "name")) 

lau_matched <- read_csv(here("data", "lau", "lau_2022_1.csv")) %>% 
  mutate(country_id = substr(id, 1, 2)) %>% 
  drop_na(avg_d) %>% #some small cities do not have data and their internet speed is NA
  left_join(matcher, by = c("id" = "gisco_id")) %>% 
  left_join(lau) %>% 
  left_join(nuts_0 %>% 
              st_set_geometry(NULL) %>% 
              rename("country_id" = "id", "Country" = "name")) %>% 
  mutate(City = name,
         Country = str_replace_all(Country, "/", "-"),
         region = str_replace_all(region, "/", "-"),
         "Average Download Speed" = avg_d %>% paste0(" Mbps"),
         "Average Upload Speed" = avg_u %>% paste0(" Mbps"),
         "Average Latency" = avg_l %>% paste0(" ms")) %>% 
  st_set_geometry(.$geometry)
