## Libraries
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, 
               here, 
               cowplot, 
               ggtext)

dir.create(here("visualizations", "density_plots"))

## Density plots regions

region <- lau_matched %>%
  pull(region) %>% 
  unique()

for (i in region) {
  
  region_i <- lau_matched %>% filter(region == i)
  
  country_i <- lau_matched %>% filter(country_id == unique(region_i$country_id))
  
  if(nrow(region_i) == 1) {
    
    plt <- ggplot() + 
      geom_segment(aes(x = 64, y = 0, xend = 64, yend = Inf), size = 1, linetype = 2) +
      geom_density(data = lau_matched, aes(avg_d), color = "#283377", fill = "#283377", alpha = .2, size = 1) +
      geom_density(data = country_i, aes(avg_d), color = "#337728", fill = "#337728", alpha = .2, size = 1) +
      geom_segment(aes(x = region_i$avg_d, y = 0, xend = region_i$avg_d, yend = Inf), size = 1, linetype = 1, color = "#a9073b") +
      scale_x_continuous(limits = c(0, 305), expand = c(0,0), breaks = c(0, 30, 50, 64, 100, 150, 200, 250, 300)) +
      scale_y_continuous(expand = c(0, 0)) +
      xlab("Download speed (Mbps)") +
      ylab("") +
      labs(title = "Municipalities' average download speed distribution <br> in <span style = 'color:#283377'>Europe</span>, <span style = 'color:#337728'>" %>% 
             paste0(unique(country_i$Country)) %>% 
             paste0("</span>, and <span style = 'color:#a9073b'>") %>% 
             paste0(unique(region_i$region)) %>% 
             paste0("</span>"),
           subtitle = "64 Mbps is the median download speed of European cities") +
      theme_half_open() +
      theme(plot.title = element_markdown(hjust = .5),
            plot.subtitle = element_text(hjust = .5),
            axis.line = element_line(colour = "black", size = 1),
            axis.ticks = element_line(colour = "black", size = 1))
    
    ggsave(filename = here("visualizations", "density_plots", i %>% paste0(".png")), plt, width = 23, height = 13, units = "cm", dpi = 333)
    
  } else { 
      
      if(max(region_i$avg_d) > 250) {
    
    plt <- ggplot() + 
      geom_segment(aes(x = 64, y = 0, xend = 64, yend = Inf), size = 1, linetype = 2) +
      geom_density(data = lau_matched, aes(avg_d), color = "#283377", fill = "#283377", alpha = .2, size = 1) +
      geom_density(data = country_i, aes(avg_d), color = "#337728", fill = "#337728", alpha = .2, size = 1) +
      geom_density(data = region_i, aes(avg_d), color = "#a9073b", fill = "#a9073b", alpha = .2, size = 1) +
      scale_x_continuous(limits = c(0, 355), expand = c(0,0), breaks = c(0, 30, 50, 64, 100, 150, 200, 250, 300, 350)) +
      scale_y_continuous(expand = c(0,0)) +
      xlab("Download speed (Mbps)") +
      ylab("") +
      labs(title = "Municipalities' average download speed distribution <br> in <span style = 'color:#283377'>Europe</span>, <span style = 'color:#337728'>" %>% 
             paste0(unique(country_i$Country)) %>% 
             paste0("</span>, and <span style = 'color:#a9073b'>") %>% 
             paste0(unique(region_i$region)) %>% 
             paste0("</span>"),
           subtitle = "64 Mbps is the median download speed of European cities") +
      theme_half_open() +
      theme(plot.title = element_markdown(hjust = .5),
            plot.subtitle = element_text(hjust = .5),
            axis.line = element_line(colour = "black", size = 1),
            axis.ticks = element_line(colour = "black", size = 1))
    
    ggsave(filename = here("visualizations", "density_plots", i %>% paste0(".png")), plt, width = 23, height = 13, units = "cm", dpi = 333)
    
  } else {
          
    plt <- ggplot() + 
      geom_segment(aes(x = 64, y = 0, xend = 64, yend = Inf), size = 1, linetype = 2) +
      geom_density(data = lau_matched, aes(avg_d), color = "#283377", fill = "#283377", alpha = .2, size = 1) +
      geom_density(data = country_i, aes(avg_d), color = "#337728", fill = "#337728", alpha = .2, size = 1) +
      geom_density(data = region_i, aes(avg_d), color = "#a9073b", fill = "#a9073b", alpha = .2, size = 1) +
      scale_x_continuous(limits = c(0, 305), expand = c(0,0), breaks = c(0, 30, 50, 64, 100, 150, 200, 250, 300)) +
      scale_y_continuous(expand = c(0,0)) +
      xlab("Download speed (Mbps)") +
      ylab("") +
      labs(title = "Municipalities' average download speed distribution <br> in <span style = 'color:#283377'>Europe</span>, <span style = 'color:#337728'>" %>% 
             paste0(unique(country_i$Country)) %>% 
             paste0("</span>, and <span style = 'color:#a9073b'>") %>% 
             paste0(unique(region_i$region)) %>% 
             paste0("</span>"),
           subtitle = "64 Mbps is the median download speed of European cities") +
      theme_half_open() +
      theme(plot.title = element_markdown(hjust = .5),
            plot.subtitle = element_text(hjust = .5),
            axis.line = element_line(colour = "black", size = 1),
            axis.ticks = element_line(colour = "black", size = 1))
    
    ggsave(filename = here("visualizations", "density_plots", i %>% paste0(".png")), plt, width = 23, height = 13, units = "cm", dpi = 333)
    
        } 
      
    }
  
}


