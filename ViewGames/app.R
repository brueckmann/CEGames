#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#



games <- readr::read_delim("https://raw.githubusercontent.com/brueckmann/CEGames/refs/heads/main/data/ListGames_2025_08_27.csv",
                           delim = ";", escape_double = FALSE, na = "NA",
                           trim_ws = TRUE)

games <- games |>  filter(!((Link == "")))

games <- games |> relocate("Name", "Known serious game")

games <- games |> rename("Serious Game" =  "Known serious game")


library(DT)
library(shiny)

server <- function(input, output) {

  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    data <- games
    if (input$onlineonly != "All") {
      data <- data[data$`Online Game` == input$onlineonly, ]
    }
    if (input$onlyserious != "All") {
      data <- data[data$`Known Known serious game` == input$onlyserious, ]
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
           selectInput("onlineonly",
                       "Only Online Games?",
                       c("All",
                         unique(as.character(games$`Online Game`))))
    ),
    column(4,
           selectInput("onlyserious",
                       "Only Known serious games?",
                       c("All",
                         unique(as.character(games$`Known Known serious game`))))
    )
  ),
  # Create a new row for the table.
  DT::dataTableOutput("table")
)

# Run the application
shinyApp(ui = ui, server = server)
