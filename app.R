library(shiny)
library(rvest)

ui <- fluidPage(
  titlePanel("Golden State Warriors Roster (1971-2020)"),
  
  numericInput("yearInput", "Enter a year:", 2000, min = 1971, max = 2020),
  tableOutput('BasketballTable'),
  
  tags$a(href="https://www.statscrew.com/basketball/t-GSW", 
         "all data scraped from statscrew.com"),
)

server <- function(input, output) {
  
  #function takes year as parameter
  tibbleTable <- function(x){
    #year is pasted to the end of the URL
    yearPlusURL <- paste("https://www.statscrew.com/basketball/roster/t-GSW/y-",x,sep = "")
    #read in the content from the .html file
    players <- read_html(yearPlusURL)
    #tidyverse pipe (%>%)
    players %>%
      #xpath specifies what we want to grab from the html, can also use class, id, ect...
      html_nodes(xpath ="/html/body/div[1]/div/div[2]/div/div[3]/table") %>%
      #parse the html table into a data frame
      html_table()
  }
  
  #runs tibbleTable function which scrapes and makes the table
  tibbleExecuted <- reactive({tibbleTable(input$yearInput)})
  
  output$BasketballTable <- renderTable(tibbleExecuted())
}

###########
shinyApp(ui = ui, server = server)
