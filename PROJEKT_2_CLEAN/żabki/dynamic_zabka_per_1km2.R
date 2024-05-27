library(dplyr)
library(leaflet)
library(leaflet.extras)
library(htmlwidgets)

data <- read.csv("zabka_shops.csv")
data <- na.omit(data[c("lat", "lng")])

grid_size_km <- 1 / 111.32

lat_offset <- grid_size_km / 2
lng_offset <- grid_size_km / 2

lat_centers <- seq(min(data$lat) + lat_offset, max(data$lat) + lat_offset, by = grid_size_km)
lng_centers <- seq(min(data$lng) + lng_offset, max(data$lng) + lng_offset, by = grid_size_km)

data$lat_grid <- findInterval(data$lat, lat_centers)
data$lng_grid <- findInterval(data$lng, lng_centers)

grid_counts <- data %>% 
  group_by(lat_grid, lng_grid) %>%
  summarise(point_count = n())

average_lat <- mean(data$lat)
average_lng <- mean(data$lng)
m <- leaflet() %>%
  setView(lng = average_lng, lat = average_lat, zoom = 6) %>%
  addTiles()

max_lat_grid <- max(grid_counts$lat_grid)
max_lng_grid <- max(grid_counts$lng_grid)
filtered_grid_counts <- grid_counts %>%
  filter(lat_grid != max_lat_grid & lng_grid != max_lng_grid)

lat_center <- lat_centers[filtered_grid_counts$lat_grid + 1]
lng_center <- lng_centers[filtered_grid_counts$lng_grid + 1]

m <- addHeatmap(m, lat = lat_center, lng = lng_center, intensity = filtered_grid_counts$point_count, radius = 15, blur = 15, max = 10)

saveWidget(m, "./dynamic_graphs/zabka_per_1km2.html")