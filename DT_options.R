# nice looking options for DT, plus some hints on how to contorl certain aspects
# taken from https://gist.github.com/senthilthyagarajan/4448495e2ecb6fd9456cc1924502c43c
library(shiny)
library(DT)

table_frame <-
  function() {
    htmltools::withTags(table(class = 'display',
                              thead(
                                tr(
                                  th(rowspan = 2, 'Latitude'),
                                  th(rowspan = 2, 'Longitude'),
                                  th(rowspan = 2, 'Month'),
                                  th(rowspan = 2, 'Year'),
                                  th(class = 'dt-center', colspan = 3, 'Cloud'),
                                  th(rowspan = 2, 'Ozone'),
                                  th(rowspan = 2, 'Pressure'),
                                  th(rowspan = 2, 'Surface Temperature'),
                                  th(rowspan = 2, 'Temperature'),
                                  tr(lapply(rep(
                                    c('High', 'Low', 'Mid'), 1
                                  ), th))
                                )
                              )))
  }

table_options <- function() {
  list(
    dom = 'Bfrtip',
    #Bfrtip
    pageLength = 10,
    buttons = list(
      c('copy', 'csv', 'excel', 'pdf', 'print'),
      list(
        extend = "collection",
        text = 'Show All',
        action = DT::JS(
          "function ( e, dt, node, config ) {
          dt.page.len(-1);
          dt.ajax.reload();}"
        )
        ),
      list(
        extend = "collection",
        text = 'Show Less',
        action = DT::JS(
          "function ( e, dt, node, config ) {
          dt.page.len(10);
          dt.ajax.reload();}"
        )
        )
        ),
    deferRender = TRUE,
    lengthMenu = list(c(10, 20,-1), c('10', '20', 'All')),
    searching = FALSE,
    editable = TRUE,
    scroller = TRUE,
    lengthChange = FALSE
    ,
    initComplete = JS(
      "function(settings, json) {",
      "$(this.api().table().header()).css({'background-color': '#517fb9', 'color': '#fff'});",
      "}"
    )
      )
}

ui <- fluidPage(
br(),
br(),
  dataTableOutput("output_table"))

server <- function(input, output, session) {
  output$output_table <- DT::renderDataTable({
    as.data.frame(nasa) %>%
      top_n(200) %>%
      DT::datatable(
        rownames = FALSE,
        editable = TRUE,
        class = 'cell-border',
        escape = FALSE,
        container = table_frame(),
        options = table_options(),
        extensions = 'Buttons'
      )
  })
  
}

shinyApp(ui, server)
