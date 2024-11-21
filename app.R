#Loading in Libraries: 
library(tidyverse)
library(maps)
library(tidycensus)
library(leaflet)
library(dplyr)
library(shiny)
library(shinythemes)
library(sf)
library(rgdal) 
library(readxl)
library(tidygeocoder)
library(ggmap)
library(simplevis)
library(stars)
library(mapview)
library(leafgl)
library(shinyBS)


#Loading in Shape Files:
janjuly2016 <- read_sf("Geo_Data/2016/NIJ2016_JAN01_JUL31.shp")
aug2016<- read_sf("Geo_Data/2016/NIJ2016_AUG01_AUG31.shp")
aug2016<- na.omit(aug2016)
sept2016<- read_sf("Geo_Data/2016/NIJ2016_SEP01_SEP30.shp")
oct2016<- read_sf("Geo_Data/2016/NIJ2016_OCT01_OCT31.shp")
nov2016<- read_sf("Geo_Data/2016/NIJ2016_NOV01_NOV30.shp")
dec2016<- read_sf("Geo_Data/2016/NIJ2016_DEC01_DEC31.shp")


jan2017<- read_sf("Geo_Data/2017/NIJ2017_JAN01_JAN31.shp")
feb1to142017<- read_sf("Geo_Data/2017/NIJ2017_FEB01_FEB14.shp")
feb15to212017<- read_sf("Geo_Data/2017/NIJ2017_FEB15_FEB21.shp")
feb22to26 <- read_sf("Geo_Data/2017/NIJ2017_FEB22_FEB26.shp")
feb27<- read_sf("Geo_Data/2017/NIJ2017_FEB27.shp")
feb28<- read_sf("Geo_Data/2017/NIJ2017_FEB28.shp")
marchmay2017<- read_sf("Geo_Data/2017/NIJ2017_MAR01_MAY31.shp")


#Full years: 2012 only has data from march - dec. 
full_2012<-  read_sf("Geo_Data/2012/NIJ2012_MAR01_DEC31.shp")
full_2013<- read_sf("Geo_Data/2013/NIJ2013_JAN01_DEC31.shp")
full_2014<- read_sf("Geo_Data/2014/NIJ2014_JAN01_DEC31.shp")
full_2014<- na.omit(full_2014)
full_2015<- read_sf("Geo_Data/2015/NIJ2015_JAN01_DEC31.shp")
full_2015<- na.omit(full_2015)

# file merges:

#We cannot merge the full 2016 together yet until we push the dbf files. 
full2016 <- rbind(janjuly2016,aug2016,sept2016,oct2016,nov2016,dec2016)

#Full 2017 is good if you want to start a geo-spatial technique on this! 
full2017<- rbind(jan2017,feb1to142017,feb15to212017, feb22to26, feb27, feb28, marchmay2017)


#Final CRS Transformations: 
finalfull2012<- st_transform(full_2012, crs = 4326)
finalfull2013 <- st_transform(full_2013, crs=4326)
finalfull2014<- st_transform(full_2014, crs = 4326)
finalfull2015<- st_transform(full_2015, crs = 4326)
finalfull2016<- st_transform(full2016, crs = 4326)
finalfull2017<- st_transform(full2017, crs = 4326)


# Bring in Economic feature:
i_to_p_2012 <- get_acs(geography = "tract", variables = "C17002_001", state = "OR", county = "Multnomah", geometry = TRUE, year = 2012)
i_to_p_2013 <- get_acs(geography = "tract", variables = "C17002_001", state = "OR", county = "Multnomah", geometry = TRUE, year = 2013)
i_to_p_2014 <- get_acs(geography = "tract", variables = "C17002_001", state = "OR", county = "Multnomah", geometry = TRUE, year = 2014)
i_to_p_2015 <- get_acs(geography = "tract", variables = "C17002_001", state = "OR", county = "Multnomah", geometry = TRUE, year = 2015)
i_to_p_2016 <- get_acs(geography = "tract", variables = "C17002_001", state = "OR", county = "Multnomah", geometry = TRUE, year = 2016)
i_to_p_2017 <- get_acs(geography = "tract", variables = "C17002_001", state = "OR", county = "Multnomah", geometry = TRUE, year = 2017)

estimate2012<-na.omit(i_to_p_2012$estimate)
estimate2013<-na.omit(i_to_p_2013$estimate)
estimate2014<-na.omit(i_to_p_2014$estimate)
estimate2015<-na.omit(i_to_p_2015$estimate)
estimate2016<-na.omit(i_to_p_2016$estimate)
estimate2017<-na.omit(i_to_p_2017$estimate)

