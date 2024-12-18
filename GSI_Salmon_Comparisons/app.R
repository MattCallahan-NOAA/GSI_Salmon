#
# This is a Shiny web application for displaying salmon genetic
# stock identification (GSI) information.

library(shiny)
library(tidyverse)
library(DT)


####User Interface####
# Define UI
ui <- fluidPage(
  tags$head(includeHTML("google-analytics.html")),

  # Application title
   titlePanel("Genetic Stock Composition of salmon bycatch"),

   # Sidebar with reactive dropdowns based on the criteria selected
   sidebarLayout(
      sidebarPanel(
        selectInput(inputId = "lme", label = "1) Region", choices = c("Bering Sea","GOA"), selected = 1),
        selectInput(inputId = "bar.col", label = "2) Group barplot by (color):",
                    choices = c("Spatial Strata","Temporal Strata", "Year")),
        selectInput(inputId = "bar.opts", label = "Include:",
                    choices = NULL, selected = NULL, multiple = TRUE),
        selectInput(inputId = "graph.by", label = "3) Separate graphs horizontally by:",
                    choices = NULL, selected = NULL),
        selectInput(inputId = "graphby.opts", label = "Include:",
                           choices = NULL, selected = NULL, multiple = TRUE),
        selectInput(inputId = "Fixed.par", label = "4) Separate graphs vertically by:",
                    choices = NULL, selected = NULL, multiple = FALSE),
        selectInput(inputId = "Fixed.opt", label = "Include:",
                    choices = NULL, selected = NULL, multiple = TRUE)
      ),
      # Show a plot of the generated distribution
      mainPanel(
        tags$style(type="text/css",
                   ".shiny-output-error { visibility: hidden; }",
                   ".shiny-output-error:before { visibility: hidden; }"
        ),
        tabsetPanel(type = "tabs",
                    tabPanel("Plot",plotOutput("GSI.Plot",height="auto")),
                    tabPanel("Table", DT::dataTableOutput("GSI.Table"))
        )
      )
   )
)


