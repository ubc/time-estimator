library(shiny)
library(shinydashboard)

#pulls Tab Item details from "tabItem.R"
getTabItem <- function(x){
  source("tabItem.R")
  return(createTabItem(x))
}

#initialize UI component
shinyUI(
  ui= (
  dashboardPage(
    dashboardHeader(title = "Course Workload Estimator", titleWidth = 300),
      sidebar <- dashboardSidebar(
        #add menu items to the sidebar
        #menu items are tabs that open when clicked
        sidebarMenu(
          menuItem(text= "Info", tabName="info", icon=icon("info-circle")),
          menuItem(text= "Course 1", tabName="course1", icon=icon("book")),
          menuItem(text= "Course 2", tabName="course2", icon=icon("book")),
          menuItem(text= "Course 3", tabName="course3", icon=icon("book")),
          menuItem(text= "Course 4", tabName="course4", icon=icon("book")),
          menuItem(text= "Course 5", tabName="course5", icon=icon("book")),
          menuItem(text= "Course 6", tabName="course6", icon=icon("book")),
          menuItem(text= "Workload Total", tabName="total", icon=icon("calculator"))
        )
      ),
      body <- dashboardBody(
        tabItems(
          #tabItem(tabName = "info",
           #       h2("Info tab content"),
           #       #Credit Information
           #       p("Modifed from ", HTML('&nbsp;'), a("Betsy Barre", href="https://cat.wfu.edu/about/our-team/", target="blank"), HTML('&nbsp;'), a("|"), HTML('&nbsp;'), a("Allen Brown", href="https://oe.wfu.edu/about/", target="blank"), HTML('&nbsp;'), a("|"), HTML('&nbsp;'), a("Justin Esarey", href="http://www.justinesarey.com", target="blank"), br(), a("Click Here for Estimation Details", href="https://cte.rice.edu/workload#howcalculated")),  
           #       div(a(img(src="/cc-by-nc-sa.png"),href="https://creativecommons.org/licenses/by-nc-sa/4.0/"), style="text-align: left;"),
           #       div(a(href="https://cat.wfu.edu/resources/tools/estimator2/", "Workload Calculator 2.0"), style="text-align:left;", target="blank", align="left"),
           #       hr(),
                  #Information for our code
                 #div(a(img(src="/cc-by-nc-sa.png"),href="https://creativecommons.org/licenses/by-nc-sa/4.0/"), style="text-align: left;"),
                 #div(a(href="source.zip", "Download our Source Code"), style="text-align:left;", target="blank", align="left")
          #),
                     
          #creates new tab items using "IDs"tabNames" created above
          getTabItem("course1"),
          #getTabItem("course2"),
          #getTabItem("course3"),
          #getTabItem("course4"),
          #getTabItem("course5"),
          #getTabItem("course6"),
          
          tabItem(tabName = "total",
                  h2("Total tab content")
          )
        )
      ),
    
      # Put them together into a dashboardPage
      dashboardPage(
        dashboardHeader(),
        sidebar,
        body
      )
    )#end of dashboard page
  )#end of UI declaration
)#end of shinyUI
