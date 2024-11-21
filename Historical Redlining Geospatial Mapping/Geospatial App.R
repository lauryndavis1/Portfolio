#Loading necessary packages:

library(tidyverse)
library(maps)
library(tidycensus)
library(leaflet)
library(shiny)
library(shinythemes) 
library(sf)
library(readxl)
library(tidygeocoder)
library(ggmap)
library(bslib)
library(shinyWidgets)
library(car)
library(plotrix)
library(rsconnect)
library(ggthemes)
library(plotly)
library(datasets)
library(shinyalert)
library(profvis)

write_message <- function(name, email, message, messages) {
  message_data <- data.frame(Name = name, Email = email, Message = message, stringsAsFactors = FALSE)
  rbind(messages, message_data)}


#Loading shape files from richmond:
all_shape<- read_sf('https://dsl.richmond.edu/panorama/redlining/static/mappinginequality.json')


#Transforming shape files to have appropriate coordinates system:
all_shape <- st_transform(all_shape, crs = 4326)
#Removing N/A'/ grades that were not equal to A,B,C or D:
no_na_richmond<- na.omit(all_shape)
updated<- no_na_richmond %>%
  mutate(grade = if_else(grade == 'A ', 'A', grade))%>%
  mutate(grade = if_else(grade == 'C ', 'C', grade))
final_richmond <- subset(updated, grade != "F" & grade != 'E' & grade!= '' & grade!= ' ')

#Adding in color pallete for HOLC Grades: 
rl_pal <- colorFactor(c("#76a856", "#7cb5bd", "#ffff00", "#d9838d"), domain = levels(final_richmond$grade))

#Reading in county/state names sheet for future use:
data1 <- read_excel("practice.xlsx", sheet = 4)


#Median Household income shape files for 2019:
shape_2020<- read_sf('Economic Indicators/median_update1.shp')

all_shapes<- shape_2020

test<- as.data.frame(all_shapes)
med<- st_sf(test)
#Creating Intervals:
med$category <- cut(all_shapes$estimate, 
                    breaks=c(-Inf, 50000, 100000, 300000, 800000, Inf), 
                    labels=c("< $50,000","$50,001 - 100,000","$100,001 - 300,000","$300,001 - 800,000", "> $800,000"))
estimated<-na.omit(med$category)


#Reading in Educational Attainment shape files from 2019 - 2021
test_edu<- read_sf('Economic Indicators/combined_education.shp')
test_edu<- test_edu|>
  filter(year == 2019)
#Potentially dealing with the lack of locations for this year.

#Removing observations that have estimates for only one education category":
remove_counties<- c("Census Tract 9819.01, Calhoun County, Alabama" ,
                    "Census Tract 9805.01; San Francisco County; California",
                    "Census Tract 9810; Suffolk County; Massachusetts"  ,
                    "Census Tract 297; New York County; New York"  ,
                    "Census Tract 9801; Oneida County; New York"   ,
                    "Census Tract 9800.08; Oklahoma County; Oklahoma" ,
                    "Census Tract 9800.09; Oklahoma County; Oklahoma"  ,
                    "Census Tract 9809; Allegheny County; Pennsylvania"  ,
                    "Census Tract 9806; Allegheny County; Pennsylvania" ,
                    "Census Tract 9824, Wayne County, Michigan"    ,
                    "Census Tract 9839.01, Wayne County, Michigan"  ,
                    "Census Tract 9864, Wayne County, Michigan",
                    "Census Tract 561; Queens County; New York",
                    "Census Tract 1167.33; Maricopa County; Arizona" ,
                    "Census Tract 9.03; Pueblo County; Colorado"  ,
                    "Census Tract 9813; Suffolk County; Massachusetts" ,
                    "Census Tract 15.01; Durham County; North Carolina",
                    "Census Tract 18.03; Kings County; New York" ,
                    "Census Tract 217.03; New York County; New York"  ,
                    "Census Tract 179.02; Queens County; New York" ,
                    "Census Tract 171.02; Queens County; New York"  ,
                    "Census Tract 9800.01; Oklahoma County; Oklahoma"  ,
                    "Census Tract 369.01; Philadelphia County; Pennsylvania",
                    "Census Tract 9801, Butler County, Pennsylvania" ,
                    "Census Tract 9800; Mobile County; Alabama"  ,
                    "Census Tract 9809; Suffolk County; Massachusetts",
                    "Census Tract 218.13, Orange County, California"
)

