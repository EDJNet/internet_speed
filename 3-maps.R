if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, here, leaflet, leaflet.extras, leafpop, cartography, htmlwidgets)

## Folders to set the outputs
dir.create(here("visualizations"))
dir.create(here("visualizations", "maps"))
dir.create(here("visualizations", "maps", "countries"))
dir.create(here("visualizations", "maps", "regions"))

## Countries map
setwd(here("visualizations", "maps", "countries"))

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
  
  htmlwidgets::saveWidget(map, i %>% paste0(".html"), selfcontained = T)
  
}

## NUTS2 regions maps
setwd(here("visualizations", "maps", "regions"))

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
  
  htmlwidgets::saveWidget(map, i %>% paste0(".html"), selfcontained = T)
  
}