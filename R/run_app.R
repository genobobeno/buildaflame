#' Run the Shiny Application
#'
#' @param ... A series of options to be used inside the app.
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(
  ...
) {
  library("googledrive")
  library("googlesheets4")
  library("gargle")
  options(gargle_oauth_cache = "/home/egeis/Documents/RProjects/.secrets",stringsAsFactors = FALSE,scipen=999)
  # options(gargle_oauth_cache = "secrets",stringsAsFactors = F,scipen=999)
  r<-reactiveValues()
  with_golem_options(
    app = shinyApp(
      ui = app_ui, 
      server = app_server
    ), 
    golem_opts = list(...)
  )
}
