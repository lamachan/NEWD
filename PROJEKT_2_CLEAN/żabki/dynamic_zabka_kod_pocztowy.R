library(shiny)
library(leaflet)
library(dplyr)

df <- read.csv("zabka_shops.csv")
df <- na.omit(df)
print(head(df))

ui <- fluidPage(
  titlePanel("Interactive Postcode Map"),
  sidebarLayout(
    sidebarPanel(
      textInput("postcode", "Enter Postcode Pattern:", value = "")
    ),
    mainPanel(
      leafletOutput("map")
    )
  )
)

server <- function(input, output, session) {
  filteredData <- reactive({
    if (input$postcode == "") {
      df
    } else {
      df %>% filter(grepl(paste0("^", input$postcode), postcode))
    }
  })

  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles()
  })
  
  observe({
    data <- filteredData()
    
    if (nrow(data) > 0) {
      leafletProxy("map", data = data) %>%
        clearMarkers() %>%
        addCircleMarkers(lng = ~lng, lat = ~lat, popup = ~postcode, radius = 2, color = '#00692b') %>%
        fitBounds(
          lng1 = min(data$lng), lat1 = min(data$lat), 
          lng2 = max(data$lng), lat2 = max(data$lat)
        )
    } else {
      leafletProxy("map") %>%
        clearMarkers()
    }
  })
}

shinyApp(ui = ui, server = server)