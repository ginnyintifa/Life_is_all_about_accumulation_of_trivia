# Dynamically append arbitrary number of inputs (Shiny) from 
# https://gist.github.com/ncarchedi/2ef57039c238ef074ee7
library(shiny)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("My Wiki"),
  
  # Sidebar with a slider input for number of bins
  sidebarPanel(
    actionButton("update_view", label = "View words"), 
    hr(), 
    
    actionButton("add_entry", label = "Add new word"), 
    conditionalPanel(
      "input.add_entry == 1", 
      textInput("word", label = "new word:", value = ""), 
      textInput("explanation", label = "what is it about:", value = ""), 
      dateInput("date_add", label = "Date of getting:", value = Sys.Date()), 
      selectInput("category", label = "Add labels", multiple = T,
                  choices = c("Umm...","food","design","Book","Genetics","Biology", "Physics","Chemistry","Math","Statistics","Machine Learning",
                              "Literature","Celebrities","Music","Dance","Sports","Geography","Life Style",
                              "Fine Arts","Food","Movies","Language")), 
      #numericInput("amount", label = "Payment amount:", value = 0, min = 0), 
      actionButton("add_entry_confirm", label = "Confirm to add word")
    ),
    hr(), 
    actionButton("delete_entry", label = "Delete a word"), 
    conditionalPanel(
      "input.delete_entry == 1", 
      p("Please use this function with caution."), 
      numericInput("row_id", label = "Row id of word to delete:", 
                   value = 1, min = 1), 
      actionButton("delete_entry_confirm", label = "Confirm to delete word")
    )
    
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    DT::dataTableOutput("view_data")
)))

