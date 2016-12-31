#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)




# Define UI for application that draws a histogram
shinyUI(fluidPage(
        
  # Application title
  titlePanel("Carrier Mobility and Diffusion Coefficient vs. doping concentration"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
        helpText("Note: The figures exhibits the calculated doping dependence of the 
                electron and hole mobilities and diffusivity in Si."),

        helpText("You can input the doping concentration and get the calculated
                mobilities and diffusivity in the calculator below."),
        hr(),
       textInput("doping",
                   "Selects doping concentration, e.g. 1E15", 
                   value = 1E15),
       radioButtons ("type", label = ("Semiconductor Type"),
                     choices = list("p-Si" = 1, "n-Si" = 2), selected = 1),
       h5("The carriers mobility of this silicon is: "),
       textOutput("mobility"),
       h5("The diffusion coefficient of this silicon is:"),
       textOutput("diffusivity")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
            plotOutput("distPlot"),
            hr(),
            plotOutput("distPlot1"),
            hr()
       
       
    )
  )
))
