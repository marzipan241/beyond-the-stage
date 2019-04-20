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
         sliderInput("bins",
                     "Number of bins:",
                     min = 1,
                     max = 50,
                     value = 30),
         # Hyperlink
         tags$a("GitHub Repo", href = "https://github.com/marzipan241/beyond-the-stage.git")
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("cityPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$cityPlot <- renderPlot({
     love_yourself %>% 
       select(city, continent, attendance) %>% 
       group_by(city, continent) %>% 
       count(attendance) %>% 
       
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

