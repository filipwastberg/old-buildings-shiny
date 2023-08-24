# app/view/chart.R

box::use(
  leaflet,
  shiny[moduleServer, NS, observeEvent, tagList, uiOutput, renderUI, reactive, selectizeInput, fluidRow],
  bs4Dash[box],
  dplyr[filter]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      box(
        id = "map_container",
        title = "",
        width = 9,
        height = "100%",
        leaflet$leafletOutput(ns("map"), height = 460)
      ),
      box(
        width = 3,
        uiOutput(ns("kommun_select"))
        )
      )
    )
}

#' @export
server <- function(id, buildings) {
  moduleServer(id, function(input, output, session) {
    
    output$kommun_select <- renderUI({
      selectizeInput(
        session$ns("kommun"),
        "Område", 
        choices = unique(buildings()$kommun),
        selected = unique(buildings()$kommun)[[1]],
          multiple = TRUE, options = list(maxItems = 2)
        )
      
    })
    
    
    output$map <- leaflet$renderLeaflet({
      
      leaflet$leaflet() |> 
        leaflet$addProviderTiles(leaflet$providers$Stamen.Toner, group = "Svartvit") |> 
        leaflet$addProviderTiles(leaflet$providers$Esri.WorldImagery, group = "Satellit") |> 

        leaflet$addAwesomeMarkers(
          data = filter(buildings(), kommun %in% input$kommun),
          ~lng, ~lat,
          icon = leaflet$awesomeIcons(
            icon = 'fa-building',
            iconColor = "#ffffff",
            library = 'fa',
            markerColor = "darkblue"
          ),
          popup = ~paste0(
            '<header style="position: relative; top: 1px; bottom: 1px"><h6>', sitename, "</h6>",
            "<i>Historisk kategori: ", historisk_kategori_smal, "</i></br>",
            "Byggnadsår: ", byggnadsar_start
            
            ),
          group = "ibinder") |> 
        leaflet$addLayersControl(
          baseGroups = c("Satellit", "Svartvit"),
          options = leaflet$layersControlOptions(collapsed = FALSE)
        )
      
      
    })
    
  })
  
}