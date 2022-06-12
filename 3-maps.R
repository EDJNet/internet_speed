## Libraries
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, 
               sf, 
               here, 
               leaflet, 
               leaflet.extras, 
               leafpop, 
               cartography, 
               htmlwidgets)

## Folders for outputs
dir.create(here("visualizations"))
dir.create(here("visualizations", "maps"))

setwd(here("visualizations", "maps"))


## NUTS2 regions maps
region <- lau_matched %>% 
  pull(region) %>% 
  unique()


for (i in region) {
  
  lau_i <- lau_matched %>% filter(region == i)
  
  bins <- c(0,10,20,30,40,50,60,70,80,90,100,120,140,160,180,200,1200)
  
  qpal <- colorBin(palette = cartography::carto.pal("turquoise.pal", 20), 
                   domain = lau_i$avg_d,
                   bins = bins)
  
  map <- leaflet() %>%
    addProviderTiles(providers$CartoDB.PositronNoLabels) %>% 
    addPolygons(data = lau_i,
                fillColor = ~qpal(lau_i$avg_d),
                fillOpacity = 1,
                smoothFactor = .2,
                color = "#5d5d5d",
                opacity = .2,
                weight = .25,
                label = ~City,
                group = "City",
                popup = popupTable(lau_i,
                                   zcol = c(12:15), 
                                   row.numbers = F,
                                   feature.id = F)) %>% 
    addLegend(pal = qpal,
              values = lau_i$avg_d,
              opacity = 1,
              position = "bottomright",
              title = "Download speed (Mbps)")  %>%
    addSearchFeatures(targetGroups = 'City',
                      options = searchFeaturesOptions(zoom = 11,
                                                      openPopup = T,
                                                      hideMarkerOnCollapse = T))
  
  saveWidget(map, i %>% paste0(".html"), selfcontained = T)
  
}


## Countries map
country <- lau_matched %>%
  pull(Country) %>% 
  unique()


for (i in country) {
  
  lau_i <- lau_matched %>% filter(Country == i)
  
  bins <- c(0,10,20,30,40,50,60,70,80,90,100,120,140,160,180,200,1200)
  
  qpal <- colorBin(palette = cartography::carto.pal("turquoise.pal", 20), 
                   domain = lau_i$avg_d,
                   bins = bins)
  
  map <- leaflet() %>%
    addProviderTiles(providers$CartoDB.PositronNoLabels) %>% 
    addPolygons(data = lau_i,
                fillColor = ~qpal(lau_i$avg_d),
                fillOpacity = 1,
                smoothFactor = .2,
                color = "#5d5d5d",
                opacity = .2,
                weight = .25,
                label = ~City,
                group = "City",
                popup = popupTable(lau_i,
                                   zcol = c(12:15), 
                                   row.numbers = F,
                                   feature.id = F)) %>% 
    addLegend(pal = qpal,
              values = lau_i$avg_d,
              opacity = 1,
              position = "bottomright",
              title = "Download speed (Mbps)")  %>%
    addSearchFeatures(targetGroups = 'City',
                      options = searchFeaturesOptions(zoom = 11,
                                                      openPopup = T,
                                                      hideMarkerOnCollapse = T)) 
  
  saveWidget(map, i %>% paste0(".html"), selfcontained = T)
  
}


## European maps
euro_maps <- c("nuts_0", "nuts_2", "nuts_3")


for (i in euro_maps) {
  
  level_i <- read_csv(here("data", i, i %>% paste("2022_1.csv", sep = "_"))) %>% 
    left_join(get(i)) %>% 
    mutate(Name = name, 
           "Average Download Speed" = avg_d %>% paste0(" Mbps"),
           "Average Upload Speed" = avg_u %>% paste0(" Mbps"),
           "Average Latency" = avg_l %>% paste0(" ms")) %>% 
    st_set_geometry(.$geometry)
  
  bins <- c(0,10,20,30,40,50,60,70,80,90,100,120,140,160,180,200,1200)
  
  qpal <- colorBin(palette = cartography::carto.pal("turquoise.pal", 20), 
                   domain = level_i$avg_d,
                   bins = bins)
  
  map <- leaflet() %>%
    addProviderTiles(providers$CartoDB.PositronNoLabels) %>% 
    addPolygons(data = level_i,
                fillColor = ~qpal(level_i$avg_d),
                fillOpacity = 1,
                smoothFactor = .2,
                color = "#5d5d5d",
                opacity = .2,
                weight = .25,
                label = ~Name,
                group = "Name",
                popup = popupTable(level_i,
                                   zcol = c(8:11), 
                                   row.numbers = F,
                                   feature.id = F)) %>% 
    addPolylines(data = nuts_0 %>% 
                   st_cast("MULTILINESTRING"),
                 fillColor = NULL,
                 color = "#FAF9F6",
                 opacity = 1,
                 weight = .65) %>% 
    addLegend(pal = qpal,
              values = lau_i$avg_d,
              opacity = 1,
              position = "bottomright",
              title = "Download speed (Mbps)")  %>%
    addSearchFeatures(targetGroups = 'City',
                      options = searchFeaturesOptions(zoom = 11,
                                                      openPopup = T,
                                                      hideMarkerOnCollapse = T)) %>% 
    setView(13.3, 47.13, 5)
  
  saveWidget(map, i %>% paste0(".html"), selfcontained = T)
  
}
