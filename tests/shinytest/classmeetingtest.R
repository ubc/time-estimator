app <- ShinyDriver$new("../../")
app$snapshotInit("classmeetingtest")

app$snapshot()
#this is a default value so wait_=FALSE and values_=FALSE is used so the test does not wait for a value change
app$setInputs(radio = "classmeeting", wait_=FALSE, values_=FALSE)
app$setInputs(syncsessions = 1)
app$snapshot()
app$setInputs(synclength = 1)
app$snapshot()
app$setInputs(add = "click")
app$snapshot()
