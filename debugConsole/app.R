library(shiny)
library(shinyAce)

ui <- fluidPage(
  fluidRow(
    column(6, 
      actionButton("eval", "Eval"),
      aceEditor("rcode", mode="r", autoComplete="live", value="print('Hello World')")
    ),
    column(6, 
      p(strong("Console:")),
      verbatimTextOutput("console", placeholder=TRUE)
    )
  )
)

server <- function(input, output, session) {
  
  session$onSessionEnded(stopApp)
  
  output$console <- renderText({
    input$eval
    withProgress(message="evaluating...", value=0, {
      paste(capture.output(eval(parse(text=isolate(input$rcode)))), collapse="\n")
    })
  })
}


shinyApp(ui=ui, server=server)
