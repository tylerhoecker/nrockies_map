library(tidyverse)
library(sf)
library(viridis)
library(gganimate)
library(USAboundaries)
library(ggplot2)
library(geosphere)

# To load original shapefile data

# mtbs_full <- st_read("mtbs_perimeter_data", quiet = FALSE)
# 
# nps <- st_read("gye_nps", quiet = FALSE)
# 
# nrock_states <- us_states(states = c('ID','MT','WY')) %>% 
#   st_transform(crs = st_crs(mtbs_full))
# 
# mtbs_nr <- mtbs_full %>%
#   st_intersection(.,nrock_states) %>% 
#   arrange(Year) %>% 
#   #mutate(area = st_area(.)) %>%
#   st_simplify(preserveTopology = TRUE, dTolerance = .01)

# To load data ready to map from .RData
load('fire_map_data.Rdata')

maps <-  
  ggplot() + 
  geom_sf(data = nrock_states) +
  geom_sf(data = nps, color = 'black', fill = 'grey80') +
  geom_sf(data = mtbs_nr,
          aes(fill = Year, frame = Year, cumulative = TRUE),
          color = 'transparent') +
  coord_sf(crs = st_crs(mtbs_full),
           xlim = c(-108, -117),
           ylim = c(41.25, 49)) +
  scale_fill_viridis('Year  ') +
  theme_bw(base_size = 16) +
  theme(legend.position = c(0.2,0.07),
        legend.direction = 'horizontal',
        legend.background = element_rect(fill = "#ffffffaa"),
        legend.text = element_text(angle = 315),
        plot.margin = unit(c(0.25,0.25,0.25,0.25), "cm"))

gganimate(maps, interval = 0.5, filename = 'nrocksfiremap.gif', ani.height = 1000, ani.width = 1000, loop = 1)

linePlot <- 
  ggplot(mtbs_nr) +
  geom_line(aes(x = Year, y = (cumsum(Acres)*0.404686)/1000000, frame = Year, cumulative = T), size =1) +
  labs(y = 'Cumulative\narea burned (M ha)') +
  theme_bw(base_size = 16) +
  theme(plot.margin = unit(c(.5,7.2,.5,6), "cm"))


gganimate(linePlot, filename = 'nrocksfireCumLine.gif', 
          interval = 0.5, ani.height = 200, ani.width = 1200)

