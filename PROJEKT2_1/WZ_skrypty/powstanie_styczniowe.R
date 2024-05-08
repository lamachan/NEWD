library(shiny)
library(ggplot2)
library(tidyr)
library(dplyr)

dane <- read.table("data/powstanie_styczniowe.txt", header = TRUE, sep = ';', colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))
head(dane)

# UI
ui <- fluidPage(
  titlePanel("Powstanie styczniowe"),
  sidebarLayout(
    sidebarPanel(
      selectInput("kraj", "Wybierz Kraj:", choices = c("Wszystkie", unique(dane$Kraj))),
      br(),
      helpText("Wybierz kraj, aby zobaczyć dane dla danego kraju z podziałem na województwa.
               Wybierz Wszystkie, aby porównać sumaryczne wartości dla poszczególnych krajów.")
    ),
    mainPanel(
      plotOutput("wykres")
    )
  )
)

palette_map <- c("Królestwo Polskie" = "Set1",
                 "Litwa" = "Set2",
                 "Ruś" = "Set3")

# Server
server <- function(input, output) {
  output$wykres <- renderPlot({
    dane_do_wykresu <- dane
    
    # Filter data based on selected Kraj
    if (input$kraj != "Wszystkie") {
      dane_do_wykresu <- dane_do_wykresu[dane_do_wykresu$Kraj == input$kraj, ]
      
      # Reshape data to long format
      dane_long <- pivot_longer(dane_do_wykresu, cols = -c(Kraj, Województwo), names_to = "Kwartał", values_to = "Wartość")
      dane_long$Kwartał <- gsub("X", "", dane_long$Kwartał)  # Remove "X"
      dane_long$Kwartał <- gsub("\\.", " ", dane_long$Kwartał)  # Replace "." with space
      
      # Plot stacked bar plot
      ggplot(dane_long, aes(x = factor(Kwartał), y = Wartość, fill = Województwo)) +
        geom_bar(stat = "identity") +
        labs(title = "Liczba jednostek w poszczególnych kwartałach",
             x = "Kwartał", y = "Liczba jednostek", fill = "Województwo") +
        theme_minimal() +
        theme(legend.position = "bottom",
              axis.text.x = element_text(angle = 45, hjust = 1, size = 12),  # Adjust text size here
              axis.text.y = element_text(size = 12),  # Adjust y-axis text size
              axis.title = element_text(size = 14),   # Adjust axis title size
              plot.title = element_text(size = 22),
              legend.text = element_text(size = 12)) +
        scale_fill_brewer(palette = palette_map[input$kraj]) +
        facet_wrap(~Kraj)
    } else {
      # Reshape data to long format
      dane_long <- pivot_longer(dane_do_wykresu, cols = -c(Kraj, Województwo), names_to = "Kwartał", values_to = "Wartość")
      dane_long$Kwartał <- gsub("X", "", dane_long$Kwartał)  # Remove "X"
      dane_long$Kwartał <- gsub("\\.", " ", dane_long$Kwartał)  # Replace "." with space
      summed_data <- dane_long %>%
        group_by(Kraj, Kwartał) %>%
        summarise(Wartość = sum(Wartość))
      
      # Plot grouped bar plot
      ggplot(summed_data, aes(x = factor(Kwartał), y = Wartość, fill = Kraj)) +
        geom_bar(stat = "identity", position = position_dodge(width = 0.9)) +
        labs(title = "Liczba jednostek w poszczególnych kwartałach",
             x = "Kwartał", y = "Liczba jednostek", fill = "Kraj") +
        theme_minimal() +
        theme(legend.position = "bottom",
              axis.text.x = element_text(angle = 45, hjust = 1, size = 12),  # Adjust text size here
              axis.text.y = element_text(size = 12),  # Adjust y-axis text size
              axis.title = element_text(size = 14),   # Adjust axis title size
              plot.title = element_text(size = 22),
              legend.text = element_text(size = 12)) +
        scale_fill_brewer(palette = "Dark2")
    }
  })
}


# Run the application
shinyApp(ui = ui, server = server)