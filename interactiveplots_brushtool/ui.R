# UI - Example of using the plot brush with interactive plots
# -----------------------------------------------------------------------------

fluidPage(
  textOutput("title", h2),
# Brush argument allows you to use the brush tool interactively with the plot
# This input is titled by the first argument in brushOpts
# resetOnNew deletes the previously brushed points when a new plot is drawn
  plotOutput("plot",
    brush = brushOpts("plot_brush", resetOnNew = T),
    height = 250, width = 600
  ),  # plotOutput
# A similar feataure implemented in renderUI_tab_buttons
  fluidRow(
    uiOutput("nextPrev")
  ),  # fluidRow
  hr(),
  fluidRow(
    verbatimTextOutput("info")
  ),  # fluidRow
  align = "center"
)
