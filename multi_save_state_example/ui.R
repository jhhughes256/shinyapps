# ui.R script for state_saving function example
# ------------------------------------------------------------------------------
  fixedPage(
    h3("1-compartment, first-order oral absorption kinetics"),
    actionButton("console","Debug Console"),
    hr(),
    plotOutput("concPlot",width = 600),  # Concentration-time profile output
    fixedRow(
      column(9,
        sliderInput("DOSE",
          "Dose (mg):",
          min = 10,
          max = 100,
          step = 5,
          value = 50
        )  # sliderInput
      ),  # column
      column(2,
        actionButton("save", "Save"),  # actionButton
        actionButton("clear", "Clear")  # actionButton
      ) # column
    ), # fixedRow
    fixedRow(
      div("If you wish to see the innards of the code using debug press the
        debug button and navigate to the console window."),
      hr(),
      div("Enter rv$n to see the number of extra plots"),
      div("Enter rv$Sconc to see the state of the data.frame"),
      div("Enter c to allow the app to function after debug"),
      div("Enter Q to stop the shiny app while in debug")
    ),  # fixedRow
    align = "center"
  )  # fixedPage
