# Dynamically append arbitrary number of inputs (Shiny) from 
# https://gist.github.com/ncarchedi/2ef57039c238ef074ee7
library(shiny)
library(DT)
source("functions.R")

shinyServer(function(input, output) {
  
  
  get_database <- eventReactive(input$update_view, {
    database <- load_database()
    if (!is.null(database)) {
      database[with(database, 
                    order(date_add, row_id, decreasing = T)), ]
    } else {
      database
    }
  })
  
  
  #####
  
  output$view_data <- DT::renderDataTable({
    DT::datatable(get_database(), rownames = F)
  })
  
  
  #####
  
  
  observeEvent(input$add_entry_confirm, {
    entry <- form_entry(word = input$word, explanation = input$explanation,
                        category = input$category,
                        date_add = input$date_add)
    
    add_entry(entry)
    showNotification(
      "New entry added. Please click on 'View word' for an updated words.", 
      type = "message"
    )
  })
  
  
  
  
  observeEvent(input$delete_entry_confirm, {
    delete_entry(input$row_id)
    showNotification(
      paste("Entry with row id", input$row_id, "is deleted from database.", 
            "Please click on 'View words' for an updated view."), 
      type = "message"
    )
  })
  
  
  })
  
  
 
  