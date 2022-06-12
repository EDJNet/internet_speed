## Libraries
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse,
               sf)

## In order to have hierarchical territorial units shown in the tables

matcher <- read_csv("https://raw.githubusercontent.com/EDJNet/lau_centres/main/lau_nuts_concordance_by_geo/lau_2020_nuts_2021_concordance_by_geo.csv") %>%
  select(gisco_id, lau_name, country, nuts_2, nuts_3, population) %>%
  left_join(nuts_0%>% 
              st_set_geometry(NULL) %>% 
              rename("country" = "id",
                     "country_name" = "name")) %>% 
  left_join(nuts_2 %>% 
              st_set_geometry(NULL) %>% 
              rename("nuts_2" = "id",
                     "nuts_2_name" = "name")) %>%
  left_join(nuts_3 %>% 
              st_set_geometry(NULL) %>% 
              rename("nuts_3" = "id",
                     "nuts_3_name" = "name")) 


## Create the datasets for the tables and write them as csv

table_lau <- read_csv(here("data", "timeseries", "timeseries_lau.csv")) %>% 
  left_join(matcher, by = c("id" = "gisco_id")) %>% 
  filter(population >= 100000) %>%  
  mutate(country = str_replace_all(country, "EL", "GR")) %>% 
  mutate(Country = ":" %>% 
           paste0(country) %>% 
           paste(country_name, sep = ": ")) %>% 
  select(Country, nuts_2_name, nuts_3_name, lau_name, quarter, avg_d) %>% 
  pivot_wider(names_from = quarter, values_from = avg_d) %>% 
  mutate(Variation = round((`2022-01-01`-`2019-01-01`)/`2019-01-01`*100, 1)) %>%
  write_csv("table_lau.csv")


table_nuts_3 <- read_csv(here("data", "timeseries", "timeseries_nuts_3.csv")) %>% 
  left_join(matcher, by = c("id" = "nuts_3")) %>%
  mutate(country = str_replace_all(country, "EL", "GR")) %>% 
  mutate(Country = ":" %>% 
           paste0(country) %>% 
           paste(country_name, sep = ": ")) %>%
  select(Country, nuts_2_name, name, quarter, avg_d) %>%
  unique() %>% 
  pivot_wider(names_from = quarter, values_from = avg_d) %>%
  mutate(Variation = round((`2022-01-01`-`2019-01-01`)/`2019-01-01`*100, 1)) %>% 
  drop_na() %>% 
  write_csv("table_nuts_3.csv")


table_nuts_2 <- read_csv(here("data", "timeseries", "timeseries_nuts_2.csv")) %>% 
  left_join(matcher, by = c("id" = "nuts_2")) %>% 
  mutate(Country = ":" %>% 
           paste0(country) %>% 
           paste(country_name, sep = ": ")) %>% 
  select(Country, name, quarter, avg_d) %>%
  unique() %>% 
  pivot_wider(names_from = quarter, values_from = avg_d) %>% 
  mutate(Variation = round((`2022-01-01`-`2019-01-01`)/`2019-01-01`*100, 1)) %>% 
  drop_na() %>%
  write_csv("table_nuts_2.csv")


table_countries <- read_csv(here("data", "timeseries", "timeseries_nuts_0.csv")) %>% 
  mutate(Country = ":" %>% 
           paste0(id) %>% 
           paste(name, sep = ": ")) %>% 
  select(Country, quarter, avg_d) %>%
  unique() %>% 
  pivot_wider(names_from = quarter, values_from = avg_d) %>% 
  mutate(Variation = round((`2022-01-01`-`2019-01-01`)/`2019-01-01`*100, 1)) %>% 
  drop_na() %>% 
  write_csv("table_countries.csv")
