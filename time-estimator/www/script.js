//wl_list is the "list" of components. DS is Array
var wl_list = new Array();
//this is the "Add to Workload" button
var btn = document.getElementById("add");
//this gives all of the WellPanel divs created by R code
var wl_div = document.getElementsByClassName("well");

//when the Add to Workload button is clicked
btn.onclick = function(){
    //get the component type from the selected_radio HEADER
    var select_text = document.getElementById('selected_radio').innerHTML;
    // first 6 characters (0-5) are USUALLY "Add a "
    var selected = select_text.substring(6, select_text.length);
    //getNewComponent creates the component string
    var newComp = getNewComponent(selected);
    //push component to the list (array)
    wl_list.push(newComp);
    //update the table with new list
    updateWorkload(wl_list);
 }

function deleteElem(id){
    //this function is for deleting a component from the list.
    
    //the id is the delete button id (starts at 1) so we need id-1 for list index 
    var comp = wl_list[id-1];
    //components are comma seperated
    var compArray = comp.split(",");

    var hoursI = compArray[2];
    var hoursS = compArray[3];

    //negate the hours to "Add" negative hours to totals (removing them)
    hoursI = -1 * hoursI;
    hoursS = -1 * hoursS;

    hours = hoursI + hoursS;
    
    //splice removes from list (array data structure)
    wl_list.splice((id-1), 1);

    //if the list not empty, update hours accordingly
    if(wl_list.length > 0){
        updateTotal(hours);
        updateSyncAsync("(I)", hoursI);
        updateSyncAsync("(S)", hoursS);
    }
    else{//if list is empty, send values of -100 so they are reset to 0 ( hours < 0 check in functions)
        updateTotal(-100);
        updateSyncAsync("(I)", -100);
        updateSyncAsync("(S)", -100);
    }

    updateWorkload(wl_list);
    
}

