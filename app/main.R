box::use(
  shiny[bootstrapPage, div, moduleServer, NS, renderUI, tags, uiOutput, icon],
  bs4Dash[dashboardPage, dashboardHeader, dashboardSidebar, box, bs4Card,
          sidebarMenu, menuItem, dashboardFooter, dashboardBody,
          tabItem, tabItems, dashboardControlbar]
)

box::use(
  app/view/map,
  app/data/read_data
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  dashboardPage(
    title = "Basic Dashboard",
    header = dashboardHeader(
      title = "Sveriges äldsta byggnader"
    ),
    sidebar = dashboardSidebar(
      skin = "light",
      sidebarMenu(
        id = "sidebarmenu",
        menuItem(
          "Översikt",
          tabName = "Karta",
          icon = icon("globe", lib = "glyphicon")
        )
      )
    ),
    controlbar = dashboardControlbar(),
    footer = dashboardFooter(),
    body = dashboardBody(
      tabItems(
        tabItem(
          tabName = "Karta",
          map$ui(ns("map"))
        )
      )
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    data <- read_data$buildings("read_data")
 
    map$server(
      id = "map",
      buildings = data
    )
  })
}
