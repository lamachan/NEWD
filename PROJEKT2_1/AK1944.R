library(shiny)
library(ggplot2)
library(tidyr)

dane <- read.table(text = "Okreg;Plutony_pelne;Plutony_szkieletowe;Oficerowie_suma;Oficerowie_sztabowi;Podchorazowie;Podoficerowie
Komenda Glowna; 54 ;6 ;1273 ;893 ;411 ;1060
Obszar Warszawy; 511 ;692 ;1540 ;280 ;809 ;9801
Warszawa miasto; 647 ;153 ;1938 ;149 ;2462 ;10635
Lublin; 775 ;73 ;839 ;258 ;476 ;7256
Kielce (Radom); 552 ;76 ;808 ;303 ;486 ;7815
Krakow; 1057 ;220 ;1883 ;677 ;1082 ;14872
Lodz; 707 ;0 ;274 ;29 ;177 ;6229
Slask; 862 ;117 ;253 ;116 ;153 ;5895
Poznan; 5 ;272 ;99 ;49 ;96 ;1481
Pomorze; 56 ;181 ;61 ;12 ;4 ;230
Bialystok; 205 ;253 ;390 ;183 ;365 ;7320
Wilno; 93 ;27 ;469 ;193 ;188 ;1666
Nowogrodek; 15 ;107 ;123 ;59 ;220 ;1022
Polesie; 61 ;35 ;42 ;25 ;45 ;454
Wolyn; 0 ;201 ;62 ;62 ;0 ;0
Lwow; 196 ;184 ;459 ;247 ;321 ;9154
Tarnopol; 301 ;20 ;121 ;52 ;139 ;2303
Stanislawow; 90 ;16 ;114 ;44 ;72 ;693", sep = ";", header = TRUE)

wszystkie_kolumny <- colnames(dane)

# UI
ui <- fluidPage(
  titlePanel("Ilość poszczególnych jednostek wojskowych Armii Krajowej w roku 1944"),
  sidebarLayout(
    sidebarPanel(
      selectInput("kolumny", "Wybierz kolumny:", choices = wszystkie_kolumny, selected = wszystkie_kolumny, multiple = TRUE),
      selectInput("filtr_okreg", "Filtruj okregi:", choices = c("Wszystkie", unique(dane$Okreg)), selected = "Wszystkie", multiple = TRUE) # zaznaczone "Wszystkie" domyślnie
    ),
    mainPanel(
      plotOutput("wykres", height = "500px") # powiększenie wykresu
    )
  )
)
# Server
server <- function(input, output) {
  output$wykres <- renderPlot({
    dane_do_wykresu <- dane
    
    # Jeśli żadna kolumna nie jest wybrana, automatycznie zaznaczamy kolumnę Okręg
    if (is.null(input$kolumny) || length(input$kolumny) == 0) {
      input$kolumny <- "Okreg"
    }
    
    # Jeśli nie wybrano żadnych okręgów, wyświetlamy wszystkie okręgi
    if (is.null(input$filtr_okreg) || length(input$filtr_okreg) == 0 || "Wszystkie" %in% input$filtr_okreg) {
      dane_do_wykresu <- dane_do_wykresu
    } else {
      dane_do_wykresu <- dane_do_wykresu[dane_do_wykresu$Okreg %in% input$filtr_okreg, ]
    }
    
    # Filtruj dane według wyboru użytkownika
    dane_do_wykresu <- dane_do_wykresu[, input$kolumny, drop = FALSE]
    
    # Przekształcenie danych do długiego formatu
    dane_long <- pivot_longer(dane_do_wykresu, cols = -Okreg, names_to = "Kolumna", values_to = "Wartosc")
    
    # Wykres countplot
    ggplot(dane_long, aes(x = Okreg, y = Wartosc, fill = Kolumna)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "Countplot dla wybranych kolumn", x = "Okreg", y = "Wartosc") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 12), # zmiana rozmiaru czcionki na podpisach osi x
            axis.text.y = element_text(size = 12), # zmiana rozmiaru czcionki na podpisach osi y
            axis.title = element_text(size = 14), # zmiana rozmiaru czcionki na podpisach osi x i y
            legend.text = element_text(size = 12)) + # zmiana rozmiaru czcionki w legendzie
      coord_cartesian(ylim = c(0, max(dane_long$Wartosc) * 1.2)) # powiększenie osi y
  })
}



# Uruchomienie aplikacji
shinyApp(ui = ui, server = server)