## Density plots countries

country <- lau_matched %>%
  pull(Country) %>% 
  unique()


for (i in country) {
  
  country_i <- lau_matched %>% filter(Country == i)
  
  
  if(max(country_i$avg_d) > 250) {
    
    plt <- ggplot() + 
      geom_segment(aes(x = 64, y = 0, xend = 64, yend = Inf), size = 1, linetype = 2) +
      geom_density(data = lau_matched, aes(avg_d), color = "#283377", fill = "#283377", alpha = .2, size = 1) +
      geom_density(data = country_i, aes(avg_d), color = "#337728", fill = "#337728", alpha = .2, size = 1) +
      scale_x_continuous(limits = c(0, 355), expand = c(0,0), breaks = c(0, 30, 50, 64, 100, 150, 200, 250, 300, 350)) +
      scale_y_continuous(expand = c(0,0)) +
      xlab("Download speed (Mbps)") +
      ylab("") +
      labs(title = "Municipalities' average download speed distribution <br> in <span style = 'color:#283377'>Europe</span>, and <span style = 'color:#337728'>" %>% 
             paste0(unique(country_i$Country)) %>%
             paste0("</span>"),
           subtitle = "64 Mbps is the median download speed of European cities") +
      theme_half_open() +
      theme(plot.title = element_markdown(hjust = .5),
            plot.subtitle = element_text(hjust = .5),
            axis.line = element_line(colour = "black", size = 1),
            axis.ticks = element_line(colour = "black", size = 1))
    
    ggsave(filename = here("visualizations", "density_plots", i %>% paste0(".png")), plt, width = 23, height = 13, units = "cm", dpi = 333)
    
  } else {
    
    plt <- ggplot() + 
      geom_segment(aes(x = 64, y = 0, xend = 64, yend = Inf), size = 1, linetype = 2) +
      geom_density(data = lau_matched, aes(avg_d), color = "#283377", fill = "#283377", alpha = .2, size = 1) +
      geom_density(data = country_i, aes(avg_d), color = "#337728", fill = "#337728", alpha = .2, size = 1) +
      scale_x_continuous(limits = c(0, 305), expand = c(0,0), breaks = c(0, 30, 50, 64, 100, 150, 200, 250, 300)) +
      scale_y_continuous(expand = c(0,0)) +
      xlab("Download speed (Mbps)") +
      ylab("") +
      labs(title = "Municipalities' average download speed distribution <br> in <span style = 'color:#283377'>Europe</span>, and <span style = 'color:#337728'>" %>% 
             paste0(unique(country_i$Country)) %>%
             paste0("</span>"),
           subtitle = "64 Mbps is the median download speed of European cities") +
      theme_half_open() +
      theme(plot.title = element_markdown(hjust = .5),
            plot.subtitle = element_text(hjust = .5),
            axis.line = element_line(colour = "black", size = 1),
            axis.ticks = element_line(colour = "black", size = 1))
    
    ggsave(filename = here("visualizations", "density_plots", i %>% paste0(".png")), plt, width = 23, height = 13, units = "cm", dpi = 333)
    
  } 
  
}
