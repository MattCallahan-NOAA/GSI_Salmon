# This is a Shiny web application for displaying salmon PSC numbers
# on a map. This app just reads in static images.

library(shiny)

####User Interface####
# Define UI
ui <- fluidPage(
  tags$head(includeHTML("google-analytics.html")),

   # Application title
   titlePanel("Salmon Prohibited Species Catch"),

   # Sidebar with reactive dropdowns based on the criteria selected
   sidebarLayout(
      sidebarPanel(
        selectInput(inputId = "speciesInput",
                    label = "Species",
                    choices = c("Chum" = "Chum",
                                "Chinook" = "Chinook"),
                    selected = "Chum",multiple=FALSE),
      selectInput("yearInput",
                  "Year",
                  choices = 2011:2021, selected = 2011,multiple=F)
      ),

      # Show a plot of the generated distribution
      mainPanel(
        plotOutput("plot")
      )
   )
)



####Server####
# Define server logic required to draw a histogram
server <- function(input, output, session) {

  output$plot <- renderImage({
    height <- session$clientData$output_plot_height
    filename<-normalizePath(file.path("www/", paste0(input$speciesInput,"_Map_bycatch_clusters_",input$yearInput,"WithScale.png",sep="")))
    list(src = filename,
         height = height,
         alt = paste(input$speciesInput, input$yearInput,sep=" "))
  }, deleteFile = FALSE)


}

####Run App####
# Run the application
shinyApp(ui = ui, server = server)

