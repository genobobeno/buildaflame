#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # List the first level callModules here
  r<-reactiveValues()
  
  # output$MessageMenu <- renderMenu({
  #   # Code to generate each of the messageItems here, in a list. This assumes
  #   # that messageData is a data frame with two columns, 'from' and 'message'.
  #   msgs <- apply(messageData, 1, function(row) {
  #     messageItem(from = row[["from"]], message = row[["message"]])
  #   })
  # })
  
  # output$notif <- renderMenu({
  #   req(length(ETL.Test)>0)
  #   dropdownMenu(type = "notifications",
  #                notificationItem(icon = icon("exclamation-triangle"), status = etlStatus,text = Message),
  #                notificationItem(icon = icon("exclamation-triangle"), status = etlStatus,text = Message1)
  #   )
  # })

  callModule(mod_Survey_server,"survey1",r)
  
  session$onSessionEnded(function() {
    stopApp()
  })
  
}
