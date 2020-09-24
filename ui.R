library(shiny)
library(shinyBS)

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
    
    h3("Student Course Time Estimator (Beta)", align="center"),
    p(strong("Modified by:"), HTML('&nbsp;'), a("Daulton Baird", href="https://provost.ok.ubc.ca/about-the-office/office-team-contact/#daulton", target="blank"), HTML('&nbsp;'), a("|"), HTML('&nbsp;'), a("Mateen Shaikh", href="http://kamino.tru.ca/experts/home/main/bio.html?id=mshaikh", target="blank"), HTML('&nbsp;'), a("|"), HTML('&nbsp;'), a("Michelle Lamberson", href="https://provost.ok.ubc.ca/about-the-office/office-team-contact/#michelle", target="blank"), align="center"),
    
    p(strong("Research & Design:"), HTML('&nbsp;'), a("Betsy Barre", href="https://cat.wfu.edu/about/our-team/", target="blank"), HTML('&nbsp;'), a("|"), HTML('&nbsp;'), a("Allen Brown", href="https://oe.wfu.edu/about/", target="blank"), HTML('&nbsp;'), a("|"), HTML('&nbsp;'), a("Justin Esarey", href="http://www.justinesarey.com", target="blank"), br(), br(), align="center"),
    p(strong("Beta Version Review: Click", a("here", href="https://ubc.ca1.qualtrics.com/jfe/form/SV_7P4lcDHWNV7ePkN", target="_blank"),"to provide feedback on this tool."), align="center"),
    
    hr(),
    bsCollapse(id = "collapse1", open = "About this tool (click to view/hide)",
       bsCollapsePanel("About this tool (click to view/hide)", 
       
       tags$p("This planning tool is for instructors who wish to estimate the expected student time commitment in a course based on the assigned learning activities. The tool is designed to be used for courses that represent the blended learning spectrum from face-to-face to fully online. Based on the input provided, the tool calculates the total time commitment expected, and allocates activities into scheduled (set by the institution, typically live meetings) and independent (at the discretion of the student within the parameters set by course deadlines) activities."),style = "primary")
    ),
    bsCollapse(id = "collapse2", open = "Instructions (click to view/hide)",
       bsCollapsePanel("Instructions (click to view/hide)",
                    tags$ol(
                      tags$li("Set your course duration (in weeks). Once any component has been added to the Workload, the course duration can not be changed."),
                      tags$li("Add a course component by selecting the radio button next to the component, adjusting the provided options and clicking on “Add to Workload Summary”. Note that information about each component will appear in Background panel."),
                      tags$li("Once a component is added, the “Workload Summary” panel will document the components and provide a summary."),
                      tags$li("Note that items can be removed by clicking on the x next to the component in the summary."),
                      tags$li("Keep adding components until complete."),
                    ), 
                    tags$p("Note that some components have a name associated with them. This name is optional, but may be helpful to facilitate tracking in the situation where you add particular components one at a time.  For example, you may choose to add a Midterm Exam and a Final Exam that are of different lengths."),
                    style = "primary")
    ),
    fluidRow(
      #These radio buttons allow the user to select an item to add to workload
      column(2,
             h4("Select a Course Component", align="center"),
             wellPanel(
               p(strong(uiOutput("numWeeks", inline=T))),
               p(strong(uiOutput("classmeetings", inline=T))),
               radioButtons("radio", "",
                            c(
                              "Primary Class Meeting" = "classmeeting",
                              "Creative Practice Session" = "creativepractice",
                              "Discussion" = "discussion",
                              "Exam" = "exam",
                              "Lab" = "lab",
                              "Quiz" = "quiz",
                              "Reading Assignment" = "reading",
                              "Tutorial" = "tutorial",
                              "Video/Podcast" = "video",
                              "Writing Assignment" = "writing",
                              "Custom Assignment" = "custom"))
             )
      ),
      column(3,
             #This is the panel that  is generated based on the radio button
             h4(textOutput("selected_radio"), align="center"),
             uiOutput("selected_panel"),
             actionButton("add", "Add to Workload Summary")
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

      uiOutput(("workload")),
      

     
      p(strong(textOutput("estimatedAsynch", inline=T))),
      p(strong(textOutput("estimatedSynch", inline=T))), 
      p(strong(textOutput("estimatedworkload", inline=T))),
      hr(),
      #p(strong("Total Hours: 0 hrs")),
      p(strong(textOutput("totalcoursehours", inline=T))),
      ),
  
  #br(style="line-height:27px")
      )
    ),
  hr(),
  bsCollapse(id = "collapse2", open = "",
             bsCollapsePanel("More info (click to view/hide)", 
                             tags$ul(
                               tags$li("Course duration : The duration of a course, specified in weeks. This parameter is the basis for the time commitment calculations. "),
                             ),
                             tags$ul(
                               tags$li("Each course component includes options to set the number of times the associated activities are performed and how long each will take."),
                               tags$li("Course components may include options for allocating time into the different activities. For example, when adding a lab component, you may specify the amount of time expected to prepare for, conduct and write up a lab."),
                               tags$li("Course components may include options for allocating between independent and scheduled time. The scheduled time may be excluded from a calculation and instead included in the class meeting times."),
                             ), style = "primary"
                             )
  ),
  div(
  a(img(src="cc-by-nc-sa.png"),href="https://creativecommons.org/licenses/by-nc-sa/4.0/"), style="text-align: center;"),
  p(style="text-align:center", "This app was modified from", a(href= "https://cat.wfu.edu/resources/tools/estimator2/", "Workload Estimator 2.0"), "created by Barre, Brown, and Esarey. under a ", a("Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.",href="http://creativecommons.org/licenses/by-nc-sa/4.0/")),
  tags$script(src = "script.js")
  )
)