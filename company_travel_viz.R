
library(ggplot2)
library(dplyr)
library(readxl)
library(ggthemes)

curves <- read_excel(file.choose(), sheet = "Curves")
points <- read_excel(file.choose(), sheet = "Points")

curves$code <- paste(curves$From, curves$To, sep="")
curves <- curves %>% group_by(code, From, To, FromLat, FromLong, StartLat, StartLong) %>%
  summarise(Count = n())
curves$Count <- sqrt(curves$Count)
points$Days <- points$Days/10

usMap <- borders("state", colour="grey", fill="white")
ggplot() + usMap
travelMap <- ggplot() + usMap +
  geom_curve(data=curves,
             aes(x=FromLong, y=FromLat, xend=StartLong, yend=StartLat),
             col="#8C1D40",
             size=curves$Count,
             curvature=0.2) +
  geom_point(data=points,
             aes(x=Long, y=Lat), 
             colour="#FFC627",
             size=points$Days,
             alpha = 0.85) +
  labs(title = "Oh, the Places You'll Go with the [Anonymous Employer]",
       subtitle = "[Anonymous] Travel Schedule from July 2018 to March 2020",
       caption = "Source: Self-Collected Data") +
  theme_economist()
travelMap
