#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

k <- 8.617e-5
T <- 300
# Fit Parameters

NDref <- 1.3e17
NAref <- 2.35e17
unmin <- 92
upmin <- 54.3
un0 <- 1268
up0 <- 406.9
an <- 0.91
ap <- 0.88
##Diffusion Coefficient Calculation
concentration <- seq(1e14, 1e18, length.out = 100)
un <- unmin + un0/(1+(concentration/NDref)^an)
up <- upmin + up0/(1+(concentration/NAref)^ap)

electron.diffusivity <- k * T * un
hole.diffusivity <- k * T * up
mobility <- data.frame(doping = concentration, e.mob = un, h.mob = up)
diffusivity <-  data.frame(doping = concentration, e.diff = electron.diffusivity, h.diff = hole.diffusivity)
mobility <- melt(mobility, id = c("doping"))
diffusivity<- melt(diffusivity, id = c("doping"))
## Plotting result
q <- ggplot(data = diffusivity, aes(x = concentration)) + 
        geom_line(aes(x = doping, y = value, colour = variable)) +
        scale_colour_manual(values = c("red", "blue"))+
        scale_x_log10() +
        scale_y_log10() + 
        labs(title = "Diffusion Coefficient vs. dopant concentration at room temperature") +
        xlab("NA or ND (cm-3)") +
        ylab("Difffusion Coefficient (cm2/sec)")
      

q1 <- ggplot(data = mobility, aes(x = concentration)) + 
        geom_line(aes(x = doping, y = value, colour = variable)) +
        scale_colour_manual(values = c("red", "blue"))+
        scale_x_log10() +
        scale_y_log10() + 
        labs(title = "carrier mobilities vs. dopant concentration at room temperature") +
        xlab("NA or ND (cm-3)") +
        ylab("Carrier Mobilities (cm2/V-sec)")
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
      
      output$mobility <- renderText({
              upout <- upmin + up0/(1+(as.numeric(input$doping)/NAref)^ap)
              unout <- unmin + un0/(1+(as.numeric(input$doping)/NDref)^ap)
              paste0(
             if (input$type== 1) { 
                   round(upout,2)
             }
              else if(as.numeric(input$type) == 2) {
                   round(unout,2)
              }, "<b>",
              " cm2/V-sec" )
             
      })  
      output$diffusivity <- renderText({
              upout <- upmin + up0/(1+(as.numeric(input$doping)/NAref)^ap)
              unout <- unmin + un0/(1+(as.numeric(input$doping)/NDref)^ap)
              paste0( 
                      if (input$type== 1) { 
                             round( upout * k * T,2)
                      }
                      else if(as.numeric(input$type) == 2) {
                              round(unout * k * T, 2)
                      }, "<b>",
                      " cm2/sec"
              )
      })  
      
      output$distPlot <- renderPlot({
    
      print(q1)
    
  })
      output$distPlot1 <- renderPlot({
         print(q)
      })
      
  
})
