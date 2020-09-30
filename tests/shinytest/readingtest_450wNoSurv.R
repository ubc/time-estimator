app <- ShinyDriver$new("../../")
app$snapshotInit("readingtest_450wNoSurv")

app$snapshot()
app$setInputs(radio = "reading")
app$snapshot()
app$setInputs(readingName = "readings")
app$snapshot()
app$setInputs(weeklypages = 10)
app$snapshot()
#this is a default value so wait =FALSE and values=FALSE is used so the test does not wait for a value change
app$setInputs(readingdensity = "1", wait_=FALSE, values_=FALSE)
app$snapshot()
#this is a default value so wait =FALSE and values=FALSE is used so the test does not wait for a value change
app$setInputs(difficulty = "1", wait_=FALSE, values_=FALSE)
app$snapshot()
#this is a default value so wait =FALSE and values=FALSE is used so the test does not wait for a value change
app$setInputs(readingpurpose = "1", wait_=FALSE, values_=FALSE)
app$snapshot()
app$setInputs(add = "click")
app$snapshot()