function getNewComponent(selected){
    //get class weeks
    var classWeeks = document.getElementById("classweeks").value;
    //if undefined, classweeks is static, we need the HTML instead
    if(classWeeks === undefined){
        //get HTML
        classWeeks = parseFloat(document.getElementById("classweeks").innerHTML.split(" ")[3]);
    }
    //Not static so we can just use value from the numeric input box
    else{
        classWeeks = parseFloat(classWeeks);
    }
    
    if(selected === "e Primary Class Meeting"){ //Since header is "Add The Primary class meeting", selected parse gets the e
        //input variables
        var numMeetings = parseFloat(document.getElementById("syncsessions").value);
        var meetingLength = parseFloat(document.getElementById("synclength").value);

        //abbreviation is either (I) for Indep or (S) for Sched
        //Class Meetings are always scheduled so no need to check.
        var abbreviation = "(S) "; 

        // no need to divide by weeks because input is lectures per week
        var hoursperweek = numMeetings * meetingLength;
        var totalhours = hoursperweek * classWeeks;

        //update async or sync hours based on abbrieviation
        updateSyncAsync(abbreviation, hoursperweek);
        //update total with new hours
        updateTotal(hoursperweek);
        //component needs to be of the form: 'Component, name, hrs/week(I), hrs/week(S), hrs/term(I), hrs/term(S)' for the table 
        var component = "Class Meeting, " +" ,"+ "0," +Number(hoursperweek).toFixed(2)+", 0, " + Number(totalhours).toFixed(0);
        return(component);
   
    }else if(selected === "Creative Practice Session"){
        //input variables
        var numSess = parseFloat(document.getElementById("sess").value);
        var sessPrep = parseFloat(document.getElementsByClassName("irs-single")[0].innerHTML);
        var sessHours = parseFloat(document.getElementsByClassName("irs-single")[1].innerHTML);
        var postSess = parseFloat(document.getElementsByClassName("irs-single")[2].innerHTML);

        //abbreviation is either (I) for Indep or (S) for Sched
        var abbreviation = "(S) "; 
    
        var synch = document.getElementById("sesssynch");
        if(synch.checked === false){
            abbreviation = "(I) ";
            var totalhours = (numSess * (sessPrep+sessHours+postSess));
            var hoursperweek = totalhours/classWeeks;
            //update async or sync hours based on abbrieviation
            updateSyncAsync(abbreviation, hoursperweek);
            //update total with new hours
            updateTotal(hoursperweek);
        //component needs to be of the form: 'Component, name, hrs/week(I), hrs/week(S), hrs/term(I), hrs/term(S)' for the table
        var component = "Creative Practice Session, " +" , "+ Number(hoursperweek).toFixed(2) + ", 0, " + Number(totalhours).toFixed(0) +", 0";
        return(component);
        }else{
            var totalhours = (numSess * (sessPrep+postSess));
            var hoursperweek = totalhours/classWeeks;

            var sessTotal = numSess * sessHours;
            var sessperweek = sessTotal/classWeeks;
            //component needs to be of the form: 'Component, name, hrs/week(I), hrs/week(S), hrs/term(I), hrs/term(S)' for the table
            var component = "Creative Practice Session, " + " , " + Number(hoursperweek).toFixed(2) + ", " + Number(sessperweek).toFixed(2) + ", " + Number(totalhours).toFixed(0) +", "+ Number(sessTotal).toFixed(0); 
            //update async or sync hours based on abbrieviation
            updateSyncAsync("(I) ", hoursperweek);
            //update async or sync hours based on abbrieviation
            updateSyncAsync("(S) ", sessperweek);
            //update total with new hours
            updateTotal(hoursperweek);
            updateTotal(sessperweek);

            return(component);
        }
    
    }else if(selected === "Discussion"){
        //if setdiscussion true, manual override of hours.
        var setdiscussion = document.getElementById("setdiscussion");
        //number of discussions per semester
        var numDisc = parseFloat(document.getElementById("postspersem").value);
        //custom name input
        var customName = document.getElementById("discName").value;
        //hoursperweek and totalhours are the output
        var hoursperweek = 0;
        var totalhours = 0;
        //abbreviation is either (I) for Indep or (S) for Sched
        //assume (I) for discussions (checkbox unchecked by default).
        var abbreviation = "(I) "; 

        //check for manual input
        if(setdiscussion.checked === true ){
            //manual override of hours
            var override = document.getElementById("overridediscussion");
            hoursperweek = parseFloat(override.value);
            totalhours = hoursperweek*classWeeks;

            var format = document.getElementsByClassName("selectize-input items full has-options has-items")[0].textContent;
            if(format === "Synchronous (S)"){
                //abbreviation = "(S) "; //currently only allocating independent hours
            }
        }else{
            //format = online async or in-person sync
            var format = document.getElementsByClassName("selectize-input items full has-options has-items")[0].textContent;
            
            if(format === "Asynchronous (I)"){
                //postsperweek and postlength input variables in calculation
                var posts= parseFloat(document.getElementById("posts").value);
                var postlength = parseFloat(document.getElementById("postlength").value);

                //postsperweek and postlength input variables in calculation
                var responses = parseFloat(document.getElementById("responses").value);
                var resplength = parseFloat(document.getElementById("resplength").value);

                //format is online, posts are avg 250 words, calculate # posts and responses times # discussions divided by classWeeks
                totalhours = ((((posts*postlength)/250)+((responses*resplength)/250))*numDisc);
                hoursperweek = totalhours/classWeeks;
                abbreviation = "(I) ";
            }else{
                //format is in-person, preptime is in minutes
                //abbreviation = "(S) "; //currently only allocating independent hours
                var preptime = parseFloat(document.getElementById("preptime").value);
                totalhours = ((preptime/60) * numDisc);
                hoursperweek = totalhours/classWeeks;

            }
        }
        var currList = wl_div[4].innerHTML;

        //update async or sync hours based on abbrieviation
        updateSyncAsync(abbreviation, hoursperweek);
        //update total with new hours
        updateTotal(hoursperweek);
        //component needs to be of the form: 'Component, name, hrs/week(I), hrs/week(S), hrs/term(I), hrs/term(S)' for the table   
        var component = "Discussion, "+ customName + ", " + Number(hoursperweek).toFixed(2) + ", 0, " + Number(totalhours).toFixed(0) +", 0"; 
        return(component);
    }else if(selected === " Exam"){ //since header is "Add an Exam", selected parse gets the space
        //input variables
        var numExams = parseFloat(document.getElementById("exams").value);
        var studyHours = parseFloat(document.getElementById("examhours").value);
        var examlength = parseFloat(document.getElementById("examlength").value);
        //custom name input
        var customName = document.getElementById("examName").value;
        //abbreviation is either (I) for Indep or (S) for Sched
        var abbreviation = "(I) "; 
        //output variables
        var hoursperweek = 0;
        var totalhours = 0;

        //format = online async or in-person sync
        var format = document.getElementsByClassName("selectize-input items full has-options has-items")[0].textContent;
        var format_abbriev = format[0];

        //Independent Exam
        if(format_abbriev == "I"){
            abbreviation = "(I) ";
            totalhours = (numExams * (studyHours + examlength));
            hoursperweek = totalhours / classWeeks;
        }else{
            //schedule exam
            //abbreviation = "(S) "; //currently only allocating independent (study) hours
            totalhours = (numExams * studyHours);
            hoursperweek = totalhours/ classWeeks;
        }

  

        //update async or sync hours based on abbrieviation
        updateSyncAsync(abbreviation, hoursperweek);
        //update total with new hours
        updateTotal(hoursperweek);
        
        //component needs to be of the form: 'Component, name, hrs/week(I), hrs/week(S), hrs/term(I), hrs/term(S)' for the table   
        var component = "Exam, " + customName + ", " + Number(hoursperweek).toFixed(2) + ", 0, " + Number(totalhours).toFixed(0) +", 0";
        return(component);
    }else if(selected === "Lab"){
        //input variables
        var numLabs = parseFloat(document.getElementById("labs").value);
        var labPrep = parseFloat(document.getElementsByClassName("irs-single")[0].innerHTML);
        var labHours = parseFloat(document.getElementsByClassName("irs-single")[1].innerHTML);
        var postLab = parseFloat(document.getElementsByClassName("irs-single")[2].innerHTML);

        //abbreviation is either (I) for Indep or (S) for Sched
        //assume (S) for labs (checkbox checked by default).
        var abbreviation = "(S) "; 
    
        //check scheduled checkbox
        var synch = document.getElementById("labsynch");
        if(synch.checked === false){
            abbreviation = "(I) ";
            var totalhours = (numLabs * (labPrep+labHours+postLab));
            var hoursperweek = totalhours/classWeeks;
            //update async or sync hours based on abbrieviation
            updateSyncAsync(abbreviation, hoursperweek);
            //update total with new hours
            updateTotal(hoursperweek);
        //component needs to be of the form: 'Component, name, hrs/week(I), hrs/week(S), hrs/term(I), hrs/term(S)' for the table
        var component = "Lab, "+ " , " + Number(hoursperweek).toFixed(2) + ", 0, " + Number(totalhours).toFixed(0) +", 0";
        return(component);
        }else{ //partial scheduled lab, different calculation

            var totalhours = (numLabs * (labPrep+postLab));
            var hoursperweek = totalhours/classWeeks;
            var labTotal = numLabs*labHours;
            var labperweek = labTotal/classWeeks;
            
            //update async or sync hours based on abbrieviation
            updateSyncAsync("(I) ", hoursperweek);
            //update async or sync hours based on abbrieviation
            updateSyncAsync("(S) ", labperweek);
            //update total with new hours
            updateTotal((hoursperweek+labperweek));

            //component needs to be of the form: 'Component, name, hrs/week(I), hrs/week(S), hrs/term(I), hrs/term(S)' for the table
            var component = "Lab, " +" , " + Number(hoursperweek).toFixed(2) + ", " + Number(labperweek).toFixed(2) + ", " + Number(totalhours).toFixed(0) +", "+ Number(labTotal).toFixed(0); 

            return(component);
        }
        
    }else if(selected === "Quiz"){
        //input variables
        var numQuizzes = parseFloat(document.getElementById("quizzes").value);
        var studyHours = parseFloat(document.getElementById("studyhours").value);

        //output variables
        var hoursperweek = 0;
        var totalhours = 0 ;

        //abbreviation is either (I) for Indep or (S) for Sched
        //assume (I) for quiz (checkbox unchecked by default).
        var abbreviation = "(I) "; 

        //format = online async or in-person sync
        var format = document.getElementsByClassName("selectize-input items full has-options has-items")[0].textContent;
        //Just need first letter
        var format_abbriev = format[0];

        if(format_abbriev == "I"){
            abbreviation = "(I) ";
            //if quiz is timed, time will be quiz length + hours * # of quizzes
            var quizLength = parseFloat(document.getElementById("quizlength").value)/60;
            totalhours = (numQuizzes * (studyHours + quizLength));
            hoursperweek = totalhours/ classWeeks;
        }else{//if format is S, we only take I hours so no change to abbriev
            totalhours = (numQuizzes * studyHours);
            hoursperweek= totalhours/ classWeeks;
        }

        //update async or sync hours based on abbrieviation
        updateSyncAsync(abbreviation, hoursperweek);
        //update total with new hours
        updateTotal(hoursperweek);
        
        //component needs to be of the form: 'Component, name, hrs/week(I), hrs/week(S), hrs/term(I), hrs/term(S)' for the table   
        var component = "Quiz, " +" , "+ Number(hoursperweek).toFixed(2) + ", 0, " + Number(totalhours).toFixed(0) +", 0";
        return(component);
    
    }else if(selected === "Reading Assignment"){
        //input variables
        var weeklyPages = parseFloat(document.getElementById("weeklypages").value);
        var pageDensity = parseFloat(document.getElementsByClassName("item")[0].innerHTML);
        var difficulty = document.getElementsByClassName("item")[1].innerHTML;
        var purpose = document.getElementsByClassName("item")[2].innerHTML;

        //custom name input
        var customName = document.getElementById("readingName").value;

        //output variable
        var hoursperweek = 0;
        var totalhours = 0;

        var setRate = document.getElementById("setreadingrate").checked;

        if(setRate){ //if set reading rate, calculations are easy!
            readingRate = parseFloat(document.getElementById("overridepagesperhour").value);
            hoursperweek = Number(weeklyPages / readingRate).toFixed(2);
        }else{
            // See background table for calculations, or WFU estimation details: https://cte.rice.edu/workload#howcalculated
            if(difficulty === "No New Concepts"){
                if(purpose === "Survey"){
                    if(pageDensity === 450){
                        hoursperweek = weeklyPages / 67;
                    }else if(pageDensity === 600){
                        hoursperweek = weeklyPages / 50;
                    }//pageDensity = 750
                    else{
                        hoursperweek = weeklyPages / 40;
                    }
                }else if(purpose === "Understand"){
                    if(pageDensity === 450){
                        hoursperweek = weeklyPages / 33;
                    }else if(pageDensity === 600){
                        hoursperweek = weeklyPages / 25;
                    }//pageDensity = 750
                    else{
                        hoursperweek = weeklyPages / 20;
                    }
                }//Engage
                else{
                    if(pageDensity === 450){
                        hoursperweek = weeklyPages / 17;
                    }else if(pageDensity === 600){
                        hoursperweek = weeklyPages / 13;
                    }//pageDensity = 750
                    else{
                        hoursperweek = weeklyPages / 10;
                    }
                }
            }else if(difficulty === "Some New Concepts"){
                if(purpose === "Survey"){
                    if(pageDensity === 450){
                        hoursperweek = weeklyPages / 47;
                    }else if(pageDensity === 600){
                        hoursperweek = weeklyPages / 35;
                    }//pageDensity = 750
                    else{
                        hoursperweek = weeklyPages / 28;
                    }
                }else if(purpose === "Understand"){
                    if(pageDensity === 450){
                        hoursperweek = weeklyPages / 24;
                    }else if(pageDensity === 600){
                        hoursperweek = weeklyPages / 18;
                    }//pageDensity = 750
                    else{
                        hoursperweek = weeklyPages / 14;
                    }
                }//Engage
                else{
                    if(pageDensity === 450){
                        hoursperweek = weeklyPages / 12;
                    }else if(pageDensity === 600){
                        hoursperweek = weeklyPages / 9;
                    }//pageDensity = 750
                    else{
                        hoursperweek = weeklyPages / 7;
                    }
                }
            }// Many New Concepts
            else{
                if(purpose === "Survey"){
                    if(pageDensity === 450){
                        hoursperweek = weeklyPages / 33;
                    }else if(pageDensity === 600){
                        hoursperweek = weeklyPages / 25;
                    }//pageDensity = 750
                    else{
                        hoursperweek = weeklyPages / 20;
                    }
                }else if(purpose === "Understand"){
                    if(pageDensity === 450){
                        hoursperweek = weeklyPages / 17;
                    }else if(pageDensity === 600){
                        hoursperweek = weeklyPages / 13;
                    }//pageDensity = 750
                    else{
                        hoursperweek = weeklyPages / 10;
                    }
                }//Engage
                else{
                    if(pageDensity === 450){
                        hoursperweek = weeklyPages / 9;
                    }else if(pageDensity === 600){
                        hoursperweek = weeklyPages / 7;
                    }//pageDensity = 750
                    else{
                        hoursperweek = weeklyPages / 5;
                    }
                }
            }
            
        }

        totalhours = hoursperweek * classWeeks;

        //abbreviation is either (I) for Indep or (S) for Sched
        var abbreviation = "(I) "; 
       
        /* we are assuming only independent
        var synch = document.getElementById("readsynch");
        if(synch.checked === true){
            abbreviation = "(S) ";
        }//no need for else as default is synch === true.
        */

        //update async or sync hours based on abbrieviation
        updateSyncAsync(abbreviation, hoursperweek);
        //update total with new hours
        updateTotal(hoursperweek);
        //component needs to be of the form: 'Component, name, hrs/week(I), hrs/week(S), hrs/term(I), hrs/term(S)' for the table
        var component = "Reading Assignment, " + customName + ", " + Number(hoursperweek).toFixed(2) + ", 0, " + Number(totalhours).toFixed(0) +", 0";
        return(component);
    
    
    
    }else if(selected === "Tutorial"){
        //input variables
        var numTut = parseFloat(document.getElementById("tutorials").value);
        var tutPrep = parseFloat(document.getElementsByClassName("irs-single")[0].innerHTML);
        var  tutHours = parseFloat(document.getElementsByClassName("irs-single")[1].innerHTML);

        //check for scheduled checkbox
        var synch = document.getElementById("tutsynch");

        if(synch.checked === false){ //fully independent
            var totalhours = (numTut * (tutHours+tutPrep))
            var hoursperweek = totalhours/classWeeks;
            //update async or sync hours based on abbrieviation
            updateSyncAsync(abbreviation, hoursperweek);
            //update total with new hours
            updateTotal(hoursperweek);
            //component needs to be of the form: 'Component, name, hrs/week(I), hrs/week(S), hrs/term(I), hrs/term(S)' for the table
            var component = "Tutorial, "+ " , " + Number(hoursperweek).toFixed(2) + ", 0, " + Number(totalhours).toFixed(0) +", 0"; 
        }
        else{//partially scheduled
            var itotal = numTut * tutPrep;
            var stotal = numTut * tutHours;

            var iperweek = itotal /classWeeks;
            var sperweek = stotal/classWeeks;

            var hoursperweek = iperweek + sperweek;

            //update async or sync hours based on abbrieviation
            updateSyncAsync("(I)", iperweek);
            updateSyncAsync("(S)", sperweek);
            //update total with new hours
            updateTotal(hoursperweek);
            //component needs to be of the form: 'Component, name, hrs/week(I), hrs/week(S), hrs/term(I), hrs/term(S)' for the table
            var component = "Tutorial, " + " , "+ Number(iperweek).toFixed(2) + ", " + Number(sperweek).toFixed(2) + ", " + Number(itotal).toFixed(0) +", "+  + Number(stotal).toFixed(0); 
        }
        return(component);

    }else if(selected === "Video or Podcast"){
        //input variables
        var weeklyvideos = parseFloat(document.getElementById("weeklyvideos").value);

        //custom name input
        var customName = document.getElementById("videoName").value;

        // calculate hours per week and hours per term
        var hoursperweek = weeklyvideos;
        var totalhours = hoursperweek*classWeeks;

        //update async or sync hours based on abbrieviation
        updateSyncAsync("(I)", hoursperweek);
        //update total with new hours
        updateTotal(hoursperweek);

        //component needs to be of the form: 'Component, name, hrs/week(I), hrs/week(S), hrs/term(I), hrs/term(S)' for the table
        var component = "Video/Podcast, " + customName + ", " + Number(hoursperweek).toFixed(2) + ", 0, " + Number(totalhours).toFixed(0) +", 0";
        return(component);
    }else if(selected === "Writing Assignment"){
        //input variables
        var pagesPerAssign = parseFloat(document.getElementById("assignmentpages").value);
        var numAssign = parseFloat(document.getElementById("numassign").value);
        var pageDensity = parseFloat(document.getElementsByClassName("item")[1].innerHTML.substring(0,3));
        var genre = document.getElementsByClassName("item")[2].innerHTML;
        var drafting = document.getElementsByClassName("item")[3].innerHTML;

        //custom name input
        var customName = document.getElementById("writingName").value;

        //output variables
        var hoursperweek = 0;
        var totalhours = 0;

        //format is independent or schedule (calculations are different)
        var format = document.getElementsByClassName("selectize-input items full has-options has-items")[0].textContent;

        if(format === "Independent"){
            var setRate = document.getElementById("setwritingrate").checked;
            //calculations based on WFU table, see their calculation info: https://cte.rice.edu/workload#howcalculated
            //ours are slightly modified to use pages per assignment * num assigments
            if(setRate){
                var hoursPerPage = parseFloat(document.getElementById("overridehoursperwriting").value);
                totalhours = (pagesPerAssign * hoursPerPage)
                hoursperweek = totalhours/classWeeks;  
            }else{ 
                if(genre === "Reflection/Narrative"){
                    if(drafting === "No Drafting"){
                        if(pageDensity === 250){
                            hoursperweek =(pagesPerAssign * .75)*numAssign/classWeeks; 
                        }//500
                        else{
                            hoursperweek = (pagesPerAssign * 1.5)*numAssign/classWeeks;
                        }
                    }else if(drafting === "Minimal Drafting"){
                        if(pageDensity === 250){
                            hoursperweek = ((pagesPerAssign * 1)*numAssign)/classWeeks; 
                            
                        }//500
                        else{
                            hoursperweek = (pagesPerAssign * 2)*numAssign/classWeeks;
                        }
                    }//Extensive drafting
                    else{
                        if(pageDensity === 250){
                            hoursperweek = (pagesPerAssign * 1.25)*numAssign/classWeeks; 
                        }//500
                        else{
                            hoursperweek = (pagesPerAssign * 2.5)*numAssign/classWeeks;
                        }
                    }
                }else if(genre === "Argument"){
                    if(drafting === "No Drafting"){
                        if(pageDensity === 250){
                            hoursperweek = (pagesPerAssign * 1.5)*numAssign/classWeeks; 
                        }//500
                        else{
                            hours = (pagesPerAssign * 3)*numAssign/classWeeks;
                        }
                    }else if(drafting === "Minimal Drafting"){
                        if(pageDensity === 250){
                            hoursperweek = (pagesPerAssign * 2)*numAssign/classWeeks; 
                        }//500
                        else{
                            hoursperweek = (pagesPerAssign * 4)*numAssign/classWeeks;
                        }
                    }//Extensive drafting
                    else{
                        if(pageDensity === 250){
                            hoursperweek = (pagesPerAssign * 2.5)*numAssign/classWeeks; 
                        }//500
                        else{
                            hoursperweek = (pagesPerAssign * 5)*numAssign/classWeeks;
                        }
                    }
                }//Research
                else{
                    if(drafting === "No Drafting"){
                        if(pageDensity === 250){
                            hoursperweek = (pagesPerAssign * 3)*numAssign/classWeeks; 
                        }//500
                        else{
                            hoursperweek = (pagesPerAssign * 6)*numAssign/classWeeks;
                        }
                    }else if(drafting === "Minimal Drafting"){
                        if(pageDensity === 250){
                            hoursperweek = (pagesPerAssign * 4)*numAssign/classWeeks; 
                        }//500
                        else{
                            hoursperweek = (pagesPerAssign * 8)*numAssign/classWeeks;
                        }
                    }//Extensive drafting
                    else{
                        if(pageDensity === 250){
                            hoursperweek = (pagesPerAssign * 5)*numAssign/classWeeks; 
                        }//500
                        else{
                            hoursperweek = (pagesPerAssign * 10)*numAssign/classWeeks;
                        }
                    }
                }
                totalhours = hoursperweek * classWeeks;
            }
            
            //abbreviation is either (I) for Indep or (S) for Sched
            var abbreviation = "(I) "; 
            
        }else{ //scheduled format
            var preptime = parseFloat(document.getElementById("preptime").value);
            
            abbreviation = "(I) ";
            totalhours = numAssign * (preptime/60);
            hoursperweek = totalhours/classWeeks;
        }
        
        //update async or sync hours based on abbrieviation
        updateSyncAsync(abbreviation, hoursperweek);
        //update total with new hours
        updateTotal(hoursperweek);

        //component needs to be of the form: 'Component, name, hrs/week(I), hrs/week(S), hrs/term(I), hrs/term(S)' for the table
        var component = "Writing Assignment, " + customName + ", " + Number(hoursperweek).toFixed(2) + ", 0," + Number(totalhours).toFixed(0) +", 0";
        return(component);

    }else if(selected === "Custom Assignment"){
        //input variables
        var customName = document.getElementById("customName").value;
        var custPerSem = parseFloat(document.getElementById("customnum").value);
        var custPrep = parseFloat(document.getElementsByClassName("irs-single")[0].innerHTML);
        var custHours = parseFloat(document.getElementsByClassName("irs-single")[1].innerHTML);
        var postCust = parseFloat(document.getElementsByClassName("irs-single")[2].innerHTML);

        //abbreviation is either (I) for Indep or (S) for Sched
        //assume (I) for custom (checkbox unchecked by default).
        var abbreviation = "(I) "; 

        //checks schedule checkbox
        var synch = document.getElementById("custsynch");
        
        if(synch.checked === false){
            abbreviation = "(I) ";
            var totalhours = (custPerSem * (custPrep+custHours+postCust));
            var hoursperweek = totalhours/classWeeks;
            //update async or sync hours based on abbrieviation
            updateSyncAsync(abbreviation, hoursperweek);
            //update total with new hours
            updateTotal(hoursperweek);

        //component needs to be of the form: 'Component, name, hrs/week(I), hrs/week(S), hrs/term(I), hrs/term(S)' for the table
        var component = "Custom Assignment, " + customName +", " + Number(hoursperweek).toFixed(2) + ", 0, " + Number(totalhours).toFixed(0) +", 0";
        return(component);
        }else{
            //if a portion is scheduled, calculations are different
            var totalhours = (custPerSem * (custPrep+postCust));
            var hoursperweek = totalhours/classWeeks;

            var custTotal = custPerSem * custHours;
            var custperweek = custTotal/classWeeks;

            //update async or sync hours based on abbrieviation
            updateSyncAsync("(I) ", hoursperweek);
            //update async or sync hours based on abbrieviation
            updateSyncAsync("(S) ", custperweek);
            //update total with new hours
            updateTotal(hoursperweek);
            updateTotal(custperweek);

            //component needs to be of the form: 'Component, name, hrs/week(I), hrs/week(S), hrs/term(I), hrs/term(S)' for the table
            var component = "Custom Assignment, "+ customName + ", " + Number(hoursperweek).toFixed(2) + ", " + Number(custperweek).toFixed(2) + ", " + Number(totalhours).toFixed(0) +", "+ Number(custTotal).toFixed(0); 

            return(component);
        }
    }
}

