library(dplyr)
library(leaflet)
library(leaflet.extras)
library(htmlwidgets)

# Load the CSV data
data <- read.csv("../zabka_shops.csv")

# Filter out rows with missing latitude or longitude values
data <- na.omit(data[c("lat", "lng")])

# Create a grid of 1km x 1km cells covering your data
grid_size_km <- 1 / 111.32  # 1 degree of latitude or longitude is approximately 111.32 km

# Calculate the latitude and longitude offsets for the grid
lat_offset <- grid_size_km / 2
lng_offset <- grid_size_km / 2

# Create latitude and longitude grid centers
lat_centers <- seq(min(data$lat) + lat_offset, max(data$lat) + lat_offset, by = grid_size_km)
lng_centers <- seq(min(data$lng) + lng_offset, max(data$lng) + lng_offset, by = grid_size_km)

# Assign each data point to a grid cell
data$lat_grid <- findInterval(data$lat, lat_centers)
data$lng_grid <- findInterval(data$lng, lng_centers)

# Count the number of data points in each grid cell
grid_counts <- data %>% 
  group_by(lat_grid, lng_grid) %>%
  summarise(point_count = n())

# Create a map centered on the average latitude and longitude
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

saveWidget(m, "../WZ_wykresy/zabka_per_1km2.html")