removed_obs<- test_edu|>
  filter(!(NAME %in% remove_counties))
test1<- as.data.frame(removed_obs)
edu<- st_sf(test1)


ui<- shinyUI(fluidPage(
  shinyjs::useShinyjs(),
  tags$head(
    tags$style(
      HTML(
        "
        body {
          text-align: center;
        }
        .titlepanel {
          margin-bottom: 0px;
          text-align: center; /* Center title panel text */
          margin-top: 20px; /* Move title panel down */
          position: relative;
        }
        .titletext {
          color: white;
          font-size: 250%; /* Smaller font size */
          font-family: 'Cinzel', serif;
          font-weight: bolder;
          text-shadow: 0.1em 0.1em 0.2em black;
          position: absolute;
          top: 40px; 
          left: 50%;
          transform: translateX(-50%);
          white-space: nowrap; /* Keeps the text on one line */
        }
        .titlepanel h2 {
          text-align: center; /* Center title panel headings */
        }
        .main-panel h2, .main-panel h3 {
          text-align: center; /* Center main panel headings */
        }
        .main-panel {
          width: 80%;
          overflow-x: hidden;
         text-align: center; /* Center paragraphs */
          margin: 0 auto; /* Center main panel */
          margin-top: -10px; /* Reduce top margin to move text closer to image */
        }
        "
      )
    )
  ),
  navbarPage(
    theme =  bs_theme(
      bootswatch = "journal",
      base_font = font_google("Inter")),
    
    title = span("Interactive Historical Redlining Analysis"),
    tags$style(type = 'text/css', '.navbar {
                           font-family: Arial;
                           font-size: 15px;
                            }',
               
               
               '.navbar-default .navbar-brand {
                             color: #cc3f3f;
                           }'
               
               
    ),
    tabPanel("About", 
             
             titlePanel(
               div(
                 img(
                   src = "test1.png",
                   height = 200,
                   width = "100%", 
                   style = "position: relative;"
                 ),
                 div(class = "titletext", "What is Redlining?"),
                 style = "position: relative;"
               ),
               windowTitle = "Redlining Description"
             ),
             div(
               class = "main-panel",
               br(),
               h3("Redlining Description"),
               
               HTML("&emsp;Obtaining a mortgage and working with a banking institution throughout the 1900’s was challenging for many people within the United States. Due to discriminatory mindsets, many minorities were denied access to mortgages by the Federal Housing Administration due to the fear of “hazardness” within these suburban communities (Nelson et al., 2023). Due to this, many racial and ethnic minorities today face socioeconomic mobility challenges within society."),
               br(),
               HTML("&emsp;Throughout the 1930’s, the HOLC created area descriptions which stated the assigned grade of “mortgage security” of a neighborhood. From the grade “A”, which was considered the “least risk for investors'', to the grade “D”, which was considered “hazardous”, grades were mapped and color coded on maps to visualize this redlining phenomenon. Additional information provided for these areas were the neighborhood's quality of housing, recent sale and rent values, and racial and ethnic background of the residents. The Mapping Inequality research team (Nelson et al., 2023) developed an online interactive map that has digitized these historical maps and rescaled them to be mapped over the current cities so that users can view the “grade” given to various neighborhoods in the area."),
               br(),
               br(),
               h3("Project Description"),
               
               HTML("&emsp;An online interactive map was created by the Mapping Inequality research team (Nelson et al., 2023) that digitized and rescaled these historical mortgage maps. Expansion will include utilizing these redlining boundaries in conjunction with current/recent demographics, economic, and community patterns. Specifically, this project will combine the open-source shape files created by the Mapping Inequality team and data sources from the U.S. Census Bureau (USCB) in one digital tool. The audience for this tool will be middle and high school social studies teachers to use within their classrooms."),
               br(),
               br(),
               h3("Significance"),
               
               HTML("&emsp;Data literacy is an essential competency in social studies education and an informed citizen must also be a data-literate citizen (Bowen & Bartley, 2014; Franklin et al., 2015; Gould, 2017). Although it is often assumed that data visualizations make information easier to understand, research has indicated that students face several challenges when attempting to make sense of them (Brugar & Roberts, 2017; Duke et al., 2013; Roberts et al., 2017a, 2017b; Shreiner, 2018, 2019). Teachers may be the single most important factor in mitigation of these challenges (Rockoff, 2004; Stronge et al., 2011). However, in a survey of 262 practicing teachers throughout the United States, Shreiner and Dykes (2020) found only 24% of respondents reported they incorporate data literacy practices into lesson and unit plans. This apparent lack of data literacy instruction is not surprising if one considers how unprepared teachers must feel.")
             )
    ),
    tabPanel("User Manual", 
             titlePanel(
               div(
                 img(
                   src = "user1.png",
                   height = 200,
                   width = "100%",
                   style = "position: relative;"
                 ),
                 div(class = "titletext", "User Manual"),
                 style = "position: relative;"
               ),
               windowTitle = "User Manual"
             ),
             div(style = "text-align: left;",
                 class = "main-panel",
                 br(),
                 h3("Steps to Find a Location of Interest"),
                 tags$ol(
                   tags$li("Hover over and click on a circle located near the point of interest."),
                   tags$li("Inspect the different markers and labels to identify the presence of the city of interest."),
                   tags$li("Click on another circle to zoom in further if needed on the map."),
                   tags$li("Finally, click on the marker corresponding to the city you wish to analyze.")
                 ),
                 h2("How to Interpret HOLC Grades"),
                 p("Explore the map by moving your cursor and observe the locations marked in red, green, and yellow. Consider why certain areas were classified as 'Red' in the 1930s. For instance:",
                   tags$ul(
                     tags$li("How do HOLC grades vary across regions and between urban and rural areas, and what factors might contribute to these patterns?"),
                     tags$li("Are there any unexpected findings in the distribution of HOLC grades that challenge your prior assumptions or knowledge about redlining?"),
                     tags$li("Can you identify any factors that may have influenced the assignment of HOLC grades to different areas?")
                   )
                 ),
                 h3("Select an Economic Indicator"),
                 p("Once you've located your point of interest and reviewed the HOLC grades, choose an economic indicator to overlay onto the HOLC grades. This allows you to compare historical redlining data with current economic and demographic information, providing insights into the impact of redlining on economic and demographic development.",
                   tags$ul(
                     tags$li("How might layering economic data on HOLC grades enhance our understanding of redlining?"),
                     tags$li("How could economic data with HOLC grades support policies for economic equality?"),
                     tags$li("What challenges do you see in showing economic data with HOLC grades?")
                   )
                 )
             )),
    tabPanel("Interactive Map",
             titlePanel("Interactive Map"),
             fluidPage(
               setBackgroundColor(
                 color = c("#F7FBFF", "#B6B6B6"),
                 gradient = "linear",
                 direction = "bottom"
               )),
             fluidRow(width = 10, column(width = 6, align="center", offset = 3,
                                         selectInput("demo", "Choose an Economic and/or Demographic Category",
                                                     choices =list("",
                                                                   "Median Home Value",
                                                                   "High School Diploma or Equivalent" = "sum_highschool_ged",
                                                                   "Associates Degree" = "associates_degree",
                                                                   "Some College" = "some_college", 
                                                                   "Bachelors Degree" = "bachelors_degree",
                                                                   "Masters Degree" = "masters_degree",
                                                                   "Professional School" = "professional_school",
                                                                   "Doctorate Degree" = "doctorate_degree"), selected= '', width = "100%", ))),
             
             div(
               id = "map_container",
               
               fluidRow(leafletOutput(height = "700px", "map"),
                        textOutput("coords")))),
    
    tabPanel("Contact Us", 
             div(style = "text-align: left;",
                 titlePanel("Contact Us")),
             useShinyalert(),  # Initialize shinyalert
             
             sidebarLayout(
               sidebarPanel(
                 style = "width: 400px;",  # Set the width of the sidebar panel
                 textInput("name", "Name:", placeholder = "Enter your name"),
                 textInput("email", "Email:", placeholder = "Enter your email"),
                 textAreaInput("message", "Message:", placeholder = "Enter your message"),
                 shinyjs::inlineCSS(".animated-button {background-color: #4CAF50; color: white; padding: 10px 24px; text-align: center; text-decoration: none; display: inline-block; font-size: 16px; margin: 4px 2px; cursor: pointer;} .animated-button:hover {background-color: #45a049;}"),
                 shinyjs::useShinyjs(),
                 actionButton("submit", "Submit", class = "animated-button btn-lg btn-success")
               ),
               mainPanel(
                 fluidRow(
                   column(
                     width = 12,
                     tags$div(
                       style = "padding: 20px; background-color: #f9f9f9; border-radius: 5px;",
                       verbatimTextOutput("feedback")
                     )
                   )
                 )
               )
             )
    ),
    
    tabPanel("References", 
             tags$head(
               tags$style(
                 HTML("
           body {
             font-family: 'Cinzel', serif;
             font-size: 18px;
             text-align: left
           }
           
           ")
               )
             ),
             div(style = "text-align: center;",
                 titlePanel("References")),
             fluidRow(
               column(
                 width = 10,
                 style = "height: 600px; overflow-y: scroll; padding: 10px;",
                 uiOutput("citations")
               )
             )
    )
    
 
  )))




