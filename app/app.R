# app/app.R

library(shiny)
library(httr)
library(jsonlite)

ui <- fluidPage(
  titlePanel("FDA Recall Severity Classifier"),
  
  sidebarLayout(
    sidebarPanel(
      textAreaInput("reason", "Enter Reason for Recall:", 
                    placeholder = "e.g., contamination due to glass particles"),
      actionButton("submit", "Predict"),
      br(), br(),
      textOutput("prediction")
    ),
    
    mainPanel(
      tags$h4("Prediction Probabilities:"),
      verbatimTextOutput("result")
    )
  )
)

server <- function(input, output) {
  result <- reactiveVal(NULL)
  prediction <- reactiveVal(NULL)
  
  observeEvent(input$submit, {
    if (input$reason == "") return(NULL)
    
    res <- POST("http://127.0.0.1:8000/predict",
                body = list(reason = input$reason),
                encode = "json")
    
    parsed <- content(res)
    result(parsed)
    
    pred_class <- names(parsed)[which.max(unlist(parsed))]
    prediction(paste("Predicted Class:", pred_class))
  })
  
  output$result <- renderPrint(result())
  output$prediction <- renderText(prediction())
}

shinyApp(ui, server)