pal_2012 <- colorNumeric(palette = "Greys",
                         domain = estimate2012,
                         na.color = NA)

pal_2013 <- colorNumeric(palette = "Greys",
                         domain = estimate2013,
                         na.color = NA)
pal_2014 <- colorNumeric(palette = "Greys",
                         domain = estimate2014,
                         na.color = NA)
pal_2015 <- colorNumeric(palette = "Greys",
                         domain = estimate2015,
                         na.color = NA)
pal_2016 <- colorNumeric(palette = "Greys",
                         domain = estimate2016,
                         na.color = NA)

pal_2017 <- colorNumeric(palette = "Greys",
                         domain = estimate2017,
                         na.color = NA)

ui<- shinyUI(fluidPage(
  shinyjs::useShinyjs(),
  navbarPage(
    theme = shinytheme("superhero"),
    "Portland Crime Analysis",
    tabPanel("Interactive Map",
             fluidRow(width = 2, 
                      helpText("Choose a Year to Display", style = "font-size:15px;"),
                      actionButton("2012", "2012"),
                      actionButton("2013", "2013"),
                      actionButton("2014", "2014"),
                      actionButton("2015", "2015"),
                      actionButton("2016", "2016"),
                      actionButton("2017", "2017")),
             actionButton("revert", "Reset Back to Full Portland View", style='padding:2px; font-size:100%', class= 'btn btn-danger'),
             div(
               id = "map_container",
               leafletOutput(height = "700px", "map")
             ),
             textOutput("coords")),
    tabPanel("About Us", 
             h1(paste0("Contributors:")),
             h2("Lauryn Davis"),
             p("Lauryn is an undergraduate student pursuing a Bachelor's degree in Applied Mathematics, minor in Applied Statistics, and a Master's degree in Data Science and Analytics. In her free time, she enjoys working on her Kindschi Research Fellowship that is centered around developing an interactive historical redlining website application within Shiny for R studio."),
             h2("L Dettling"),
             p("L works full-time in Technology Acquisitions at Grand Valley State University, and is dual-enrolled in the Master's program for Applied Computer Science. Her research focuses on applications of the Voronoi Diagram, and other computational geometry topics. In her free time, she enjoys playing Animal Crossings, scuba-diving, and playing D&D."),
             h2("Jessica Malinowski"),
             p("Jess is a graduate student pursuing a Master's in Applied Computer Science. She does this while working as a software developer parttime. In her free time - *she does not have any*, she enjoys hiking with her dog.")),
            
    tabPanel("Contact Us",  
             h2("Who to Contact"),
             p("If any questions arise pertaining to the geospatial analysis or techniques used, please reach out to Lauryn Davis, at davisl5@mail.gvsu.edu."))
  )))

library(shinyjs)

