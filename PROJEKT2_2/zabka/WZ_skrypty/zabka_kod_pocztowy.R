library(shiny)
library(leaflet)
library(dplyr)

# Load the CSV data
df <- read.csv("../zabka_shops.csv")

# Filter out rows with missing values
df <- na.omit(df)

print(head(df))

# Define UI
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

# Define Server Logic
server <- function(input, output, session) {
  # Reactive expression to filter data based on input
  filteredData <- reactive({
    if (input$postcode == "") {
      df
    } else {
      df %>% filter(grepl(paste0("^", input$postcode), postcode))
    }
  })
  
  # Render the initial leaflet map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles()
  })
  
  # Observe and update the map based on filtered data
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

# Run the application
shinyApp(ui = ui, server = server)

