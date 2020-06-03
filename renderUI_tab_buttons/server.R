# Set up shiny server
shinyServer(function(input, output, session) {

# In this app we look up what tab we are on a lot, so a reactive object
# should be made

  which.tab <- reactive({
    which.tab <- which(tabList == input$tabBox.nextPrev)
  })

# Set up the UI for the next and previous buttons
# Using columns that are offset to position the buttons, this uses the same
# general grid structure of Bootstrap (as in javascript Bootstrap)
# I'm not particularly happy with the offset of columns in this part of the UI,
# distance from the borders are not even, but it shows the general idea

  output$nextPrev <- renderUI({
  # Using the functions we defined in global
    ntabs <- length(tabList)
    if (which.tab() == ntabs) {
      prevFun(1)
    }  # if on final tab
    else if (which.tab() == 1) {
      nextFun(10)  # 10 so that it is created in the same spot
    }  # if on first tab
    else {
      div(prevFun(1), nextFun(8))  # 1 column + 1 offset + 8 offsets = 10
    }  # otherwise
  })  # renderUI

# Now that the buttons are rendered they need to have an action: namely
# changing the tab that is open. observeEvent can be used for this
  observeEvent(input$prevTab, {
    updateTabsetPanel(session,
    inputId = "tabBox.nextPrev",
    selected = tabList[which.tab() - 1])
  })

  observeEvent(input$nextTab, {
    updateTabsetPanel(session,
    inputId = "tabBox.nextPrev",
    selected = tabList[which.tab() + 1])
  })

})  # shinyServer
