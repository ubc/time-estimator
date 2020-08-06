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


# Define server logic
shinyServer(
  
    function(input, output){
      
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
      
      #dynamically render one of the panels based on radio choice
      output$selected_panel <- renderUI({
        if(input$radio == "discussion"){ #start of discussion code
          h4("Add a Discussion", align="center")
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
        } #end of discussion code
        else if (input$radio == "exam"){ #start of exam code
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
        }#end of exam code
        else if (input$radio == "quiz"){#start of quiz code
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
        }#end of quiz code
        else if (input$radio == "lecture"){#start of lecture code
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
        }#end of lecture code
        else if (input$radio == "lab"){#start of lab code
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
        }#end of lab code
        else if (input$radio == "reading"){#start of reading code
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
        }#end of reading code
        else if (input$radio == "video"){#start of video/podcast code
          wellPanel( # Video and Audio panel
            
            numericInput(
              inputId = "weeklyvideos",
              label = "Hours Per Week:",
              value=0,
              width='100%'
            )
          ) # end of video & audio panel
        }#end of video/podcast code
        else if (input$radio == "writing"){ #start of writing code
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
        }#end of writing code
        else if (input$radio == "custom"){#start of custom code
          wellPanel(
            h5("Custom Assignment", align = "center"),
            wellPanel( 
              textInput(
                inputId = "customName",
                label = "Assignment Name:",
                value="",
              ),
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
              checkboxInput("other.engage", "Synchronous", value=F, width='100%')
            )
          )
        }#end of custom code
        else{ #should not be reachable but put in for safety.
          "You have selected something not in the list."
        }
      }) #end of output selected panel
      
      
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
          tags$div(style="margin:10px",
            h4("Reading Rates"), tags$br(),
          p("Of all the work students might do outside of class, we know the most about their reading. Educators, cognitive psychologists, and linguists have been studying how 
          human beings read for more than a century. One of the best summaries of this extensive literature is the the late Keith Rayner's recently published \"So Much to Read, 
          So Little Time: How Do We Read, and Can Speed Reading Help?\" A central insight of this piece (along with the literature it summarizes) is that none of us read at a 
          constant rate. Instead, we use varying rates that depend on the difficulty and purpose of the reading task (Rayner et al., 2016; Love, 2012; Aronson, 1983; Carver, 
          1983, 1992; Jay and Dahl, 1975; Parker, 1962; Carrillo and Sheldon, 1952; Robinson, 1941). Another obvious (but rarely acknowledged) insight is that a page-based 
          reading rate is going to vary by the number of words on the page. As a result, our estimator assumes that reading rate will be a function of three factors: 1) page 
          density, 2) text difficulty, and 3) reading purpose. For the sake of simplicity, we limited the variation within each factor to three levels.
          "),
            tags$br(),
            tags$b("Page Density*"),
            tags$br(),

          p("450 words: Typical of paperback pages, as well as the 6\" x 9\" pages of academic journal articles
          600 words: Typical of academic monograph pages
          750 words: Typical of textbook pages that are 25% images, as well as the full-size pages of two-column academic journal articles 
          *estimates were determined by direct sampling of texts in our personal collection
          "),
          tags$br(),
          tags$b("Text Difficulty"),
          tags$br(),
          tags$ul(
          tags$li("No New Concepts: The reader knows the meaning of each word and has enough background knowledge to immediately understand the ideas expressed"),
          tags$li("Some New Concepts: The reader is unfamiliar with the meaning of some words and doesn't have enough background knowledge to immediately understand some of the ideas expressed."),
          tags$li("Many New Concepts: The reader is unfamiliar with the meaning of many words and doesn't have enough background knowledge to immediately understand most of the ideas expressed"),
          ),
          tags$br(),
          tags$b("Reading Purpose"),
          tags$br(),
          tags$ul(
          tags$li("Survey: Reading to survey main ideas; OK to skip entire portions of text"),
          tags$li("Understand:  Reading to understand the meaning of each sentence"),
          tags$li("Engage:  Reading while also working problems, drawing inferences, questioning, and evaluating")
          ),
          p("What we know from the research:"),
          tags$ul(
            tags$li("The optimal reading rate of the skilled adult reader (including college students) is around 300 words per minute. This assumes a \"normal\" reading environment in which there are no new words or concepts in the text and the purpose of the reading is to understand the meaning of each sentence (Rayner et al., 2016; Carver, 1982). "),
            tags$li("Adults can read faster than 300 words per minute, but if the goal is to understand the meaning of sentences, rates beyond 300 words per minute reduce comprehension in a near linear fashion (Zacks and Treiman, 2016; Love, 2012; Carver, 1982)."),
            tags$li("The default reading rates of college students under these normal conditions can range from 100-400 words per minute (Rayner et al., 2016; Siegenthaler et al., 2011; Acheson et al., 2008; Carver, 1982, 1983, 1992; Underwood et al., 1990; Hausfeld, 1981; Just and Carpenter, 1980; Jay and Dahl, 1975; Grob, 1970; McLaughlin, 1969; Robinson and Hall, 1941)."),
            tags$li("There is no real upper limit on skimming speeds, but the average college student skims for main ideas at rates between 450 and 600 words per minute (Rayner et al., 2016; Carver 1992; Just and Carpenter, 1980; Jay and Dahl, 1975)"),
            tags$li("In conditions where the material is more difficult (i.e., with some new words and concepts), the optimal reading rate slows to 200 words per minute (Carver, 1992)."),
            tags$li("In conditions where the purpose is to memorize the text for later recall, the optimal reading rate slows even further to 138 words per minute or lower (Carver, 1992)."),
            tags$li("Although this has not been measured (to our knowledge), reading experts have argued that it is perfectly reasonable to slow down to rates below 50 words per minute if the goal is to engage a text (Parker, 1962). "),
          ),
          p("What we don't know, but deduce and/or stipulate:"),
          tags$ul(
            tags$li("Given that the rates above were discovered in laboratory conditions, when subjects are asked to perform in short, time-constrained intervals, we assume that the reading rates in actual conditions, when students read for longer periods with periodic breaks, will be slightly slower."),
            tags$li("Because there is no research on the time it takes students to engage texts, we assume that the rates would be similar to the rates found when students are asked to memorize a text for later recall. Although these are incredibly different tasks, both require attention to details alongside additional processing. If anything, we imagine equating these two rates significantly underestimates the time it takes to read for engagement (for an example of the sort of reading that is likely to take more time than it takes to memorize, see the", 
                  tags$a(href="http://socrates.berkeley.edu/~jcampbel/documents/ReadingPhilosophy_4.pdf", target="_blank", "appendix"), " of Perry et al., 2015)."),
            tags$li("If the reading purpose remains the same, the change in reading rates across text difficulty levels is linear."),
            tags$li("The rate of change in reading rates across text difficulty levels is the same across reading purposes."),
          ),
          p("Combining what we know with what we assume allows us to construct the following table of estimated reading rates (with rates about which we are most confident in yellow):"),
          tags$table(style="border: 1px solid;",
            tags$tbody(
              tags$tr(
                tags$td(style="border: 1px solid;"), tags$td(style="border: 1px solid;",tags$b("450 Words (Paperback)")), tags$td(style="border: 1px solid;",tags$b("600 Words (Monograph)")),tags$td(style="border: 1px solid;",tags$b("750 Words (Textbook))"))
              ),
              tags$tr(
                tags$td(style="border: 1px solid;",tags$b("Survey; No New Concepts (500 wpm)")), tags$td(style="border: 1px solid;","67 pages per hour"), tags$td(style="border: 1px solid;","50 pages per hour"), tags$td(style="border: 1px solid;","40 pages per hour")
              ),
              tags$tr(
                tags$td(style="border: 1px solid;",tags$b("Survey; Some New Concepts (350 wpm)")), tags$td(style="border: 1px solid;","47 pages per hour"), tags$td(style="border: 1px solid;","35 pages per hour"), tags$td(style="border: 1px solid;","28 pages per hour")
              ),
              tags$tr(
                tags$td(style="border: 1px solid;",tags$b("Survey; Many New Concepts (250 wpm)")), tags$td(style="border: 1px solid;","33 pages per hour"), tags$td(style="border: 1px solid;","25 pages per hour"), tags$td(style="border: 1px solid;","20 pages per hour")
              ),
              tags$tr(
                tags$td(style="border: 1px solid;",tags$b("Understand; No New Concepts (250 wpm)")), tags$td(style="border: 1px solid;","33 pages per hour"), tags$td(style="border: 1px solid;","25 pages per hour"), tags$td(style="border: 1px solid;","20 pages per hour")
              ),
              tags$tr(
                tags$td(style="border: 1px solid;",tags$b("Understand; Some New Concepts (180 wpm)")), tags$td(style="border: 1px solid;","24 pages per hour"), tags$td(style="border: 1px solid;","18 pages per hour"), tags$td(style="border: 1px solid;","14 pages per hour")
              ),
              tags$tr(
                tags$td(style="border: 1px solid;",tags$b("Understand; Many New Concepts (130 wpm)")), tags$td(style="border: 1px solid;","17 pages per hour"), tags$td(style="border: 1px solid;","13 pages per hour"), tags$td(style="border: 1px solid;","10 pages per hour")
              ),
              tags$tr(
                tags$td(style="border: 1px solid;",tags$b("Engage; No New Concepts (130 wpm)")), tags$td(style="border: 1px solid;","17 pages per hour"), tags$td(style="border: 1px solid;","13 pages per hour"), tags$td(style="border: 1px solid;","10 pages per hour")
              ),
              tags$tr(
                tags$td(style="border: 1px solid;",tags$b("Engage; Some New Concepts (90 wpm)")), tags$td(style="border: 1px solid;","12 pages per hour"), tags$td(style="border: 1px solid;","9 pages per hour"), tags$td(style="border: 1px solid;","7 pages per hour")
              ),
              tags$tr(
                tags$td(style="border: 1px solid;",tags$b("Engage; Many New Concepts (65 wpm)")), tags$td(style="border: 1px solid;","9 pages per hour"), tags$td(style="border: 1px solid;","7 pages per hour"), tags$td(style="border: 1px solid;","5 pages per hour")
              ),
            )
          )
          
          )
        }else if (input$radio == "video"){
          "Video/Podcast background info"
        }else if (input$radio == "writing"){
          tags$div(
            h4("Writing Rates"),
          p("Sadly, we know much less about student writing rates than we do about reading rates. This is no doubt because writing rates vary even more widely than reading rates. Nevertheless, we've found at least one study that can give us a place to begin. In \"", a(href="https://link.springer.com/article/10.1023/A:1003990432398","Individual Differences in Undergraduate Essay-Writing Strategies"),",\" Mark Torrance and his colleagues find (among other things) that 493 students reported spending anywhere between 9 to 15 hours on 1500-word essays. In these essays, students were asked to produce a \"critical description and discussion of psychological themes\" using at least one outside source. Torrance and his colleagues also show that students who spent the least time reported no drafting, while those who spent the most time reported multiple drafts, along with detailed outlining and planning. And the students who spent the most time received higher marks than those who spent the least (Torrance et al., 2000)."),
          tags$br(),
          p("Although the sample of this study is sizable, we should not read too much into a single result of student self-reports about a single assignment from a single institution.  But to arrive at our estimates, we must. Users should simply be aware that the table below is far more speculative than our reading rate estimates. And that the time your students spend on these tasks is likely to vary from these estimates in significant ways."),
          tags$br(),
          p("As with reading rates, we assume that writing rates will be a function of a variety of factors. The three we take into account are 1) page density, 2) text genre, 3) degree of drafting and revision."),
          tags$br(),
          tags$b("Page Density"),
          tags$ul(
            tags$li("250 words: Double-Spaced, Times New Roman, 12-Point Font, 1\" Margins"),
            tags$li("500 words: Single-Spaced, Times New Roman, 12-Point Font, 1\" Margins")
          ),
          tags$br(),
          tags$b("Text Genre"),
          tags$ul(
            tags$li("Reflection/Narrative: Essays that require very little planning or critical engagement with content  "),
            tags$li("Argument: Essays that require critical engagement with content and detailed planning, but no outside research"),
            tags$li("Research: Essays that require detailed planning, outside research, and crtical engagement")
          ),
          tags$br(),
          tags$b("Drafting and Revision"),
          tags$ul(
            tags$li("No Drafting: Students submit essays that were never revised"),
            tags$li("Minimal Drafting: Students submit essays that were revised at least once"),
            tags$li("Extensive Drafting: Students submit essays that were revised multiple times")
          ),
          tags$br(),
          p("What we assume to arrive at our estimates:"),
          tags$ul(
            tags$li("The results of the Torrance study are reasonably accurate."),
            tags$li("The assignment in the study falls within the \"argument\" genre. It's hard to tell without more details, but \"critical description and discussion\" seems to imply more than reflection. And while an outside source was required, finding and using a single source falls well below the expectations of a traditional research paper."),
            tags$li("Students write at a constant rate. That is, we assume that a student writing the same sort of essay will take exactly twice as much time to write a 12 page paper as she takes to write a 6 page paper. There are good reasons to think this assumption is unrealistic, but because we have no way of knowing how much rate might shift over the course of a paper, we assume constancy."),
            tags$li("Students will spend less time writing a reflective or narrative essay than they spend constructing an argumentative essay (assuming the same degree of drafting and revision). For simplicity's sake, we assume they will spend exactly half the time. It's highly unlikely to be this linear, but we don't know enough to make a more accurate assumption."),
            tags$li("Students will spend more time writing a research paper than they spend on their argumentative essays. Again, for simplicity's sake, we assume they will spend exactly twice the amount of time. It's not only unlikely to be this linear, it's also likely to vary greatly by the amount of outside reading a student does and the difficulty of the sources he or she tackles.")
          ),
          tags$br(),
          p("These assumptions allow us to construct the following table of estimated writing rates (with rates about which we are most confident in yellow):"),
          tags$table(style="border: 1px solid;",
            tags$tbody(
              tags$tr(
                tags$td(style="border: 1px solid;"), tags$td(style="border: 1px solid;",tags$b("250 Words (Double Spaced)")), tags$td(style="border: 1px solid;",tags$b("500 Words (Single Spaced)"))
              ),
              tags$tr(
                tags$td(style="border: 1px solid;",tags$b("Reflection/Narrative; No Drafting")), tags$td(style="border: 1px solid;","45 minutes per page"), tags$td(style="border: 1px solid;","1 hour 30 minutes per page")
              ),
              tags$tr(
                tags$td(style="border: 1px solid;",tags$b("Reflection/Narrative; Minimal Drafting")), tags$td(style="border: 1px solid;","1 hour per page"), tags$td(style="border: 1px solid;","2 hours per page")
                ),
              tags$tr(
                tags$td(style="border: 1px solid;",tags$b("Reflection/Narrative; Extensive Drafting")), tags$td(style="border: 1px solid;","1 hour 15 minutes per page"), tags$td(style="border: 1px solid;","2 hours 30 minutes per page")
                ),
              tags$tr(
                tags$td(style="border: 1px solid;",tags$b("Arguement; No Drafting")), tags$td(style="border: 1px solid;","1 hour 30 minutes per page"), tags$td(style="border: 1px solid;","3 hours per page")
              ),
              tags$tr(
                tags$td(style="border: 1px solid;",tags$b("Arguement; Minimal Drafting")), tags$td(style="border: 1px solid;","2 hours per page"), tags$td(style="border: 1px solid;","4 hours per page")
              ),
              tags$tr(
                tags$td(style="border: 1px solid;",tags$b("Arguement; Extensive Drafting")), tags$td(style="border: 1px solid;","2 hour 30 minutes per page"), tags$td(style="border: 1px solid;","5 hours per page")
              ),
              tags$tr(
                tags$td(style="border: 1px solid;",tags$b("Research; No Drafting")), tags$td(style="border: 1px solid;","3 hours per page"), tags$td(style="border: 1px solid;","6 hours per page")
              ),
              tags$tr(
                tags$td(style="border: 1px solid;",tags$b("Research; Minimal Drafting")), tags$td(style="border: 1px solid;","4 hours per page"), tags$td(style="border: 1px solid;","8 hours per page")
              ),
              tags$tr(
                tags$td(style="border: 1px solid;",tags$b("Research; Extensive Drafting")), tags$td(style="border: 1px solid;","5 hours per page"), tags$td(style="border: 1px solid;","10 hours per page")
              ),
            )
          )
          )
          
        }else if (input$radio == "custom"){
          "Custom Assignment background info"
        }else{#should not be reachable but put in for safety.
          "You have selected something not in the list."
        }
      })
      
    # calculate the total estimated workload in hours per week
    output$estimatedworkload <- renderText({
      
      # set reading rate in pages per hour
      # if user has not opted to manually input a value...
      if(input$setreadingrate==F){
        # use the values in the pagesperhour array above to select a reading rate
        pagesperhour.sel <- pagesperhour[as.numeric(input$difficulty), as.numeric(input$readingpurpose), as.numeric(input$readingdensity)]
      }else{
        # if user selects manual override, use the manually input value
        pagesperhour.sel <- input$overridepagesperhour
      }
      
      # set writing rate in hours per page
      # if user has not opted to manually input a value...
      if(input$setwritingrate==F){
        # use the values in the hoursperwriting array above to select a writing rate
        hoursperwriting.sel <- hoursperwriting[as.numeric(input$writtendensity), as.numeric(input$draftrevise), as.numeric(input$writingpurpose)]
      }else{
        # if user selects manual override, use the manually input value
        hoursperwriting.sel <- input$overridehoursperwriting 
      }
      
      # determine correct value to use for discussion post hours
      if(input$setdiscussion==F){
        if(input$postformat==1){ # text estimate
          posthours.sel <- ((as.numeric(input$postlength.text)*as.numeric(input$postsperweek))/250)
        }
        if(input$postformat==2){ # audio/video estimate
          posthours.sel <- 0.18*((as.numeric(input$postlength.av)*as.numeric(input$postsperweek)))+((as.numeric(input$postlength.av)*as.numeric(input$postsperweek))/6)
        }}else{
          posthours.sel <- input$overridediscussion
        }
      
      # determine if quiz time needs to be added
      if(input$quiztimed==T){
        quiztimed.sel <- as.numeric(input$quiz.length)
      }else{quiztimed.sel <- 0}
      
      # determine if exam time needs to be added
      if(input$takehome==T){
        takehome.sel <- as.numeric(input$exam.length)
      }else{takehome.sel <- 0}
      
      # calculate hours spent working using inputted values from UI
      expr = paste("Total: ", round(
                    (as.numeric(input$weeklypages)/as.numeric(pagesperhour.sel)) + 
                    ( (as.numeric(hoursperwriting.sel)*as.numeric(input$semesterpages)) / as.numeric(input$classweeks) ) +
                    ( (as.numeric(input$labs))*((as.numeric(input$labhours))+(as.numeric(input$labprep))) / as.numeric(input$classweeks)) +
                    ( (as.numeric(input$quizzes)*as.numeric(input$quizhours)) / as.numeric(input$classweeks)) +
                    ( (as.numeric(input$exams)*as.numeric(input$examhours)) / as.numeric(input$classweeks)) +
                    ( (as.numeric(input$projects)*as.numeric(input$projhours)) / as.numeric(input$classweeks) ) +
                    ( (as.numeric(input$otherassign)*as.numeric(input$otherhours)) / as.numeric(input$classweeks) ) +
                      (as.numeric(posthours.sel) ) +
                      (as.numeric(input$weeklyvideos) ) +
                    ( (as.numeric(quiztimed.sel) / 60 ) * as.numeric(input$quizzes) / as.numeric(input$classweeks) ) +
                    ( (as.numeric(takehome.sel) / 60 ) * as.numeric(input$exams) / as.numeric(input$classweeks) ) +
                    ( (as.numeric(input$syncsessions) * as.numeric(input$synclength)) ), 
                  digits=2),"hrs/wk")
      
    })
    
    # calculate the out-of-class/independent workload in hours per week
    output$estimatedoutofclass<- renderText({
      
      # set reading rate in pages per hour
      # if user has not opted to manually input a value...
      if(input$setreadingrate==F){
        # use the values in the pagesperhour array above to select a reading rate
        pagesperhour.sel <- pagesperhour[as.numeric(input$difficulty), as.numeric(input$readingpurpose), as.numeric(input$readingdensity)]
      }else{
        # if user selects manual override, use the manually input value
        pagesperhour.sel <- input$overridepagesperhour
      }
      
      # set writing rate in hours per page
      # if user has not opted to manually input a value...
      if(input$setwritingrate==F){
        # use the values in the hoursperwriting array above to select a writing rate
        hoursperwriting.sel <- hoursperwriting[as.numeric(input$writtendensity), as.numeric(input$draftrevise), as.numeric(input$writingpurpose)]
      }else{
        # if user selects manual override, use the manually input value
        hoursperwriting.sel <- input$overridehoursperwriting 
      }
      
      # determine correct value to use for discussion post hours
      if(input$setdiscussion==F){
        if(input$postformat==1){ # text estimate
          posthours.sel <- ((as.numeric(input$postlength.text)*as.numeric(input$postsperweek))/250)
        }
        if(input$postformat==2){ # audio/video estimate
          posthours.sel <- ((as.numeric(input$postlength.av)*as.numeric(input$postsperweek))/3)
        }}else{
          posthours.sel <- input$overridediscussion
        }
      
      # determine if quiz time needs to be added
      if(input$quiztimed==T){
        quiztimed.sel <- as.numeric(input$quiz.length)
      }else{quiztimed.sel <- 0}
      
      
      # determine if exam time needs to be added
      if(input$takehome==T){
        takehome.sel <- as.numeric(input$exam.length)
      }else{takehome.sel <- 0}
      
      # should we include other assignments?
      if(input$other.engage==F){
        other.sel <- as.numeric(input$otherassign) * (input$otherhours)
      }else{other.sel <- 0}
      
      # calculate hours spent working out of class per week using inputted values from UI
      expr = paste("Independent: ", round(
        
        (as.numeric(input$weeklypages)/as.numeric(pagesperhour.sel)) + 
          ( (as.numeric(hoursperwriting.sel)*as.numeric(input$semesterpages)) / as.numeric(input$classweeks) ) +
          ( (as.numeric(input$labs))*(as.numeric(input$labprep)) / as.numeric(input$classweeks)) +
          ( (as.numeric(input$projects)*as.numeric(input$projhours)) / as.numeric(input$classweeks) ) +
          ( (as.numeric(input$quizzes)*as.numeric(input$quizhours)) / as.numeric(input$classweeks)) +
          ( (as.numeric(input$exams)*as.numeric(input$examhours)) / as.numeric(input$classweeks)) +
          (as.numeric(posthours.sel) ) +
          (as.numeric(input$weeklyvideos) ) +
          (as.numeric(other.sel))/(as.numeric(input$classweeks)) +
          ( (as.numeric(quiztimed.sel) / 60 ) * as.numeric(input$quizzes) / as.numeric(input$classweeks) ) +
          ( (as.numeric(takehome.sel) / 60 ) * as.numeric(input$exams) / as.numeric(input$classweeks) ),
        
        digits=2),"hrs/wk")
      
    })
    

    # calculate engagement time in hours per week
    output$estimatedengaged <- renderText({
      
      # should we include other assignments?
      if(input$other.engage==T){
        other.sel <- as.numeric(input$otherassign) * (input$otherhours)
      }else{other.sel <- 0}
      
      # determine correct value to use for discussion post hours
      if(input$setdiscussion==F){
        if(input$postformat==1){ # text estimate
          posthours.sel <- ((as.numeric(input$postlength.text)*as.numeric(input$postsperweek))/250)
        }
        if(input$postformat==2){ # audio/video estimate
          posthours.sel <- ((as.numeric(input$postlength.av)*as.numeric(input$postsperweek))/3)
        }}else{
          posthours.sel <- input$overridediscussion
        }
      
      # calculate hours engaged w/ instructor using inputted values from UI
      expr = paste("Contact: ", round(
        
          #(as.numeric(posthours.sel) ) +
          ( (as.numeric(input$syncsessions) * as.numeric(input$synclength)) ) +
          ( (as.numeric(input$labs))*(as.numeric(input$labhours)) / as.numeric(input$classweeks)) +
          (as.numeric(other.sel))/(as.numeric(input$classweeks)),
        
        digits=2),"hrs/wk")
      
    })
    
    # calculate the total estimated workload in hours per week
    output$totalcoursehours <- renderText({
      
      # set reading rate in pages per hour
      # if user has not opted to manually input a value...
      if(input$setreadingrate==F){
        # use the values in the pagesperhour array above to select a reading rate
        pagesperhour.sel <- pagesperhour[as.numeric(input$difficulty), as.numeric(input$readingpurpose), as.numeric(input$readingdensity)]
      }else{
        # if user selects manual override, use the manually input value
        pagesperhour.sel <- input$overridepagesperhour
      }
      
      # set writing rate in hours per page
      # if user has not opted to manually input a value...
      if(input$setwritingrate==F){
        # use the values in the hoursperwriting array above to select a writing rate
        hoursperwriting.sel <- hoursperwriting[as.numeric(input$writtendensity), as.numeric(input$draftrevise), as.numeric(input$writingpurpose)]
      }else{
        # if user selects manual override, use the manually input value
        hoursperwriting.sel <- input$overridehoursperwriting 
      }
      
      # determine correct value to use for discussion post hours
      if(input$setdiscussion==F){
        if(input$postformat==1){ # text estimate
          posthours.sel <- ((as.numeric(input$postlength.text)*as.numeric(input$postsperweek))/250)
        }
        if(input$postformat==2){ # audio/video estimate
          posthours.sel <- 0.18*((as.numeric(input$postlength.av)*as.numeric(input$postsperweek)))+((as.numeric(input$postlength.av)*as.numeric(input$postsperweek))/6)
        }}else{
          posthours.sel <- input$overridediscussion
        }
      
      # determine if quiz time needs to be added
      if(input$quiztimed==T){
        quiztimed.sel <- as.numeric(input$quiz.length)
      }else{quiztimed.sel <- 0}
      
      # determine if exam time needs to be added
      if(input$takehome==T){
        takehome.sel <- as.numeric(input$exam.length)
      }else{takehome.sel <- 0}
      
      # calculate hours spent working using inputted values from UI
      expr = paste("Total Hours in Course: ", round(
          ( (as.numeric(input$weeklypages)/as.numeric(pagesperhour.sel)) * as.numeric(input$classweeks)  )+ 
          ( (as.numeric(hoursperwriting.sel)*as.numeric(input$semesterpages)) ) +
          ( (as.numeric(input$labs))*((as.numeric(input$labhours))+(as.numeric(input$labprep))) ) +
          ( (as.numeric(input$quizzes)*as.numeric(input$quizhours)) ) +
          ( (as.numeric(input$exams)*as.numeric(input$examhours)) ) +
          ( (as.numeric(input$projects)*as.numeric(input$projhours)) ) +
          ( (as.numeric(input$otherassign)*as.numeric(input$otherhours)) ) +
          (as.numeric(posthours.sel) * as.numeric(input$classweeks) ) +
          (as.numeric(input$weeklyvideos) * as.numeric(input$classweeks) ) +
          ( (as.numeric(quiztimed.sel) / 60 ) * as.numeric(input$quizzes) ) +
          ( (as.numeric(takehome.sel) / 60 ) * as.numeric(input$exams)  ) +
          ( (as.numeric(input$syncsessions) * as.numeric(input$synclength)) * as.numeric(input$classweeks) ), 
        digits=2),"hrs")
      
    })
        
    # generate an estimate for hours per week spent on Discussion Posts
    output$hoursperposts.out <- renderText({
      
    # determine correct value to use for discussion post hours
      if(input$postformat==1){ # text estimate
        posthours.sel <- ((as.numeric(input$postlength.text)*as.numeric(input$postsperweek))/250)
      }
      if(input$postformat==2){ # audio/video estimate
        posthours.sel <- ((as.numeric(input$postlength.av)*as.numeric(input$postsperweek))/3)
      }
      
      # calculate hours spent on discussion posts using inputted values from UI
      expr = paste(round(
        as.numeric(posthours.sel), 
        digits=2),"hours / week")      
        
    })
    
    # generate a displayable value for the reading rate used from the pagesperhour matrix
    output$pagesperhour.out <- renderText({
      
      expr = paste(pagesperhour[
        as.numeric(input$difficulty), as.numeric(input$readingpurpose), as.numeric(input$readingdensity)
        ], "pages per hour")
      
    })
    
    # generate a displayable value for the writing rate used from the hoursperwriting matrix
    output$hoursperwriting.out <- renderText({
      expr = paste(hoursperwriting[
        as.numeric(input$writtendensity), as.numeric(input$draftrevise), as.numeric(input$writingpurpose)
        ], "hours per page")
    })
    
  }
              
)
