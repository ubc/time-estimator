app <- ShinyDriver$new("../../")
app$snapshotInit("examStest")

app$snapshot()
app$setInputs(radio = "exam")
app$snapshot()
app$setInputs(examName = "Midterm")
app$snapshot()
app$setInputs(exams = 2)
app$snapshot()
app$setInputs(examhours = 3)
app$snapshot()
app$setInputs(add = "click")
app$snapshot()
