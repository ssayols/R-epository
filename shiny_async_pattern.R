## Minimal example, taken from http://blog.fellstat.com/?p=407
library(shiny)
library(promises)
library(future)
plan(multiprocess)

##
## UI part
##
ui <- fluidPage(
 
  # Application title
  titlePanel("Long Run Async"),
 
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      actionButton('run', 'Run')
    ),
 
    # Show a plot of the generated distribution
    mainPanel(
      tableOutput("result")
    )
  )
)

##
## Server part
##
server <- function(input, output) {

  # long running task
  result_val <- reactiveVal()
  observeEvent(input$run, {
    result_val(NULL)
    future({
      print("Running...")
      for(i in 1:10) {
        Sys.sleep(1)
      }
      quantile(rnorm(1000))
    }) %...>% result_val()
  })

  # fill UI with the results
  output$result <- renderTable({
    req(result_val())
  })
}
 
# Run the application 
shinyApp(ui = ui, server = server)
