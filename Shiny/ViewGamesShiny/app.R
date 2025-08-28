library(DT)
library(shiny)
library(bslib)


urlfile="https://raw.githubusercontent.com/brueckmann/CEGames/refs/heads/main/data/GamesOverview.csv"

gamedata <-readr::read_csv2(url(urlfile), na = "NA",
                            trim_ws = TRUE, show_col_types = FALSE)

ui <- page_sidebar(

  # App title ----
  title = "Last updated on 28 August 2025 by brueckmann.github.io.",

  # Sidebar panel for inputs ----
  sidebar = sidebar(


    # Input: Selectors for Filters ----
    selectInput("onlyserious",
                "Serious Games?",
                c("All",
                  unique(as.character(gamedata$`Known Serious Game`)))),

    selectInput("onlineonly",
                "Online Games?",
                c("All",
                  unique(as.character(gamedata$`Online Game`)))),

    selectInput("onlyplaynow",
                "Playable Now?",
                c("All",
                  unique(as.character(gamedata$`Playable Now`)))),


    # checkboxGroupInput("variable", "Languages to show:",
    #                choices =     c("English" = "English",
    #                      "Français" = "French",
    #                      "Deutsch" = "German",
    #                      "Español" = "Spanish",
    #                      "More" = "More Lanuages"
    #                      ), selected =  c("English", "French", "German", "Spanish")),

    checkboxInput("displayunknownlang", "Show unknown language games?", FALSE),



    # Input: Numeric entry for number of obs to view ----
    numericInput(
      inputId = "obs",
      label = "Number of rows to display:",
      value = 18
    )
  ),


  # # Output: Formatted text for caption ----
  h3("List of 18 Climate and Energy (Serious) Games"),


  # Output: HTML table with requested number of observations ----
  tableOutput("view")
)

# Define server logic to summarize and view selected dataset ----
server <- function(input, output) {

  data <- gamedata

  datasetInput <- reactive({
    if (input$onlineonly != "All") {
      data <- data[data$`Online Game` == input$onlineonly, ]
    }
    if (input$onlyserious != "All") {
      data <- data[data$`Known Serious Game` == input$onlyserious, ]
    }
    if (input$onlyplaynow != "All") {
      data <- data[data$`Playable Now` == input$onlyplaynow, ]
    }
    if (input$displayunknownlang == FALSE) {
      data <- data[data$`Language known` == "Yes", ]
    }
    # if (input$variable != "English") {
    #   data <- data[data$`English` == 0, ]
    # }
    # if (input$variable != "French") {
    #   data <- data[data$`French` == 0, ]
    # }
    # if (input$variable != "German") {
    #   data <- data[data$`German` == 0, ]
    # }
    # if (input$variable != "Spanish") {
    #   data <- data[data$`Spanish` == 0, ]
    # }
    # if (input$variable == "More Languages") {
    #   data <- data[data$`More Languages` != 0, ]
    # }
    data
  })




  # Show the first "n" observations ----
  # The output$view depends on both the databaseInput reactive
  # expression and input$obs, so it will be re-executed whenever
  # input$dataset or input$obs is changed
  output$view <- renderTable({
    head(datasetInput(), n = input$obs)
  })
}

# Create Shiny app ----
shinyApp(ui, server)
