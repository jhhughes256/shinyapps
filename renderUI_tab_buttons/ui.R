# UI for example of buttons to navigate tabBox

# setup the shinydashboard page
dashboardPage(
  # remove the header and sidebar as these are not important to the example
  dashboardHeader(disable = T),
  dashboardSidebar(disable = T),
  # place the tabBox
  dashboardBody(
    box(width = 12,
      tabBox(width = 12, id = "tabBox.nextPrev",
        tabPanel(tabList[1], p("This is tab 1")),
        tabPanel(tabList[2], p("This is tab 2")),
        tabPanel(tabList[3], p("This is tab 3")),
        tabPanel(tabList[4], p("This is tab 4"))
      ),  # tabBox
      uiOutput("nextPrev")
    )  # box
  )  # dashboardBody
)  # dashboardPage
