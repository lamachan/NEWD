# Load required library
library(dplyr)
library(ggplot2)

# Load the CSV data
data <- read.csv("../zabka_shops.csv")

# Filter out rows with missing values
data <- na.omit(data)

# Determine the latitude and longitude range of data
min_lat <- 0  # Minimum latitude
max_lat <- max(data$lat)  # Maximum latitude
min_lng <- 0  # Minimum longitude
max_lng <- max(data$lng)  # Maximum longitude

# Create a grid of 1km x 1km cells covering your data
grid_size_km <- 1 / 111.32  # 1 degree of latitude or longitude is approximately 111.32 km

# Calculate the latitude and longitude offsets for the grid
lat_offset <- grid_size_km / 2
lng_offset <- grid_size_km / 2

# Create latitude and longitude grid centers
lat_centers <- seq(min_lat + lat_offset, max_lat + lat_offset, by = grid_size_km)
lng_centers <- seq(min_lng + lng_offset, max_lng + lng_offset, by = grid_size_km)

# Assign each data point to a grid cell
data$lat_grid <- cut(data$lat, breaks = lat_centers, labels = FALSE)
data$lng_grid <- cut(data$lng, breaks = lng_centers, labels = FALSE)

# Function to get cities for a grid cell
get_cities <- function(lat_grid, lng_grid) {
  grid_data <- data[data$lat_grid == lat_grid & data$lng_grid == lng_grid, ]
  cities <- unique(grid_data$city)
  return(paste(cities, collapse = ', '))
}

# Function to get the most common postcode for a grid cell
get_most_common_postcode <- function(lat_grid, lng_grid) {
  grid_data <- data[data$lat_grid == lat_grid & data$lng_grid == lng_grid, ]
  most_common_postcode <- names(which.max(table(grid_data$postcode)))
  return(most_common_postcode)
}

# Count the number of data points in each grid cell
grid_counts <- data %>%
  group_by(lat_grid, lng_grid) %>%
  summarise(point_count = n()) %>%
  ungroup()

# Sort the grid cells by point count and select the top 10
top_10_grids <- grid_counts %>%
  arrange(desc(point_count)) %>%
  head(10)

# Add a column with cities for each grid cell in the top 10
top_10_grids$cities <- mapply(get_cities, top_10_grids$lat_grid, top_10_grids$lng_grid)

# Add a column with the most common postcode for each grid cell in the top 10
top_10_grids$most_common_postcode <- mapply(get_most_common_postcode, top_10_grids$lat_grid, top_10_grids$lng_grid)

# Display the top 10 most crowded grid cells with cities and most common postcode as a table
print(top_10_grids[, c('point_count', 'cities', 'most_common_postcode')])

# Combine city and postcode for labels
top_10_grids$city_postcode <- paste(top_10_grids$cities, top_10_grids$most_common_postcode, sep = " ")

# Reorder the data to ensure the top value is at the top of the plot
top_10_grids <- top_10_grids[order(-top_10_grids$point_count), ]

# Create barplot
barplot <- ggplot(top_10_grids, aes(x = reorder(city_postcode, point_count), y = point_count, fill = city_postcode)) +
  geom_bar(stat = "identity", fill='#00692b') +
  coord_flip() +
  labs(x = "Miasto i najczęstszy kod pocztowy", y = "Liczba Żabek", title = "Top 10 obszarów z największą liczbą Żabek na 1 km^2") +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 8),
        legend.position = "none")

# Display the barplot
print(barplot)