function updateWorkload(wl_list){
   //clear the table and rerender on update
    wl_div[4].innerHTML = "";
    //style variables
    var padding = "5px";
    var border = "1px solid black";

    //create table and header row
    var x = document.createElement("TABLE");
    var y = document.createElement("TR");
    //table and header row formatting
    x.style.border = border;
    y.style.border = border;
    y.style.backgroundColor = "#267bb6";
    y.style.color = "white";
    x.appendChild(y);
    for(let i=0; i<7; i++){
        var z = document.createElement("TH");
        //add headers to table
        switch(i){
            case 0: z.textContent = "Component"; break;
            case 1: z.textContent = "Name"; break;
            case 2: z.textContent = "hrs/wk (I)"; break;
            case 3: z.textContent = "hrs/wk (S) "; break;
            case 4: z.textContent = "hrs/term (I)"; break;
            case 5: z.textContent = "hrs/term (S)"; break;
            case 6: z.textContent = "Delete?"; break;
        }
        //header formatting
        z.style.border = border;
        z.style.padding = padding;
        z.style.backgroundColor = "#267bb6";
        z.style.color = "white";
        x.appendChild(z);
    }
    wl_div[4].appendChild(x);
    //duplicate origanl list (so that it is not modified)
    var wl_list2 = [... wl_list];

    var counter = wl_list2.length;

    while(wl_list2.length > 0){
        //shift "pops" each element but in FIFO fashion
        cur = wl_list2.shift();
        var y = document.createElement("TR");
        y.style.border = border;
        x.appendChild(y);

        //split component into a list to put in table
        var curr_list = cur.split(",");

        var type = curr_list[0];
         //If the component name (type) is two words, append them and remove the index 1 so that it is alligned with others
        if(type === "Class" || type === "Reading" || type === "Writing" || type === "Custom"){
           
            var type = curr_list[0] + " " + curr_list[1];
            curr_list.splice(1, 1);
            curr_list[0] = type;
        }

        //delete row https://developer.mozilla.org/en-US/docs/Web/API/HTMLTableElement

        for(var i=0; i<curr_list.length; i++){
            var cell = document.createElement("TD");
            cell.style.padding = padding;
            cell.style.border = border;
            cell.textContent = curr_list[i];
            x.appendChild(cell);
        }
        
        //create cell for button
        var cell = document.createElement("TD");
        cell.style.padding = padding;
        cell.style.border = border;
        
        // creating button element  
        var button = document.createElement('BUTTON');
        // creating text to be displayed on button 
        var btntext = document.createTextNode("X"); 
        // add unique id (for onlick)
        button.id = counter - wl_list2.length;
        //on click listener to remove element

        button.onclick = function(){
            deleteElem(this.id);
        } 
        // appending text to button 
        button.appendChild(btntext);
        //add button to cell
        cell.appendChild(button);
        //add cell to table
        x.appendChild(cell);
    }
}

