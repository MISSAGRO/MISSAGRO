library(shiny)

# Umbrales de eficiencia por cultivo (kg/mm)
umbrales <- list(
  "Maíz" = c(bajo = 15, alto = 25),
  "Trigo" = c(bajo = 10, alto = 18),
  "Soja" = c(bajo = 8, alto = 13),
  "Girasol" = c(bajo = 9, alto = 15),
  "Cebada" = c(bajo = 10, alto = 17),
  "Sorgo" = c(bajo = 12, alto = 20)
)

# Texto explicativo según nivel de eficiencia
guia_texto <- function(nivel) {
  switch(nivel,
         "baja" = "🔴 Baja eficiencia: Puede deberse a exceso de agua, manejo inadecuado, mal uso del riego o baja captación del agua disponible.",
         
         "media" = "🟡 Eficiencia media: Se está usando el agua de forma moderada, pero existen oportunidades de mejora.",
         
         "alta" = "🟢 Alta eficiencia: ¡Excelente! El cultivo está aprovechando el agua de forma óptima. Seguí monitoreando el sistema para mantener estos valores.")
}

ui <- fluidPage(
  titlePanel("📊 Calculadora de eficiencia de uso del agua"),
  tags$p("Ingresá tu rendimiento y el agua acumulada durante el ciclo del cultivo. Esta herramienta te devuelve la eficiencia hídrica estimada en kg/mm."),
  
  sidebarLayout(
    sidebarPanel(
      # Tooltip para el selector de cultivo
      div(
        title = "Umbrales sugeridos de eficiencia (kg/mm):\nMaíz: 15–25\nTrigo: 10–18\nSoja: 8–13\nGirasol: 9–15\nCebada: 10–17\nSorgo: 12–20",
        selectInput("cultivo", "Cultivo:", choices = names(umbrales), selected = "Maíz")
      ),
      numericInput("rendimiento", "Rendimiento obtenido (kg/ha):", value = NA, min = 0),
      numericInput("agua", "Agua acumulada (mm):", value = NA, min = 1),
      actionButton("calcular", "Calcular")
    ),
    
    mainPanel(
      h3("Resultado"),
      verbatimTextOutput("resultado"),
      textOutput("interpretacion"),
      br(),
      uiOutput("guia")
    )
  )
)

server <- function(input, output) {
  observeEvent(input$calcular, {
    req(input$rendimiento, input$agua)
    
    eficiencia <- round(input$rendimiento / input$agua, 2)
    umbral <- umbrales[[input$cultivo]]
    
    nivel <- if (eficiencia < umbral["bajo"]) {
      "baja"
    } else if (eficiencia <= umbral["alto"]) {
      "media"
    } else {
      "alta"
    }
    
    output$resultado <- renderText({
      paste("Eficiencia de uso del agua:", eficiencia, "kg/mm")
    })
    
    output$interpretacion <- renderText({
      guia <- guia_texto(nivel)
      strsplit(guia, "\n")[[1]][1]  # Primera línea como resumen
    })
  })
}

shinyApp(ui, server)
