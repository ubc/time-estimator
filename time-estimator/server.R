library(shiny)
library(stringr)
library(shinyjs)

# an array giving data to use on pages per hour according to difficulty, reading purpose, and reading density
pagesperhour <- array(
  data<-c(67,47, 33, 33, 24, 17, 17, 12, 9, 50, 35, 25, 25, 18, 13, 13, 9, 7, 40, 28, 20, 20, 14, 10, 10, 7, 5), 
  dim=c(3,3,3),
  dimnames = list(c("No New Concepts","Some New Concepts","Many New Concepts"), 
                  c("Survey","Learn","Engage"),
                  c("450 Words (Paperback)","600 Words (Monograph)","750 Words (Textbook)")
  )
)

# an array giving data to use on hours per page according to difficulty, reading purpose, and reading density
hoursperwriting <- array(
  data<-c(0.75, 1.5, 1, 2, 1.25, 2.5, 1.5, 3, 2, 4, 2.5, 5, 3, 6, 4, 8, 5, 10),
  dim=c(2,3,3),
  dimnames = list(c("250 Words (D-Spaced)", "500 Words (S-Spaced)"),
                  c("No Drafting", "Minimal Drafting", "Extensive Drafting"),
                  c("Reflection; Narrative", "Argument", "Research")
  )
)

