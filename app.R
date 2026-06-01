#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(htmltools)
library(bslib)
# library(rsvg)
# library(bscui)
source("draw_wheel.R")

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Road to Recovery Wheel Tool"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            div("This is a test.")
        ),

        # Show a plot of the generated distribution
        mainPanel(
          card(
            card_body(
              imageOutput("wheelDiagram")
            )
          )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  # svg interactivity:  https://forum.posit.co/t/use-shiny-setinputvalue-to-register-the-clicking-of-svg/47919

    output$wheelDiagram <- renderImage(
      {
        list(
          src = draw_wheel(),
          height = "400px"
          )
      }, deleteFile = FALSE)

}

# Run the application
shinyApp(ui = ui, server = server)
