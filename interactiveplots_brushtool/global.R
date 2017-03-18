library(shiny)
library(ggplot2)

sub.cyl <- sort(unique(mtcars$cyl))

prevFun <- function(x) {
  column(1,
    actionButton("prevTab",
      icon("angle-double-left",
        class = "fa-2x"
      ),
      width = 70
    ),  # actionButton
    offset = x
  )  # column
}  # prevFun

nextFun <- function(x) {
  column(1,
    actionButton("nextTab",
      icon("angle-double-right",
        class = "fa-2x"
      ),
      width = 70
    ),  # actionButton
    offset = x
  )  # column
}  # nextFun
