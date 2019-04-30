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
library(ggplot2)


# Load data

# Load data for "Beyond K-pop?" tab

# Datasets scraped from the Spotify API in a Python script in extractions folder
# Due to the immense difficulty and time taken to run the data extraction
# scripts, this is a vanilla app as of Demo Day

kpop_top10 <- read_csv(file = "data/kpop_top10.csv",
                       col_types = cols(
                         X1 = col_double(),
                         danceability = col_double(),
                         energy = col_double(),
                         key = col_double(),
                         speechiness = col_double(),
                         acousticness = col_double(),
                         instrumentalness = col_double(),
                         liveness = col_double(),
                         valence = col_double(),
                         tempo = col_double(),
                         duration_ms = col_double(),
                         time_signature = col_double(),
                         artist_name = col_character(),
                         release_date = col_character(),
                         song_name = col_character(),
                         song_name_formatted = col_character()
                       )) %>% select(-X1, -song_name_formatted)

love_yourself <- read_csv("love_yourself.csv")

# Define UI for application that draws a histogram
ui <- navbarPage(
  
  # Application title
  title = "BEYOND THE STAGE",
  
  # Application theme
  theme = shinytheme("cosmo"),
  
  # Tab divisions
  
  # About Tab
  tabPanel(
    title = "About",
    h1("Description"),
    br(),
    "Placeholder text",
    br(),
    h2("Summary of Findings"),
    br(),
    "Research Questions answered",
    br(),
    h3("Sources"),
    a("Wikipedia", href = "https://en.wikipedia.org/wiki/BTS_World_Tour:_Love_Yourself"),
    p(strong("Further Questions:"))
  ),
  
  # Radio Buttons Tab
  tabPanel(
    title = "Beyond K-pop?",
    h1("description"),
    br(),
    sidebarLayout(
      sidebarPanel(
        radioButtons("text", 
                     "fake text", unique(love_yourself$city))
      ),
      
      mainPanel(
        plotOutput("k_danceability")
      )
      )
    )
  )
  
  tabPanel(
    title = "World Tour Attendance",
    
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
    
    output$k_danceability <- renderPlot({
      kpop_avg_danceability <- kpop_top10 %>%
        select(artist_name, danceability) %>%
        mutate(artist_name = fct_relevel(artist_name,  c("BTS", "Apink", "BIGBANG", "BLACKPINK", "BTOB",
                                                         "EXO", "iKON", "Mamamoo", "TWICE", "Wanna One"))) %>%
        group_by(artist_name) %>%
        summarize(avg_danceability = mean(danceability))
      
      kpop_avg_danceability_chart <- kpop_avg_danceability %>% 
        ggplot(aes(x = artist_name, y = avg_danceability, fill = artist_name)) + 
        geom_col() + 
        coord_flip() + 
        theme(legend.position = "none") +
        labs(title = "Average Danceability of Top 10 Korean Artists (2018)", 
             caption = "Sources: 2018 Melon Music Awards, Spotify") +
        xlab("Artist") + 
        ylab("Danceability")
    })
    
    
    
    
    # Reactive function for live multiple selections
    date_selection <- reactive({
      c(love_yourself$date, love_yourself$attendance, love_yourself$city)
    })
    
    attendance_selection <- reactive({
      c(love_yourself$attendance, love_yourself$city)
    })
    
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
        filter(date >= love_yourself$date[1] & date <= love_yourself$date[2]) %>% 
        filter(attendance >= love_yourself$attendance[1] & attendance <= love_yourself$attendance[2]) %>% 
        filter(city %in% city_selection()) %>% 
        filter(country %in% country_selection()) %>% 
        filter(continent %in% continent_selection()) %>% 
        
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
  