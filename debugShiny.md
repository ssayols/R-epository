## A browser anywhere, anytime
The first thing to do is to insert an action button, and a browser()
in the observeEvent() watching this button. This is a standard
approach: at any time, you just press this button, and you’re inside
the Shiny Application — then, you can access the value of the reactiveValues
and run the reactive elements, accessing the values they have at the moment
you’ve pressed the button.

```R
# Add to your UI: 
actionButton("browser", "browser"),
tags$script("$('#browser').hide();")
```

```R
# Add to your server 
observeEvent(input$browser,{
  browser()
})
```

And to show the button in your app, go to your web browser, open the JS console, and type:
```JS
$('#browser').show();
```
