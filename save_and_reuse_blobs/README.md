Shows how to create R objects and save them as binary BLOBs in a SQLITE3 database (field type BLOB). Afterwards, the BLOBs can be retrieved and reused as if they were the original R object.

This technique is useful when we want to save *persistent* objects together with some metadata, and index them for a quick access.

What can it be used for, in real life?

- saving the rendered result of heavy computations, to be reused later on without calculating the stuff again.
- saving stuff generated interactively, eg. from a shiny app, to be reused later in, for example, a Markdown report.

## Example

Here we have a shiny app that makes some plots and tables. Saves the dataframe containing the data, and also the plot (*grid*)), and later retrieves and displays them.

### Shiny app

```R
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
dbGetQuery(con, 'insert into t (obj) values (:g)', params=data.frame(g=I(list(serialize(d, NULL)))))
dbGetQuery(con, 'insert into t (obj) values (:g)', params=data.frame(g=I(list(serialize(p, NULL)))))
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
```

### Report

From the report, we connect to the database and retrieve the BLOBs, which we can render like in the shiny app.

```Markdown
---
title: "Interactive Document"
output: ioslides_presentation
---

```{r setup, include=F}
library(ggplot2)
library(plotly)
library(DT)
library(RSQLite)

# retrieve
con <- dbConnect(RSQLite::SQLite(), dbname="x.db")
df <- dbGetQuery(con, "select * from t")
p2 <- lapply(df$obj, unserialize)
dbDisconnect(con)
```

## retrieved plot

```{r, echo=F}
renderPlotly({ p2[[1]] })
```

## retrieved table

```{r, echo=F}
DT::renderDataTable({ p2[[2]][p2[[2]]$c == 1, ] })
```

```
