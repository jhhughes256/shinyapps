# server.R script for state_saving function example
# Allows user to save state of an object in the environment
# Can then be recalled or reused

# The use of "save states" or "state saving" is very useful when you want to
# reuse a previous state of your app, with the current state.
# ------------------------------------------------------------------------------
# Non-reactive objects/expressions
# Load package libraries
  library(shiny)
  library(ggplot2)
# Define custom ggplot theme
  theme_bw2 <- theme_set(theme_bw(base_size = 14))
# Define sequence for time at which concentrations will be calculated
  time <- sort(unique(c(
    seq(from = 0, to = 5, by = 0.25),
    seq(from = 5, to = 24, by = 1)
  )))
# Define colour palette (colour blind friendly w/ grey instead of black)
# http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/
  cPalette <- c("#E69F00", "#56B4E9", "#009E73",
    "#F0E442", "#0072B2", "#D55E00")

# ------------------------------------------------------------------------------
# Reactive objects/expressions
  shinyServer(function(input, output) {
    # First set up your reactiveValue object where you will keep track of the
    # number of dose sliders the user wants
    # While reactive() is used to create a reactive object, reactiveValues is
    # used to create a list of reactive values inside of a non-reactive object
    # It shares many similarities with list()
    rv <- reactiveValues(
      n = 1,
      Rslider.val = 10
    )  # rv

    # Use observeEvent to determine if user wants to add or remove a row of boxes
    # Each set either increases or decreases the number of sliders to render (n)
    # Create a max number of sliders to prevent user from going overboard
    observeEvent(input$add, {
      if (rv$n<4) {
        rv$n <- rv$n + 1
      }
      rv$Rslider.val <- unlist(llply(seq_len(rv$n), function(i) {
        get("input")[[paste0("DOSE", i)]]
      }))  # llply
    })  #observeEvent

    # Same as above but check number of sliders to ensure there is at least 1
    observeEvent(input$rem, {
      if (rv$n>1) {
        rv$n <- rv$n - 1
      }
      rv$Rslider.val <- unlist(llply(seq_len(rv$n), function(i) {
        get("input")[[paste0("DOSE", i)]]
      }))  # llply
    })  #observeEvent

    # Using rv$n we determine how many sliders should appear on the UI
    # We use llply to create a number of sliders equal to rv$n each with a
    # unique input name, following the pattern input$DOSE# where # is a number
    # The if statement is there for safety
    Rsliders <- reactive({
      if(rv$n>0) {
        llply(seq_len(rv$n), function(i) {
          fluidRow(
            sliderInput(paste0("DOSE", i),
              "Dose (mg):",
              min = 10,
              max = 100,
              step = 5,
              value = rv$Rslider.val[i]
            )  # sliderInput
          )  # fluidRow
        })  # llply
      }  # if
    })

    # Don't forget to render your UI!
    output$slidersUI <- renderUI({Rsliders()})

    # The data for plotting needs to be setup so that it can receive a variable
    # amount of doses
    # To achieve this we want dose to be a vector of multiple doses from
    # input$DOSE1 to input$DOSErv$n using llply
    # This creates a list, however we want a vector so we use unlist
    # Finally we use ldply to take each dose and find the concentrations for
    # them storing them as a data.frame where the rownames correlate to the each
    # input$DOSE (important to remember when plotting the data)
    # The contents of this function could all exist within the renderPlot({})
    # below, however it has been kept modular for clarity
    Rconc <- reactive({
    # Concentrations simulated from a basic one compartment model
      list.dose <- llply(seq_len(rv$n), function(i) {
        get("input")[[paste0("DOSE", i)]]
      })  # llply
      dose <- unlist(list.dose)
      wt <- 70  # Weight (kg)
      crcl <- 90  # Creatinine clearance (mL/min)
      CL <- 15*((wt/70)^0.75)*((crcl/90)^1.25)  # Clearance, L/h
      V <- 20*(wt/70)  # Volume of distribution, L
      KA <- 0.2  # Absorption rate constant, h^-1
      row.conc <- ldply(dose, function(dose) {
        dose*KA/(V*(KA - CL/V))*(exp(-CL/V*time) - exp(-KA*time))
      })
      # We now have a data.frame that has concentrations for rv$n doses stored in
      # rows of data, but this isn't useful for ggplot2
      conc <- ldply(seq_len(rv$n), function(i) {
        data.frame(
          Cp = as.numeric(row.conc[i, ]),
          n = cPalette[i]
        )
      })
    })  # Rconc

    # Render your plot so that there is a geom_line for each dose
    # Using as.numeric() we convert the rows of data.frame into a vector
    output$concPlot <- renderPlot({
    # Create the basic ggplot2 object for output
      plotobj <- ggplot()
      plotobj <- plotobj + geom_line(aes(x = rep(time, rv$n), y = Rconc()$Cp,
        colour = Rconc()$n))
      plotobj <- plotobj + scale_colour_manual(values = cPalette)
      plotobj <- plotobj + scale_x_continuous("\nTime (hours)")
      plotobj <- plotobj + scale_y_continuous("Concentration (mg/L)\n",
        lim = c(0, 1.2))
    # Print final object
      plotobj + theme(legend.position = "none")
    })  # renderPlot
  })  # shinyServer