function updateTotal(hours){
    //This function updates both the total per week and total per term
    let totalperweek = document.getElementById("estimatedworkload").innerHTML;
    let totalpw_num = parseFloat(totalperweek.split(" ")[1]);
    let total = document.getElementById("totalcoursehours").innerHTML;
    let total_num = parseFloat(total.split(" ")[1]);

    //totalpw = total per week, totalpw_num is numeric, totalpw is str
    totalpw_num += hours;
    var newTotalpw = "";
    //this prevents negatives (rounding) and removes decimal places from 0.
    if(totalpw_num <= 0){
        newTotalpw = "Total: " + 0 + " hrs/week";
    }else{        
        newTotalpw = "Total: " + Number(totalpw_num).toFixed(2) + " hrs/week";
    }
    //get class weeks (from numeric input)
    var classWeeks = parseFloat(document.getElementById("classweeks").value);

    //if class weeks already static, get from html
    if(isNaN(classWeeks)){
        classWeeks = parseFloat(document.getElementById("classweeks").innerHTML.split(" ")[3]);
    }

    //total per term adds the hours per term
    total_num += (hours * classWeeks);

    var newTotal = "";
    //this prevents negatives (rounding) and removes decimal places from 0.
    if(total_num <= 0 ){
        newTotal = "Total: " + 0 + " hrs/term";
    }else{
        newTotal = "Total: " + Number(total_num).toFixed(0) + " hrs/term";
    }
    //change classweeks to static or non static (if total is 0)
    staticClassWeeks(classWeeks, total_num);
    
    //update html
    document.getElementById("estimatedworkload").innerHTML = newTotalpw;
    document.getElementById("totalcoursehours").innerHTML = newTotal;
}

