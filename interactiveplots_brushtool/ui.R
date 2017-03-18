# UI - Example of using the plot brush with interactive plots
# -----------------------------------------------------------------------------

fluidPage(
  textOutput("title", h2),
  plotOutput("plot",
    brush = "plot_brush",
    height = 250, width = 600
  ),  # plotOutput
  fluidRow(
    uiOutput("nextPrev")
  ),  # fluidRow
  hr(),
  fluidRow(
    verbatimTextOutput("info")
  ),  # fluidRow
  align = "center"
)
