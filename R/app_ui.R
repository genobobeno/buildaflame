#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  library(shinydashboard)
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    shinydashboard::dashboardPage(
      shinydashboard::dashboardHeader(title = "Build A Flame" #  #dropdownMenuOutput("MessageMenu"),
                                      # dropdownMenuOutput("notif") #,
                                      # dropdownMenu(type = "notifications",
                                      #                notificationItem(
                                      #                text = "5 new users today",
                                      #                icon("users")
                                      #              ),
                                      #              notificationItem(
                                      #                text = "12 items delivered",
                                      #                icon("truck"),
                                      #                status = "success"
                                      #              ),
                                      #              notificationItem(
                                      #                text = "Server load at 86%",
                                      #                icon = icon("exclamation-triangle"),
                                      #                status = "warning"
                                      #              )
                                      ),
      shinydashboard::dashboardSidebar(
        mod_SurveySB_ui("survey1")),
      shinydashboard::dashboardBody(
        mod_SurveyBD_ui("survey1")
      )
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    # waiter::use_waiter(),
    # tags$style(HTML('.wrapper {height: 3000 !important; position:relative; overflow-x:hidden; overflow-y:hidden}
    #                  .main-header .logo { font-family: "Georgia", Times, "Times New Roman", serif; font-weight: bold; font-size: 24px;}')
    # ),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'buildaflame'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

# waiting_screen <- tagList(
#   waiter::spin_throbber(),
#   h4("Your data stuff is loading...")
# )
