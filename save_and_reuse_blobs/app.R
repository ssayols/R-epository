library(shiny)
library(ggplot2)
library(plotly)
library(DT)
library(RSQLite)

# original data
d <- data.frame(x=rnorm(100000),
                y=rnorm(100000),
                c=rbinom(100000, 1, .01))
p <- ggplot(d, aes(x=x, y=y, fill=c)) + geom_point() + theme_minimal()

# insert
con <- dbConnect(RSQLite::SQLite(), dbname="x.db")
dbGetQuery(con, 'insert into t (obj) values (:g)',
           params=data.frame(g=I(list(serialize(d, NULL)))))
dbDisconnect(con)

# retrieve
con <- dbConnect(RSQLite::SQLite(), dbname="x.db")
df <- dbGetQuery(con, "select * from t")
p2 <- lapply(df$obj, unserialize)
dbDisconnect(con)

# shiny app displaying the result
shinyApp(
    ui=fluidPage(fluidRow(column(6, plotlyOutput("plot")),
                          column(6, plotlyOutput("plot2"))),
                 fluidRow(column(6, DT::dataTableOutput("table")),
                          column(6, DT::dataTableOutput("table2")))),
    server=function(input, output) {
        output$plot   <- renderPlotly({ p  })
        output$plot2  <- renderPlotly({ p2[[1]] })
        output$table  <- DT::renderDataTable({ d[d$c == 1, ] })
        output$table2 <- DT::renderDataTable({ p2[[2]][p[[2]]$c == 1,] })
    }
)
