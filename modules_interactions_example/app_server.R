# Server function for module example
#' @import shiny
app_server <- function(input, output, session) {
# Set up reactive objects, "save states" or however you like to think of R6
# Reactive Values
# Set up an object which acts like a reactive list which can then be used as an
# argument in module functions to access it in the module environment.
  rv <- reactiveValues(Rdist = NULL)
# Session User Data
# Set up a "slot" or index in the session$userData object, that we can access
# later. You may be able to assign straight to this object from within a module
# without this type of preamble, but mentioning it here can help others know
# what "slots" or indices you are using within the app at a glance.
  session$userData[["Rdist"]] <- NULL
  
# Sidebar Module
# This module makes changes to the rv reactiveValues object so it is called
# using the argument defined in the module function.
  Rx <- callModule(mod_sidebar_server, "side", rv = rv)
  
# Mainbody Module
# So coming in to the mainbody module, we now have a reactive function `Rx`,
# a reactiveValues object `rv` and a session$userData index. The latter is 
# automatically an argument for the module, however the other two need to be
# specified as arguments.
  callModule(mod_mainbody_server, "main", rv = rv, Rx = Rx)

}  # app_server