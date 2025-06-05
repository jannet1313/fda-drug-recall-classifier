library(shiny)
library(httr)
library(jsonlite)
library(ggplot2)
library(dplyr)

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
      tableOutput("prob_table"),
      
      tags$h4("Raw API Response:"),
      verbatimTextOutput("result"),  
      
      tags$h4("Confidence Bar Chart:"),
      plotOutput("probPlot"),
      br(),
      
      tags$h4("📄 Modeling Report"),
      tags$a(
        href = "FDA%20Drug%20Recall%20Classifier%20-%20Modeling%20Report.html", 
        "View Full Modeling Report (HTML)", 
        target = "_blank"
      )
    )
  )
)

server <- function(input, output) {
  result <- reactiveVal(NULL)
  prediction <- reactiveVal(NULL)
  probs <- reactiveVal(NULL)
  
  # API call with automatic retry
  make_api_call <- function(reason, retries = 1) {
    for (i in seq_len(retries + 1)) {
      res <- tryCatch({
        POST("http://3.145.181.209:8000/predict",
             body = list(reason = reason),
             encode = "form")
      }, error = function(e) NULL)
      
      if (!is.null(res) && status_code(res) == 200) return(res)
      
      Sys.sleep(1)  # wait 1 second before retry
    }
    return(NULL)
  }
  
  observeEvent(input$submit, {
    if (input$reason == "") return(NULL)
    
    res <- make_api_call(input$reason, retries = 1)
    
    if (!is.null(res) && status_code(res) == 200) {
      parsed <- content(res)
      result(parsed)
      prediction(paste("Predicted Severity Class:", parsed$severity))
      
      raw_probs <- parsed$probabilities
      prob_df <- data.frame(
        Class = gsub(".pred_", "", names(raw_probs)),
        Probability = sapply(raw_probs, function(x) unlist(x))
      )
      
      prob_df$Class <- factor(prob_df$Class, levels = c("Class I", "Class II", "Class III"))
      probs(prob_df)
    } else {
      result("Prediction failed. Please try again.")
      prediction("")
      probs(NULL)
    }
  })
  
  output$result <- renderPrint(result())
  output$prediction <- renderText(prediction())
  output$prob_table <- renderTable(probs(), digits = 3)
  
  output$probPlot <- renderPlot({
    req(probs())
    ggplot(probs(), aes(x = Class, y = Probability, fill = Class)) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      ggtitle("Predicted Class Probabilities") +
      ylim(0, 1)
  })
}

shinyApp(ui, server)