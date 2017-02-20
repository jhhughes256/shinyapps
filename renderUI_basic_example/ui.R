# ui.R script for state_saving function example
# ------------------------------------------------------------------------------
  fixedPage(
    h3("1-compartment, first-order oral absorption kinetics"),
    hr(),
    plotOutput("concPlot",width = 600),  # Concentration-time profile output
    column(8,
      uiOutput("slidersUI")
    ),  # column
    column(4,
      strong("Add or remove dose sliders"),
      hr(),
      actionButton("add", "Add"),  # actionButton
      actionButton("rem", "Remove"),  # actionButton
      hr(),
      p("Every time a new slider is added, the values for each slider will reset."),
      p("To prevent this you can save the current value in a reactiveValues object
        whenever add or remove is pressed."),
      p("This reactiveValue object will then
        be the new number for the value argument in sliderInput.")
    ),  # column
    align = "center"
  )  # fixedPage
