library(ggplot2)
library(plotly)

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
mobility <- data.frame(doping = concentration, e.diff = electron.diffusivity, h.diff = hole.diffusivity)
mobility <- melt(mobility, id = c("doping"))
## Plotting result
q <- ggplot(data = mobility) + 
        geom_line(aes(x = doping, y = value, colour = variable)) +
        scale_colour_manual(values = c("red", "blue"))+
        
        scale_x_log10() +
        scale_y_log10() + 
        labs(title = "Diffusion Coefficient vs. doping concentration") +
        xlab("NA or ND (cm-3)") +
        ylab("Difffusion Coefficient (cm2/sec)")