
# Load the required libraries

library(shiny)
library(ggplot2)
library(maps)
library(dplyr)

# Define server logic required to draw the map
shinyServer(function(input, output) {
  
  # Read and subset the data by the required month
  
  s_monthInput <- reactive({
    tord <- read.csv("tor_data.csv")
    lmth<- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
    tords<- tord[tord$mth==which(lmth==input$s_month),]

  })
  
  # Subset the data by the required tornado scales
  
  efsInput <- reactive({
    
    tords<- s_monthInput()
    tordse<- tords[tords$fs %in% input$efs,]
    
    # if subset has no rows, initialise with a dummy row
    
    if (nrow(tordse) == 0) {
       
      tordse[1,1] = 1950
      tordse[1,2] = 1
      tordse[1,3] = ""
      tordse[1,4] = 1
      tordse[1,5] = 0
    }
    
    # Summarise the subset by state
    
    sumtor<- summarise(group_by(tordse,region), cnt=n(),fat=sum(fat, na.rm = T))
    
  })
  
  # Plot the map based on the number of tornadoes
   
  output$TorPlot <- renderPlot({
    
    state_map <- map_data("state")
    tdata<- efsInput()
    pdata <- merge(state_map, tdata, by="region", all=TRUE)
    
    title <- paste("Number of Tornadoes in the month of", input$s_month, "per state")
    p <- ggplot(pdata, aes(map_id = region))
    
    p <- p + geom_map(aes(fill = cnt), map = state_map, colour='black') + expand_limits(x = state_map$long, y = state_map$lat)
    
    p <- p + scale_fill_continuous(low = "thistle2", high = "darkred", guide="colorbar")
    
    p <- p + coord_map() + theme_bw()
    
    p <- p + labs(x = "Long", y = "Lat", title = title) + theme(plot.title = element_text(hjust = 0.5))
    
    print(p)
    
  })
  
  # Plot the map based on the number of fatalities
  
  output$FatPlot <- renderPlot({
    
    state_map <- map_data("state")
    tdata<- efsInput()
    pdata <- merge(state_map, tdata, by="region", all=TRUE)
    
    title <- paste("Number of Fatalities in the month of", input$s_month, "per state")
    p <- ggplot(pdata, aes(map_id = region))
    
    p <- p + geom_map(aes(fill = fat), map = state_map, colour='black') + expand_limits(x = state_map$long, y = state_map$lat)
    
    p <- p + scale_fill_continuous(low = "thistle2", high = "darkred", guide="colorbar")
    
    p <- p + coord_map() + theme_bw()
    
    p <- p + labs(x = "Long", y = "Lat", title = title) + theme(plot.title = element_text(hjust = 0.5))
    
    print(p)
    
  })
  
})
