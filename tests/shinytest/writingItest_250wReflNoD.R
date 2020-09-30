app <- ShinyDriver$new("../../")
app$snapshotInit("writingItest_250wReflNoD")

app$snapshot()
app$setInputs(radio = "writing")
app$snapshot()
app$setInputs(writingName = "writing")
app$snapshot()
app$setInputs(numassign = 5)
app$snapshot()
app$setInputs(assignmentpages = 5)
app$snapshot()
#this is a default value so wait =FALSE and values=FALSE is used so the test does not wait for a value change
app$setInputs(writtendensity = "1", wait_=FALSE, values_=FALSE)
app$snapshot()
#this is a default value so wait =FALSE and values=FALSE is used so the test does not wait for a value change
app$setInputs(writingpurpose = "1", wait_=FALSE, values_=FALSE)
app$snapshot()
#this is a default value so wait =FALSE and values=FALSE is used so the test does not wait for a value change
app$setInputs(draftrevise = "1", wait_=FALSE, values_=FALSE)
app$snapshot()
app$setInputs(add = "click")
app$snapshot()
