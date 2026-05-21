## script for prtf 3 visualisation: interactive map

#creates folders
dir.create("data")
dir.create("figures")

# activates relevant packages
library(leaflet)
library(htmltools)
library(htmlwidgets)
library(tidyverse)
library(googlesheets4)

#########################################
#### Task 1: Create a Danish equivalent of AUSmap with Esri layers calles DANmap
#########################################
# solution
# sets the location and zoom level of map
leaflet() %>% 
  setView(10.85089,55.2339084, zoom = 6) %>% 
  addTiles() # checking I am in the right area

# Creates a basic base map
l_dan <- leaflet() %>%   # assign the base location to an object
  setView(10.85089,55.2339084, zoom = 6) %>%
  addTiles() # viser kort
l_dan

# prepares to select backgrounds by grabbing their names
esri <- grep("^Esri", providers, value = TRUE)
esri

# Selects backgrounds from among provider tiles.
for (provider in esri) {
  l_dan <- l_dan %>% addProviderTiles(provider, group = provider)
}

l_dan # shows map

# makes a layered map out of the components above in an object called DANmap
DANmap <- l_dan %>% # create object
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

DANmap # shows map

saveWidget(DANmap, "DANmap.html", selfcontained = TRUE) # saves map

#########################################
#### task 2 Read in the googlesheet data to the DANmap object.
#########################################

# Reads in the Google sheet
gs4_deauth()
places <- read_sheet("https://docs.google.com/spreadsheets/d/1PlxsPElZML8LZKyXbqdAYeQCDIvDps2McZx1cTVWSzI/edit#gid=124710918",
                     col_types = "cccnncnc",
                     range = "DAM2026") 

glimpse(places) # shows number and types of columns

places %>% 
  filter(!is.na(Longitude)) %>% 
  filter(!is.na(Latitude))

# Question 3: are the Latitude and Longitude columns present? Do they contain numeric decimal degrees?
# answer: they are marked right as "dbl" and further inspections confirm they are numerical decimal degrees.

# loads them in a basic map. No points are missing.
studentmap<- leaflet() %>% 
  addTiles() %>% 
  addMarkers(lng = places$Longitude, 
             lat = places$Latitude,
             popup = paste(places$Description, "<br>", places$Type))

saveWidget(studentmap, "studentmap.html", selfcontained = T)

# reads it into the DANmap
DANmap %>% 
  addMarkers(lng = places$Longitude, 
             lat = places$Latitude,
             popup = paste(places$Description, "<br>", places$Type))

#########################################
#### task 3: Can you cluster the points in Leaflet?
#########################################
# Solution
DANmap %>% 
  addMarkers(lng = places$Longitude, 
             lat = places$Latitude,
             popup = paste(places$Description, "<br>", places$Type), clusterOptions = markerClusterOptions()
  ) # tells Leaflet to group nearby markers into clusters

#########################################
#### task 4: reflection
#########################################
# Task 4: Look at the two maps (with and without clustering) and consider what
# each is good for and what not.

# aswer: the clustered map is good for an overview of where in Denmark there
# are more "places" and where there is less. For example we have maped many
# places close to Aarhus but only few near CPH. The unclustered map is good
# at showing the exact placement of the places, but when they are close they
# overlap making it hard to read when zoomed out.

#########################################
#### task 5: display the notes and classifications
#########################################

# Solution
DANmap_final <- DANmap %>% 
  addMarkers(
    lng = places$Longitude, 
    lat = places$Latitude,
    popup = paste(
      "<b>Placename:</b>", places$Placename, "<br>", #in bold "Placename:",insert variable, line break
      "<b>Type:</b>", places$Type, "<br>",
      "<b>Description:</b>", places$Description, "<br>",
      "<b>Notes:</b>", ifelse(is.na(places$Notes), "None", places$Notes) # show notes or "None" if NA
    ),
    clusterOptions = markerClusterOptions()
  )

DANmap_final # shows map

saveWidget(DANmap_final, "DANmap_final.html", selfcontained = TRUE)