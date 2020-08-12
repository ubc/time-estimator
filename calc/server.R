library(shiny)


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

classweeks <- 1


# Define server logic
shinyServer(
  
  function(input, output){
    
    #Radio button input to update text above second panel
    output$selected_radio <- renderText({
      if(input$radio == "discussion"){
        "Add a Discussion"
      }else if (input$radio == "exam"){
        "Add an Exam"
      }else if (input$radio == "quiz"){
        "Add a Quiz"
      }else if (input$radio == "lecture"){
        "Add a Lecture"
      }else if (input$radio == "lab"){
        "Add a Lab"
      }else if (input$radio == "reading"){
        "Add a Reading Assignment"
      }else if (input$radio == "video"){
        "Add a Video or Podcast"
      }else if (input$radio == "writing"){
        "Add a Writing Assignment"
      }else if (input$radio == "custom"){
        "Add a Custom Assignment"
      }else{#should not be reachable but put in for safety.
        "You have selected something not in the list."
      }
    })
    
    #returns component panel based on radio button choice.
    getComponent <- function(selected){
      if(selected == "discussion"){ #start of discussion code
        return( # content to be returned
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
            
            checkboxInput("discsynch", "Synchronous", value=F, width='100%'),
            
            checkboxInput("setdiscussion", "Manually Adjust", value=F, width='100%'),
            
            conditionalPanel("input.setdiscussion == true",
                             numericInput(inputId="overridediscussion", label="Hours Per Week:", value=1, min=0, max=NA)
            )
          ) #end of discussions panel
        ) #end of return
      } #end of discussion code
      else if (selected == "exam"){ #start of exam code
        return( #content to be returned
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
            
            checkboxInput("examsynch", "Synchronous", value=T, width='100%'),
            
            conditionalPanel("input.examsych == false",
                             numericInput(inputId="exam.length", label="Exam Time Limit (in Minutes)",value=60, min=0, max=NA)
            )
          ) #end of exams panel
        )#end of return
      }#end of exam code
      else if (selected == "quiz"){#start of quiz code
        return( #content to be returned
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
            ),
            checkboxInput("quizsynch", "Synchronous", value=F, width='100%')
          ) #end of quiz panel
        ) #end of return
      }#end of quiz code
      else if (selected == "lecture"){#start of lecture code
        return( #content to be returned
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
            ),
            checkboxInput("lecturesynch", "Synchronous", value=T, width='100%')
          ) # end of Synchronous panel
        ) #end of return
      }#end of lecture code
      else if (selected == "lab"){#start of lab code
        return( #content to be returned
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
              
            ),
            checkboxInput("labsynch", "Synchronous", value=F, width='100%'),
          ) #end of labs panel
        )#end of return
      }#end of lab code
      else if (selected == "reading"){#start of reading code
        return( #content to be returned
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
            ),
            checkboxInput("readsynch", "Synchronous", value=F, width='100%')
          ) #end of reading panel
        )#end of return
      }#end of reading code
      else if (selected == "video"){#start of video/podcast code
        return( #content to be returned
          wellPanel( # Video and Audio panel
            numericInput(
              inputId = "weeklyvideos",
              label = "Hours Per Week:",
              value=0,
              width='100%'
            ),
            checkboxInput("videosynch", "Synchronous", value=F, width='100%'),
          ) # end of video & audio panel
        )#end of return
      }#end of video/podcast code
      else if (selected == "writing"){ #start of writing code
        return( #content to be returned
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
            ),
            checkboxInput("writingsynch", "Synchronous", value=F, width='100%'),
          ) #end of writing assignment panel
        )#end of return
      }#end of writing code
      else if (selected == "custom"){#start of custom code
        return( #content to be returned
          wellPanel(
            h5("Custom Assignment", align = "center"),
            wellPanel( 
              textInput(
                inputId = "customName",
                label = "Assignment Name:",
                value=""
              ),
              numericInput(
                inputId = "customnum",
                label = "# Per Semester:",
                value=0,
                width='100%'
              ),
              sliderInput(
                inputId = "customhours",
                label = "Hours Per Assignment:",
                min=0,
                max=50,
                step=1,
                value=0,
                width='100%'
              ),
              checkboxInput("custsynch", "Synchronous", value=F, width='100%')
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
    
    #dynamically renders output panel from getComponent fuction
    output$selected_panel <- renderUI({
      getComponent(input$radio)
    })
    
    #initially empty
    componentList <- reactiveVal("")
    hours <- reactiveValues(number=0)
    asynch <- reactiveValues(number=0)
    synch <- reactiveValues(number=0)
    typeList <- reactiveVal("")
    
    workloadList <- reactiveVal("")
    currentComp <- reactiveVal("")
    
    
    observeEvent(input$btn,{
      if(input$radio == "discussion"){
        #to be set to synch or asynch
        type <- ""
        #calculate synchronous or asynchronous
        if(input$discsynch == T){
          type <- "(S)"
          synch$number <- isolate(synch$number) + calculateWorkload(input$radio)
          
        }else{
          type <- "(A)"
          asynch$number <- isolate(asynch$number) + calculateWorkload(input$radio)
        }
        currentComp(paste("Discussion ", calculateWorkload(input$radio), "hrs/week ", type))
      }else if (input$radio == "exam"){
        #to be set to synch or asynch
        type <- ""
        #calculate synchronous or asynchronous
        if(input$examsynch == T){
          type <- "(S)"
          synch$number <- isolate(synch$number) + calculateWorkload(input$radio)
          
        }else{
          type <- "(A)"
          asynch$number <- isolate(asynch$number) + calculateWorkload(input$radio)
        }
        currentComp(paste("Exam ", calculateWorkload(input$radio), "hrs/week ", type))
      }else if (input$radio == "quiz"){
        #to be set to synch or asynch
        type <- ""
        #calculate synchronous or asynchronous
        if(input$quizsynch == T){
          type <- "(S)"
          synch$number <- isolate(synch$number) + calculateWorkload(input$radio)
          
        }else{
          type <- "(A)"
          asynch$number <- isolate(asynch$number) + calculateWorkload(input$radio)
        }
        currentComp(paste("Quiz ", calculateWorkload(input$radio), "hrs/week ", type))
      }else if (input$radio == "lecture"){
        #to be set to synch or asynch
        type <- ""
        #calculate synchronous or asynchronous
        if(input$lecturesynch == T){
          type <- "(S)"
          synch$number <- isolate(synch$number) + calculateWorkload(input$radio)
          
        }else{
          type <- "(A)"
          asynch$number <- isolate(asynch$number) + calculateWorkload(input$radio)
        }
        currentComp(paste("Lecture ", calculateWorkload(input$radio), "hrs/week", type))
      }else if (input$radio == "lab"){
        #to be set to synch or asynch
        type <- ""
        #calculate synchronous or asynchronous
        if(input$labsynch == T){
          type <- "(S)"
          synch$number <- isolate(synch$number) + calculateWorkload(input$radio)
          
        }else{
          type <- "(A)"
          asynch$number <- isolate(asynch$number) + calculateWorkload(input$radio)
        }
        currentComp(paste("Lab ", calculateWorkload(input$radio), "hrs/week", type))
      }else if (input$radio == "reading"){
        #to be set to synch or asynch
        type <- ""
        #calculate synchronous or asynchronous
        if(input$readsynch == T){
          type <- "(S)"
          synch$number <- isolate(synch$number) + calculateWorkload(input$radio)
          
        }else{
          type <- "(A)"
          asynch$number <- isolate(asynch$number) + calculateWorkload(input$radio)
        }
        currentComp(paste("Reading Assignment ", calculateWorkload(input$radio), "hrs/week", type))
      }else if (input$radio == "video"){
        #to be set to synch or asynch
        type <- ""
        #calculate synchronous or asynchronous
        if(input$videosynch == T){
          type <- "(S)"
          synch$number <- isolate(synch$number) + calculateWorkload(input$radio)
          
        }else{
          type <- "(A)"
          asynch$number <- isolate(asynch$number) + calculateWorkload(input$radio)
        }
        currentComp(paste("Video/Podcast ", calculateWorkload(input$radio), "hrs/week", type))
      }else if (input$radio == "writing"){
        #to be set to synch or asynch
        type <- ""
        #calculate synchronous or asynchronous
        if(input$writingsynch == T){
          type <- "(S)"
          synch$number <- isolate(synch$number) + calculateWorkload(input$radio)
          
        }else{
          type <- "(A)"
          asynch$number <- isolate(asynch$number) + calculateWorkload(input$radio)
        }
        currentComp(paste("Writing Assingment ", calculateWorkload(input$radio), "hrs/week", type))
      }else if (input$radio == "custom"){
        #to be set to synch or asynch
        type <- ""
        #calculate synchronous or asynchronous
        if(input$custsynch == T){
          type <- "(S)"
          synch$number <- isolate(synch$number) + calculateWorkload(input$radio)
          
        }else{
          type <- "(A)"
          asynch$number <- isolate(asynch$number) + calculateWorkload(input$radio)
        }
        currentComp(paste(input$customName, calculateWorkload(input$radio), "hrs/week", type))
      }else{#should not be reachable but put in for safety.
        print("There is something wrong here...")
      }
      
      hours$number <- isolate(hours$number) + calculateWorkload(input$radio)
      print(calculateWorkload(input$radio))
      print(hours$total)
      workloadList(paste(workloadList(),currentComp(), sep="\n"))
      
      
    })
    
    
    #output$components <- renderText({
    # componentList()
    #})
    
    #output$hours <- renderText({
    # hourList()
    #})
    
    
    output$workload <- renderText({
      workloadList()
    })
    
    #Hours per week output
    output$estimatedworkload <- renderText({
      paste("Total: ", hours$number, "hrs/week")
    })
    
    #Asynchronous Hours per week output
    output$estimatedAsynch <- renderText({
      paste("Independent, Asynchronous (A): ", asynch$number, "hrs/week")
    })
    
    #Synchronous Hours per week output
    output$estimatedSynch <- renderText({
      paste("Scheduled, Synchronous (S): ", synch$number, "hrs/week")
    })
    
    
    
    #Returns number of hours per week for each component based on radio selection
    calculateWorkload <- function(selected){
      if(selected == "discussion"){
        if(input$setdiscussion==F){
          if(input$postformat==1){ # text estimate
            posthours.sel <- ((as.numeric(input$postlength.text)*as.numeric(input$postsperweek))/250)
          }
          if(input$postformat==2){ # audio/video estimate
            posthours.sel <- 0.18*((as.numeric(input$postlength.av)*as.numeric(input$postsperweek)))+((as.numeric(input$postlength.av)*as.numeric(input$postsperweek))/6)
          }}else{
            posthours.sel <- input$overridediscussion
          }
        
        expr = round((as.numeric(posthours.sel)),digits=2)
        return(expr)
        
      }else if (selected == "exam"){
        expr = round(((as.numeric(input$exams)*as.numeric(input$examhours)) / as.numeric(classweeks)), digits=2)
        return(expr)
        
      }else if (selected == "quiz"){
        expr = round(((as.numeric(input$quizzes)*as.numeric(input$quizhours)) / as.numeric(classweeks)), digits=2)
        return(expr)
        
      }else if (selected == "lecture"){
        expr = round((as.numeric(input$syncsessions) * as.numeric(input$synclength)), digits=2)
        return(expr)
        
      }else if (selected == "lab"){
        expr = round((as.numeric(input$labs))*((as.numeric(input$labhours))+(as.numeric(input$labprep))) / as.numeric(classweeks), digits=2)
        return(expr)
        
      }else if (selected == "reading"){
        # set reading rate in pages per hour
        # if user has not opted to manually input a value...
        if(input$setreadingrate==F){
          # use the values in the pagesperhour array above to select a reading rate
          pagesperhour.sel <- pagesperhour[as.numeric(input$difficulty), as.numeric(input$readingpurpose), as.numeric(input$readingdensity)]
        }else{
          # if user selects manual override, use the manually input value
          pagesperhour.sel <- input$overridepagesperhour
        }
        expr = round((as.numeric(input$weeklypages)/as.numeric(pagesperhour.sel)), digits=2)
        return(expr)
        
      }else if (selected == "video"){
        expr = round(as.numeric(input$weeklyvideos), digits=2)
        return(expr)
        
      }else if (selected == "writing"){
        # set writing rate in hours per page
        # if user has not opted to manually input a value...
        if(input$setwritingrate==F){
          # use the values in the hoursperwriting array above to select a writing rate
          hoursperwriting.sel <- hoursperwriting[as.numeric(input$writtendensity), as.numeric(input$draftrevise), as.numeric(input$writingpurpose)]
        }else{
          # if user selects manual override, use the manually input value
          hoursperwriting.sel <- input$overridehoursperwriting 
        }
        expr = round(((as.numeric(hoursperwriting.sel)*as.numeric(input$semesterpages)) / as.numeric(classweeks)), digits=2)
        return(expr)
        
      }else if (selected == "custom"){
        expr = round((as.numeric(input$customnum)*as.numeric(input$customhours)/as.numeric(classweeks)), digits=2)
        return(expr)
      }else{#should not be reachable but put in for safety.
        return("You have selected something not in the list.")
      }
    }
    
    #dynamically render the background information based on radio choice
    output$selected_bkgd <- renderUI({
      if(input$radio == "discussion"){
        "Discussion background info"
      }else if (input$radio == "exam"){
        "Exam background info"
      }else if (input$radio == "quiz"){
        "Quiz background info"
      }else if (input$radio == "lecture"){
        "Lecture background info"
      }else if (input$radio == "lab"){
        "Lab background info"
      }else if (input$radio == "reading"){
        tags$div(
          p("Estimates based on Barre, Brown, and Esarey. See ", a(href="https://cat.wfu.edu/resources/tools/estimator2details/","estimation details"), "for more information."),        
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
      }else if (input$radio == "video"){
        "Video/Podcast background info"
      }else if (input$radio == "writing"){
        tags$div(
          p("Estimates based on Barre, Brown, and Esarey. See ", a(href="https://cat.wfu.edu/resources/tools/estimator2details/","estimation details"), "for more information."),        
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
        
      }else if (input$radio == "custom"){
        "Custom Assignment background info"
      }else{#should not be reachable but put in for safety.
        "You have selected something not in the list."
      }
    })
    
    
  }
  
)