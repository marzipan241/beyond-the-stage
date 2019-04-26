#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Load packages

library(shiny)
library(shinythemes)
library(tidyverse)

# Load data

love_yourself <- read_csv("love_yourself.csv")

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Beyond the Stage"),
  
  # Application theme
  theme = shinytheme("cyborg"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      
      # Concert date selection
      dateRangeInput(inputId = "date",
                     label = "Concert Date(s):",
                     start = min(love_yourself$date),
                     end = max(love_yourself$date),
                     min = min(love_yourself$date), 
                     max(love_yourself$date),
                     format = "yyyy-mm-dd",
                     separator = "-"),
      
      # Attendance selection
      sliderInput(inputId = "attendance",
                  label = "Attendance:",
                  min = 0, max(love_yourself$attendance),
                  step = 1000,
                  value = c(0, 50000)),
      
      # City selection
      selectInput(inputId = "city",
                  label = "Select City(s)",
                  choices = love_yourself$city,
                  multiple = TRUE),
      
      # Country selection
      selectInput(inputId = "country",
                  label = "Select Country(s)",
                  choices = love_yourself$country,
                  multiple = TRUE),
      
      # Continent selection
      selectInput(inputId = "continent",
                  label = "Select Continent(s)",
                  choices = love_yourself$continent,
                  multiple = TRUE),
      
      # Hyperlink
      tags$a("GitHub Repo", href = "https://github.com/marzipan241/beyond-the-stage.git")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("attendancePlot")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # # Reactive function for live multiple selections
  # date_selection <- reactive({
  #   c(love_yourself$date, love_yourself$attendance, love_yourself$city)
  # })
  # 
  # attendance_selection <- reactive({
  #   c(love_yourself$attendance, love_yourself$city)
  # })
  # 
  city_selection <- reactive({
    c(love_yourself$city)
  })

  country_selection <- reactive({
    c(love_yourself$country)
  })

  continent_selection <- reactive({
    c(love_yourself$continent)
  })

  output$attendancePlot <- renderPlot({
    love_yourself %>% 
      select(date, attendance, city, country, continent) %>% 
      mutate(date >= love_yourself$date[1] & date <= love_yourself$date[2]) %>% 
      mutate(attendance >= love_yourself$attendance[1] & attendance <= love_yourself$attendance[2]) %>% 
      mutate(city %in% city_selection()) %>% 
      mutate(country %in% country_selection()) %>% 
      mutate(continent %in% continent_selection()) %>% 
      
      ggplot(aes(x = city, y = attendance, color = continent, fill = continent)) +
      geom_col() +
      coord_flip() +
      labs(title = "Average Attendance of Each Concert Stop",
           subtitle = "BTS World Tour: Love Yourself",
           caption = "Source: Wikipedia chronology compiled from news articles") +
      xlab("City") +
      ylab("Attendance")
  })
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
