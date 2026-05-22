#This part has been coded by Stephanie Torpdahl Joel
# To install Leaflet package
install.packages("leaflet")
install.packages("htmlwidgets")

# Activate the library
library(leaflet)
library(htmlwidgets) # not essential, only needed for saving the map as .html
library(tidyverse)
library(googlesheets4)
library(dplyr)
library(htmltools)

# To create a map with Esri layers

womens_occupations <- leaflet() %>%
  setView(10.85089,55.2339084, zoom = 6)%>%
  addTiles()

#Prepares to select backgrounds by grabbing their names
esri <- grep("^Esri", providers, value = TRUE)
esri

for (provider in esri) {
  womens_occupations <- womens_occupations %>% addProviderTiles(provider, group = provider)
}
womens_occupations

Womens_map <- womens_occupations %>%
  addLayersControl(baseGroups = names(esri),
                   options = layersControlOptions(collapsed = FALSE)) %>%
  addMiniMap(tiles = esri[[1]], toggleDisplay = TRUE,
             position = "bottomright") %>%
  addMeasure(
    position = "bottomleft",
    primaryLengthUnit = "meters",
    primaryAreaUnit = "sqmeters",
    activeColor = "#3D535D",
    completedColor = "#7D4479") %>% 
  htmlwidgets::onRender("
                        function(el, x) {
                        var myMap = this;
                        myMap.on('baselayerchange',
                        function (e) {
                        myMap.minimap.changeLayer(L.tileLayer.provider(e.name));
                        })
                        }") %>% 
  addControl("", position = "topright")

Womens_map

#To add our data to leaflet 

# gs4_deauth() is to deauthorize to load the spreadsheet into R
gs4_deauth()

# Read in the Google sheet we've created
places <- read_sheet("https://docs.google.com/spreadsheets/d/13QklaE4BExogLTa8MzbymyL2Pl36Ba-5jJRRuEoeTyg/edit?gid=0#gid=0",
                     col_types = "ccccnnccccc",  
                     range = "Ark1")
glimpse(places)  


# To cluster the points in Leaflet

Womens_map%>%
  addMarkers(lng = places$Longitude, 
             lat = places$Latitude,
             popup = paste(places$Name, "<br>", places$Occupation, "<br>", places$Description),
             )
             clusterOptions = markerClusterOptions()

Womens_map

#clusterOptions = markerClusterOptions()
  #This tells leaflet to group nearby markers into clusters
  #It combines the points in clusters on the map when zoomed out
  #This shows were many locations are concentrated around Denmark
  #It is therefore also greater for singling out points in a specific area of Denmark


# Final map
# To display more columns in the map. 
womens_occupations_map <- Womens_map%>%
  addMarkers(lng = places$Longitude, 
             lat = places$Latitude,
             popup = paste(
               "<b>Name:</b>", places$Name, "<br>",
               "<b>Period:</b>", places$Year, "<br>",
               "<b>Occupation:</b>" , places$English_translation, "<br>",
               "<b>Popularity:</b>", places$Popularity, "<br>",
               "<b>Description:</b>", places$Description, "<br>",
               "<b>Source:</b>", ifelse(is.na(places$Source), "None", places$Source)
             ),
             clusterOptions = markerClusterOptions()
  )

womens_occupations_map

saveWidget(womens_occupations_map, "Womens_occupations_map.html", selfcontained = TRUE)


######################################## 