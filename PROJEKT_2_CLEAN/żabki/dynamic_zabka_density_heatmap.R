library(plotly)
library(dplyr)
library(htmlwidgets)

data <- read.csv('zabka_shops.csv')
data <- data %>%
  filter(!is.na(lat) & !is.na(lng))

fig <- plot_ly(
  data,
  type = 'densitymapbox',
  lat = ~lat,
  lon = ~lng,
  radius = 10,
  colorscale = 'Greens',
  opacity = 0.6
) %>%
  layout(
    mapbox = list(
      style = 'open-street-map',
      center = list(lon = 19, lat = 52),
      zoom = 5
    ),
    title = 'Żabki w Polsce',
    showlegend = FALSE
  )

saveWidget(fig, "./dynamic_graphs/zabka_density_heatmap.html")