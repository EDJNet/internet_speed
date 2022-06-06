## In order to upload the visualizations we need to remove spaces and commas; and uniform the encoding 

# For the htmls
file.rename(list.files(here("visualizations", "maps", "all_maps"), full.names = T), 
            str_replace_all(list.files(here("visualizations", "maps", "all_maps"), full.names = T), " ", "_"))

file.rename(list.files(here("visualizations", "maps", "all_maps"), full.names = T), 
            str_replace_all(list.files(here("visualizations", "maps", "all_maps"), full.names = T), ",", ""))

file.rename(list.files(here("visualizations", "maps", "all_maps"), full.names = T), 
            stringi::stri_trans_general(list.files(here("visualizations", "maps", "all_maps"), full.names = T), "Latin-ASCII"))


# For the pngs
file.rename(list.files(here("visualizations", "density_plots"), full.names = T), 
            str_replace_all(list.files(here("visualizations", "density_plots"), full.names = T), " ", "_"))

file.rename(list.files(here("visualizations", "density_plots"), full.names = T), 
            str_replace_all(list.files(here("visualizations", "density_plots"), full.names = T), ",", ""))

file.rename(list.files(here("visualizations", "density_plots"), full.names = T), 
            stringi::stri_trans_general(list.files(here("visualizations", "density_plots"), full.names = T), "Latin-ASCII"))


## We also need to create a file for the dropdown selector
selector <- lau_matched %>% 
  st_set_geometry(NULL) %>% 
  select(country_id, region) %>% 
  unique() %>% 
  arrange(country_id, region) %>% 
  mutate(region = str_replace_all(region, ",", ""),
         region = stringi::stri_trans_general(region, "Latin-ASCII")) %>% 
  write_csv("selector_az.csv")