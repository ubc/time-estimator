app <- ShinyDriver$new("../../")
app$snapshotInit("customItest")

app$snapshot()
app$setInputs(radio = "custom")
app$snapshot()
app$setInputs(customName = "custom")
app$snapshot()
app$setInputs(customnum = 14)
app$snapshot()
app$setInputs(custprep = 1)
app$snapshot()
app$setInputs(customhours = 5)
app$snapshot()
app$setInputs(postcust = 1)
app$snapshot()
app$setInputs(add = "click")
app$snapshot()
