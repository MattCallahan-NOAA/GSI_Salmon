#
# This is a Shiny web application for displaying salmon genetic
# stock identification (GSI) information.

library(shiny)
library(tidyverse)
library(DT)
library(scales)
library(lubridate)
library(qdapRegex)


#Pull and format AKRO mortality estimates

CurrentYear<-lubridate::year(Sys.Date())
RprtYear <- CurrentYear - 1

#Chinook
BSAImort = readLines(paste('https://www.fisheries.noaa.gov/sites/default/files/akro/chinook_salmon_mortality',CurrentYear,'.html',sep=""))

BSAImort<-gsub(pattern=",","",BSAImort)
FirstLines<-grep("Chinook salmon mortality in BSAI pollock directed fisheries",BSAImort) #read in morality for pollock directed fisheries
LastYearLines <-grep(paste(">",CurrentYear,"<",sep=""),BSAImort)[2]

DatLines <- grep(">[0-9]+<",BSAImort) %>% #just give me the lines with data
  {.[. > FirstLines]} %>%
  {.[. < LastYearLines]}

BlankDat<-c(DatLines[3]+3,DatLines[7]+3,DatLines[7]+6,#1991 missing
            DatLines[10]+3,DatLines[14]+3,DatLines[14]+6,#1992 missing
            DatLines[17]+3,DatLines[21]+3,DatLines[21]+6)#1993 missing

DatLines<-c(DatLines,BlankDat) %>% sort()

BSAImortDat<-sapply(DatLines,function(x) BSAImort[x] %>%
                      qdapRegex::rm_between(.,">","<",extract=T)%>%
                      unlist())

#AKRO has blank spaces for CDQ in 1991

BSAImortmat <- matrix(data=BSAImortDat,ncol=10,nrow=length(BSAImortDat)/10,byrow=T)

colnames(BSAImortmat)<-c("Year","BSAI_Annual","BSAI_Annual_noCDQ","BSAI_Annual_CDQ","BSAI_SeasonA","BSAI_SeasonB","BSAI_SeasonA_noCDQ","BSAI_SeasonB_noCDQ","BSAI_SeasonA_CDQ","BSAI_SeasonB_CDQ")

Chinook_BSAImortMeltMat<- BSAImortmat %>%
  as_tibble() %>%
  mutate_at(2:10,as.numeric)%>%
  reshape2::melt(.,id.vars=c("Year"))%>%
  filter(Year %in% seq(1991,RprtYear,1))%>%
  mutate(Year = as.numeric(Year))%>%
  mutate(Species="Chinook Salmon")

#Chum
BSAImort = readLines(paste('https://www.fisheries.noaa.gov/sites/default/files/akro/chum_salmon_mortality',CurrentYear,'.html',sep=""))

BSAImort<-gsub(pattern=",","",BSAImort)
FirstLines<-grep("Non-Chinook salmon mortality in BSAI pollock directed fisheries",BSAImort) #read in morality for pollock directed fisheries
LastYearLines <-grep(paste(">",CurrentYear,"<",sep=""),BSAImort)[2]

DatLines <- grep(">[0-9]+<",BSAImort) %>% #just give me the lines with data
  {.[. > FirstLines]} %>%
  {.[. < LastYearLines]}

BlankDat<-c(DatLines[3]+3,DatLines[7]+3,DatLines[7]+6,#1991 missing
            DatLines[10]+3,DatLines[14]+3,DatLines[14]+6,#1992 missing
            DatLines[17]+3,DatLines[21]+3,DatLines[21]+6)#1993 missing

DatLines<-c(DatLines,BlankDat) %>% sort()

BSAImortDat<-sapply(DatLines,function(x) BSAImort[x] %>%
                      qdapRegex::rm_between(.,">","<",extract=T)%>%
                      unlist())

#AKRO has blank spaces for CDQ in 1991

BSAImortmat <- matrix(data=BSAImortDat,ncol=10,nrow=length(BSAImortDat)/10,byrow=T)

colnames(BSAImortmat)<-c("Year","BSAI_Annual","BSAI_Annual_noCDQ","BSAI_Annual_CDQ","BSAI_SeasonA","BSAI_SeasonB","BSAI_SeasonA_noCDQ","BSAI_SeasonB_noCDQ","BSAI_SeasonA_CDQ","BSAI_SeasonB_CDQ")

Chum_BSAImortMeltMat<- BSAImortmat %>%
  as_tibble() %>%
  mutate_at(2:10,as.numeric)%>%
  reshape2::melt(.,id.vars=c("Year"))%>%
  filter(Year %in% seq(1991,RprtYear,1))%>%
  mutate(Year = as.numeric(Year))%>%
  mutate(Species="Chum Salmon")

#Bind the data together for processing
dat <- rbind(Chinook_BSAImortMeltMat,Chum_BSAImortMeltMat)

####User Interface####
# Define UI
ui <- fluidPage(
  tags$head(includeHTML("google-analytics.html")),
  # Application title
   titlePanel("Salmon mortality in BSAI pollock directed fisheries."),

   # Sidebar with reactive dropdowns based on the criteria selected
   sidebarLayout(
      sidebarPanel(
        selectInput(inputId = "Species", label = "Species", choices = c("Chum Salmon","Chinook Salmon"), selected = "Chum Salmon",multiple=TRUE),
        selectizeInput("fisheryInput","Fishery",
                    choices = c("BSAI_ANNUAL"), selected = c("BSAI_ANNUAL"), multiple = FALSE)
      ),
      # Show a plot of the generated distribution
      mainPanel(
        tags$style(type="text/css",
                   ".shiny-output-error { visibility: hidden; }",
                   ".shiny-output-error:before { visibility: hidden; }"
        ),
        tabsetPanel(type = "tabs",
                    tabPanel("Plot",plotOutput("mortPlot",height="auto")),
                    tabPanel("Table", DT::dataTableOutput("mortTable"))
        )
      )
   )
)


####Server####
server <- function(input, output, session) {

updateSelectizeInput(session, 'fisheryInput',
                     choices = dat$variable,
                     server = TRUE
)

#Create a plot
   output$mortPlot <- renderPlot({

     #ColorColval<-quo_name(ColorCol())
     #FacetWrap.byval<-quo_name(FacetWrap.by())
     #FixedPARval<-quo_name(FixedPAR())

     plot.dat <- dat%>%
       dplyr::filter(variable %in% input$fisheryInput)%>%
       dplyr::filter(Species %in% input$Species)

       ggplot(data=plot.dat,aes(x = Year,
                                y = value)) +
       geom_point(col="black") +
       geom_line(col="red") +
       theme_bw() +
       xlab("Year") +
       ylab("Number of Salmon") +
       theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
             axis.title.x = element_text(size=16),
             axis.title.y = element_text(size=16),
             legend.title = element_blank(),
             legend.text=element_text(size=12))+
        scale_y_continuous(labels=scales::comma)+
       facet_wrap(~Species,ncol=1,scales="free_y")+
         theme(strip.text.x = element_text(size = 12),
               strip.text.y = element_text(size = 12)
               )


   }, height = function() {
     0.75*session$clientData$output_mortPlot_width
     })

   output$mortTable <- DT::renderDataTable({

     plot.dat <- dat%>%
       dplyr::filter(variable %in% input$fisheryInput)%>%
       dplyr::filter(Species %in% input$Species)
   })

}

####Run App####
# Run the application
shinyApp(ui = ui, server = server)

