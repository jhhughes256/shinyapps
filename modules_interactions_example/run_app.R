# Example Module Application - Interactions Between Modules ------------------
# For module basics see other modules_basic_example

# The app has two modules, one for the sidebar and one for the main body. There
# are objects in one module that we want to use in the other module. There are
# four ways (that I know of) to communicate between modules. These have some
# overlap but the ways are via:
# - reactive functions
# - reactiveValues R6 objects
# - the session R6 object (specifically the userData environment in that object)
# - custom R6 objects

# This application will show the first 3, as I don't see any good reason to
# design a custom R6 when reactiveValues and session$userData exist.

# Import packages and set up ggplot2 ------------------------------------------
  library(tidyverse)
  library(shiny)
  theme <- theme_set(theme_bw(base_size = 18))

# UI for application ----------------------------------------------------------
  source("app_ui.R")

# Server for application ------------------------------------------------------
  source("app_server.R")

# Source in modules -----------------------------------------------------------
  source("mod_sidebar.R")
  source("mod_mainbody.R")

# Run app ---------------------------------------------------------------------
  runApp(shinyApp(app_ui, app_server))
