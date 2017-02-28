# Set up shiny server
shinyServer(function(input, output, session) {

# In this app we look up what tab we are on alot, so a reactive object
# should be made

  which.tab <- reactive({
    which.tab <- which(tabList == input$tabBox.nextPrev)
  })

# Set up the UI for the next and previous buttons
# Using columns that are offset to position the buttons, this uses the same
# general grid structure of bootstrap
# I'm not particularly happy with the offset of columns in this part of the UI,
# distance from the borders are not even, but it shows the general idea

  output$nextPrev <- renderUI({
  # First functions are made to cutdown on repetitive code
    prevFun <- function(x) {
      column(1,
        prevButton,
        offset = x
      )  # column
    }  # prevFun
    nextFun <- function(x) {
      column(1,
        nextButton,
        offset = x
      )  # column
    }  # nextFun

  # Then we make the buttons render depending on which tab we are on
    ntabs <- length(tabList)
    if (which.tab() == ntabs) {
      prevFun(1)
    }  # if on final tab
    else if (which.tab() == 1) {
      nextFun(10)  # 10 so that it is created in the same spot
    }  # if on first tab
    else {
      div(prevFun(1), nextFun(8))
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
