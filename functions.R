
library(dplyr)

DataFile <- "database.RData"
ArchiveFolder <- "archive"
if (!dir.exists(ArchiveFolder)) {
  dir.create(ArchiveFolder)
}
Today <- Sys.Date()



load_database <- function() {
  if (!file.exists(DataFile)) {
    database <- NULL
  } else {
    load(DataFile) # R object: database
  }
  database
}




form_entry <- function(word = "",
                       explanation = "", 
                       category,
                       date_add = Sys.Date()) {
  # Check item name
  if (word %in% c("", " ")) {
    warning(simpleWarning(
      "You are equired to name your word."
    ))
  }
  
  # Check item explain
  if (explanation %in% c("", " ")) {
    warning(simpleWarning(
      "You are not equired but advised to describe your word."
    ))
  }
  
  category <- match.arg(arg = category, several.ok = T,
                             choices = c("Umm...","food","design","Book", "Genetics", "Biology", "Physics","Chemistry","Math","Statistics","Machine Learning",
                                         "Literature","Celebrities","Music","Dance","Sports","Geography","Life Style",
                                         "Fine Arts","Food","Movies","Language","Weirdo"))
  
  
  
  # Check dateof addition
  if (class(date_add) != "Date") {
    date_add <- as.Date(date_add)
  }
  if (is.na(date_add)) {
    stop(simpleError(
      "Please specify correct data_add of addition. Default is current data_add."
    ))
  } else {
    if (date_add > Today) {
      stop(simpleError("Please specify a reasonable date_add of addition."))
    }
  }
  # Check the person who paid and people to share the expense. If the amount 
  # should only be born by one person, `person_share` should be that person.
 
  # Return new entry
  data.frame(word = word,
             explanation = explanation,
             category = category,
             date_add = date_add, 
             stringsAsFactors = FALSE)
}



check_entry <- function(entry) {
  # Load database
  database <- load_database()
  # Check if similar entry already exists
  dup <- NULL
  if (!is.null(database)) {
    rows <- which(database$date_add == entry$date_add& 
                    database$word == entry$word & 
                    database$explanation == entry$explanation &
                    database$category == entry$category
                    )
    if (length(rows) > 0) {
      dup <- database[rows, ]
    }
  }
  list(entry = entry, duplicates = dup)
}



add_entry <- function(entry) {
  database <- load_database()
  save(
    database, 
    file = file.path(ArchiveFolder, paste0("database", Sys.Date(), ".RData"))
  )
  # Compile new entry
  if (is.null(database)) {
    entry <- cbind(row_id = 1, entry)
  } else {
    entry <- cbind(row_id = max(database$row_id) + 1, entry)
  }
  database <- rbind(database, entry)
  save(database, file = DataFile)
}



delete_entry <- function(row_id) {
  database <- load_database()
  database <- database[!(database$row_id %in% row_id), ]
  save(database, file = "database.RData")
}




