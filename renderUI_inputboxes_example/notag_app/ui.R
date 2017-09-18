# ui.R script for input_boxes_example
# ------------------------------------------------------------------------------
fixedPage(
  h4("Input Boxes Example"),
  hr(),
  sidebarPanel(
    uiOutput("tableui"),
  # Use of div tags and classes to ensure that buttons are inline with one another
    fluidRow(
        actionButton("addsamp", "Add"),
        actionButton("remsamp", "Remove"),
        actionButton("savesamp", "Save")
    ),  # fluidRow
    width = 8
  ),  # sidebarPanel
  mainPanel(
    tableOutput("data"),
    width = 4
  ),  # mainPanel
  align = "center"
)  # fixedPage
