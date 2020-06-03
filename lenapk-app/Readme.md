This Shiny application demonstrates the use of `shinydashboard` for utilising
different `box` functions in a grid layout. It also demonstrates how to 
customise buttons with icons. 

It is also an example of simulating from a population pharmacokinetic model in 
an application using `mrgsolve`, where simulation results can be "saved" and 
compared to new simulations. This allows the comparison of concentrations
with varying covariates and doses.

Press the floppy disk button to save the current simulation and
then change the inputs to see it in action. Press the trash can button to
delete the saved data. This ability to remember the state of the application
uses `observeEvent` and `reactiveValues` to store the save data.

**THIS IS AN EXAMPLE APPLICATION AND IS FOR DEMONSTRATION PURPOSES ONLY.**