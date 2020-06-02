# UI module

# This is the UI for the main body module. A simple mainPanel with a plot in it.

mod_mainbody_ui <- function(id) {
# Define namespace function for IDs
  ns <- NS(id)
# Create tagList to be used in the UI
  tagList(
    mainPanel(
      plotOutput(ns("distPlot"))
    )  # mainPanel
  )
}  # mod_mainbody_ui

# Server module

# The server module has extra arguments for the two objects we bring in from
# the server. Here a quick check occurs to see if session$userData and rv$Rdist 
# made it all the way here, and if they are equal! Note that 
# session$userData[["Rx"]] is commented out as I don't want to have two 
# identical lines, but could easily be swapped in, and the app should still 
# work. Try it out! 

mod_mainbody_server <- function(input, output, session, rv, Rx) {
# Generate the server output to be sent back to the user interface
  output$distPlot <- renderPlot({
    print(all.equal(session$userData[["Rdist"]], rv$Rdist))
    if (length(Rx() == length(rv$Rdist))) {  # Error prevention
      plotobj1 <- NULL
      plotobj1 <- ggplot()
      plotobj1 <- plotobj1 + geom_line(aes(x = Rx(), y = rv$Rdist))
      # plotobj1 <- plotobj1 + geom_line(aes(x = Rx(), y = session$userData[["Rdist"]]))
      plotobj1 <- plotobj1 + scale_y_continuous("Distribution Density\n")
      plotobj1 <- plotobj1 + scale_x_continuous("\nx")
      print(plotobj1)
    }
  })  #output.distPlot
}  # mod_mainbody_server