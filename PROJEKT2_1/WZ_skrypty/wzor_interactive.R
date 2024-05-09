library(shiny)
library(ggplot2)
library(tidyr)

dane <- read.table("../data/powstanie_kosciuszkowskie.txt", header = TRUE, sep = ';', colClasses = c("character", "numeric", "numeric", "numeric", "numeric", "numeric"))
head(dane)

# Nazwy wszystkich kolumn
wszystkie_kolumny <- colnames(dane[,-1])

# UI
ui <- fluidPage(
  titlePanel("Powstanie Kościuszkowskie"),
  sidebarLayout(
    sidebarPanel(
      selectInput("kolumny", "Wybierz kolumny:", choices = wszystkie_kolumny, selected = wszystkie_kolumny, multiple = TRUE),
      selectInput("filtr_miesiac", "Filtruj miesiąc:", choices = c("Wszystkie", unique(dane$Miesiące)), selected = "Wszystkie", multiple = TRUE) # zaznaczone "Wszystkie" domyślnie
    ),
    mainPanel(
      plotOutput("wykres", height = "700px") # powiększenie wykresu
    )
  )
)

# Server
server <- function(input, output) {
  output$wykres <- renderPlot({
    dane_do_wykresu <- dane
    
    # Jeśli żadna kolumna nie jest wybrana, automatycznie zaznaczamy kolumnę Okręg
    if (is.null(input$kolumny) || length(input$kolumny) == 0) {
      input$kolumny <- "Miesiące"
    }
    
    # Jeśli nie wybrano żadnych okręgów, wyświetlamy wszystkie okręgi
    if (is.null(input$filtr_miesiac) || length(input$filtr_miesiac) == 0 || "Wszystkie" %in% input$filtr_miesiac) {
      dane_do_wykresu <- dane_do_wykresu
    } else {
      dane_do_wykresu <- dane_do_wykresu[dane_do_wykresu$Miesiące %in% input$filtr_miesiac, ]
    }
    
    # Filtruj dane według wyboru użytkownika
    dane_do_wykresu <- dane_do_wykresu[, c("Miesiące", input$kolumny), drop = FALSE]
    
    # Maintain the order of Miesiące column
    dane_do_wykresu$Miesiące <- factor(dane_do_wykresu$Miesiące, levels = unique(dane$Miesiące))
    
    # Przekształcenie danych do długiego formatu
    dane_long <- pivot_longer(dane_do_wykresu, cols = -Miesiące, names_to = "Kolumna", values_to = "Wartosc")
    
    # Wykres countplot
    ggplot(dane_long, aes(x = Miesiące, y = Wartosc, fill = Kolumna)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "Liczba jednostek w poszczególnych miesiącach", x = "Miesiące", y = "Wartosc") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 12),  # Adjust text size here
            axis.text.y = element_text(size = 12),  # Adjust y-axis text size
            axis.title = element_text(size = 14),   # Adjust axis title size
            plot.title = element_text(size = 22),
            legend.text = element_text(size = 12)) +
      coord_cartesian(ylim = c(0, max(dane_long$Wartosc) * 1.2)) # powiększenie osi y
  })
}


# Uruchomienie aplikacji
shinyApp(ui = ui, server = server)