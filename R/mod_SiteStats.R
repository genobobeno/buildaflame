#' SiteStats UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_SiteStats_ui <- function(id){
  ns <- NS(id)
  tagList(
    
  )
}
    
#' SiteStats Server Function
#'
#' @noRd 
mod_SiteStats_server <- function(input, output, session){
  ns <- session$ns
 
}
    
## To be copied in the UI
# mod_SiteStats_ui("SiteStats_ui_1")
    
## To be copied in the server
# callModule(mod_SiteStats_server, "SiteStats_ui_1")
 