server<- function(input, output, session) {
  output$map <- renderLeaflet({
    if (is.null(v$data)) return()
    leaflet(options = leafletOptions(minZoom = 11, preferCanvas = TRUE, zoomToLimits="first"))%>%
      addProviderTiles(provider = "CartoDB.Positron"       # map won't load new tiles when panning
      )%>%
      setView(lng = -122.676483, 
              lat = 45.523064, 
              zoom = 11)%>%
      setMaxBounds(-122.75, 45.45, -122.5, 45.6)%>%
      addLegend(colors = c('lightblue', 'salmon', 'lightpink', 'lightgrey', 'orange', 'mediumaquamarine'),labels = c("Disorder", "Non Criminal/Admin", "Traffic", "Suspicious", "Property Crime", "Person Crime" ), opacity = 1)%>%
      addLayersControl(overlayGroups = c("Disorder", "Non Criminal/Admin", "Traffic", "Suspicious", "Property Crime", "Person Crime" ),
                       options = layersControlOptions(collapsed =FALSE),
                       position = 'bottomleft')
  })
  v <- reactiveValues(data = output)
  observeEvent(input$"2012", {
    v$data <- leafletProxy('map')%>%
      addGlPoints(data = finalfull2012[finalfull2012$CALL_GROUP == 'DISORDER',], group = "Disorder",  fillColor = 'lightblue',fillOpacity = 1, radius = 6, popup = "Disorder")%>%
      addGlPoints(data = finalfull2012[finalfull2012$CALL_GROUP == 'NON CRIMINAL/ADMIN',],  fillColor = 'salmon',fillOpacity = 1, radius = 6, popup = 'Non Criminal/Admin', group = 'Non Criminal/Admin')%>%
      addGlPoints(data = finalfull2012[finalfull2012$CALL_GROUP == 'TRAFFIC',], fillColor = 'lightpink', popup = 'Traffic', group = 'Traffic', fillOpacity = 5, radius = 6)%>%
      addGlPoints(data = finalfull2012[finalfull2012$CALL_GROUP == 'SUSPICIOUS',],  fillColor = 'lightgrey', popup = 'Suspicious', group = 'Suspicious', fillOpacity = 5, radius = 6)%>%
      addGlPoints(data = finalfull2012[finalfull2012$CALL_GROUP == 'PROPERTY CRIME',],fillColor = 'orange', popup = 'Property Crime', group = 'Property Crime', fillOpacity = 5, radius = 6)%>%
      addGlPoints(data = finalfull2012[finalfull2012$CALL_GROUP == 'PERSON CRIME',],  fillColor = 'mediumaquamarine', popup = 'Person Crime', group = 'Person Crime', fillOpacity = 5, radius = 6)%>%
      setView(lng = -122.676483, 
              lat = 45.523064, 
              zoom = 11)%>%
      setMaxBounds(-122.75, 45.45, -122.5, 45.6)%>%
      addPolygons(data = i_to_p_2012,
                  popup = ~ str_extract(NAME, "^([^,]*)"),
                  stroke = FALSE,
                  smoothFactor = 0,
                  fillOpacity = 0.3,
                  color = ~ pal_2012(estimate))%>%
      addLegend(data = i_to_p_2012,
                "bottomright", 
                pal = pal_2012, 
                values = ~ estimate,
                title = "Income to Poverty Ratio",
                labFormat = labelFormat(prefix = "$"),
                opacity = 1)})
  
  observeEvent(input$revert, {
    
    if(is.null(input$revert))
      return(NULL)
    leafletProxy('map') %>% 
      setView(-122.676483,  45.523064, zoom = 11)
    
  })  
  
  observeEvent(input$"2013", {
    v$data <- leafletProxy('map')%>%
      addGlPoints(data = finalfull2013[finalfull2013$CALL_GROUP == 'DISORDER',], group = "Disorder",  fillColor = 'lightblue',fillOpacity = 1, radius = 6, popup = "Disorder")%>%
      addGlPoints(data = finalfull2013[finalfull2013$CALL_GROUP == 'NON CRIMINAL/ADMIN',],  fillColor = 'salmon',fillOpacity = 1, radius = 6, popup = 'Non Criminal/Admin', group = 'Non Criminal/Admin')%>%
      addGlPoints(data = finalfull2013[finalfull2013$CALL_GROUP == 'TRAFFIC',], fillColor = 'lightpink', popup = 'Traffic', group = 'Traffic', fillOpacity = 5, radius = 6)%>%
      addGlPoints(data = finalfull2013[finalfull2013$CALL_GROUP == 'SUSPICIOUS',],  fillColor = 'lightgrey', popup = 'Suspicious', group = 'Suspicious', fillOpacity = 5, radius = 6)%>%
      addGlPoints(data = finalfull2013[finalfull2013$CALL_GROUP == 'PROPERTY CRIME',],fillColor = 'orange', popup = 'Property Crime', group = 'Property Crime', fillOpacity = 5, radius = 6)%>%
      addGlPoints(data = finalfull2013[finalfull2013$CALL_GROUP == 'PERSON CRIME',],  fillColor = 'mediumaquamarine', popup = 'Person Crime', group = 'Person Crime', fillOpacity = 5, radius = 6)%>%
      setView(lng = -122.676483, 
              lat = 45.523064, 
              zoom = 11)%>%
      addLegend(data = i_to_p_2013,
                "bottomright", 
                pal = pal_2013, 
                values = ~ estimate,
                title = "Income to Poverty Ratio",
                labFormat = labelFormat(prefix = "$"),
                opacity = 1)%>%
      addPolygons(data = i_to_p_2013,
                  popup = ~ str_extract(NAME, "^([^,]*)"),
                  stroke = FALSE,
                  smoothFactor = 0,
                  fillOpacity = 0.4,
                  color = ~ pal_2013(estimate))%>%
      setMaxBounds(-122.75, 45.45, -122.5, 45.6)})
  
  observeEvent(input$"2014", {
    v$data <- leafletProxy('map')%>%
      addGlPoints(data = finalfull2014[finalfull2014$CALL_GROUP == 'DISORDER',], group = "Disorder",  fillColor = 'lightblue',fillOpacity = 1, radius = 6, popup = "Disorder")%>%
      addGlPoints(data = finalfull2014[finalfull2014$CALL_GROUP == 'NON CRIMINAL/ADMIN',],  fillColor = 'salmon',fillOpacity = 1, radius = 6, popup = 'Non Criminal/Admin', group = 'Non Criminal/Admin')%>%
      addGlPoints(data = finalfull2014[finalfull2014$CALL_GROUP == 'TRAFFIC',], fillColor = 'lightpink', popup = 'Traffic', group = 'Traffic', fillOpacity = 5, radius = 6)%>%
      addGlPoints(data = finalfull2014[finalfull2014$CALL_GROUP == 'SUSPICIOUS',],  fillColor = 'lightgrey', popup = 'Suspicious', group = 'Suspicious', fillOpacity = 5, radius = 6)%>%
      addGlPoints(data = finalfull2014[finalfull2014$CALL_GROUP == 'PROPERTY CRIME',],fillColor = 'orange', popup = 'Property Crime', group = 'Property Crime', fillOpacity = 5, radius = 6)%>%
      addGlPoints(data = finalfull2014[finalfull2014$CALL_GROUP == 'PERSON CRIME',],  fillColor = 'mediumaquamarine', popup = 'Person Crime', group = 'Person Crime', fillOpacity = 5, radius = 6)%>%
      
      setView(lng = -122.676483, 
              lat = 45.523064, 
              zoom = 11)%>%
      addLegend(data = i_to_p_2014,
                "bottomright", 
                pal = pal_2014, 
                values = ~ estimate,
                title = "Income to Poverty Ratio",
                labFormat = labelFormat(prefix = "$"),
                opacity = 1)%>%
      addPolygons(data = i_to_p_2014,
                  popup = ~ str_extract(NAME, "^([^,]*)"),
                  stroke = FALSE,
                  smoothFactor = 0,
                  fillOpacity = 0.4,
                  color = ~ pal_2014(estimate))%>%
      setMaxBounds(-122.75, 45.45, -122.5, 45.6)})
  
  observeEvent(input$"2015", {
    v$data <- leafletProxy('map')%>%
      addGlPoints(data = finalfull2015[finalfull2015$CALL_GROUP == 'DISORDER',], group = "Disorder",  fillColor = 'lightblue',fillOpacity = 1, radius = 6, popup = "Disorder")%>%
      addGlPoints(data = finalfull2015[finalfull2015$CALL_GROUP == 'NON CRIMINAL/ADMIN',],  fillColor = 'salmon',fillOpacity = 1, radius = 6, popup = 'Non Criminal/Admin', group = 'Non Criminal/Admin')%>%
      addGlPoints(data = finalfull2015[finalfull2015$CALL_GROUP == 'TRAFFIC',], fillColor = 'lightpink', popup = 'Traffic', group = 'Traffic', fillOpacity = 5, radius = 6)%>%
      addGlPoints(data = finalfull2015[finalfull2015$CALL_GROUP == 'SUSPICIOUS',],  fillColor = 'lightgrey', popup = 'Suspicious', group = 'Suspicious', fillOpacity = 5, radius = 6)%>%
      addGlPoints(data = finalfull2015[finalfull2015$CALL_GROUP == 'PROPERTY CRIME',],fillColor = 'orange', popup = 'Property Crime', group = 'Property Crime', fillOpacity = 5, radius = 6)%>%
      addGlPoints(data = finalfull2015[finalfull2015$CALL_GROUP == 'PERSON CRIME',],  fillColor = 'mediumaquamarine', popup = 'Person Crime', group = 'Person Crime', fillOpacity = 5, radius = 6)%>%
      
      setView(lng = -122.676483, 
              lat = 45.523064, 
              zoom = 11)%>%
      addLegend(data = i_to_p_2015,
                "bottomright", 
                pal = pal_2015, 
                values = ~ estimate,
                title = "Income to Poverty Ratio",
                labFormat = labelFormat(prefix = "$"),
                opacity = 1)%>%
      addPolygons(data = i_to_p_2015,
                  popup = ~ str_extract(NAME, "^([^,]*)"),
                  stroke = FALSE,
                  smoothFactor = 0,
                  fillOpacity = 0.4,
                  color = ~ pal_2015(estimate))%>%
      setMaxBounds(-122.75, 45.45, -122.5, 45.6)})
  
  observeEvent(input$"2016", {
    v$data <- leafletProxy('map')%>%
      addGlPoints(data = finalfull2016[finalfull2016$CALL_GROUP == 'DISORDER',], group = "Disorder",  fillColor = 'lightblue',fillOpacity = 1, radius = 6, popup = "Disorder")%>%
      addGlPoints(data = finalfull2016[finalfull2016$CALL_GROUP == 'NON CRIMINAL/ADMIN',],  fillColor = 'salmon',fillOpacity = 1, radius = 6, popup = 'Non Criminal/Admin', group = 'Non Criminal/Admin')%>%
      addGlPoints(data = finalfull2016[finalfull2016$CALL_GROUP == 'TRAFFIC',], fillColor = 'lightpink', popup = 'Traffic', group = 'Traffic', fillOpacity = 5, radius = 6)%>%
      addGlPoints(data = finalfull2016[finalfull2016$CALL_GROUP == 'SUSPICIOUS',],  fillColor = 'lightgrey', popup = 'Suspicious', group = 'Suspicious', fillOpacity = 5, radius = 6)%>%
      addGlPoints(data = finalfull2016[finalfull2016$CALL_GROUP == 'PROPERTY CRIME',],fillColor = 'orange', popup = 'Property Crime', group = 'Property Crime', fillOpacity = 5, radius = 6)%>%
      addGlPoints(data = finalfull2016[finalfull2016$CALL_GROUP == 'PERSON CRIME',],  fillColor = 'mediumaquamarine', popup = 'Person Crime', group = 'Person Crime', fillOpacity = 5, radius = 6)%>%
      
      setView(lng = -122.676483, 
              lat = 45.523064, 
              zoom = 11)%>%
      addLegend(data = i_to_p_2016,
                "bottomright", 
                pal = pal_2016, 
                values = ~ estimate,
                title = "Income to Poverty Ratio",
                labFormat = labelFormat(prefix = "$"),
                opacity = 1)%>%
      addPolygons(data = i_to_p_2016,
                  popup = ~ str_extract(NAME, "^([^,]*)"),
                  stroke = FALSE,
                  smoothFactor = 0,
                  fillOpacity = 0.4,
                  color = ~ pal_2016(estimate))%>%
      setMaxBounds(-122.75, 45.45, -122.5, 45.6)})
  
  observeEvent(input$"2017", {
    v$data <- leafletProxy('map')%>%
      addGlPoints(data = finalfull2017[finalfull2017$CALL_GROUP == 'DISORDER',], group = "Disorder",  fillColor = 'lightblue',fillOpacity = 1, radius = 6, popup = "Disorder")%>%
      addGlPoints(data = finalfull2017[finalfull2017$CALL_GROUP == 'NON CRIMINAL/ADMIN',],  fillColor = 'salmon',fillOpacity = 1, radius = 6, popup = 'Non Criminal/Admin', group = 'Non Criminal/Admin')%>%
      addGlPoints(data = finalfull2017[finalfull2017$CALL_GROUP == 'TRAFFIC',], fillColor = 'lightpink', popup = 'Traffic', group = 'Traffic', fillOpacity = 5, radius = 6)%>%
      addGlPoints(data = finalfull2017[finalfull2017$CALL_GROUP == 'SUSPICIOUS',],  fillColor = 'lightgrey', popup = 'Suspicious', group = 'Suspicious', fillOpacity = 5, radius = 6)%>%
      addGlPoints(data = finalfull2017[finalfull2017$CALL_GROUP == 'PROPERTY CRIME',],fillColor = 'orange', popup = 'Property Crime', group = 'Property Crime', fillOpacity = 5, radius = 6)%>%
      addGlPoints(data = finalfull2017[finalfull2017$CALL_GROUP == 'PERSON CRIME',],  fillColor = 'mediumaquamarine', popup = 'Person Crime', group = 'Person Crime', fillOpacity = 5, radius = 6)%>%
      
      setView(lng = -122.676483, 
              lat = 45.523064, 
              zoom = 11)%>%
      addLegend(data = i_to_p_2017,
                "bottomright", 
                pal = pal_2017, 
                values = ~ estimate,
                title = "Income to Poverty Ratio",
                labFormat = labelFormat(prefix = "$"),
                opacity = 1)%>%
      addPolygons(data = i_to_p_2017,
                  popup = ~ str_extract(NAME, "^([^,]*)"),
                  stroke = FALSE,
                  smoothFactor = 0,
                  fillOpacity = 0.4,
                  color = ~ pal_2017(estimate))%>%
      setMaxBounds(-122.75, 45.45, -122.5, 45.6)})}
     
  

shinyApp(ui, server)

