app <- ShinyDriver$new("../../")
app$snapshotInit("writingtest_manuallyadjust")

app$snapshot()
app$setInputs(radio = "writing")
app$snapshot()
app$setInputs(writingName = "writing")
app$snapshot()
app$setInputs(numassign = 5)
app$snapshot()
app$setInputs(assignmentpages = 5)
app$snapshot()
app$setInputs(setwritingrate = TRUE)
app$snapshot()
app$setInputs(overridehoursperwriting = 1)
app$snapshot()
app$setInputs(add = "click")
app$snapshot()
