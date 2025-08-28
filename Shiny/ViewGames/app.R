#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(DT)
library(shiny)



urlfile="https://raw.githubusercontent.com/brueckmann/CEGames/refs/heads/main/data/GamesOverview.csv"

gamedata <-readr::read_csv2(url(urlfile), na = "NA",
                     trim_ws = TRUE, show_col_types = FALSE)




server <- function(input, output) {

  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    data <- gamedata
    if (input$onlineonly != "All") {
      data <- data[data$`Online Game` == input$onlineonly, ]
    }
    if (input$onlyserious != "All") {
      data <- data[data$`Known Serious Game` == input$onlyserious, ]
    }
    if (input$onlyplaynow != "All") {
      data <- data[data$`Playable Now` == input$onlyplaynow, ]
    }
    data
  }))
}


# Define UI for application that draws a histogram
ui <- fluidPage(
  titlePanel("List of Climate and Energy (Serious) Games"),

  # Create a new Row in the UI for selectInputs
  fluidRow(
    column(4,
           selectInput("onlyserious",
                       "Serious Games?",
                       c("All",
                         unique(as.character(gamedata$`Known Serious Game`))))
    ),
    column(4,
           selectInput("onlineonly",
                       "Online Games?",
                       c("All",
                         unique(as.character(gamedata$`Online Game`))))
    ),
    column(4,
           selectInput("onlyplaynow",
                       "Playable Now?",
                       c("All",
                         unique(as.character(gamedata$`Playable Now`))))
    )
  ),
  # Create a new row for the table.
  DT::dataTableOutput("table")
)

# Run the application
shinyApp(ui = ui, server = server)
