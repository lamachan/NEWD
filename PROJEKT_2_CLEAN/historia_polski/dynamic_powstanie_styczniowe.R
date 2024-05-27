library(shiny)
library(ggplot2)
library(tidyr)
library(dplyr)

dane <- read.table("./data/powstanie_styczniowe.txt", header = TRUE, sep = ';', colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))
head(dane)

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

server <- function(input, output) {
  output$wykres <- renderPlot({
    dane_do_wykresu <- dane
  
    if (input$kraj != "Wszystkie") {
      # Wszystkie -> porównanie sumarycznych wartości dla poszczególnych krajów
      dane_do_wykresu <- dane_do_wykresu[dane_do_wykresu$Kraj == input$kraj, ]

      dane_long <- pivot_longer(dane_do_wykresu, cols = -c(Kraj, Województwo), names_to = "Kwartał", values_to = "Wartość")
      dane_long$Kwartał <- gsub("X", "", dane_long$Kwartał)
      dane_long$Kwartał <- gsub("\\.", " ", dane_long$Kwartał)

      ggplot(dane_long, aes(x = factor(Kwartał), y = Wartość, fill = Województwo)) +
        geom_bar(stat = "identity") +
        labs(title = "Liczba bitew i potyczek w poszczególnych kwartałach",
             x = "Kwartał", y = "Liczba bitew i potyczek", fill = "Województwo") +
        theme_minimal() +
        theme(legend.position = "bottom",
              axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
              axis.text.y = element_text(size = 12),
              axis.title = element_text(size = 14),
              plot.title = element_text(size = 22),
              legend.text = element_text(size = 12)) +
        scale_fill_brewer(palette = palette_map[input$kraj]) +
        facet_wrap(~Kraj)
    } else {
      # Kraj -> dane dla danego kraju z podziałem na województwa
      dane_long <- pivot_longer(dane_do_wykresu, cols = -c(Kraj, Województwo), names_to = "Kwartał", values_to = "Wartość")
      dane_long$Kwartał <- gsub("X", "", dane_long$Kwartał)
      dane_long$Kwartał <- gsub("\\.", " ", dane_long$Kwartał)
      summed_data <- dane_long %>%
        group_by(Kraj, Kwartał) %>%
        summarise(Wartość = sum(Wartość))
      
      ggplot(summed_data, aes(x = factor(Kwartał), y = Wartość, fill = Kraj)) +
        geom_bar(stat = "identity", position = position_dodge(width = 0.9)) +
        labs(title = "Liczba bitew i potyczek w poszczególnych kwartałach",
             x = "Kwartał", y = "Liczba bitew i potyczek", fill = "Kraj") +
        theme_minimal() +
        theme(legend.position = "bottom",
              axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
              axis.text.y = element_text(size = 12),
              axis.title = element_text(size = 14),
              plot.title = element_text(size = 22),
              legend.text = element_text(size = 12)) +
        scale_fill_brewer(palette = "Dark2")
    }
  })
}

shinyApp(ui = ui, server = server)