####Server####
server <- function(input, output, session) {

dat<-read.csv("Data/chum_all_years_gsi_summaryNew.csv",na="NA",
                stringsAsFactors = F,header = T)

GraphChoices<-c("Spatial Strata","Temporal Strata","Year")

#Choices for bar.opts
  choices_bar.opts <- reactive({
    choices_bar.opts <- if(input$bar.col == "Spatial Strata"){
      dat%>%
        dplyr::filter(lme %in% input$lme) %>%
        select(spatialstrat)%>%
        unique()
    } else if(input$bar.col == "Temporal Strata"){
      dat%>%
        dplyr::filter(lme %in% input$lme) %>%
        select(temporalstrat)%>%
        unique()
    } else if(input$bar.col == "Year"){
      dat%>%
        dplyr::filter(lme %in% input$lme) %>%
        select(year)%>%
        unique()
    }
  })


  observe({
    updateSelectInput(session =  session, inputId = "bar.opts", choices = choices_bar.opts())
  })

  ColorCol<- reactive({
    ColorCol<-if(input$bar.col == "Spatial Strata"){
      "spatialstrat"
    } else if(input$bar.col == "Temporal Strata"){
      "temporalstrat"
    } else if(input$bar.col == "Year"){
      "year"
    }
  })


#Choices for graph.by
  choices_graph.by <- reactive({
    choices_graph.by <- GraphChoices[!(GraphChoices %in% input$bar.col)]
  })

  observe({
    updateSelectInput(session =  session, inputId = "graph.by", choices = choices_graph.by())
  })


#Choices for graphby.opts
  choices_graphby.opts <- reactive({
    choices_bar.opts <- if(input$graph.by == "Spatial Strata"){
      dat%>%
        dplyr::filter(lme %in% input$lme) %>%
        dplyr::filter(eval(parse(text=quo_name(ColorCol()))) %in% input$bar.opts) %>%
        select(spatialstrat)%>%
        unique()
    } else if(input$graph.by == "Temporal Strata"){
      dat%>%
        dplyr::filter(lme %in% input$lme) %>%
        dplyr::filter(eval(parse(text=quo_name(ColorCol()))) %in% input$bar.opts) %>%
        select(temporalstrat)%>%
        unique()
    } else if(input$graph.by == "Year"){
      dat%>%
        dplyr::filter(lme %in% input$lme) %>%
        dplyr::filter(eval(parse(text=quo_name(ColorCol()))) %in% input$bar.opts) %>%
        select(year)%>%
        unique()
    }
  })


  observe({
    updateSelectInput(session =  session, inputId = "graphby.opts", choices = choices_graphby.opts())
  })

  FacetWrap.by <- reactive({
    FacetWrap.by<-if(input$graph.by == "Spatial Strata"){
      "spatialstrat"
    } else if(input$graph.by == "Temporal Strata"){
      "temporalstrat"
    } else if(input$graph.by == "Year"){
      "year"
    }
  })


  #Choices for Fixed.par
  choices_Fixed.par <- reactive({
    choices_Fixed.par <- GraphChoices[!(GraphChoices %in% c(input$bar.col,input$graph.by))]
  })

  observe({
    updateSelectInput(session =  session, inputId = "Fixed.par", choices = choices_Fixed.par())
  })


  #Choices for Fixed.opt
  choices_Fixed.opt <- reactive({
    choices_Fixed.opt <- if(input$Fixed.par == "Spatial Strata"){
      dat%>%
        dplyr::filter(lme %in% input$lme) %>%
        dplyr::filter(eval(parse(text=quo_name(ColorCol()))) %in% input$bar.opts) %>%
        dplyr::filter(eval(parse(text=quo_name(FacetWrap.by()))) %in% input$graphby.opts) %>%
        select(spatialstrat)%>%
        unique()
    } else if(input$Fixed.par == "Temporal Strata"){
      dat%>%
        dplyr::filter(lme %in% input$lme) %>%
        dplyr::filter(eval(parse(text=quo_name(ColorCol()))) %in% input$bar.opts) %>%
        dplyr::filter(eval(parse(text=quo_name(FacetWrap.by()))) %in% input$graphby.opts) %>%
        select(temporalstrat)%>%
        unique()
    } else if(input$Fixed.par == "Year"){
      dat%>%
        dplyr::filter(lme %in% input$lme) %>%
        dplyr::filter(eval(parse(text=quo_name(ColorCol()))) %in% input$bar.opts) %>%
        dplyr::filter(eval(parse(text=quo_name(FacetWrap.by()))) %in% input$graphby.opts) %>%
        select(year)%>%
        unique()
    }
  })

  observe({
    updateSelectInput(session =  session, inputId = "Fixed.opt", choices = choices_Fixed.opt())
  })


  FixedPAR <- reactive({
    FixedPAR<-if(input$Fixed.par == "Spatial Strata"){
      "spatialstrat"
    } else if(input$Fixed.par == "Temporal Strata"){
      "temporalstrat"
    } else if(input$Fixed.par == "Year"){
      "year"
    }
  })

#Create a plot
   output$GSI.Plot <- renderPlot({

     ColorColval<-quo_name(ColorCol())
     FacetWrap.byval<-quo_name(FacetWrap.by())
     FixedPARval<-quo_name(FixedPAR())

     plot.dat <- dat%>%
       dplyr::filter(lme %in% input$lme)%>%
       dplyr::filter(eval(parse(text=ColorColval)) %in% input$bar.opts)%>%
       dplyr::filter(eval(parse(text=FacetWrap.byval)) %in% input$graphby.opts)%>%
       dplyr::filter(eval(parse(text=FixedPARval)) %in% input$Fixed.opt)%>%
       mutate(reporting_group = factor(reporting_group,levels = c("SE Asia", "NE Asia",
                                "Western AK", "Up/Mid Yukon", "SW Alaska", "E GOA/PNW")
       ))


       ggplot(data=plot.dat,aes(reporting_group,mean,
                                color= factor(eval(parse(text=ColorColval))),
                                fill= factor(eval(parse(text=ColorColval))))) +
       geom_bar(stat="identity",position="dodge") +
       geom_errorbar(aes(ymin=lower, ymax=upper),
                     position=position_dodge(width = 0.90),
                     width=0.25,col="black")+
       theme_bw() +
       xlab("Reporting Group") +
       ylab("Proportion") +
       theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
             axis.title.x = element_text(size=16),
             axis.title.y = element_text(size=16),
             legend.title = element_blank(),
             legend.text=element_text(size=12))+
       facet_grid(eval(parse(text=FixedPARval)) ~ eval(parse(text=FacetWrap.byval)))+
         theme(strip.text.x = element_text(size = 12),
               strip.text.y = element_text(size = 12)
               )


   }, height = function() {
     0.75*session$clientData$output_GSI.Plot_width
     })

   output$GSI.Table <- DT::renderDataTable({
     ColorColval<-quo_name(ColorCol())
     FacetWrap.byval<-quo_name(FacetWrap.by())
     FixedPARval<-quo_name(FixedPAR())

     plot.dat<-dat%>%
       dplyr::filter(lme %in% input$lme)%>%
       dplyr::filter(eval(parse(text=ColorColval)) %in% input$bar.opts)%>%
       dplyr::filter(eval(parse(text=FacetWrap.byval)) %in% input$graphby.opts)%>%
       dplyr::filter(eval(parse(text=FixedPARval)) %in% input$Fixed.opt)%>%
       dplyr::select(c(1,2,3,4,8,10,12,14))
   })

}

####Run App####
# Run the application
shinyApp(ui = ui, server = server)