need<- unique(edu$variabl)



server<- function(input, output, session) {
  
  output$citations <- renderUI({
    citations <- c(
      "<strong>Bowen, Michael, and Anthony Bartley.</strong> <i>The Basics of Data Literacy: Helping Your Students (and You!) Make Sense of Data.</i> National Science Teachers Association Press, 2014.",
      "<b>Brugar, K. A., & Roberts, K. L.</b> 'Seeing is Believing: Promoting Visual Literacy in Elementary Social Studies.' <i>Journal of Teacher Education</i>, vol. 68, 2017.",
      "<b>Digital Scholarship Lab.</b> 'Mapping Inequality.' University of Richmond, 2022.",
      "<b>edX.</b> 'Introduction to Web Accessibility.' Accessed 2024.",
      "<b>Franklin, Christine A., et al.</b> <i>Statistical Education of Teachers.</i> 2015.",
      "<b>Rockoff, Jonah E.</b> 'The Impact of Individual Teachers on Student Achievement: Evidence from Panel Data.' <i>The American Economic Review</i>, vol. 94, no. 2, 2004.",
      "<b>ShinyLive.</b> 'ShinyLive.' Accessed 2024.",
      "<b>Shreiner, T. L.</b> 'Data Literacy for Social Studies: Examining the Role of Data Visualizations in K–12 Textbooks.' <i>Theory & Research in Social Education</i>, vol. 46, no. 2, 2018.",
      "<b>Shreiner, T. L.</b> 'Students’ Use of Data Visualizations in Historical Reasoning: A Think-Aloud Investigation with Elementary, Middle, and High School Students.' <i>The Journal of Social Studies Research</i>, vol. 43, no. 4, 2019.",
      "<b>Shreiner, T. L., and B. M. Dykes.</b> 'Visualizing the Teaching of Data Visualizations in Social Studies: A Study of Teachers’ Data Literacy Practices, Beliefs, and Knowledge.' <i>Theory & Research in Social Education</i>, 2020.",
      "<b>Stronge, James H., Thomas J. Ward, and Leslie W. Grant.</b> 'What Makes Good Teachers Good? A Cross-Case Analysis of the Connection between Teacher Effectiveness and Student Achievement.' <i>Journal of Teacher Education</i>, vol. 62, no. 4, 2011."
    )
    sorted_citations <- sort(citations)
    HTML(paste("<ul>", paste("<li>", sorted_citations, "</li>", sep = ""), "</ul>", sep = ""))
  })
  # Create an empty data frame to store messages
  messages <- reactiveValues(data = data.frame(Name = character(), Email = character(), Message = character(), stringsAsFactors = FALSE))
  
  observeEvent(input$submit, {
    # Validate the form inputs
    validate(
      need(input$name != "", "Please enter your name."),
      need(input$email != "" && grepl("^\\S+@\\S+\\.\\S+$", input$email), "Please enter a valid email address."),
      need(input$message != "", "Please enter a message.")
    )
    
    # Add the message to the data frame
    messages$data <- write_message(input$name, input$email, input$message, messages$data)
    
    # Show a success message
    showModal(
      shinyalert(
        title = "Success!",
        text = "Your message has been submitted.",
        type = "success",
        timer = 2000
      )
    )
    
    
    # Reset the form fields
    updateTextInput(session, "name", value = "")
    updateTextInput(session, "email", value = "")
    updateTextAreaInput(session, "message", value = "")
  })
  session$onFlushed(function() {
    shinyjs::runjs('$("#shinyalert").remove();')
  })
  
  
  output$feedback <- renderPrint({
    messages$data
  })
  
  
  # Initial map creation
  initialMap <- leaflet(options = leafletOptions(minZoom = 4, preferCanvas = TRUE, zoomToLimits = "first")) %>%
    addProviderTiles(provider = "CartoDB.Positron") %>%
    setView(lng = -95.7129, lat = 37.0902, zoom = 4.2) %>%
    setMaxBounds(-50.04102, 10, -150, 50) %>%
    addPolygons(data = final_richmond, color = ~rl_pal(final_richmond$grade), stroke = FALSE, fillOpacity = 0.7) %>%
    addLegend("bottomright",
              pal = rl_pal,
              values = final_richmond$grade,
              title = "HOLC Grade",
              opacity = 1) %>%
    addMarkers(data = data1, ~long, ~lat, popup = ~as.character(state), clusterOptions = markerClusterOptions(color="#0017bb"), 
               label = ~as.character(cities),
               labelOptions = labelOptions(noHide = TRUE), group = "mymarkers")|>
    addControl(actionButton("zoomer","Reset to Full USA View", style="color: #fff; background-color: #cc3f3f; border-color: #c34113;
             border-radius: 10px;
             border-width: 2px"),position="topright")
  
  output$map <- renderLeaflet({
    initialMap
  })
  
  observeEvent(input$demo, {
    req(input$demo != '')
    leafletProxy('map') %>%
      clearControls()
    
    if (input$demo == "Median Home Value") {
      myData1 <- reactive({
        data <- med
        data
      })
      medhome_pal <- colorFactor(palette = "Greys",
                                 domain = estimated,
                                 na.color = NA)
      leafletProxy('map') %>%
        clearGroup("selected_layer") %>%
        addPolygons(data = myData1(),
                    group = "selected_layer",
                    popup = ~str_extract(NAME, "^([^,]*)"),
                    stroke = FALSE,
                    smoothFactor = 0,
                    fillOpacity = 0.4,
                    color = ~medhome_pal(category)
        ) %>%
        addLegend(data = myData1(),
                  "bottomright",
                  pal = medhome_pal,
                  values = ~category,
                  title = "Current Median Home Value",
                  opacity = 1)
    } else if (input$demo != '') {
      myData <- removed_obs[removed_obs$variabl == input$demo, ]
      edu_pal <- colorNumeric(palette = "Greys",
                              domain = myData$prcntg_,
                              na.color = NA)
      leafletProxy('map') %>%
        clearGroup("selected_layer") %>%
        addPolygons(data = myData, group = "selected_layer", popup = input$demo,
                    stroke = FALSE,
                    smoothFactor = 0,
                    fillOpacity = 0.4,
                    color = ~edu_pal(prcntg_)
        ) %>%
        addLegend(data = myData,
                  "bottomright",
                  pal = edu_pal,
                  values = ~prcntg_,
                  title = "Current Percentage",
                  labFormat = labelFormat(suffix = "%"),
                  opacity = 1)
    }
    
    # Add the initial legend back
    leafletProxy('map') %>%
      addLegend("bottomright",
                pal = rl_pal,
                values = final_richmond$grade,
                title = "HOLC Grade",
                opacity = 1)
  })
  
  v<- reactiveValues(data = output)
  observe({
    click <- input$map_marker_click
    zoom <- isolate(input$map_zoom)
    if(is.null(click))
      return()
    
    leafletProxy('map') %>%
      setView(click$lng, click$lat, zoom = 13)
  })
  
  
  
  
  observeEvent(input$zoomer, {
    
    
    if(is.null(input$zoomer))
      return()
    leafletProxy('map') %>% 
      setView(-95.7129, 37.0902, zoom = 4.2)
    
  })}



shinyApp(ui, server)



