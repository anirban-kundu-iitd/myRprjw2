
library(shiny)
library (miniUI)
library(leaflet)
library(readr)
library(dplyr)

state_geocodes <- read_csv("state_geocodes.csv")


server<-shinyServer(function(input, output) {
  
  #-------------- Data explorer ----------------
  output$cpstable <- renderDataTable({state_geocodes})
  
  #-------------- Map data  ----------------
  state_df<-data.frame(lat=as.numeric(state_geocodes$lat),
                       lng= as.numeric(state_geocodes$lng),
                       population= state_geocodes$`population`,
                       popup= paste( state_geocodes$State,
                                     "<br> Population: ",state_geocodes$population,
                                     "<br>visit tourist pacles: <br> <a href='",
                                     state_geocodes$`link`,
                                     "'>", state_geocodes$link,
                                     "</a>",
                                     sep=" ") 
  )
  
  #  curBins<-reactive({input$bins})
  #load the default map 
  output$mymap <- renderLeaflet({
    state_df%>%
      leaflet() %>%
      addTiles()%>% 
      addCircleMarkers(popup=state_df$popup,
                       # fillColor = state_df$fcol,
                       col="#000000" )%>%
      addCircles(weight=.01, radius= state_df$population/100000)
    # addGeoJSON(indiaGeo_json, 
    #            fillColor = "blue") 
  })
  
  
  # # --------- Changes on Map ------------------
  observe({
    
    # output$temp<-renderText({toString(input$bins)})
    # # update colors
    colorpal <- colorBin(palette = "Reds",
                         domain=state_df$population,
                         bins=input$bins,
                         pretty = TRUE )
    
    # update the map data
    state_df<-data.frame(state_df,fcol=colorpal(state_df$population))
    
    leafletProxy("mymap", data=state_df) %>%
      clearMarkers()%>%
      clearControls()%>%
      addCircleMarkers(popup=state_df$popup,
                       fillColor = state_df$fcol,
                       opacity = 0.9,
                       fillOpacity = 0.9,
                       col=state_df$fcol
      )%>%
      addCircles(weight=0.01,
                 radius= state_df$population/100000,
                 col=state_df$fcol,
                 fillColor = state_df$fcol,
                 opacity = 0.9,
                 fillOpacity = 0.9)%>%
      addLegend("bottomright", pal = colorpal, values = state_df$population,
                title = "Population",
                labFormat = labelFormat(prefix = ""),
                opacity = 1
      )
  })# end of observe
  
})
