library(shiny)
library(scales)  # Para la escala de colores

# Definición de la interfaz de usuario
ui <- fluidPage(
  titlePanel("Análisis de Sensibilidad del Margen Bruto"),
  sidebarLayout(
    sidebarPanel(
      numericInput("rendimiento", "Rendimiento esperado (kg/ha):", value = 4000, min = 0),
      numericInput("precio", "Precio base (US$/ton):", value = 215, min = 0),
      numericInput("costo", "Costo total estimado (US$/ha):", value = 662, min = 0),
      selectInput("usar_put", "¿Querés simular un put?", choices = c("No", "Sí")),
      conditionalPanel(
        condition = "input.usar_put == 'Sí'",
        numericInput("costo_put", "Costo del put (US$/ha):", value = 30, min = 0)
      )
    ),
    mainPanel(
      h3("Resultados del Análisis de Sensibilidad"),
      tableOutput("tabla_resultados"),
      plotOutput("grafico_resultados")
    )
  )
)

# Definición del servidor
server <- function(input, output) {
  
  output$tabla_resultados <- renderTable({
    precios <- c(input$precio * 0.90, input$precio * 0.95, input$precio, input$precio * 1.05, input$precio * 1.10)
    ingresos <- precios * input$rendimiento / 1000
    margenes_sin_put <- ingresos - input$costo
    
    if (input$usar_put == "Sí") {
      margenes_con_put <- margenes_sin_put - input$costo_put
    } else {
      margenes_con_put <- margenes_sin_put
    }
    
    data.frame(
      "Escenario" = c("Precio -10%", "Precio -5%", "Precio Base", "Precio +5%", "Precio +10%"),
      "Precio (US$/ton)" = round(precios, 2),
      "Ingreso (US$/ha)" = round(ingresos, 2),
      "Margen Bruto (US$/ha)" = round(margenes_con_put, 2)
    )
  })
  
  output$grafico_resultados <- renderPlot({
    precios <- c(input$precio * 0.90, input$precio * 0.95, input$precio, input$precio * 1.05, input$precio * 1.10)
    ingresos <- precios * input$rendimiento / 1000
    margenes_sin_put <- ingresos - input$costo
    
    if (input$usar_put == "Sí") {
      margenes_con_put <- margenes_sin_put - input$costo_put
    } else {
      margenes_con_put <- margenes_sin_put
    }
    
    ylim_max <- max(c(margenes_con_put)) * 1.2
    
    # Escala de colores verde -> amarillo -> rojo
    color_function <- col_numeric(
      palette = c("red4", "#FFCC00", "#004d40"),
      domain = range(margenes_con_put)
    )
    colores_barras <- color_function(margenes_con_put)
    
    if (all(margenes_con_put > 0)) {
      color_linea_base <- "#004d40"
    } else {
      color_linea_base <- "red4"
    }
    
    bp <- barplot(
      margenes_con_put,
      names.arg = c("Precio -10%", "Precio -5%", "Precio Base", "Precio +5%", "Precio +10%"),
      col = colores_barras,
      ylab = "Margen Bruto (US$/ha)",
      main = "Análisis de Sensibilidad del Margen Bruto",
      space = 1.5,
      ylim = c(min(0, min(margenes_con_put)), ylim_max)
    )
    
    abline(h = 0, col = color_linea_base, lty = 2, lwd = 2)
    
    text(
      x = bp,
      y = margenes_con_put,
      labels = round(margenes_con_put, 1),
      pos = 3,
      cex = 1.2,
      col = "black",
      font = 2
    )
  })
}

# Lanzar la aplicación
shinyApp(ui = ui, server = server)

