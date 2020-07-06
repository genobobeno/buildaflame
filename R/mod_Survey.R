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
                                shinydashboard::menuItem(tabName = "survey", text = "Take the Survey!",
                                                         icon = icon(name = "tasks"),selected = TRUE),
                                shinydashboard::menuItem(tabName = "results", text = "See Current Results",
                                                         icon = icon(name = "chart-bar"))
    )
  )
}

mod_SurveyBD_ui <- function(id){
  ns <- NS(id)
  tagList(
    conditionalPanel("input.surveyMenu=='survey'",
        shinydashboard::tabBox(title = "Tell Me About The Content You Want To See!",
                               # The id lets us use input$tabset1 on the server to find the current tab
                               id = "surveyTabBox",width = 12,#height = "250px",
            tabPanel("Tab1", title = "Take My Survey",
                     textInput(ns("voterEmail"),label="Your email? (optional)",value=""),
                     uiOutput(ns("selectCategories")),
                     uiOutput(ns("voteTopics")),
                     textInput(ns("addComments"),"Any comments in reference to your vote?"),
               # radioButtons(ns("Q1"),label = "Pick The Topic That Interests You",
               #              choices = list("AutoBio"=1,"Career"=2,"Code"=3,"Esoterics"=4,"Creativity"=5,"Fatherhood"=6,"Trading"=7)),
                     actionButton(ns("uploadVote"),label = "Submit Vote!"),
                     hr(),
                     uiOutput(ns("votes"))),
            tabPanel("Tab2", "Leave a Note!",
                     textInput(ns("noteEmail"),label = "Your email? (optional)",value = ""),
                     textInput(ns("userStory"),label = "Let me know what topics you're thinking about:",value = "e.g. money, life, kids, trading",width = '100%'),
                     actionButton(ns("uploadStory"),label = "Submit!"))
          )
    ),
    conditionalPanel("input.surveyMenu=='results'",
                     plotOutput(ns("currentVotes")),
                     DT::dataTableOutput(ns("resultsLegend")))
  )   
}

