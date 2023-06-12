library(leaflet)
library(leaflet.extras)
library(rgdal)
library(shiny)
library(htmlwidgets)
library(htmltools)
library(pool)
library(dplyr)
library(RPostgres)

route <- readOGR(dsn = "data/route.geojson", layer = "route")
parking <- readOGR(dsn = "data/parking.geojson", layer = "parking")
start_finish <- readOGR(dsn = "data/start_finish.geojson", layer = "start_finish")

parkingIcon <- makeIcon("images/parking.png",
                          iconWidth = 30, iconHeight = 30)

startFinishIcons <- iconList(
  startIcon <- makeIcon("images/start.png",
                        iconWidth = 30, iconHeight = 30),
  finishIcon <- makeIcon("images/finish.png",
                         iconWidth = 30, iconHeight = 30)
)

ui <- fluidPage(
  titlePanel("Em's Trip Around the Sun Celebratory Run"),
  leafletOutput("map", height = 800)
  )

server <- function(input, output) {
  output$map <- renderLeaflet({
    # --- get location from rds ---
    egine <- dbConnect(drv      = RPostgres::Postgres(), 
                       user = "<user>", 
                       password = "<pass>", 
                       host     = "<host>", 
                       port     = <port>, 
                       dbname   = "<database>")
    last_loc <- dbGetQuery(egine, "SELECT * FROM <database>;")
    last_loc <- tail(last_loc, n=1)
    
    em_lat <- last_loc[,1]
    em_lon <- last_loc[,2]
    em_time <- last_loc[,3]
    # --- ---
    leaflet() %>% 
      addTiles(group = "OSM (default)") %>%
      addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
      setView(lng = -77.087620, lat = 38.973347, zoom = 10) %>%
      addPolylines(data=route) %>%
      addMarkers(data=parking, group = "Parking", popup = ~as.character(Name), icon = parkingIcon) %>%
      addMarkers(data=start_finish, group = "Start/Finish", popup = ~as.character(Name), icon=startFinishIcons) %>%
      addPulseMarkers(
        lng = as.numeric(em_lon), lat = as.numeric(em_lat),
        label = paste("Emily's last known location as of", em_time, sep = " "),
        icon = makePulseIcon(heartbeat = 0.5),
        group = "pulse"
      ) %>%
      addLayersControl(
        baseGroups = c("Light", "OSM (default)"),
        overlayGroups = c("Start/Finish", "Parking"),
        options = layersControlOptions(collapsed = FALSE)
      ) %>% hideGroup("Parking") %>%
      addEasyButtonBar(
        easyButton(icon = "fa-crosshairs", title = "Locate Me",
                   onClick = JS("function(btn, map){ map.locate({setView: true});}"))
      )
  })
}

shinyApp(ui, server)

