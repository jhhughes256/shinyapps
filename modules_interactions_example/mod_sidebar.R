# UI module

# Example UI module that contains all my inputs. Scroll down for server.

mod_sidebar_ui <- function(id) {
# Define namespace function for IDs
  ns <- NS(id)
# Create tagList to be used in the UI
  tagList(
    sidebarPanel(
      selectInput(ns("disttype"),
        "Distribution type",
        choices = list(
          "Normal" = 1,
          "Log-Normal" = 2,
          "Inverse Gamma" = 3,
          "Cauchy" = 4,
          "Uniform" = 5
        )  # choices.disttype
      ),  # selectInput.disttype
      sliderInput(ns("lengthx"),
        "Length of x:",
        min = 0,
        max = 10,
        step = 1,
        value = 10
      ),  # sliderInput.lengthx
      conditionalPanel(condition = "input.disttype == 1",
        sliderInput(ns("nmean"),
          "Mean:",
          min = -10,
          max = 10,
          step = 0.1,
          value = 0
        ),  # sliderInput.nmean
        ns = ns  # specify namespace for conditionalPanel
      ),  # conditionalPanel.disttype==1
      conditionalPanel(condition = "input.disttype == 2",
        sliderInput(ns("lnmean"),
          "Mean:",
          min = 0.1,
          max = 20,
          step = 0.1,
          value = 1
        ),  # sliderInput.lnmean
        ns = ns  # specify namespace for conditionalPanel
      ),  # conditionalPanel.disttype==2
      conditionalPanel(condition = "input.disttype <= 2",
        sliderInput(ns("sd"),
          "Standard Deviation:",
          min = 0,
          max = 10,
          step = 0.1,
          value = 1
        ),  # sliderInput.sd
        ns = ns  # specify namespace for conditionalPanel
      ),  # conditionalPanel.disttype<=2
      conditionalPanel(condition = "input.disttype == 3",
        sliderInput(ns("alpha"),
          "alpha:",
          min = 0.1,
          max = 2,
          step = 0.1,
          value = 0.1
        ),  # sliderInput.alpha
        sliderInput(ns("beta"),
          "beta:",
          min = 0.1,
          max = 2,
          step = 0.1,
          value = 0.1
        ),  # sliderInput.beta
        ns = ns  # specify namespace for conditionalPanel
      ),  # conditionalPanel.disttype==3
      conditionalPanel(condition = "input.disttype == 4",
        sliderInput(ns("l"),
          "Location:",
          min = 0.1,
          max = 2,
          step = 0.1,
          value = 0.1
        ),  # sliderInput.l
        sliderInput(ns("s"),
          "Scale:",
          min = 0.1,
          max = 2,
          step = 0.1,
          value = 0.1
        ),  # sliderInput.s
        ns = ns  # specify namespace for conditionalPanel
      ),  # condtionalPanel.disttype==4
      conditionalPanel(condition = "input.disttype == 5",
        sliderInput(ns("min"),
          "Minimum:",
          min = 0,
          max = 10,
          step = 0.5,
          value = 1
        ),  # sliderInput.min
        sliderInput(ns("max"),
          "Maximum:",
          min = 0,
          max = 10,
          step = 0.5,
          value = 7
        ),  # sliderInput.max
        ns = ns  # specify namespace for conditionalPanel
      )  # conditionalPanel.disttype==5
    )
  )
}  # mod_sidebar_ui

# Server module

# Here the server is defined. The server is treated as it normally would, 
# using reactive functions. It has additional arguments, session, because its
# required by callModule to handle namespaces, but also lets us used 
# session$userData, and rv, an object that contains our reactiveValues object.
# Code that allows communication with other modules is at the bottom of the
# server module.

mod_sidebar_server <- function(input, output, session, rv) {
# Generate a sequence of x suitable for user-selected distribution
  Rx <- reactive({
    if (input$disttype == 1) {
      x <- seq(from = -10, to = input$lengthx, by = 0.001)
    } else if (input$disttype == 2) {
      x <- seq(from = 0.001, to = input$lengthx, by = 0.001)
    } else {
      x <- seq(from = 0, to = input$lengthx, by = 0.001)
    }
    return(x)
  })  # reactive.Rx

# Generate the user-selected distribution
  Rdist <- reactive({
    # Generate the normal distribution for each value of x given the input for
    # mean ("input$nmean") and standard deviation ("input$sd")
    if (input$disttype == 1) {
      dist <- 1/(sqrt(2*pi)*input$sd)*exp(-((Rx()-input$nmean)^2)/(2*input$sd^2))
    }
    # Generate the log-normal distribution for each value of x given the input
    # for mean ("input$lnmean") and standard deviation ("input$sd")
    if (input$disttype == 2) {
      dist <- 1/(sqrt(2*pi)*input$sd)*exp(-((log(Rx())-log(input$lnmean))^2)/(2*input$sd^2))
    }
    # Generate the inverse gamma distribution for each value of x given the
    # input for alpha ("input$alpha") and beta ("input$beta")
    if (input$disttype == 3) {
      dist <- (input$beta^input$alpha)/gamma(input$alpha)*Rx()^(-input$alpha-1)*exp(-input$beta/Rx())
    }
    # Generate the cauchy distribution for each value of x given the input for
    # l (location) and s (scale)
    if (input$disttype == 4) {
      dist <- 1/(pi*input$s*(1+((Rx()-input$l)/input$s)^2))
    }
    # Generate the uniform distribution for each value of x given the input
    # for min and max
    if (input$disttype == 5) {
      dist <- Rx()/Rx()*1/(input$max-input$min)
    }
    return(dist)
  })  # reactive.Rdist
  
# Communication example from here down ----------------------------------------
  
# Reactive Values and Session User Data
# Here we observe for changes in the output of the Rx reactive function
# When it changes (with an update of input) the value is then assigned to one
# of our two methods of communicaton. 
  observeEvent(Rdist(), {
  # The reactiveValues object rv is like a list, so we can use rv$Rx to assign 
  # the values to the list. Because we "pulled in" rv by naming it as an 
  # argument in our server function, when it is updated in the module, it is 
  # updated on the server level too!
    rv$Rdist <- Rdist()
  # The session object is also called in as a part of all modules (to allow 
  # namespaces to work), so we can access the object we defined on the server 
  # level and make changes to it. Changes made in the module are reflected on 
  # the server level.
    session$userData[["Rdist"]] <- Rdist()
  })
  
# Reactive Functions
# By using return the Rx reactive function is returned to whichever 
# environment the module function was called. If the callModule() function on
# the server is assigned to a name, then that reactive function will exist in
# the server! In this case, the reactive function is assigned to the same name
# server side. You could also return a list of reactive functions if you want
# to send multiple reactives to the server! Remember, this is a function, so 
# still needs to be called via Rx().
  return(Rx)
  
}  # mod_sidebar_server