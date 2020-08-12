library(shiny)
library(ggplot2)

shinyUI(
  fluidPage(
    #titlePanel("Workload Calculator"),
    
    tags$head(
      #tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.css"),
      tags$style("#scrollpanel {
            overflow: auto;
            background:	#f5f5f5;
            margin-left: 5px;
        }"),
      tags$style("#workload {
            
            font-family: Arial, Helvetica, sans-serif;
            font-size: 14px;
            }")
      
    ),
    
    h3("Workload Estimator", align="center"),
    p(strong("Modified by:"), HTML('&nbsp;'), a("Daulton Baird", href="https://provost.ok.ubc.ca/about-the-office/office-team-contact/", target="blank"), HTML('&nbsp;'), a("|"), HTML('&nbsp;'), a("Mateen Shaikh", href="http://kamino.tru.ca/experts/home/main/bio.html?id=mshaikh", target="blank"), HTML('&nbsp;'), a("|"), HTML('&nbsp;'), a("Michelle Lamberson", href="https://provost.ok.ubc.ca/about-the-office/office-team-contact/", target="blank"), align="center"),
    
    p(strong("Research & Design:"), HTML('&nbsp;'), a("Betsy Barre", href="https://cat.wfu.edu/about/our-team/", target="blank"), HTML('&nbsp;'), a("|"), HTML('&nbsp;'), a("Allen Brown", href="https://oe.wfu.edu/about/", target="blank"), HTML('&nbsp;'), a("|"), HTML('&nbsp;'), a("Justin Esarey", href="http://www.justinesarey.com", target="blank"), br(), br(), a("Click Here for Estimation Details", href="https://cat.wfu.edu/resources/tools/estimator2details/",target="blank"), align="center"),
    
    hr(),
    
    fluidRow(
      #These radio buttons allow the user to select an item to add to workload
      column(2,
             h4("Select a Course Component", align="center"),
             wellPanel(
               radioButtons("radio", "",
                            c("Discussion" = "discussion",
                              "Exam" = "exam",
                              "Quiz" = "quiz",
                              "Lecture" = "lecture",
                              "Lab" = "lab",
                              "Reading Assignment" = "reading",
                              "Video/Podcast" = "video",
                              "Writing assignment" = "writing",
                              "Custom Assignment" = "custom"))
             )
      ),
      column(3,
             #This is the panel that  is generated based on the radio button
             h4(textOutput("selected_radio"), align="center"),
             uiOutput("selected_panel"),
             actionButton("btn", "Add to Workload Summary")
      ),
      column(3,
             #This is the background information on the panel that has been selected (also controlled by radio button)
             h4("Background",align="center"),
             wellPanel(id="scrollpanel", height="480px", width="90%",
                       uiOutput("selected_bkgd")
             )
             
      ),
      column(4,
             #This is the summary tab where the calculations are shown.
             h4("Workload Summary", align = "center"),
             
             wellPanel(
               
               #htmlOutput("components"),
               #htmlOutput("hours"),
               #htmlOutput("type"),
               verbatimTextOutput("workload"),
               #p(strong("Asynchronous:", inline=T), align="left"),
               #p(strong("Synchronous:", inline=T), align="left"),
               #p(strong("Total:", inline=T), align="left"),
               #hr(),
               #p(strong("Term Total:", inline=T), align="left"),
               
               p(strong(textOutput("estimatedworkload", inline=T))),
               p(strong(textOutput("estimatedAsynch", inline=T))),
               p(strong(textOutput("estimatedSynch", inline=T)))
               
               #p(strong(textOutput("totalcoursehours", inline=T)), align="right"),
               #br(style="line-height:27px")
             )
      ),
    )    
  )
)
