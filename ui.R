
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
# installed install.packages("googlesheets")

library(shiny)
library(leaflet)
# library(htmlwidgets)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("" ),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel( position="float",
                  #--------- have to put image in root/www/ directory--------------- 
                  h3("India State wise Places to visit"),
                  br(),
                  sliderInput("bins",
                              "Devide states into buckets as per population:",
                              min = 2,
                              max = 5,
                              value = 3)
                  
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      
      # plotOutput("distPlot")
      # -- for multiple tab on a sigle panel--------------
      tabsetPanel(type="tabs",
                  tabPanel("State wise information", 
                           br(),
                           # h1(textOutput("temp")),
                           leafletOutput("mymap", height = 550)),
                  tabPanel("Data Explorer", br(),dataTableOutput('cpstable'))
                  )
      )
      #----------------------end of tab---------------------
      
    ) # end of main Panel
  )
)

