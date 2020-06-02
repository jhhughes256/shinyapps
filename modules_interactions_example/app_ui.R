# UI function for module example
# The UI for this app is very simple. It consists of a standard shiny fluidPage
# structure, with a titlePanel and a sidebarLayout. The sidebar and mainbody
# of the sidebarLayout are made into separate modules.

#' @import shiny
app_ui <- function() {
  fluidPage(
  # Application title
    titlePanel("Distributions"),
    sidebarLayout(
      mod_sidebar_ui("side"),
      mod_mainbody_ui("main")
    )  # sidebarLayout
  )  # fluidPage
}  # app_ui