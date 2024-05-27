library(plotly)
library(dplyr)
library(htmlwidgets)

data <- read.csv('zabka_shops.csv')
data <- data %>%
  filter(!is.na(lat) & !is.na(lng) & !is.na(services))

data_filtered <- data[grepl("DKM", data$services, fixed = TRUE), ]

fig <- plot_ly(
  data_filtered,
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
    title = 'Żabki w Polsce z usługą DKM',
    showlegend = FALSE
  )

saveWidget(fig, "./dynamic_graphs/zabka_mapa_dkm.html")