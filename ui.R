
library(shiny)

# Define UI for application
fluidPage(
  
  # Application title
  titlePanel("Tornado Explorer"),
  
  # Sidebar Panel to provide inputs
  
  sidebarPanel(
  
  selectInput(inputId = "s_month",
              label = "Select a month to explore the impact",
              choices = c("Jan", "Feb", "Mar", "Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"),
              selected = "May"),
  
  br(),
  
  checkboxGroupInput(inputId = "efs",
                label = "Select the EF scale of the tornado",     
                c(1,2,3,4,5),
                selected = 1)

  ),
    # Show a plot of the map with the impacts
    # Show documentation about the application
  
  mainPanel(
    tabsetPanel(type = "tabs", 
                tabPanel("Plot", plotOutput("TorPlot"), br(), br(), plotOutput("FatPlot")), 
                tabPanel("About",includeMarkdown("Readme.md"))) 
               
    )

)

