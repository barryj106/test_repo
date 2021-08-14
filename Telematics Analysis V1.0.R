setwd("~/Downloads/DataTelematics")

library(dplyr)
library(readr)
library(lubridate)
allcars <- read_csv("allcars.csv")

v2 <- read_csv("v2.csv")




# Explore Data ------------------------------------------------------------

# df<- allcars[1:1e4,]

df<- allcars %>% filter(deviceID %in% c(1:12))
head(df)
str(df)
# View(df)

df$timeStamp
df <- df %>% mutate(time.hour = hour(df$timeStamp))

df1 <- df %>% filter(gps_speed != 0) %>%
  group_by(deviceID, time.hour) %>%
  summarise(speed.average = mean(gps_speed))

library(tidyverse)
df2 <- df1 %>%
pivot_wider(names_from = deviceID, 
            values_from = speed.average, 
            names_glue = paste("Driver","{deviceID}", sep = "_"))
df2


library(reactable)
reactable(
  df2,
  defaultColDef = colDef(
    header = function(value) gsub(".", " ", value, fixed = TRUE),
    cell = function(value) format(value, nsmall = 1),
    align = "center",
    minWidth = 70,
    headerStyle = list(background = "#f7f7f8")
  ),
  columns = list(
    deviceID = colDef(name = "Driver Number"),
    time.hour = colDef(name = "Time"),
    speed.average = colDef(name = "Average Speed", align = "center")
  )
)
