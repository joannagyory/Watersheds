library(shiny)
library(dplyr)
library(ggplot2)
library(readr)
library(plotly)
library(lubridate)
library(leaflet)

# Set directories, read files, subset data
#setwd()
df <- read.csv("Concatenated_Weekly.csv")
df$Date <- ymd(df$Date)
df2015 <- filter(df, Year == 2015)

# Buildy Shiny UI
ui <- fluidPage(
  tabsetPanel(
    # The first tab will be the Readme
    tabPanel("ReadMe",
             h2("NH Rivers Shiny App"),
             br(),
             h3("Welcome!"),
             br(),
             h4("This app displays data collected since 2013 at ten rivers throughout New Hampshire. 
                The River Flow tab has a map of the water sensors indicated by circles whose radii 
                change as a function of the volume of water flow measured through time. Pressing the
                'play' button on the slider bar will animate the changes in river flow for every week
                in 2015. The River Flow tab also includes time series plots of precipitation and air 
                temperature to aid in the interpretation of the river flow data. The Temperatures tab 
                showcases air and water temperature at each site. It allows subsetting by site and 
                date range, and displays the data in a table below. "),
             br(),
             br(),
             h5("Author: Joanna Gyory"),
             h5("jg1088@wildcats.unh.edu")
             ),
    # The second tab will have a map of the water sensors indicated by circles whose radii change
    # as a function of the volume of water flow measured through time.
    tabPanel("River Flow",
             verticalLayout(
               h3("Size of circles is proportional to water flow"),
               
               
               
               # Put a slider on the top right hand corner of the map to cycle through the weeks of the
               # year in 2015.
               absolutePanel(top = 1, right = 20,
                             sliderInput("week", "Week of the year in 2015",min = 1, 
                                         max = 52,
                                         value = 1,
                                         step=1,
                                         animate=animationOptions(interval = 300) # This sets the animation speed
                             ),
                             style = "z-index: 1000;"
               ),
               
               # Use the "leaflet" library to create a map
               leafletOutput("mymap",height = 700),
               
               
               hr(),
               h3("Precipitation at station MCQ (Merrimack River)"),
               plotlyOutput("rain"),
               
               hr(),
               h3("Air temperature at station MCQ (Merrimack River)"),
               plotlyOutput("airtemp")
               
             )
    ),
    # The third tab will have the time series plots of air and water temperature, along with
    # options to subset by site and date range, and a display of the data in a table below.
    tabPanel("Temperatures",
             verticalLayout(
                      h3("Time series of air and water temperature"),
                      plotlyOutput("timeseries"),
                      hr(),
                      h4("Select Site and Date Range"),
                      selectInput("site", "Sites", unique(df$Site)),
                      br(),
                      sliderInput("time",  "Date", min = ymd("2013-11-17"),  max = ymd("2016-04-10"),value = c(ymd("2014-04-15"),ymd("2015-12-31"))),
                      br(),
                      hr(),
                      h4("Data table"),
                      dataTableOutput(outputId = "table")
               )
               )

  )
)
                      

server <- function(input, output, session) {
  
  # Filter data according to the slider bar in the "Temperatures" tab
  filtered_data <- reactive({filter(df, Site == input$site, Date >= input$time[1], Date <= input$time[2])})
  
  # Time series graph output
  output$timeseries <- renderPlotly(
    {
     p <- ggplot(filtered_data(), aes(x=Date)) + 
       theme_bw()+
       geom_line(aes(y=TempC, color = "Water Temp"))+
       geom_line(aes(y=MeanTemp,color = "Air Temp"))+
       scale_color_discrete(name = "Parameters", labels = c("Air Temp", "Water Temp"))+
       labs(y = "Temperature (C)")
      ggplotly(p)
      
    }
  )
  
  # Table output
  output$table <- renderDataTable(
    {
      filtered_data()
    }
  )
  
  # Filter the data according to the slider bar in the "River Discharge" tab
  filteredData2 <- reactive({filter(df2015, Week == input$week)
  })
  
  # Map output
  output$mymap <- renderLeaflet({
    # Use leaflet() for the parts of the map that won't change dynamically
    leaflet(df2015) %>%
      addTiles() %>%
      fitBounds(~min(Long), 42.5, ~max(Long), ~max(Lat))
  })
  
  # Use an observer for changing the size of the circles according to time
  # and the volume of river discharge (Q)
  observe({
    leafletProxy("mymap", data=filteredData2())%>%
      clearShapes()%>%
      addCircles(~Long, ~Lat, weight = 3, radius= ~2000*log(Q), # The radius is a function of
                 # Q, the volume of river discharge,
                 # and I decided on this function of
                 # it by just trial and error.
                 color="#ffa500", stroke = TRUE, fillOpacity = 0.6)
  })
  
  # Time series graph of precipitation
  filtered_data3 <- filter(df2015, Site == 'MCQ')
  
  output$rain <- renderPlotly(
    {
      p <- ggplot(filtered_data3, aes(x=Week)) + 
        theme_bw()+
        geom_line(color = "deepskyblue", aes(y=Precip)) +
        labs(y = "Precipitation (Inches)")
      ggplotly(p)
      
    }
  )
  
  # Time series graph of air temperature
  output$airtemp <- renderPlotly(
    {
      p <- ggplot(filtered_data3, aes(x=Week)) + 
        theme_bw()+
        geom_line(color = "darkorange", aes(y=MeanTemp))+
        labs(y = "Air Temperature (C)")
      ggplotly(p)
      
    }
  )
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)
