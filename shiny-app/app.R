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

# Datasets scraped from the Spotify API in a Python script in extractions folder
# Due to the immense difficulty and time taken to run the data extraction
# scripts, this is a vanilla app as of Demo Day

kpop_top10 <- read.csv("data/kpop_top10.csv")
us_top10 <- read.csv("data/us_top10.csv")


# Importing charts

k_danceability <- read_rds("./k_danceability.rds")
k_energy <- read_rds("./k_energy.rds")
k_speechiness <- read_rds("./k_speechiness.rds")
k_acousticness <- read_rds("./k_acousticness.rds")
k_instrumentalness <- read_rds("./k_instrumentalness.rds")
k_liveness <- read_rds("./k_liveness.rds")
k_valence <- read_rds("./k_valence.rds")
k_tempo <- read_rds("./k_tempo.rds")
k_duration_ms <- read_rds("./k_duration_ms.rds")




# Define UI for application that draws a histogram
ui <- navbarPage(
  
  # Application title
  title = "BEYOND THE STAGE",
  
  # Application theme
  theme = shinytheme("cosmo"),
  
  
  # Tab divisions
  
  # "ABOUT" TAB
  
  tabPanel(
    title = "About",
    fluidRow(
      column(12,
             wellPanel(
               htmlOutput("about")
             ))
    )),
  
  # "VARIABLES" TAB
  
  tabPanel(
    title = "Variables",
    fluidRow(
      column(12,
             wellPanel(
               htmlOutput("variables")
             ))
    )),
  
  
  # "BEYOND K-POP?" TAB
  
  tabPanel(
    title = "Beyond K-pop?",
    h3("How Does BTS Compare in the Top 10 Korean Artists?"),
    br(),
    sidebarLayout(
      sidebarPanel(
        radioButtons(inputId = "k_type", 
                     label = "Musical Attribute:", 
                     choices = c("Danceability", "Energy", "Speechiness", "Acousticness", "Instrumentalness",
                                 "Liveness", "Valence", "Tempo", "Duration (ms)"))
      ),
      
      mainPanel(
        plotOutput("k_chart")
      )
    )
  )
)
  
  # Define server logic required to draw a histogram
  server <- function(input, output) {
    
    output$about <- renderUI({
      HTML(paste(
        h2("Overview"),
        br(),
        "Beyond the Stage (BTS) searches into various possible explanations for the rapid rise of the Korean music group", tags$a("BTS (방탄소년단, Beyond the Scene)", href = "https://en.wikipedia.org/wiki/BTS_(band)"), "With a",  tags$a("3 new Guinness World Records", href =  "https://www.billboard.com/articles/news/bts/8507811/bts-break-3-guinness-world-records-boy-with-luv"), "in just 2019,", tags$a ("2 Billboard Music Awards", href = "https://www.billboard.com/articles/news/bbma/8456936/bts-wins-top-social-artist-2018-billboard-music-awards"), "YouTube records for numerous music video releases", tags$a("sold-out concerts in some of the largest stadiums in the world", href = "https://www.forbes.com/sites/caitlinkelley/2019/03/02/bts-sold-out-america-europe-world-tour-love-yourself/#660891c55af3"), "what distinguishes this group of seven from other artists?",
        br(),
        br(),
        h3("Summary of Findings"),
        br(),
        h4("Comparison to Top 10 Korean Artists"),
        p("BTS is quite similar to the other Korean Artists (voted Top 10 through the Melon Music Awards), most notably in Speechiness."),
        p("Based on Spotify data, BTS members employ musical attributes similar to other Korean popular music artists. They distinguish themselves with rap, and a higher emphasis on spoken word in their tracks. From the concerns of youth in a neoliberal Korea, to songs encouraging every listener to “Love Yourself” in alliance with their UNICEF campaign, a higher Speechiness value supports articles attributing the group’s success to their social messages."),
        br(),
        h4("Comparison to Top 10 Billboard Artists"),
        p("BTS is quite similar to the other Korean Artists (voted Top 10 through the Melon Music Awards), most notably in Speechiness."),
        br(),
        h3("Sources"),
        a("Spotify", href = "https://open.spotify.com/artist/3Nrfpe0tUJi4K4DXYWgMUX"),
        br(),
        a("Wikipedia", href = "https://en.wikipedia.org/wiki/BTS_World_Tour:_Love_Yourself"),
        br(),
        a("Billboard", href = "https://www.billboard.com/charts/year-end/2018/top-artists"),
        br(),
        a("Melon (멜론)", href = "https://www.soompi.com/article/1262803wpp/2018-melon-music-awards-announces-winners-top-10-artists"),
        br(),
        a("Haebichan Jung's kpopclassifier", href = "https://github.com/haebichan/kpopclassifier.git"),
        br(),
        br(),
        a("Browse Source Code Here", href = "https://github.com/marzipan241/beyond-the-stage.git"),
        br()
      ))
    })
    
    output$variables <- renderUI({
      HTML(paste(
        h3("Variables analyzed come from the Spotify API. Find their explanations below:"),
        br(),
        p(""),
        h4("Danceability"),
        p("On a scale of 0 (least danceable) to 1 (most danceable), a combination of beat strength, overall regularity, rhythm stability, and tempo informs Danceability."),
        br(),
        h4("Energy"),
        p("On a scale of 0 (least energy) to 1 (most energy), dynamic range, perceived loudness, timbre, and general entropy inform Energy. Classical music would score low here, while death metal high."),
        br(),
        h4("Speechiness"),
        p("On a scale of 0 (least speech) to 1 (most speech), Speechiness measures spoken words in a track. 0.66 or above indicates tracks almost entirely composed of spoken words, while the 0.33 to 0.66 range contains both music and speech."),
        br(),
        h4("Acousticness"),
        p("On a scale of 0 (least acoustic) to 1 (most acoustic), the general distribution of values is positively skewed, with most values closer to 0 because of use of electronic amplification in most songs."),
        br(),
        h4("Instrumentalness"),
        p("On a scale of 0 (least instrumental) to 1 (no vocal content), Instrumentalness measures whether tracks have vocals. Most songs on Spotify fall closer to 0 due to lyrics. “Ooh” and “aah” filler sounds count as instrumental."),
        br(),
        h4("Liveness"),
        p("On a scale of 0 (least likely performed live) to 1 (performed live), values above 0.8 for Liveness means the track is most likely live. This is also a positively skewed distribution."),
        br(),
        h4("Valence"),
        p("On a scale of 0 to 1, high Valence songs sound positive (euphoric, cheerful), which low Valence songs sounds negative (angry, depressed). "),
        br(),
        h4("Tempo"),
        p("On a scale of 0 to 1, Tempo measures a track’s beats per minute (BPM). Tempo is also the pace or speed of a track in relation to the average beat duration."),
        br(),
        h4("Duration (ms)"),
        p("Duration measures the length of the track in milliseconds."),
        br()
      ))
    })
    
    output$k_chart <- renderPlot({
      if(input$k_type == "Danceability"){
        k_danceability
      }
      
      else if(input$k_type == "Energy"){
        k_energy
      }
      
      else if(input$k_type == "Speechiness"){
        k_speechiness
      }
      
      else if(input$k_type == "Acousticness"){
        k_acousticness
      }
      
      else if(input$k_type == "Instrumentalness"){
        k_instrumentalness
      }
      
      else if(input$k_type == "Liveness"){
        k_liveness
      }
      
      else if(input$k_type == "Valence"){
        k_valence
      }
      
      else if(input$k_type == "Tempo"){
        k_tempo
      }
      
      else if(input$k_type == "Duration (ms)"){
        k_duration_ms
      }
    })
    
    
    
  }
    
    
    
    


  
  # Run the application 
  shinyApp(ui = ui, server = server)
  