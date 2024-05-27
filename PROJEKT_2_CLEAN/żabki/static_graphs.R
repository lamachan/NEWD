library(dplyr)
library(ggplot2)
library(gridExtra)

data <- read.csv("zabka_shops.csv")
data <- na.omit(data)

# ------------------------------------------------------------------------------
# TOP 10 OBSZARÓW Z NAJWIĘKSZĄ LICZBĄ ŻABEK NA 1 KM^2
# ------------------------------------------------------------------------------
min_lat <- 0
max_lat <- max(data$lat)
min_lng <- 0
max_lng <- max(data$lng)

grid_size_km <- 1 / 111.32

lat_offset <- grid_size_km / 2
lng_offset <- grid_size_km / 2

lat_centers <- seq(min_lat + lat_offset, max_lat + lat_offset, by = grid_size_km)
lng_centers <- seq(min_lng + lng_offset, max_lng + lng_offset, by = grid_size_km)

data$lat_grid <- cut(data$lat, breaks = lat_centers, labels = FALSE)
data$lng_grid <- cut(data$lng, breaks = lng_centers, labels = FALSE)

get_cities <- function(lat_grid, lng_grid) {
  grid_data <- data[data$lat_grid == lat_grid & data$lng_grid == lng_grid, ]
  cities <- unique(grid_data$city)
  return(paste(cities, collapse = ', '))
}

get_most_common_postcode <- function(lat_grid, lng_grid) {
  grid_data <- data[data$lat_grid == lat_grid & data$lng_grid == lng_grid, ]
  most_common_postcode <- names(which.max(table(grid_data$postcode)))
  return(most_common_postcode)
}

grid_counts <- data %>%
  group_by(lat_grid, lng_grid) %>%
  summarise(point_count = n()) %>%
  ungroup()

top_10_grids <- grid_counts %>%
  arrange(desc(point_count)) %>%
  head(10)

top_10_grids$cities <- mapply(get_cities, top_10_grids$lat_grid, top_10_grids$lng_grid)
top_10_grids$most_common_postcode <- mapply(get_most_common_postcode, top_10_grids$lat_grid, top_10_grids$lng_grid)
print(top_10_grids[, c('point_count', 'cities', 'most_common_postcode')])
top_10_grids$city_postcode <- paste(top_10_grids$cities, top_10_grids$most_common_postcode, sep = " ")
top_10_grids <- top_10_grids[order(-top_10_grids$point_count), ]

barplot <- ggplot(top_10_grids, aes(x = reorder(city_postcode, point_count), y = point_count, fill = city_postcode)) +
  geom_bar(stat = "identity", fill='#00692b') +
  coord_flip() +
  labs(x = "Miasto i najczęstszy kod pocztowy", y = "Liczba Żabek", title = "Top 10 obszarów z największą liczbą Żabek na 1 km^2") +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 8),
        legend.position = "none")

print(barplot)

# ------------------------------------------------------------------------------
# TOP 10 MIAST Z NAJWIĘKSZĄ LICZBĄ ŻABEK
# ------------------------------------------------------------------------------
city_counts <- data %>%
  group_by(city) %>%
  summarise(num_shops = n()) %>%
  ungroup()

top_10_cities <- city_counts %>%
  arrange(desc(num_shops)) %>%
  head(10)

barplot <- ggplot(top_10_cities, aes(x = reorder(city, -num_shops), y = num_shops, fill = city)) +
  geom_bar(stat = "identity", fill='#00692b') +
  labs(x = "Miasto", y = "Liczba Żabek", title = "Top 10 miast z największą liczbą Żabek") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(barplot)

# ------------------------------------------------------------------------------
# TOP 10 POWIATÓW (BEZ MIAST NA PRAWACH POWIATU) Z NAJWIĘKSZĄ LICZBĄ ŻABEK
# ------------------------------------------------------------------------------
county_counts <- data %>%
  group_by(county) %>%
  summarise(num_shops = n()) %>%
  ungroup()

county_counts <- county_counts[substr(county_counts$county, 1, 1) == tolower(substr(county_counts$county, 1, 1)), ]

top_10_counties <- county_counts %>%
  arrange(desc(num_shops)) %>%
  head(10)

barplot <- ggplot(top_10_counties, aes(x = reorder(county, -num_shops), y = num_shops, fill = county)) +
  geom_bar(stat = "identity", fill='#00692b') +
  labs(x = "Powiat", y = "Liczba Żabek", title = "Top 10 powiatów (bez miast na prawach powiatu) z największą liczbą Żabek") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(barplot)

# ------------------------------------------------------------------------------
# LICZBA ŻABEK W POSZCZEGÓLNYCH WOJEWÓDZTWACH
# ------------------------------------------------------------------------------
voivodeship_counts <- data %>%
  group_by(voivodeship) %>%
  summarise(num_shops = n()) %>%
  ungroup()

barplot <- ggplot(voivodeship_counts, aes(x = reorder(voivodeship, -num_shops), y = num_shops, fill = voivodeship)) +
  geom_bar(stat = "identity", fill='#00692b') +
  labs(x = "Województwo", y = "Liczba Żabek", title = "Liczba Żabek w poszczególnych województwach") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(barplot)

# ------------------------------------------------------------------------------
# TOP 3 NAJCZĘSTSZE GODZINY OTWARCIA ŻABEK
# ------------------------------------------------------------------------------
data$opening_hours <- paste(data$openTime, "-", data$closeTime, sep = "")

opening_hours_counts <- data %>%
  group_by(opening_hours) %>%
  summarise(num_shops = n()) %>%
  ungroup()

top_3_opening_hours <- opening_hours_counts %>%
  arrange(desc(num_shops)) %>%
  head(3)

barplot <- ggplot(top_3_opening_hours, aes(x = reorder(opening_hours, -num_shops), y = num_shops, fill = opening_hours)) +
  geom_bar(stat = "identity", fill='#00692b') +
  labs(x = "Godziny otwarca", y = "Liczba Żabek", title = "Top 3 najczęstsze godziny otwarcia Żabek") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(barplot)

# ------------------------------------------------------------------------------
# CZAS OTWARCIA
# ------------------------------------------------------------------------------
data$open_seconds <- data$closeTimeSeconds - data$openTimeSeconds
data$open_seconds <- ifelse(data$open_seconds < 0, 86400 + data$open_seconds, data$open_seconds)
data$open_hours <- data$open_seconds / 3600

histogram <- hist(data$open_hours,
                  main = "Histogram - czas otwarcia",
                  xlab = "Liczba godzin",
                  ylab = "Liczba Żabek",
                  breaks = 10,
                  col = '#00692b',
                  plot = FALSE)

boxplot <- ggplot(data, aes(y = open_hours)) +
  geom_boxplot(fill = "#00692b", color = "black") +
  labs(title = "Wykres pudełkowy - czas otwarcia", y = "Liczba godzin")

hist_gg <- ggplot(data.frame(x = histogram$mids, y = histogram$counts), aes(x, y)) +
  geom_bar(stat = "identity", fill = "#00692b") +
  theme_minimal() +
  labs(title = "Histogram - czas otwarcia", x = "Liczba godzin", y = "Liczba Żabek")

grid.arrange(hist_gg, boxplot, ncol = 2)