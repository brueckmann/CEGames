#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#
install.packages("tidyverse")

library(tidyverse)

games <- read_delim("data/ListGames_2025_08_27.csv",
                                   delim = ";", escape_double = FALSE, na = "NA",
                                   trim_ws = TRUE)

install.packages("DT")

library(dt)


function(input, output) {

  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    data <- games
    if (input$`Online Game` != "All") {
      data <- data[data$`Online Game` == input$`Online Game` ,]
    }
    if (input$`Serious game` != "All") {
      data <- data[data$`Known serious game` == input$`Known serious game`,]
    }
    data
  }))

}



library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  titlePanel("Basic DataTable"),

  # Create a new Row in the UI for selectInputs
  fluidRow(
    column(4,
           selectInput("Online Game",
                       "Online Game",
                       c("All",
                         unique(as.character(games$`Online Game`))))
    ),
    column(4,
           selectInput("Serious game",
                       "Serious game",
                       c("All",
                         unique(as.character(games$`Known serious game`))))
    )
  ),
  # Create a new row for the table.
  DT::dataTableOutput("table")
)

# Run the application
shinyApp(ui = ui, server = server)
