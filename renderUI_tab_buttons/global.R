# Shiny app example of buttons to navigate tabBox
# App based on blog post from "guillotantoine":
# https://antoineguillot.wordpress.com/2017/02/15/three-r-shiny-tricks-to-make-your-shiny-app-shines-13/

# Javascript giving mouseover functionality was removed
# This doesn't really have much to do with

# Load libraries
# This app uses shinydashboard::tabBox
library(shiny)
library(shinydashboard)

# Set up non-reactive code
# Non-reactive code is set up in global.r in this app as we are using
# shinydashboard, and will be calling the tabList object from within the ui
# and the server

# The buttons used in renderUI do not change (however the way they link to their
# respective tabs do) so we can put them in the non-reactive area as ui chunks.

# Here we use an icon() instead of a string to put a "font-awesome" icon on
# the button, `class = fa-2x` makes it twice as big

prevButton <- actionButton("prevTab",
  icon("angle-double-left",
    class = "fa-2x"
  ),
  width = 70
)

nextButton <- actionButton("nextTab",
  icon("angle-double-right",
    class = "fa-2x"
  ),
  width = 70
)

# Set up list of Tabs that will be used
tabList <- c("Tab1", "Tab2", "Tab3", "Tab4")

# This could be set up to make easily modifiable number of tabs
# the following function is the idea, but is untested
# the ui argument would be given a list of ui elements you want in each of your tabs
#library(plyr)
#multiTabPanel <- function(x, ui = list(1:length(x))) {
#  llply(1:length(x), function(i) {
#    tabPanel(x[i], ui[i])
#  })
#}

# Blog code for previous and next buttons: Note that the method of making a
# wider button used below is an side effect of setting col-sm-4
# 70 pixels is about equivalent...
# prevButton <- div(actionButton("prevTab",
#   HTML(
#     '<div class="col-sm-4"><i class="fa fa-angle-double-left fa-2x"></i></div>'
#   )  # HTML
# ))  # div

# nextButton <- div(actionButton("nextTab",
#   HTML(
#     '<div class="col-sm-4"><i class="fa fa-angle-double-right fa-2x"></i></div>'
#   )  # HTML
# ))  # div
