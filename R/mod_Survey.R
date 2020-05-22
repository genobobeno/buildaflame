#' Survey UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_SurveySB_ui <- function(id){
  ns <- NS(id)
  tagList(
    shinydashboard::sidebarMenu(id = "surveyMenu",
                                shinydashboard::menuItem("Take the Survey!",icon = icon(name = "tasks"),selected = TRUE))
  )
}

mod_SurveyBD_ui <- function(id){
  ns <- NS(id)
  tagList(
    shinydashboard::tabBox(title = "Tell Me About The Content You Want To See!",
                           # The id lets us use input$tabset1 on the server to find the current tab
                           id = "surveyTabBox",width = 12,height = "250px",
      tabPanel("Tab1", "Take My Survey",
               radioButtons(ns("Q1"),label = "Pick The Topic That Interests You",
                            choices = list("AutoBio"=1,"Career"=2,"Code"=3,"Esoterics"=4,"Creativity"=5,"Fatherhood"=6,"Trading"=7)),
               actionButton(ns("uploadData")),
               plotOutput(ns("barplot1"))),
      tabPanel("Tab2", "Tell Me Your Story",
               textInput(ns("userText"),label = "List some keywords about your topics:",value = "e.g. money, life, kids, trading",width = '100%'))
    )    
  )
}

#' Survey Server Function
#'
#' @noRd 
mod_Survey_server <- function(input, output, session, r){
  ns <- session$ns

  r$surveyData<-read.csv("inst/surveyresults.csv",header = T)
  
  output$barplot1<-renderPlot(
    barplot(table(r$surveyData$topiccategory),main="Category Preferences")
  )
  
   
}
    
## To be copied in the UI
# mod_Survey_ui("Survey_ui_1")
    
## To be copied in the server
# callModule(mod_Survey_server, "Survey_ui_1")
 