#' Survey Server Function
#'
#' @noRd 
mod_Survey_server <- function(input, output, session, r){
  ns <- session$ns
  
  #options(gargle_oauth_cache = "/home/egeis/Documents/RProjects/.secrets",stringsAsFactors = FALSE,scipen=999)
  
  googlesheets4::gs4_auth(
    email = gargle::token_email(gargle::token_fetch(  path = "/home/egeis/Documents/RProjects/.secrets/BuildAFlame-d80788031549.json" )),
    path = "/home/egeis/Documents/RProjects/.secrets/BuildAFlame-d80788031549.json" ,
    cache = gargle::gargle_oauth_cache(),
    use_oob = gargle::gargle_oob_default()
  )
  
  # json<-gargle:::secret_read("buildaflame","gargle-testing.json")
  # # gargle:::token_fetch(  path = rawToChar(json) )
  # googlesheets4::gs4_auth(
  #   email = gargle::token_email(gargle:::token_fetch(  path = rawToChar(json) )),
  #   path = rawToChar(json) ,
  #   cache = gargle::gargle_oauth_cache(),
  #   use_oob = gargle::gargle_oob_default()
  # )
  r$selectedTopics<-c()  
  Topics<-googlesheets4::read_sheet(ss = "1-4kwf6x4-zJC7JOKly-Wp4VZ47arooxO87PUTlOgI6I",sheet = "Topics")
  Votes<-googlesheets4::read_sheet(ss = "1-4kwf6x4-zJC7JOKly-Wp4VZ47arooxO87PUTlOgI6I",sheet = "Votes")
  Notes<-googlesheets4::read_sheet(ss = "1-4kwf6x4-zJC7JOKly-Wp4VZ47arooxO87PUTlOgI6I",sheet = "Notes")
  
  Cats<-unique(Topics$Category)
  Articles<-list()
  for (i in Cats) {
    Articles[[i]]<-setNames(object = 1:sum(Topics$Category==i),nm=Topics$Topic[Topics$Category==i])
  }
  
  output$selectCategories<-renderUI({
    req(nchar(Cats[1])>0) 
    radioButtons(ns("categoryChoice"),label = "Choose the category of articles to display:",
                 choices = utils_createNumList(Cats))
  })

  observe({
    r$selectedTopics<-unique(c(r$selectedTopics,as.numeric(input$topicVotes)))
  })
  
  output$voteTopics<-renderUI({
    req(nchar(Cats[1])>0)
    if (!is.na(r$selectedTopics) && sum(r$selectedTopics %in% Topics$Index[Topics$Category==Cats[as.numeric(input$categoryChoice)]])>0) {
      selectedTopics<-r$selectedTopics[r$selectedTopics %in% Topics$Index[Topics$Category==Cats[as.numeric(input$categoryChoice)]]]
    } else {
      selectedTopics<-NA
    }
    checkboxGroupInput(ns("topicVotes"),label = "Check the articles you'd like to read:",
                       choices = utils_createNumList(Topics$Topic[Topics$Category==Cats[as.numeric(input$categoryChoice)]],
                                                     nums=Topics$Index[Topics$Category==Cats[as.numeric(input$categoryChoice)]]),
                       selected = selectedTopics)
  })
    
  output$votes<-renderUI({
    req(length(r$selectedTopics)>0)
    paste0("<ul>",paste0(paste0("<li>",Topics$Category[Topics$Index %in% r$selectedTopics],": ",
                                Topics$Topic[Topics$Index %in% r$selectedTopics]),collapse=""),
           "</ul>")
  })
  
  observeEvent(input$uploadVotes,{
    
    Votes<-data.frame(Category=Sheet$Category[r$selectedTopics], Topic = Sheet$Topic[r$selectedTopics],
                      Index = Sheet$Index[r$selectedTopics], User = input$voterEmail,
                      Comment = input$addComments, Timestamp = Sys.time())
    googlesheets4::sheet_append(data = Votes,ss="1-4kwf6x4-zJC7JOKly-Wp4VZ47arooxO87PUTlOgI6I",sheet = "Votes")
    fct_readVotes()
  })

  observeEvent(input$uploadStory,{
    Notes<-data.frame(User = input$noteEmail,Comment = input$userStory,Timestamp = Sys.time())
    googlesheets4::write_sheet(data = Notes,ss="1-4kwf6x4-zJC7JOKly-Wp4VZ47arooxO87PUTlOgI6I",sheet = "Notes")
  })
  
  output$currentVotes<-renderPlot({
    Results<-googlesheets4::read_sheet(ss = "1-4kwf6x4-zJC7JOKly-Wp4VZ47arooxO87PUTlOgI6I",sheet = "Topics")
    Results<-Results[Results$Votes>0]
    r$DataTable<-Results[order(-Results$Votes),c(1,2,3,4)]
    barplot(setNames(object = Results$Votes,Results$Index),main="Current Votes on Topics (Indices)",xlab="Topic Index (see Table)",
            ylab="Votes")
  })
  
  output$resultsLegent<-DT::renderDataTable(r$DataTable)
  
  # output$LinkBox <- DT::renderDataTable({
  #   IE<-utils_createLink("https://ie.datamyx.com/","IntellidataExpress")
  #   DS<-utils_createLink("https://www.pivotaltracker.com/n/projects/2055771","DS Pivotal Tracker")
  #   my_table <- data.frame("Link"=c(IE,DS),
  #                        "Description"=c("Intellidata Express is our interface to all of our data!",
  #                                        "The Data Science Pivotal Tracker Backlog of projects."))
  #   DT::datatable(my_table,options = list(paging=FALSE,searching=FALSE,processing=FALSE),escape=FALSE)
  # })
   
}
    
## To be copied in the UI
# mod_Survey_ui("Survey_ui_1")
    
## To be copied in the server
# callModule(mod_Survey_server, "Survey_ui_1")
 
