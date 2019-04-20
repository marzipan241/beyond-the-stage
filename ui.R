# Import relevant libraries

library(tidyverse)
library(tidytext)
library(ggplot2)


# Read in data set

love_yourself <- read_csv("love_yourself.csv")


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