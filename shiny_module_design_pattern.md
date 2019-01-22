## modules/button_mod.R

```R
button_UI <- function(id) {
 ns = NS(id)

 list(
     textOutput(ns("output_area")),
     actionButton(ns("next_num"), "Click to generate a random number")
   )
 }

 button <- function(input, output, session) {
   observeEvent(input$next_num, {
     output$output_area <- renderText({
       rnorm(1)
     })
   })
 }
```

## app.R

```R
library(shiny)

 source("modules/button_mod.R")

 ui <- fluidPage(
   button_UI("first"),
   button_UI("second")
 )

 server <- function(input, output, session) {
   callModule(button, "first")
   callModule(button, "second")
 }

 shinyApp(ui, server)
 ```
 
 ## Producer-Consumer pattern
 
 ```R
 produceMod <- function(input, output, session) {
  reactive(rnorm(1))
}

consumeMod <- function(input, output, session, data) {
  output$someOutput <- renderText({
    data() + 100
  })
}

...

server <- function(input, output, session) {
  result <- callModule(produceMod, "someID")
  callModule(consumeMod, "", result)
}
```
