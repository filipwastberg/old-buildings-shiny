box::use(
  shiny[moduleServer, reactive, eventReactive, NS],
  readr[read_csv]
)

building_ui <- function(id) {
  ns <- NS(id)
  ns("read_data")
}

buildings <- function(id, system) {
  moduleServer(id, function(input, output, session) {
    reactive({
      read_csv("app/data/buildings_complete.csv", show_col_types = FALSE)
    })
  })
}