function updateSyncAsync(abbrev, hours){
    //This updates the Async and Sync totals near the bottom of the right panel.
    if(abbrev.includes("(S)")){
        //pull the existing value
        var sync = document.getElementById("estimatedSynch").innerHTML;
        var sync_num = parseFloat(sync.split(" ")[2]);

        //add hours passed into function
        sync_num += hours;

        //return string
        var newSync = "";

        if(sync_num <= 0){
            //this prevents negatives and removes decimals from 0.
            newSync = "Scheduled (S): "+ 0 + " hrs/week";
        }else{
            newSync = "Scheduled (S): "+ Number(sync_num).toFixed(2) + " hrs/week";
        }
        //update html
        document.getElementById("estimatedSynch").innerHTML = newSync;

    }//abrievation = (I)
    else{
        //pull the existing value
        var sync = document.getElementById("estimatedAsynch").innerHTML;
        var sync_num = parseFloat(sync.split(" ")[2]);

        //add hours passed into function
        sync_num += hours;

        //return string
        var newSync = "";
        if(sync_num <= 0){
            //this prevents negatives (from rounding) and removes decimals from 0
            newSync = "Independent (I): "+ 0 + " hrs/week";
        }else{
            newSync = "Independent (I): "+ Number(sync_num).toFixed(2) + " hrs/week";
        }

        //update html
        document.getElementById("estimatedAsynch").innerHTML = newSync;
    }
    
}

