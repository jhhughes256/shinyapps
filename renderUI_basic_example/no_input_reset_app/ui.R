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
      hr()
    ),  # column
    align = "center"
  )  # fixedPage
