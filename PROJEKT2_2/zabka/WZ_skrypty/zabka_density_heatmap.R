# Load necessary libraries
library(plotly)
library(dplyr)

# Load the CSV data
data <- read.csv('../zabka_shops.csv')

# Filter out rows with missing latitude and longitude values
data <- data %>%
  filter(!is.na(lat) & !is.na(lng))

# Create a heatmap using Plotly
fig <- plot_ly(
  data,
  type = 'densitymapbox',
  lat = ~lat,
  lon = ~lng,
  radius = 10,  # Adjust the radius for the heatmap points
  colorscale = 'Jet',
  opacity = 0.6  # Adjust the opacity of the heatmap points
) %>%
  layout(
    mapbox = list(
      style = 'open-street-map',  # Use the OpenStreetMap style for the map
      center = list(lon = 19, lat = 52),  # Set the center to Poland's approximate coordinates
      zoom = 5  # Adjust the zoom level
    ),
    title = 'Zabka Shop Density Heatmap',
    showlegend = FALSE  # Hide the color scale legend
  )

# Show the interactive heatmap
fig

library(htmlwidgets)
saveWidget(fig, "../WZ_wykresy/zabka_shop_density_heatmap.html")
