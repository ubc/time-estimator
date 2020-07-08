library(shiny)
library(shinydashboardPlus)


createTabItem <- function(x){
  return(
    tabItem(tabName = x,
      #This box holds the course-specific calculations
      box(
        title = "Workload Estimation Calculator",
        wellPanel(
          h5("Workload Estimates", align = "center"),
          p(strong(textOutput("estimatedworkload", inline=T)), align="left"),
          p(strong(textOutput("estimatedoutofclass", inline=T)), align="left"),
          p(strong(textOutput("estimatedengaged", inline=T)), align="left"),
          hr(),
          p(strong(textOutput("totalcoursehours", inline=T)), align="left")
        ),
             
      accordion(
        accordionItem(
          id = 1,
          title = "Course Info",
          color = "warning",
          collapsed = TRUE,
          wellPanel(
            numericInput(
              inputId = "classweeks",
              label = "Class Duration (Weeks):",
              value=15,
              width='100%',
            )
          )
        ),
        
        accordionItem(
          id = 2,
          title = "Class Meetings",
          color = "warning",
          collapsed = TRUE,
          wellPanel( # beginning of Synchronous Sessions panel
            numericInput(
              inputId = "syncsessions",
              label = "Live Meetings Per Week:",
              value=0,
              width='100%'
            ),
            numericInput(
              inputId = "synclength",
              label = "Meeting Length (Hours):",
              value=0,
              width='100%'
            )
          ) # end of Synchronous panel
          
        ),
        accordionItem(
          id = 3,
          title = "Reading Assignments",
          color = "info",
          collapsed = TRUE,
          wellPanel(# reading panel
            numericInput(
              inputId = "weeklypages",
              label = "Pages Per Week:",
              value=0,
              width='100%'
            ),
            hr(),
            
            #Reading difficulty information, see wFU docs for more info
            selectInput(inputId="readingdensity", label="Page Density:",c("450 Words"=1, "600 Words"=2,"750 Words"=3), selected=1),
            
            selectInput(inputId="difficulty", label="Difficulty:",c("No New Concepts"=1,"Some New Concepts"=2,"Many New Concepts"=3), selected=1),
            
            selectInput(inputId="readingpurpose", label="Purpose:",c("Survey"=1,"Understand"=2,"Engage"=3), selected=1),
            p(strong("Estimated Reading Rate:"),br(),textOutput("pagesperhour.out", inline=T),br(),br(),
              
            checkboxInput("setreadingrate", "manually adjust", value=F, width='100%'), align="center"),
            
            conditionalPanel("input.setreadingrate == true",
            numericInput(inputId="overridepagesperhour", label="Pages Read Per Hour:", value=10, min=0, max=NA)
            )
          ) #end of reading panel
          
        ),
        accordionItem(
          id = 4,
          title = "Writing Assignments",
          color = "info",
          collapsed = TRUE,
          wellPanel( # Writing assignment panel
            numericInput(
              inputId = "semesterpages",
              label = "Pages Per Semester:",
              value=0,
              width='100%'
            ),
            hr(),
            
            #Writing Difficulty Settings, see WFU docs for more info
            selectInput(inputId="writtendensity", label="Page Density:",c("250 Words"=1, "500 Words"=2), selected=1),
            
            selectInput(inputId="writingpurpose", label="Genre:",c("Reflection/Narrative"=1, "Argument"=2, "Research"=3), selected=1),
            
            selectInput(inputId="draftrevise", label="Drafting:",c("No Drafting"=1, "Minimal Drafting"=2, "Extensive Drafting"=3), selected=1),
            
            p(strong("Estimated Writing Rate:"),br(),textOutput("hoursperwriting.out", inline=T), br(),br(),checkboxInput("setwritingrate", "manually adjust", value=F, width='100%'), align="center"),
            
            conditionalPanel("input.setwritingrate == true",
                             
            numericInput(inputId="overridehoursperwriting", label="Hours Per Written Page:", value=.5, min=0.1, max=NA)
            )
          ) #end of writing assignment panel
        ),
        
        accordionItem(
          id = 5,
          title = "Labs",
          color = "info",
          collapsed = TRUE,
          wellPanel(  #Labs panel
            numericInput(
              inputId = "labs",
              label = "Labs Per Semester:",
              value=0,
              width='100%'
            ),
            sliderInput(
              inputId = "labprep",
              label = "Preparation Per Lab:",
              min=0,
              max=10,
              step=1,
              value=0,
              width='100%'
            ),
            sliderInput(
              inputId = "labhours",
              label = "Hours Per Lab:",
              min=0,
              max=50,
              step=1,
              value=0,
              width='100%'
            )
          ) #end of labs panel
        ),
        
        accordionItem(
          id = 6,
          title = "Videos & Podcasts",
          color = "info",
          collapsed = TRUE,
          wellPanel( # Video and Audio panel
            
            numericInput(
              inputId = "weeklyvideos",
              label = "Hours Per Week:",
              value=0,
              width='100%'
            )
          ) # end of video & audio panel
        ),
        
        accordionItem(
          id = 7,
          title = "Projects",
          color = "info",
          collapsed = TRUE,
          wellPanel(#Projects panel
            numericInput( 
              inputId = "projects",
              label = "Projects Per Semester:",
              value=0,
              width='100%'
            ),
            sliderInput(
              inputId = "projhours",
              label = "Hours Per Project:",
              min=0,
              max=50,
              step=1,
              value=0,
              width='100%'
            )
          ) #end of Project panel
        ),
        
        accordionItem(
          id = 8,
          title = "Discussion Posts",
          color = "info",
          collapsed = TRUE,
          wellPanel( # Discussion board panel
            numericInput(
              inputId = "postsperweek",
              label = "Posts per Week:",
              value=0,
              width='100%'
            ),
            hr(),
            
            #Discusion board difficulty, see WFU docs for more info
            selectInput(inputId="postformat", label="Format:",c("Text"=1, "Audio/Video"=2), selected=1),
            
            conditionalPanel("input.postformat == 1",
              numericInput(inputId="postlength.text", label="Avg. Length (Words):",value=250, min=0, max=NA)
            ),
            
            conditionalPanel("input.postformat == 2",
              numericInput(inputId="postlength.av", label="Avg. Length (Minutes):",value=3, min=0, max=NA)
            ),
            
            p(strong("Estimated Hours:"),br(),textOutput("hoursperposts.out", inline=T), br(), br(), checkboxInput("setdiscussion", "manually adjust", value=F, width='100%'), align="center"),
            
            conditionalPanel("input.setdiscussion == true",
              numericInput(inputId="overridediscussion", label="Hours Per Week:", value=1, min=0, max=NA)
            )
          ) #end of discussions panel
        ),
        
        accordionItem(
          id = 9,
          title = "Quizzes",
          color = "info",
          collapsed = TRUE,
          wellPanel(     # Quiz panel
            numericInput(
              inputId = "quizzes",
              label = "Quizzes Per Semester:",
              value=0,
              width='100%'
            ),
            numericInput(
              inputId = "quizhours",
              label = "Study Hours Per Quiz:",
              min=0,
              max=50,
              #step=1,
              value=5,
              width='100%'
            ),
            
            #timed quizzes + length
            checkboxInput("quiztimed", "Timed-Quizzes", value=F, width='100%'),
            
            conditionalPanel("input.quiztimed == true",
              numericInput(inputId="quiz.length", label="Quiz Time Limit (in Minutes)",value=10, min=0, max=NA)
            )
          ) #end of quiz panel
        ),
        
        accordionItem(
          id = 10,
          title = "Other Assignments",
          color = "info",
          collapsed = TRUE,
          wellPanel(  #other assignments panel
            numericInput(
              inputId = "otherassign",
              label = "# Per Semester:",
              value=0,
              width='100%'
            ),
            sliderInput(
              inputId = "otherhours",
              label = "Hours Per Assignment:",
              min=0,
              max=50,
              step=1,
              value=0,
              width='100%'
            ),
            checkboxInput("other.engage", "Independent", value=F, width='100%')
          ) #end of other assignments panel
        ),
        
        accordionItem(
          id = 11,
          title = "Exams",
          color = "danger",
          collapsed = TRUE,
          wellPanel(     # Exam panel
            numericInput(
              inputId = "exams",
              label = "Exams Per Semester:",
              value=0,
              width='100%'
            ),
            numericInput(
              inputId = "examhours",
              label = "Study Hours Per Exam:",
              min=0,
              max=50,
              #step=1,
              value=5,
              width='100%'
            ),
            
            #take home exams + length
            checkboxInput("takehome", "Take-Home Exams", value=F, width='100%'),
            
            conditionalPanel("input.takehome == true",
              numericInput(inputId="exam.length", label="Exam Time Limit (in Minutes)",value=60, min=0, max=NA)
            )
          ) #end of exams panel
        ) #end of quiz accordion
      ) #end of accordion
    ) #end of box
    ) #end of tab item
  )#close return
}#end of function
