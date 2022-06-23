## Libraries
if (!require("pacman")) install.packages("pacman")
pacman::p_load_gh("teamookla/ooklaOpenDataR") # Source for Speedtest data
pacman::p_load_gh("giocomai/latlon2map") # Source for European geometries
pacman::p_load(tidyverse, 
               sf, 
               here, 
               lubridate)


## Geometries
lau <- ll_get_lau_eu() %>% 
  rename("id" = "GISCO_ID",  
         "name" = "LAU_NAME") %>% 
  select(id, name) 

nuts_3 <- ll_get_nuts_eu(level = 3, resolution = 1) %>% 
  rename("id" = "NUTS_ID", 
         "name" = "NAME_LATN") %>% 
  select(id, name) 

nuts_2 <- ll_get_nuts_eu(level = 2, resolution = 1) %>%
  rename("id" = "NUTS_ID", 
         "name" = "NAME_LATN") %>% 
  select(id, name)

nuts_0 <- ll_get_nuts_eu(level = 0, resolution = 1) %>%
  rename("id" = "NUTS_ID", 
         "name" = "NAME_LATN") %>% 
  select(id, name)


## Vectors to loop 
year <- c(2019, 2020, 2021, 2022)
quarter <- c(1, 2, 3, 4)
level <- c("lau", "nuts_3", "nuts_2", "nuts_0") 


## Folders
dir.create(here("data"))
dir.create(here("data", "raw_data"))


## Turn off spherical geometries
sf_use_s2(F)


## Loop to download raw data/analyse/write outputs
for (i in year) {
  
  for (j in quarter) {

      if (!file.exists(here("data", "raw_data", paste(i, j, sep = "_") %>% paste0(".rds")))) {
          
          df <- get_performance_tiles("fixed", year = i, quarter = j, sf = T) %>%
          write_rds(here("data", "raw_data", paste(i, j, sep = "_") %>% paste0(".rds"))) 
      
      for (k in level) {
        
       dir.create(here("data", k)) 
        
        st_join(get(k), df) %>% 
          st_set_geometry(NULL) %>%
          group_by(id, name) %>% 
          summarise(across(contains("avg"), weighted.mean, w = tests, na.rm = T)) %>% 
          mutate(quarter = yq(paste(i, j, sep = "_")),
                 avg_d = round(avg_d_kbps/1000, 2), 
                 avg_u = round(avg_u_kbps/1000, 2),
                 avg_l = round(avg_lat_ms, 2), 
                 .keep = "unused") %>%
          write_csv(here("data", k, paste(k, i, j, sep = "_") %>% paste0(".csv")))
        
      }

    } else {

        df <- read_rds(here("data", "raw_data", paste(i, j, sep = "_") %>% paste0(".rds")))
      
      for (k in level) {
        
        dir.create(here("data", k)) 
        
        st_join(get(k), df) %>%
          st_set_geometry(NULL) %>%
          group_by(id) %>% 
          summarise(across(contains("avg"), weighted.mean, w = tests, na.rm = T)) %>% 
          mutate(quarter = yq(paste(i, j, sep = "_")),
                 avg_d = round(avg_d_kbps/1000, 2),
                 avg_u = round(avg_u_kbps/1000, 2),
                 avg_l = round(avg_lat_ms, 2), 
                 .keep = "unused") %>%
          write_csv(here("data", k, paste(k, i, j, sep = "_") %>% paste0(".csv")))
        
      }
      
    }
    
  }
  
}


## Timeseries
dir.create(here("data", "timeseries"))

for (k in level) {
  
  list.files(here("data", k)) %>%
    map_df(~read_csv(here("data", k, .x))) %>% 
    arrange(id, quarter) %>% 
    write_csv(here("data", "timeseries", paste("timeseries_", ".csv", sep = k)))
  
}
