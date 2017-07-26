# Example of the use of input boxes

# Normally if you set up a render ui that changes depending on a counter the
# values that you have entered will disappear.

# To avoid this we use save states that are indexed to provide initial values
# for the updated ui that are equal to what you already had entered in the ui
# before you reset it! Seemless to the user, but tricky for the server!
# ------------------------------------------------------------------------------
# Non-reactive objects/expressions
# Load libraries
  library(shiny)
  library(plyr)

# ------------------------------------------------------------------------------
# Reactive objects/expressions
  shinyServer(function(input, output) {
  # Set up reactiveValues to keep track of the number of input boxes you have (n)
  # Also keep track of what is in your input.boxes (df)
    values <- reactiveValues(n = 3,
      df = data.frame(
        "ID" = c(1, 2, 2),
        "Time" = c(0, 0, 5),
        "Concentration" = c(10, 8, 2)
      )  # df
    )  # values

  # This is the reactive object used to create the rendered UI
  # This could be directly contained with a renderUI function, but is separated
  # for order and clarity.
  # The function takes the values for n and df and creates UI accordingly.
  # llply is used to create a list() of UI elements so that you add additional
  # elements under each previous set of UI elements
  # inputId = paste("text", i) to ensure each input is unique
  # label = ifelse(...) is used to give a title to the first set of input.boxes
  # value = df[i, #] is used to index the saved value in values$df
    input.boxes <- reactive({
      n <- values$n
      df <- values$df
      if(n>0){
        llply(seq_len(n), function(i){
          fluidRow(
            div(class = "MyClass",  #1
              numericInput(paste0("one", i),
                ifelse(i == 1, "ID", NA),
                df[i, 1]
              )  # input$one-i
            ),  # div
            div(class = "MyClass",  #2
              numericInput(paste0("two", i),
                ifelse(i == 1, "Time", NA),
                df[i, 2]
              )  # input$two-i
            ),  # div
            div(class = "MyClass",  #3
              numericInput(paste0("three", i),
                ifelse(i == 1, "Concentration", NA),
                df[i, 3]
              )  # input$three-i
            ),  # div
            tags$head(tags$style(type = "text/css", ".MyClass {display: inline-block}")),  # make inline
            tags$head(tags$style(type = "text/css", ".MyClass {max-width: 110px}"))  # set width
          )  # fluidRow
        })  # llply
      }  # if
    })  # textboxes

  # Use observeEvent to determine if user wants to add or remove a row of boxes
  # Also use to save current state of input.boxes for use
  # Each set either increases or decreases the number of boxes to render (n)
  # ldply to create a data.frame with a number of rows (designated by n) with
  # the values of that data.frame being the input of the user
  # It then saves those values to our reactiveValue object (values)
  # To determine what the input of the user is you need to refer to the input
  # object like you normally would for accessing values from the UI
  # However our input names are input$#i (e.g. input$one1, input$one2 etc.)
  # To access these variable input names we use get() which allows us to use
  # i (a sequential number determined by ldply) to access each input
    observeEvent(input$addsamp, {
      values$n <- values$n + 1
      values$df <- ldply(seq_len(values$n), function(i) {
        data.frame("ID" = get("input")[[paste0("one", i)]],
          "Time" = get("input")[[paste0("two", i)]],
          "Concentration" = get("input")[[paste0("three", i)]])
      })  # ldply
    })  # observeEvent

    observeEvent(input$remsamp, {
      if (values$n>1) {
        values$n <- values$n - 1
      }  # if
      values$df <- ldply(seq_len(values$n), function(i) {
        data.frame("ID" = get("input")[[paste0("one", i)]],
          "Time" = get("input")[[paste0("two", i)]],
          "Concentration" = get("input")[[paste0("three", i)]])
      })  # ldply
    })  # observeEvent

    observeEvent(input$savesamp, {
      values$df <- ldply(seq_len(values$n), function(i) {
        data.frame("ID" = get("input")[[paste0("one", i)]],
          "Time" = get("input")[[paste0("two", i)]],
          "Concentration" = get("input")[[paste0("three", i)]])
      })  # ldply
      values$df <- values$df[with(values$df, order(values$df["ID"])), ]
      print(values$df)
    })  # observeEvent

  # RenderUI for the input.boxes reactive function
    output$tableui <- renderUI({input.boxes()})

  # RenderUI for the table saved by the user
    output$data <- renderTable({
      values$df[with(values$df, order(values$df["ID"])), ]
    })  # renderTable
  })