function staticClassWeeks(classWeeks, total){
    //this function makes it so that the class weeks cannot be changed with components in workload list
    //value is from the numeric Input box
    var classWeeks_value = document.getElementById("classweeks").value;
    //html is from the NON editable classweeks
    var classWeeks_html = document.getElementById("classweeks").innerHTML;
    var classWeeks_subs = classWeeks_html.substring(classWeeks_html.length-2, classWeeks_html.length)
    var classWeeks_split = classWeeks_html.split(" ");
    
    //var classwks_div = document.getElementsByClassName("form-group shiny-input-container").innerHTML;
    if(total == 0){
        //makes the class weeks editable
        document.getElementById("numWeeks").innerHTML = "<div class=\"form-group shiny-input-container\" style=\"width: 100%;\"><label class=\"control-label\" for=\"classweeks\">Course Duration (Weeks):</label><input id=\"classweeks\" type=\"number\" class=\"form-control shiny-bound-input\" value="+Number(classWeeks_subs)+"> </div>";
    }else{
        //makes the class weeks not editable
        if(classWeeks_split[3] === undefined){
            //this is the first change from editable to not editable
            document.getElementById("numWeeks").innerHTML = "<div id=\"classweeks\">Course Duration (Weeks): " +String(classWeeks_value) +"</div>";
        }else{
            //this runs everytime when the classweeks are already non-editable
            document.getElementById("numWeeks").innerHTML = "<div id=\"classweeks\">Course Duration (Weeks): " +String(classWeeks_split[3]) +"</div>";
    
        }
    }
}