# Define server logic
shinyServer(
  function(input, output, session){
      
      #Radio button input to update text above second panel
      output$selected_radio <- renderText({
        if(input$radio == "classmeeting"){
          "Add the Primary Class Meeting"
        }
        else if (input$radio == "creativepractice"){
          "Add a Creative Practice Session"
        }
        else if(input$radio == "discussion"){
          "Add a Discussion"
        }
        else if (input$radio == "exam"){
          "Add an Exam"
        }
        else if (input$radio == "lab"){
          "Add a Lab"
        }
        else if (input$radio == "quiz"){
          "Add a Quiz"
        }
        else if (input$radio == "reading"){
          "Add a Reading Assignment"
        }
        else if (input$radio == "tutorial"){
          "Add a Tutorial"
        }
        else if (input$radio == "video"){
          "Add a Video or Podcast"
        }
        else if (input$radio == "writing"){
          "Add a Writing Assignment"
        }
        else if (input$radio == "custom"){
          "Add a Custom Assignment"
        }
        else{#should not be reachable but put in for safety.
          "You have selected something not in the list."
        }
      })
      
      #text input for variable number of weeks (denominator in calculations)
      output$numWeeks <- renderUI({
        numericInput(
          inputId = "classweeks",
          label = "Course Duration (Weeks):",
          min=0,
          value=14,
          width='100%'
        )
      })
      
      #renders output panel from getComponent function
      output$selected_panel <- renderUI({
        getComponent(input$radio)
      })
      
      #returns component panel based on radio button choice.
      getComponent <- function(selected){
        if (selected == "classmeeting"){#start of Primary Class Meeting code
          return( #content to be returned
            wellPanel( # beginning of Primary Class Meeting panel
              numericInput(
                inputId = "syncsessions",
                label = "Meetings per Week:",
                value=0,
                min=0,
                width='100%'
              ),
              numericInput(
                inputId = "synclength",
                label = "Meeting Length (Hours):",
                min=0,
                value=0,
                width='100%'
              )
            ) # end of Primary Class Meeting panel
          ) #end of return
        }#end of Primary Class code
        else if (selected == "creativepractice"){#start of creative practice code
          return( #content to be returned
            wellPanel(  #creative practice panel
              numericInput(
                inputId = "sess",
                label = "Sessions per Term:",
                value=0,
                min=0,
                width='100%'
              ),
              sliderInput(
                inputId = "sessprep",
                label = "Preparation per Session (Independent):",
                min=0,
                max=10,
                step=0.25,
                value=0,
                width='100%'
              ),
              sliderInput(
                inputId = "sesshours",
                label = "Session Hours per Term:",
                min=0,
                max=12,
                step=0.25,
                value=0,
                width='100%'
              ),
              checkboxInput("sesssynch", "Scheduled", value=T, width='100%'),
              sliderInput(
                inputId = "postsess",
                label = "Post-Session (Independent):",
                min = 0,
                max=10,
                step=0.25,
                value=0,
                width='100%'
              )
              
            ) #end of creative practice panel
          )#end of return
        }#end of creative practice code
        else if(selected == "discussion"){ #start of discussion code
          return( # content to be returned
            wellPanel( # Discussion board panel
              #Discussion board type, online (Async) or In-person (Sync)
              selectInput(inputId="postformat", label="Format:",c( "Asynchronous (I)"=1, "Synchronous (S)"=2), selected=1),
              
              textInput(
                inputId = "discName",
                label = "Discussion Name (optional):",
                value=""
              ),
              numericInput(
                inputId = "postspersem",
                label = "Number of Discussions per Term",
                value=0,
                min=0,
                width='100%'
              ),
              
              hr(),
              
              conditionalPanel("input.postformat == 1",
                               numericInput(
                                 inputId = "posts",
                                 label = "Original Posts:",
                                 value=1,
                                 min=0,
                                 width='100%'
                               ),
                               numericInput(inputId="postlength", label="Avg. Post Length (Words):",value=250, min=0, max=NA),
                               hr(),
                               numericInput(
                                 inputId = "responses",
                                 label = "Responses:",
                                 value=2,
                                 min=0,
                                 width='100%'
                               ),
                               numericInput(inputId="resplength", label="Avg. Response Length (Words):",value=125, min=0, max=NA),
              ),
              
              conditionalPanel("input.postformat == 2",
                               numericInput(inputId="preptime", label="Preparation Time (Minutes):",value=30, min=0, max=NA),
                               
              ),
             
              checkboxInput("setdiscussion", "Manually Adjust", value=F, width='100%'),
              
              conditionalPanel("input.setdiscussion == true",
                               numericInput(inputId="overridediscussion", label="Hours per Discussion:", value=1, min=0, max=NA)
              )
            ) #end of discussions panel
          ) #end of return
        } #end of discussion code
        else if (selected == "exam"){ #start of exam code
          return( #content to be returned
            wellPanel(     # Exam panel
              selectInput(inputId="examformat", label="Format:",c( "Independent"=1, "Scheduled"=2), selected=2),
              textInput(
                inputId = "examName",
                label = "Exam Name (optional):",
                value=""
              ),
              numericInput(
                inputId = "exams",
                label = "Exams per Term:",
                value=0,
                min=0,
                width='100%'
              ),
              numericInput(
                inputId = "examhours",
                label = "Study Hours per Exam:",
                min=0,
                max=50,
                #step=1,
                value=5,
                width='100%'
              ),
              
              conditionalPanel("input.examformat == 1",
                  hr(),
                  numericInput(inputId="examlength", label="Exam Time Limit (in Hours)",value=1, min=0, max=NA)
              ),

            ) #end of exams panel
          )#end of return
        }#end of exam code
        else if (selected == "quiz"){#start of quiz code
          return( #content to be returned
            wellPanel(     # Quiz panel
              
              # type, Independent or Scheduled
              selectInput(inputId="quizformat", label="Format:",c( "Independent"=1, "Scheduled"=2), selected=1),
              numericInput(
                inputId = "quizzes",
                label = "Quizzes per Term:",
                value=0,
                min=0,
                width='100%'
              ),
              hr(),
              
              conditionalPanel("input.quizformat == 1",
                 numericInput(
                   inputId="quizlength", 
                   label="Quiz Time Limit (in Minutes)",
                   value=15, 
                   min=0, 
                   max=NA)
              ),
              
              conditionalPanel("input.postformat == 2",
              ),
              numericInput(
                inputId = "studyhours",
                label = "Study Hours per Quiz:",
                min=0,
                max=50,
                #step=1,
                value=1,
                width='100%'
              ),

            ) #end of quiz panel
          ) #end of return
        }#end of quiz code
        else if (selected == "lab"){#start of lab code
          return( #content to be returned
            wellPanel(  #Labs panel
              numericInput(
                inputId = "labs",
                label = "Labs per Term:",
                value=0,
                min=0,
                width='100%'
              ),
              sliderInput(
                inputId = "labprep",
                label = "Preparation per Lab (Independent):",
                min=0,
                max=10,
                step=0.25,
                value=0,
                width='100%'
              ),
              sliderInput(
                inputId = "labhours",
                label = "Hours per Lab:",
                min=0,
                max=12,
                step=0.25,
                value=0,
                width='100%'
              ),
              checkboxInput("labsynch", "Scheduled", value=T, width='100%'),
              sliderInput(
                inputId = "postlab",
                label = "Post-lab (Independent):",
                min = 0,
                max=10,
                step=0.25,
                value=0,
                width='100%'
              )
              
            ) #end of labs panel
          )#end of return
        }#end of lab code
        else if (selected == "reading"){#start of reading code
          return( #content to be returned
            wellPanel(# reading panel
              textInput(
                inputId = "readingName",
                label = "Assignment Name (optional):",
                value=""
              ),
              numericInput(
                inputId = "weeklypages",
                label = "Pages per Week:",
                value=0,
                min=0,
                width='100%'
              ),
              hr(),
              
              #Reading difficulty information, see WFU docs for more info
              selectInput(inputId="readingdensity", label="Page Density:",c("450 Words"=1, "600 Words"=2,"750 Words"=3), selected=1),
              
              selectInput(inputId="difficulty", label="Difficulty:",c("No New Concepts"=1,"Some New Concepts"=2,"Many New Concepts"=3), selected=1),
              
              selectInput(inputId="readingpurpose", label="Purpose:",c("Survey"=1,"Understand"=2,"Engage"=3), selected=1),
                
              checkboxInput("setreadingrate", "manually adjust", value=F, width='100%'),
              
                conditionalPanel("input.setreadingrate == true",
                               numericInput(inputId="overridepagesperhour", label="Pages Read per Hour:", value=10, min=0, max=NA)
              ),
        
              #checkboxInput("readsynch", "Scheduled", value=F, width='100%')
            ) #end of reading panel
          )#end of return
        }#end of reading code
        else if (selected == "tutorial"){#start of tutorial code
          return( #content to be returned
            wellPanel(  #Tutorial panel
              numericInput(
                inputId = "tutorials",
                label = "Tutorials per Term:",
                value=0,
                min=0,
                width='100%'
              ),
              sliderInput(
                inputId = "tutprep",
                label = "Preparation per Tutorial (Independent):",
                min=0,
                max=10,
                step=0.25,
                value=0,
                width='100%'
              ),
              sliderInput(
                inputId = "tuthours",
                label = "Hours per Tutorial:",
                min=0,
                max=10,
                step=0.25,
                value=0,
                width='100%'
              ),
              checkboxInput("tutsynch", "Scheduled", value=T, width='100%')
            ) #end of tutorial panel
          )#end of return
        }#end of tutorial code
        else if (selected == "video"){#start of video/podcast code
          return( #content to be returned
            wellPanel( # Video and Audio panel
              textInput(
                inputId = "videoName",
                label = "Video Name (optional):",
                value=""
              ),
              numericInput(
                inputId = "weeklyvideos",
                label = "Hours per Week:",
                value=0,
                min=0,
                width='100%'
              ),
            ) # end of video & audio panel
          )#end of return
        }#end of video/podcast code
        else if (selected == "writing"){ #start of writing code
          return( #content to be returned
            wellPanel( # Writing assignment panel
              selectInput(inputId="writingformat", label="Format:",c( "Independent"=1, "Scheduled"=2), selected=1),
              textInput(
                inputId = "writingName",
                label = "Assignment Name (optional):",
                value=""
              ),
              numericInput(
                inputId = "numassign",
                label = "Number of Assignments:",
                value=0,
                min=0,
                width='100%'
              ),
              hr(),
              conditionalPanel("input.writingformat == 1",
                
                numericInput(
                  inputId = "assignmentpages",
                  label = "Pages per Assignment:",
                  value=0,
                  min=0,
                  width='100%'
                ),
                
                
                #Writing Difficulty Settings, see WFU docs for more info
                selectInput(inputId="writtendensity", label="Page Density:",c("250 Words"=1, "500 Words"=2), selected=1),
                
                selectInput(inputId="writingpurpose", label="Genre:",c("Reflection/Narrative"=1, "Argument"=2, "Research"=3), selected=1),
                
                selectInput(inputId="draftrevise", label="Drafting:",c("No Drafting"=1, "Minimal Drafting"=2, "Extensive Drafting"=3), selected=1),
                
                checkboxInput("setwritingrate", "manually adjust", value=F, width='100%'),
                
                conditionalPanel("input.setwritingrate == true",
                                 numericInput(inputId="overridehoursperwriting", label="Hours per Written Page:", value=.5, min=0.1, max=NA)
                )
                                
              ),
              conditionalPanel("input.writingformat == 2",
                               numericInput(inputId="preptime", label="Preparation Time (Minutes):",value=30, min=0, max=NA)
                               )
              
            ) #end of writing assignment panel
          )#end of return
        }#end of writing code
        else if (selected == "custom"){#start of custom code
          return( #content to be returned
              wellPanel( 
                textInput(
                  inputId = "customName",
                  label = "Assignment Name (optional):",
                  value=""
                ),
                numericInput(
                  inputId = "customnum",
                  label = "Custom Assignments per Term:",
                  value=0,
                  min=0,
                  width='100%'
                ),
                sliderInput(
                  inputId = "custprep",
                  label = "Preparation per Assignment (Independent):",
                  min=0,
                  max=10,
                  step=0.25,
                  value=0,
                  width='100%'
                ),
                sliderInput(
                  inputId = "customhours",
                  label = "Hours per Assignment:",
                  min=0,
                  max=50,
                  step=0.25,
                  value=0,
                  width='100%'
                ), 
                checkboxInput("custsynch", "Scheduled", value=F, width='100%'),
                sliderInput(
                  inputId = "postcust",
                  label = "Post-Assignment (Independent):",
                  min = 0,
                  max=10,
                  step=0.25,
                  value=0,
                  width='100%'
                )
                
              )
          )#end of return
        }#end of custom code
        else{ #should not be reachable but put in for safety.
          return( #content to be returned
            "You have selected something not in the list."
          )#end of return
        }
      } #end of function
      
      #dynamically render the background information for the component based on radio choice
      output$selected_bkgd <- renderUI({
        if (input$radio == "classmeeting"){
          tags$div(
            tags$p("This component tracks the number of hours students are expected to attend meetings (virtual or face-to-face) with the entire class. Typically, this type of meeting is recorded in a student information system as the “primary” meeting of a course, and instructional approaches may vary widely (e.g., lecture, seminar, active learning session of a flipped classroom delivery). The Primary Class Meeting component is synchronous and categorized as scheduled (S)."),
            tags$p("Note that you are able to associate some components (e.g., synchronous discussions and scheduled writing assignments, exams, and quizzes) with the Primary Class Meeting in order to add a preparation time in association with those activities."),
            tags$br(),
            tags$b("Calculations"),
            tags$ul(
              tags$li("The number of hours per week is calculated by first multiplying the number of Meetings per Week by Meeting Length (Hours) and then dividing that product by the number of weeks."),
              tags$li("The number of hours per term is calculated by multiplying the number of Meetings per Week by Meeting Length (Hours).")
            )
            )
        }
        else if(input$radio == "creativepractice"){
          tags$p("This component is focused on Creative Practice Sessions, which include activities that fall within the creative arts. This component can have scheduled and independent activities. When the scheduled box is checked (the default state), the Preparation per Session portion is added to scheduled hours; preparation and post-session inputs are added to independent hours. If the check is removed, all hours are assigned to the independent category and reflected in workload summary accordingly.")
        }
        else if(input$radio == "discussion"){
          tags$div(
            tags$p("This component is focused on discussions, which can be either be held in an asynchronous (typically online) or synchronous (within a live session) manner. Note that there is a pull down that allows you to select the format, and the options will change accordingly. If both a relevant, you can add this component more than once."),
            tags$b("Asynchronous (I)"),
            tags$p("Asynchronous discussions are designed to allow you to set the number of original posts (something a student has to research and post on their own) and the minimum number of replies to other posts. This parameter is challenging to quantify, as typically you expect that students will have to respond to responses on their own post, so you may want to build that into the expectation of numbers. Note that you can set the length parameter for both of these."),
            tags$ul(
              tags$li("By default, the average (Avg.) post length is based on the Reflection/Narrative, Minimal Drafting writing assignment estimate of 250 words per hour."),
              tags$li("By default, the average (Avg.) response length is based on half of a Reflection/Narrative, Minimal Drafting writing assignment estimate of 125 words per half an hour."),
              tags$li("You are able to change these averages using the Avg post length and Avg response length numeric fields.")
            ),
            tags$p("The number of hours will be assigned to the independent category and reflected in workload summary accordingly."),
            tags$b("Synchronous (S)"),
            tags$ul(
              tags$li("The Synchronous Discussion is associated with the Primary Class Meeting component and is designed to allow an instructor to take into account the preparation time required of an in class discussion. "),
              tags$li("The only time that will be added to the total will be a preparation time, classified as independent."),
            ),
            )
          }
        else if (input$radio == "exam"){
          tags$div(
            tags$p("This component is focused on major assessments, which can be either be held in an asynchronous (typically online) or synchronous (within a Primary Class Meeting) manner."),
            tags$p("Note that there is a pull down that allows you to select the format, and the options will change accordingly. If both are relevant, we suggest you add this component twice."),
            tags$b("Scheduled Exam"),
            tags$ul(
              tags$li("The Scheduled Exam is associated with the Primary Class Meeting component and is designed to allow an instructor to take into account the preparation time required to prepare for the exam. "),
              tags$li("The only time that will be added to the total will be a preparation time, classified as independent."),
            ),
            tags$b("Independent Exam"),
            tags$ul(
              tags$li("The Independent Exam is one that is taken at a time of the student’s discretion, usually within a set date and time constraint. Both preparation time and exam time are assigned to the independent category and reflected in workload summary accordingly."),
            )
          )
        }
        else if (input$radio == "lab"){
          tags$div(
            tags$p("This component is focused on the Laboratory portion of courses. Labs can have scheduled and independent activities. When the scheduled box is checked (the default state), the hours per lab portion is added to scheduled hours; preparation and post-lab inputs are added to independent hours. If the check is removed, all hours are assigned to the independent category and reflected in workload summary accordingly."),
            
          )
        }
        else if (input$radio == "quiz"){
          tags$div(
            tags$p("This component is focused on quizzes, which can be either be held in an asynchronous (typically online) or synchronous (within a Primary Class Meeting) manner."),
            tags$p("Note that there is a pull down that allows you to select the format, and the options will change accordingly. If both are relevant, you can add this component more than once."),
            tags$b("Scheduled Quiz"),
            tags$ul(
              tags$li("The Scheduled Quiz is associated with the Primary Class Meeting component and is designed to allow an instructor to take into account the preparation time required to prepare for the quiz."),
              tags$li("The only time that will be added to the total will be a preparation time, classified as independent."),
            ),
            tags$b("Independent Quiz"),
            tags$ul(
              tags$li("The Independent Quiz is one that is taken at a time of the student’s discretion, usually within a set date and time constraint. Both preparation time and quiz time are assigned to the independent category and reflected in workload summary accordingly."),
            )
          )
        }
        else if (input$radio == "reading"){
          tags$div(
            tags$p("This component is focused on independent readings such as assigned textbook readings, readings of short stories, novel excerpts, etc. The hours from this component will be assigned to the independent category and reflected in workload summary accordingly."),
            tags$p("This component allows you to set the number of Pages per Week a student is expected to read, and uses Page Density, Difficulty and Purpose as variables to calculate the length of time."),
            tags$p("The table below shows how the calculations are derived, and has been cited from the work of Barre, Brown, and Esarey (See ", tags$a("Estimation details", href= "https://cte.rice.edu/workload#howcalculated", target="_blank"),"). Note that the rows in the table that are yellow are the ones with the highest level of certainty."),
            tags$br(),
            tags$table(style="border: 1px solid;",
                       tags$tbody(
                         tags$tr(
                           tags$td(style="border: 1px solid; padding: 10px; background-color: #dcdcdc;"), tags$td(style="border: 1px solid; padding: 10px; background-color: #dcdcdc;",tags$b("450 Words (Paperback)")), tags$td(style="border: 1px solid; padding: 10px; background-color: #dcdcdc;",tags$b("600 Words (Monograph)")),tags$td(style="border: 1px solid; padding: 10px; background-color: #dcdcdc;",tags$b("750 Words (Textbook))"))
                         ),
                         tags$tr(
                           tags$td(style="border: 1px solid; padding: 10px; background-color: #ffffcc;",tags$b("Survey; No New Concepts (500 wpm)")), tags$td(style="border: 1px solid; padding: 10px; background-color: #ffffcc;","67 pages per hour"), tags$td(style="border: 1px solid; padding: 10px; background-color: #ffffcc;","50 pages per hour"), tags$td(style="border: 1px solid; padding: 10px; background-color: #ffffcc;","40 pages per hour")
                         ),
                         tags$tr(
                           tags$td(style="border: 1px solid; padding: 10px; background-color: #dcdcdc;",tags$b("Survey; Some New Concepts (350 wpm)")), tags$td(style="border: 1px solid; padding: 10px;","47 pages per hour"), tags$td(style="border: 1px solid; padding: 10px;","35 pages per hour"), tags$td(style="border: 1px solid; padding: 10px;","28 pages per hour")
                         ),
                         tags$tr(
                           tags$td(style="border: 1px solid; padding: 10px; background-color: #dcdcdc;",tags$b("Survey; Many New Concepts (250 wpm)")), tags$td(style="border: 1px solid; padding: 10px;","33 pages per hour"), tags$td(style="border: 1px solid; padding: 10px;","25 pages per hour"), tags$td(style="border: 1px solid; padding: 10px;","20 pages per hour")
                         ),
                         tags$tr(
                           tags$td(style="border: 1px solid; padding: 10px; background-color: #ffffcc;",tags$b("Understand; No New Concepts (250 wpm)")), tags$td(style="border: 1px solid; padding: 10px; background-color: #ffffcc;","33 pages per hour"), tags$td(style="border: 1px solid; padding: 10px; background-color: #ffffcc;","25 pages per hour"), tags$td(style="border: 1px solid; padding: 10px; background-color: #ffffcc;","20 pages per hour")
                         ),
                         tags$tr(
                           tags$td(style="border: 1px solid; padding: 10px; background-color: #ffffcc;",tags$b("Understand; Some New Concepts (180 wpm)")), tags$td(style="border: 1px solid; padding: 10px; background-color: #ffffcc;","24 pages per hour"), tags$td(style="border: 1px solid; padding: 10px; background-color: #ffffcc;","18 pages per hour"), tags$td(style="border: 1px solid; padding: 10px; background-color: #ffffcc;","14 pages per hour")
                         ),
                         tags$tr(
                           tags$td(style="border: 1px solid; padding: 10px; background-color: #dcdcdc;",tags$b("Understand; Many New Concepts (130 wpm)")), tags$td(style="border: 1px solid; padding: 10px;","17 pages per hour"), tags$td(style="border: 1px solid; padding: 10px;","13 pages per hour"), tags$td(style="border: 1px solid; padding: 10px;","10 pages per hour")
                         ),
                         tags$tr(
                           tags$td(style="border: 1px solid; padding: 10px; background-color: #ffffcc;",tags$b("Engage; No New Concepts (130 wpm)")), tags$td(style="border: 1px solid; padding: 10px; background-color: #ffffcc;","17 pages per hour"), tags$td(style="border: 1px solid; padding: 10px; background-color: #ffffcc;","13 pages per hour"), tags$td(style="border: 1px solid; padding: 10px; background-color: #ffffcc;","10 pages per hour")
                         ),
                         tags$tr(
                           tags$td(style="border: 1px solid; padding: 10px; background-color: #dcdcdc;",tags$b("Engage; Some New Concepts (90 wpm)")), tags$td(style="border: 1px solid; padding: 10px;","12 pages per hour"), tags$td(style="border: 1px solid; padding: 10px;","9 pages per hour"), tags$td(style="border: 1px solid; padding: 10px;","7 pages per hour")
                         ),
                         tags$tr(
                           tags$td(style="border: 1px solid; padding: 10px; background-color: #dcdcdc;",tags$b("Engage; Many New Concepts (65 wpm)")), tags$td(style="border: 1px solid; padding: 10px;","9 pages per hour"), tags$td(style="border: 1px solid; padding: 10px;","7 pages per hour"), tags$td(style="border: 1px solid; padding: 10px;","5 pages per hour")
                         )
                       )
            )
          )
        }
        else if (input$radio == "tutorial"){
          tags$div(
            tags$p("This component is focused on the tutorial portion of courses; these sessions are commonly focused on providing students with an opportunity to practice and/or reinforce learning. The Tutorial component has both scheduled and independent components. When the scheduled box is checked (the default state), the hours per tutorial portion is added to scheduled hours; and the preparation time is added to independent hours. If the check is removed, all hours are assigned to the independent category and reflected in workload summary accordingly."),
          )
        }
        else if (input$radio == "video"){
          tags$div(
            tags$p("This component accommodates the time involved in watching or listening to media (e.g., recorded lectures, assigned films). The hours from this component are assigned to the independent category and reflected in workload summary accordingly."),
          )
        }
        else if (input$radio == "writing"){
          tags$div(
            tags$p("This component is focused on writing assignments or activities such as essays, creating short stories, and research papers. A writing assignment may be independent or scheduled (for in-class writing assignments). "),
            tags$p("The in-class writing assignment option allows you to set the number of assignments, but will only add the preparation time component to the time estimate totals. The writing itself will be accommodated in the live class meeting time."),
            tags$p("The independent writing assignment component allows you to set the number of assignments and uses the number of Pages per Assignment, Genre and Drafting as variables to calculate the length of time it will take for that  assignment to be completed."),
            tags$p("The Table below shows how the calculations are derived, and has been cited from the work of Barre, Brown, and Esarey (See ", tags$a("Estimation details", href= "https://cte.rice.edu/workload#howcalculated", target="_blank"),"). Note that the rows in the table that are yellow are the ones with the highest level of certainty."),
            tags$table(style="border: 1px solid;",
                       tags$tbody(
                         tags$tr(
                           tags$td(style="border: 1px solid; padding: 5px; background-color: #dcdcdc;"), tags$td(style="border: 1px solid; padding: 5px; background-color: #dcdcdc;",tags$b("250 Words (Double Spaced)")), tags$td(style="border: 1px solid; padding: 5px; background-color: #dcdcdc;",tags$b("500 Words (Single Spaced)"))
                         ),
                         tags$tr(
                           tags$td(style="border: 1px solid; padding: 5px; background-color: #dcdcdc;",tags$b("Reflection/Narrative; No Drafting")), tags$td(style="border: 1px solid; padding: 5px;","45 minutes per page"), tags$td(style="border: 1px solid; padding: 5px;","1 hour 30 minutes per page")
                         ),
                         tags$tr(
                           tags$td(style="border: 1px solid; padding: 5px; background-color: #dcdcdc;",tags$b("Reflection/Narrative; Minimal Drafting")), tags$td(style="border: 1px solid; padding: 5px;","1 hour per page"), tags$td(style="border: 1px solid; padding: 5px;","2 hours per page")
                         ),
                         tags$tr(
                           tags$td(style="border: 1px solid; padding: 5px; background-color: #dcdcdc;",tags$b("Reflection/Narrative; Extensive Drafting")), tags$td(style="border: 1px solid; padding: 5px;","1 hour 15 minutes per page"), tags$td(style="border: 1px solid; padding: 5px;","2 hours 30 minutes per page")
                         ),
                         tags$tr(
                           tags$td(style="border: 1px solid; padding: 5px; background-color: #ffffcc;",tags$b("Argument; No Drafting")), tags$td(style="border: 1px solid; padding: 5px; background-color: #ffffcc;","1 hour 30 minutes per page"), tags$td(style="border: 1px solid; padding: 5px; background-color: #ffffcc;","3 hours per page")
                         ),
                         tags$tr(
                           tags$td(style="border: 1px solid; padding: 5px; background-color: #dcdcdc;",tags$b("Argument; Minimal Drafting")), tags$td(style="border: 1px solid; padding: 5px;","2 hours per page"), tags$td(style="border: 1px solid; padding: 5px;","4 hours per page")
                         ),
                         tags$tr(
                           tags$td(style="border: 1px solid; padding: 5px; background-color: #ffffcc;",tags$b("Argument; Extensive Drafting")), tags$td(style="border: 1px solid; padding: 5px; background-color: #ffffcc;","2 hour 30 minutes per page"), tags$td(style="border: 1px solid; padding: 5px; background-color: #ffffcc;","5 hours per page")
                         ),
                         tags$tr(
                           tags$td(style="border: 1px solid; padding: 5px; background-color: #dcdcdc;",tags$b("Research; No Drafting")), tags$td(style="border: 1px solid; padding: 5px;","3 hours per page"), tags$td(style="border: 1px solid; padding: 5px;","6 hours per page")
                         ),
                         tags$tr(
                           tags$td(style="border: 1px solid; padding: 5px; background-color: #dcdcdc;",tags$b("Research; Minimal Drafting")), tags$td(style="border: 1px solid; padding: 5px;","4 hours per page"), tags$td(style="border: 1px solid; padding: 5px;","8 hours per page")
                         ),
                         tags$tr(
                           tags$td(style="border: 1px solid; padding: 5px; background-color: #dcdcdc;",tags$b("Research; Extensive Drafting")), tags$td(style="border: 1px solid; padding: 5px;","5 hours per page"), tags$td(style="border: 1px solid; padding: 5px;","10 hours per page")
                         )
                       )
            )
          )
          
        }
        else if (input$radio == "custom"){
          tags$div(
            tags$p("This component may be used for assignments that fall outside of the categories above such as group work, projects, and discipline-specific assignments. The hours in this component can be assigned to either the scheduled or independent categories based on whether the scheduled checkbox is checked. When the scheduled box is checked (the default state), the hours are assigned to the scheduled totals. If the check is removed, all hours are assigned to the independent category and reflected in workload summary accordingly. Note that you may optionally add preparation time (e.g., for group meetings) and post-assignment time (e.g., a reflection)."),
          )
        }else{#should not be reachable but put in for safety.
          "You have selected something not in the list."
        }
      })# end of renderUI background
      
      #reactive variables
      
      #hours per week for output
      hourspw <- reactiveValues(number=0.00)
      #asynchronous or independent hours for output
      asynch <- reactiveValues(number=0.00)
      #synchronous or scheduled hours for output
      synch <- reactiveValues(number=0.00)
      #hours per term for output
      hours <- reactiveValues(number=0)
      
      index <- reactiveValues(idx=0)
  
      #current component being added is new, gets concatenated to old
      currentComp <- reactiveValues(old="", new="")
      
      #These renders are just used for the first time the page is accessed. 
      #All further updates are done in the script.js file
      
      #render workload to UI
      output$workload <- renderUI({
        #this code renders the header row of the table on page load. The table is updated using JS (see script.js)
       wellPanel(
         tags$table(
           tags$tr(style = " background-color: #267bb6; color: white;",
             tags$th(style = "padding: 5px; border: 1px solid black;","Component"),
             tags$th(style = "padding: 5px; border: 1px solid black; ","Name"),
             tags$th(style = "padding: 5px; border: 1px solid black;","hrs/wk (I)"),
             tags$th(style = "padding: 5px; border: 1px solid black;","hrs/wk (S)"),
             tags$th(style = "padding: 5px; border: 1px solid black;","hrs/term (I)"),
             tags$th(style = "padding: 5px; border: 1px solid black","hrs/term (S)"),
             tags$th(style = "padding: 5px; border: 1px solid black;","Delete?")
             
           )
         )
        )
      })
      
      #Asynchronous Hours per week output
      output$estimatedAsynch <- renderText({
        paste("Independent (I):", asynch$number, "hrs/week")
      })
      
      #Synchronous Hours per week output
      output$estimatedSynch <- renderText({
        paste("Scheduled (S):", synch$number, "hrs/week")
      })
      
      #Hours per week output
      output$estimatedworkload <- renderText({
        paste("Total:", hourspw$number, "hrs/week")
      })
      
      #Total Hours output
      output$totalcoursehours <- renderText({
        paste("Total:", hours$number, "hrs/term")
      })
    }
  )