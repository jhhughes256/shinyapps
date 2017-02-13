# server.R script for multi_state_saving function example
# Allows user to save state of multiple objects in the environment
# Can then be recalled or reused

# If something is unclear, check the comments in the original save_state_example
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
    "#F0E442", "#0072B2", "#D55E00", "#CC79A7", "#999999")

# ------------------------------------------------------------------------------
# Reactive objects/expressions
  shinyServer(function(input, output) {
    # First set up data you plan to plot
    # Save data to be plotted as a reactive object due to multiple reactive
    # functions depending on it
    Rconc <- reactive({
    # Concentrations simulated from a basic one compartment model
      dose <- input$DOSE
      wt <- 70  # Weight (kg)
      crcl <- 90  # Creatinine clearance (mL/min)
      CL <- 15*((wt/70)^0.75)*((crcl/90)^1.5)  # Clearance, L/h
      V <- 20*(wt/70)  # Volume of distribution, L
      KA <- 0.2  # Absorption rate constant, h^-1
      conc <- dose*KA/V*(KA - CL/V)*(exp(-CL/V*time) - exp(-KA*time))
    })  # Rconc

    # Now set up your reactiveValue object where you will create "save states"
    #
    rv <- reactiveValues(
      n = 0,  # additional plots
      Sconc = data.frame(Cp = NULL, palette = NULL)  # saved concentrations
    )  # rv

    # The reactive function observeEvent is used to observe save button
    # On pressing the save button:
    #   set the number of extra plots up one number
    #     - this is isolated so that the plot code does not run early
    #   attach the current concentrations to the end of the currently saved
    #   concentrations (Cp), and assign a colour to them (palette)
    observeEvent(input$save, {
      isolate({
        rv$n <- rv$n + 1
      })
      rv$Sconc <- rbind(
        rv$Sconc,
        data.frame(
          Cp = Rconc(),
          palette = factor(rv$n)
        )
      )
    })  #observeEvent

    # Observe the clear button for when the user wishes to delete the saved plot
    # On pressin the clear button:
    #   reset the number of extra plots to zero
    #   reset the saved concentrations to none
    observeEvent(input$clear, {
      isolate({
        rv$n <- 0
      })
      rv$Sconc <- data.frame(Cp = NULL, palette = NULL)
    })  #observeEvent

    # There are now two concentration vectors
    #   Rconc - reactive concentrations - called with Rconc()
    #   Sconc - saved concentrations - called with rv$Sconc

    # The server is now ready to use "save states"
    # Render your plot (table/text/etc.)
    output$concPlot <- renderPlot({
    # Create the basic ggplot2 object for output
      plotobj <- ggplot()
      plotobj <- plotobj + geom_line(aes(x = time, y = Rconc()), colour = "black")
      plotobj <- plotobj + scale_x_continuous("\nTime (hours)")
      plotobj <- plotobj + scale_y_continuous("Concentration (mg/L)\n",
        lim = c(0,0.3))
    # If statement to also plot the "save state" if it exists
    # saved concentrations is a data.frame with named columns but no existing
    # columns, so length will be zero until save is pressed
    # then it simply plots the concentrations as you would with a normal dataframe
      if (length(rv$Sconc) != 0) {
        plotobj <- plotobj + geom_line(
          aes(x = rep(time, times = rv$n), y = rv$Sconc$Cp, colour = rv$Sconc$palette)
        )
    # manually set the colour scale so that they don't change every time you
    # press the save button
        plotobj <- plotobj + scale_colour_manual(values=cPalette)
      }

    # Print final object without a legend (cleans the plot up)
      plotobj + theme(legend.position="none")
    })  # renderPlot

    # Open debug console for R session
  	observe(label = "console", {
  		if(input$console != 0) {
  			options(browserNLdisabled = TRUE)
  			saved_console <- ".RDuetConsole"
  			if (file.exists(saved_console)) load(saved_console)
  			isolate(browser())
  			save(file = saved_console, list = ls(environment()))
  		}
  	})
  })  # shinyServer
