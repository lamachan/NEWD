library(shiny)
library(ggplot2)
library(tidyr)

# Wczytanie danych
dane <- read.table(text = "Rodzaje_broni_i_sluzb;Ogolem;Oficerowie_Wojska_Polskiego;Oficerowie_Armii_Radzieckiej_liczba;Oficerowie_Armii_Radzieckiej_odsetek
Piechota;7725;6537;1188;15.4
Kawaleria;662;643;19;2.9
Artyleria;4930;2017;2913;59.1
Bron_pancerna;2743;1592;1151;42.0
Marynarka_Wojenna;167;148;19;11.4
Lotnictwo;4247;450;3797;89.4
Sluzba_inzynieryjno_saperska;1509;661;848;56.2
Lacznosc;762;737;1025;58.2
Sluzba_chemiczna;520;175;345;66.3
Sluzba_kolejowa;26;15;11;42.3
Sluzba_zaopatrzenia;5788;3114;2674;46.2
Sluzba_zdrowia;3814;1984;1830;48.0
Sluzba_sprawiedliwosci;288;258;30;10.4
Sluzba_administracyjna;1298;1109;189;14.6
Aparat_polityczny;4165;4037;128;3.1
Korpus_Bezpieczenstwa_Wewnetrznego_piechota_i_kawaleria;1215;986;229;18.8", sep = ";", header = TRUE)

# Nazwy wszystkich kolumn
wszystkie_kolumny <- colnames(dane)

# UI
ui <- fluidPage(
  titlePanel("Interaktywna wizualizacja danych"),
  sidebarLayout(
    sidebarPanel(
      selectInput("kolumny", "Wybierz kolumny:", choices = wszystkie_kolumny, selected = wszystkie_kolumny, multiple = TRUE),
      selectInput("filtr_rodzaje", "Filtruj rodzaje broni i służb:", choices = c("Wszystkie", unique(dane$Rodzaje_broni_i_sluzb)), selected = "Wszystkie", multiple = TRUE) # zaznaczone "Wszystkie" domyślnie
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
    
    # Jeśli żadna kolumna nie jest wybrana, automatycznie zaznaczamy kolumnę Rodzaje_broni_i_sluzb
    if (is.null(input$kolumny) || length(input$kolumny) == 0) {
      input$kolumny <- "Rodzaje_broni_i_sluzb"
    }
    
    # Jeśli nie wybrano żadnych rodzajów broni i służb, wyświetlamy wszystkie
    if (is.null(input$filtr_rodzaje) || length(input$filtr_rodzaje) == 0 || "Wszystkie" %in% input$filtr_rodzaje) {
      dane_do_wykresu <- dane_do_wykresu
    } else {
      dane_do_wykresu <- dane_do_wykresu[dane_do_wykresu$Rodzaje_broni_i_sluzb %in% input$filtr_rodzaje, ]
    }
    
    # Filtruj dane według wyboru użytkownika
    dane_do_wykresu <- dane_do_wykresu[, input$kolumny, drop = FALSE]
    
    # Przekształcenie danych do długiego formatu
    dane_long <- pivot_longer(dane_do_wykresu, cols = -Rodzaje_broni_i_sluzb, names_to = "Kolumna", values_to = "Wartosc")
    
    # Wykres countplot
    ggplot(dane_long, aes(x = Rodzaje_broni_i_sluzb, y = Wartosc, fill = Kolumna)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "Countplot dla wybranych kolumn", x = "Rodzaje broni i służb", y = "Wartość") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      coord_cartesian(ylim = c(0, max(dane_long$Wartosc) * 1.2)) # powiększenie osi y
  })
}

# Uruchomienie aplikacji
shinyApp(ui = ui, server = server)
