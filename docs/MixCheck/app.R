library(shiny)
library(dplyr)

# 🧪 Base de datos ampliada
productos <- c(
  "Glifosato", "2,4-D sal amina", "Dicamba", "Fomesafen", "Saflufenacil",
  "S-Metolacloro", "Atrazina", "Cletodim", "Haloxifop-R", "Imazetapir", "Flumioxazin"
)

# Compatibilidades cruzadas
compatibilidad <- tibble::tribble(
  ~producto1, ~producto2, ~resultado, ~observaciones,
  "Glifosato", "2,4-D sal amina", "✔️ Compatible", "Uso común en barbecho.",
  "Glifosato", "Dicamba", "✔️ Compatible", "Ajustar pH, buena agitación.",
  "Glifosato", "Fomesafen", "⚠️ Precaución", "Posible fitotoxicidad, usar baja dosis.",
  "Glifosato", "Saflufenacil", "⚠️ Precaución", "Agitar constantemente, control de pH.",
  "2,4-D sal amina", "Dicamba", "❌ No compatible", "Riesgo de precipitación química.",
  "2,4-D sal amina", "Fomesafen", "❌ No compatible", "Reacción química adversa.",
  "S-Metolacloro", "Flumioxazin", "✔️ Compatible", "Muy utilizada en preemergencia.",
  "Atrazina", "S-Metolacloro", "✔️ Compatible", "Alta sinergia en control.",
  "Cletodim", "Glifosato", "⚠️ Precaución", "Puede haber antagonismo parcial.",
  "Haloxifop-R", "Glifosato", "⚠️ Precaución", "Antagonismo parcial en control.",
  "Imazetapir", "Atrazina", "✔️ Compatible", "Buena compatibilidad en mezcla.",
  "Cletodim", "Haloxifop-R", "❌ No compatible", "Antagonismo entre graminicidas."
)

# 🖥️ Interfaz
ui <- fluidPage(
  titlePanel("Compatibilidad de Herbicidas en Soja 🌱"),
  sidebarLayout(
    sidebarPanel(
      h4("Seleccioná hasta 4 herbicidas para verificar la compatibilidad:"),
      checkboxGroupInput("productos_seleccionados", "Herbicidas disponibles:",
                         choices = productos),
      actionButton("verificar", "Ver compatibilidad", class = "btn btn-success"),
      tags$hr(),
      helpText("Basado en información técnica y guías de BPA.")
    ),
    mainPanel(
      h3("Resultado de Compatibilidad 🔎"),
      tableOutput("resultado_tabla"),
      textOutput("recomendacion_extra")
    )
  )
)

# 🧠 Lógica del servidor
server <- function(input, output) {
  
  observeEvent(input$verificar, {
    seleccionados <- input$productos_seleccionados
    
    if (length(seleccionados) < 2) {
      output$resultado_tabla <- renderTable({
        data.frame(Alerta = "Seleccioná al menos 2 productos para evaluar compatibilidad.")
      })
      output$recomendacion_extra <- renderText("")
      
    } else if (length(seleccionados) > 4) {
      output$resultado_tabla <- renderTable({
        data.frame(Alerta = "Por favor seleccioná hasta 4 productos máximo.")
      })
      output$recomendacion_extra <- renderText("")
      
    } else {
      resultados <- list()
      
      # Comparar todos los pares posibles seleccionados
      for (i in 1:(length(seleccionados) - 1)) {
        for (j in (i+1):length(seleccionados)) {
          p1 <- seleccionados[i]
          p2 <- seleccionados[j]
          
          match <- compatibilidad %>% 
            filter((producto1 == p1 & producto2 == p2) | (producto1 == p2 & producto2 == p1))
          
          if (nrow(match) == 0) {
            resultados <- append(resultados, list(data.frame(
              Producto_1 = p1,
              Producto_2 = p2,
              Resultado = "🔍 Sin datos disponibles",
              Observaciones = "Consultar agrónomo de confianza."
            )))
          } else {
            resultados <- append(resultados, list(data.frame(
              Producto_1 = match$producto1,
              Producto_2 = match$producto2,
              Resultado = match$resultado,
              Observaciones = match$observaciones
            )))
          }
        }
      }
      
      resultados_df <- do.call(rbind, resultados)
      
      output$resultado_tabla <- renderTable({
        resultados_df
      })
      output$recomendacion_extra <- renderText({
        if ("❌ No compatible" %in% resultados_df$Resultado) {
          "⚠️ ¡Advertencia! Hay combinaciones no compatibles detectadas. Evitar la mezcla o consultar asesor."
        } else if ("🔍 Sin datos disponibles" %in% resultados_df$Resultado) {
          "⚠️ Advertencia: No se dispone de información técnica para todas las combinaciones seleccionadas. Realizar prueba de compatibilidad y consultar asesor agronómico."
        } else if ("⚠️ Precaución" %in% resultados_df$Resultado) {
          "🔔 Precaución: algunas mezclas requieren ajustes técnicos o cuidados especiales."
        } else {
          "✅ Excelente: combinaciones compatibles."
        }
      })
    }
  })
}

# Lanzar app
shinyApp(ui = ui, server = server)

