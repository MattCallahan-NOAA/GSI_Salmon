# This is a Shiny web application landing page that describes a few
# applications for the salmon PSC analyses AFSC does

library(shiny)
library(shinyBS)
library(shinyLP)
library(shinythemes)


####User Interface####
# Define UI
ui <- fluidPage(
  tags$head(includeHTML("google-analytics.html")),
list(tags$head(HTML('<link rel="icon", href="logo.png",
                        type="image/png" />'))),
div(style="padding: 1px 0px; width: '100%'",
    titlePanel(
      title="", windowTitle="AFSC Salmon Bycatch"
    )
),

navbarPage(title=div(img(src="NOAA_logo.png"), "AFSC Salmon Bycatch"),
           inverse = F, # for diff color view
           theme = shinytheme("spacelab"),

           tabPanel("Home", icon = icon("home"),

                    jumbotron("Salmon Prohibited Species Catch", "An interactive web application to explore the NMFS annual bycatch reports.",
                              buttonLabel = "Reports"),
                    fluidRow(
                      column(12, panel_div(class_type = "info", panel_title = "About",
                                           content = "Chinook and chum salmon that are caught in Alaska’s federally managed groundfish trawl fisheries are designated as prohibited species catch (PSC).
                                           Understanding the stock compositions of PSC in large groundfish fisheries is
                                           important for informing stock-specific management. The Alaska Fishery Science center's genomics laboratory analyzes samples collected by fisheries observers
                                           and uses genetic baselines of spawning stocks to assign samples back to their stock of origin. These results are then shared
                                           with resource managers at the North Pacific Fishery Management Council to help make informed management decisions"))
                    ),  # end of fluidRow
                    fluidRow(
                      column(12, panel_div(class_type = "primary", panel_title = "Directions",
                                          content = "Information about the bycatch analyses for each species can be found in the top navigation menu. Currently there
                                          are two main applications that allow the user to: (1) look at the spatial distribution of the bycatch by year and (2) compare genetic results within
                                          and among years for multiple spatiotemporal analyses. Information about these species specific analyses are detailed in their respective pages.
                                          For further information the annual reports are accessable through the Reports link above."))
                    ),  # end of fluidRow
                    fluidRow(
                      column(4, panel_div("success", "Application Maintainers",
                                          HTML("For general questions, or sugguestions about additional applications please contact <a href='mailto:patrick.barry@noaa.gov?Subject=Shiny%20Help' target='_top'>Patrick Barry.</a>",
                                               "If the applications are not loading and the server is not working please contact <a href='mailto:matt.callahan@noaa.gov?Subject=Shiny%20Help' target='_top'>Matt Callahan.</a>"))),
                      column(4, panel_div("info", "App Status",
                                          HTML("This shiny app is being developed on GitHub and will be updated regularly. If you are interested
                                          in helping develop new applications please feel free to fork the repository and contribute at <a href='https://github.com/patbarry6' target='_top'>github.com/patbarry6</a>"))),
                      column(4, panel_div("danger", "Acknowledgements", div(HTML("This application was developed with funding from the"),
                                          a(href="http://www.pccrc.org", "Pollock Conservation Cooperative Research Center."),
                                          HTML(" It is hosted on a server managed by the Alaska Fisheries Information Network.")))),

                      #### FAVICON TAGS SECTION ####
                      tags$head(tags$link(rel="shortcut icon", href="favicon.ico")),

                      bsModal("modalExample", "Bycatch Reports", "tabBut", size = "large" ,
                              p("Annual bycatch reports produced by the Alaska Fishery Science Center genetics lab can be found on their website"),
                              a(img(src="AFSC_Genetics.png", height="75%", width="90%"), href="https://www.fisheries.noaa.gov/alaska/science-data/genetics-research-alaska-fisheries-science-center")
                      )

                    )),
           tabPanel("Chum Salmon", icon = icon("home"),
                    wells(content = "Description of the chum salmon bycatch analyses",
                          size = "default"),
                    h1("Chum Salmon", align = "center"),
                    fluidRow(
                      column(12, panel_div(class_type = "primary", panel_title = "Introduction",
                                           content = div(HTML("Chum salmon (<em>Oncorhynchus keta</em>) that are caught in Alaska’s federally managed groundfish trawl fisheries
                                                              are designated as prohibited species catch (PSC). The Alaska Fisheries Science Center (AFSC)
                                                              analyzes the genetic stock compositions of chum salmon PSC samples collected from the walleye
                                                              pollock (<em>Gadus chalcogrammus</em>) fishery in the Bering Sea. It is important to understand the
                                                              stock composition of Pacific salmon caught in these fisheries, which take place in areas that are known
                                                              feeding habitat for multiple brood years of chum salmon from many different localities in North America
                                                              and Asia."))))
                    ),
                    fluidRow(
                      column(12, panel_div(class_type = "info", panel_title = "Sampling",
                                           content = div(HTML("Genetic samples are collected from the chum salmon caught in the Bering Sea pollock fishery by the North Pacific Groundfish and
                                                              Halibut Observer Program (Observer Program). In 2011, a systematic sampling protocol was implemented
                                                              with a goal to sample axillary processes (for genetic analysis) and scales (for ageing) from
                                                              every 30th chum salmon throughout the season."))))
                    ),
                    fluidRow(
                      column(12, panel_div(class_type = "warning", panel_title = "Genetic Methods",
                                           content = div(HTML("Often the number of genetic samples recieved exceeds the capacity of AFSC's genetics lab
                                                              and the chum salmon samples are subsampled. Samples are sorted by cruise, haul or offload, and
                                                              specimen number and subsampled to maintain a systematic sampling of the bycatch throughout
                                                              the fishing season. DNA is extracted and genetic markers are amplified and scored.
                                                              Prior to 2021, AFSC used a suite of 11 microsatellite loci to estimate geneitc stock compositions,
                                                              but has since transition to 85 single nucleotide polymorphisms. Samples are sequenced on a
                                                              Illumina MiSeq short read sequencer and scored with R package <em>GTscore</em>."))))
                    ),
                    fluidRow(
                      column(12, panel_div(class_type = "success", panel_title = "Genetic Analyses",
                                           content = div(HTML("Stock compositions are determined with mixed-stock analysis (MSA) by comparing mixture genotypes with
                                                              allele frequencies from reference baseline populations. Baseline populations were grouped into six regions:
                                                              Southeast Asia (SE Asia), Northeast Asia (NE Asia), Western Alaska (W Alaska), Upper/Middle Yukon (Up/Mid Yukon),
                                                              Southwest Alaska (SW Alaska), and the Eastern GOA/Pacific Northwest (EGOA/PNW)"),
                                                         HTML('<center><img src="ChumRepGrps.png">
                                                              <figcaption>Six regional groups of baseline chum salmon populations used to estimate stock compositions.</figcaption></center>
                                                              <br>'),
                                                     div(HTML("The stock composition analyses for the chum salmon samples are performed with the Bayesian conditional MSA approach
                                                              with bootstrapping over reporting groups implemented in the R package <em>rubias</em>.
                                                              A variety of analyses are performed on the data to explore spatiotemporal trends in the data. These analyses include:
                                                              <ul>
                                                                <li><b>Bseason</b>: A full analysis of the bycatch from the pollock fishery.</li>
                                                                <li><b>Early, Middle, & Late</b>: The Bering Sea sample set from the B-season is split into three time periods. The
                                                                early period includes samples up to week 29 (July 20), the middle includes samples from week 30 to 34 (to 24 August),
                                                                and the late period includes all samples after week 34. </li>
                                                                <li><b>East and West of 170<span>&#176;</span>W</b>: Genetic samples from the B-season are split into two areas: the
                                                                U.S. waters of the Bering Sea west of 170<span>&#176;</span>W (areas 521, 523, and 524), and the southeastern Bering Sea east
                                                                of 170<span>&#176;</span>W (areas 509, 513, 516, 517, and 519). </li>
                                                                <li><b>Processing Sector</b>: Samples taken by each processing sector are analyzed separately: Catcher processors (CP),
                                                                Mothership (M), and Shoreside (S). </li>
                                                                <li><b>Clusters 1, 2, 3, & 4</b>: In order to provide more fine-scale spatial and temporal information about the
                                                                stock specific distribution of salmon PSC, NMFS areas were grouped into four clusters (see below) and analyses are performed
                                                                for two time periods; early - statistical weeks 23-32, and late - statistical weeks 33-43. </li>
                                                              </ul>
                                                              <br>")),
                                                     div(HTML('<center><img src="ShinyMap_bycatch_clusters_2021WithScale_small.png">
                                                              <figcaption>Samples from the B-season are aggregated into Early (statistical weeks 23-32) and <br>Late (statistical weeks 33-43) time periods
                                                              at four spatial clusters based on<br> ADF&G statistical areas along the continental shelf edge.</figcaption></center>')))))
                    ),
                    hr()


           ),
           tabPanel("Chinook Salmon", icon = icon("home"),
                    wells(content = "Description of the Chinook salmon bycatch analyses",
                          size = "default"),
                    h1("Chinook Salmon", align = "center"),
                    fluidRow(
                      column(12, panel_div(class_type = "primary", panel_title = "Introduction",
                                           content = div(HTML("Chinook salmon (<em>Oncorhynchus tshawytscha</em>) that are caught in Alaska’s federally managed groundfish trawl fisheries
                                                              are designated as prohibited species catch (PSC). A genetic analysis of samples from the Chinook salmon
                                                              bycatch of the Bering Sea-Aleutian Island (BSAI) trawl fishery for walleye pollock (<em>Gadus chalcogrammus</em>) is
                                                              undertaken annually to determine the overall stock composition of the bycatch and examine temporal changes in
                                                              stock composition across seasons."))))
                    ),
                    fluidRow(
                      column(12, panel_div(class_type = "info", panel_title = "Sampling",
                                           content = div(HTML("Genetic samples are collected from the Chinook salmon caught in the Bering Sea pollock fishery by the North Pacific Groundfish and
                                                              Halibut Observer Program (Observer Program). In 2011, a systematic random sampling design was implemented
                                                              with a goal to sample axillary processes (for genetic analysis) and scales (for ageing) from
                                                              every 10th Chinook salmon throughout the A and B fishing seasons. Axillary process tissues are sampled by
                                                              observers, stored in individually labeled coin envelopes,
                                                              frozen, and later shipped to AFSC genomics lab for analysis."))))
                    ),
                    fluidRow(
                      column(12, panel_div(class_type = "warning", panel_title = "Genetic Methods",
                                           content = div(HTML("DNA is extracted and genetic markers are amplified and scored.
                                                              Prior to 2021, AFSC used a suite of 43 single nucleotide polymorphism (SNP) loci to estimate
                                                              geneitc stock compositions,
                                                              but has since transition to 37 SNP loci with a change in genotyping chemistry. Samples are sequenced on a
                                                              Illumina MiSeq short read sequencer and scored with R package <em>GTscore</em>."))))
                    ),
                    fluidRow(
                      column(12, panel_div(class_type = "success", panel_title = "Genetic Analyses",
                                           content = div(HTML("Stock compositions are determined with mixed-stock analysis (MSA) by comparing mixture genotypes with
                                                              allele frequencies from reference baseline populations. Baseline populations were grouped into eleven regions:
                                                              Russia, Coastal Western Alaska, Middle Yukon, Upper Yukon, North Alaska Penninsula, Northwest Gulf of Alaska, Copper River,
                                                              Northeast Gulf of Alaska, Coastal Southeast Alaska, British Columbia, and West Coast US.
                                                              <br>
                                                              <br>"),
                                                         HTML('<center><img src="ChinookRepGrps_small.png">
                                                              <figcaption>Eleven regional groups of baseline Chinook salmon populations used to estimate stock compositions.</figcaption></center>
                                                              <br>
                                                              <br>'),
                                                         div(HTML("The stock composition analyses for Chinook salmon samples are performed with the Bayesian conditional MSA approach
                                                              with bootstrapping over reporting groups implemented in the R package <em>rubias</em>.
                                                              A variety of analyses are performed on the data to explore spatiotemporal trends in the data. These analyses include:
                                                              <ul>
                                                                <li><b>A season</b>: Analysis of the bycatch from the pollock fishery A season.</li>
                                                                <li><b>B season</b>: Analysis of the bycatch from the pollock fishery B season.</li>
                                                                <li><b>Catcher Vessel Operation Area (CVOA)</b>: Located south of 56<span>&#176;</span>N latitude,
                                                                      between 163-168<span>&#176;</span>W longitude in the Bering Sea ). </li>
                                                                <li><b>NMFS areas</b>: When possible (sample sizes are large enough), NMFS areas are run individually, typically this is restricted to area 509. </li>
                                                                <li><b>Northwest and Southeast Bering</b>: Genetic samples from the B-season are split into two areas by
                                                                      167<span>&#176;</span>W longitude.</li>
                                                              </ul>
                                                              <br>")),
                                                         div(HTML('<center><img src="ShinyChinookMap_small.png">
                                                              <figcaption>Samples from the B-season are aggregated into Early (statistical weeks 23-32) and <br>Late (statistical weeks 33-43) time periods
                                                              at four spatial clusters based on<br> ADF&G statistical areas along the continental shelf edge.</figcaption></center>')))))
                    ),
                    hr()


           ),

           tabPanel("Applications", icon = icon("cog"),

                    jumbotron("Web based applications", "Spatiotemporal Trends in Salmon PSC in the Bering Sea",
                              button = FALSE),
                    hr(),
                    fluidRow(
                      column(4, thumbnail_label(image = 'Map_Icon.png', label = 'Application 1: Spatial distribution of the salmon bycatch.',
                                                content = 'Explore spatial distribution of salmon PSC by year.',
                                                button_link = 'https://connect.fisheries.noaa.gov/GSI_Salmon_PSCMaps/', button_label = 'Click me')
                      ),
                      column(4, thumbnail_label(image = 'BargraphIcon.png', label = 'Application 2: Genetic stock composition estimates by reporting group.',
                                                content = 'Explore the genetic results by spatiotemporal analysis.',
                                               # button_link = 'https://shinyfin.psmfc.org/GSI_Salmon_MixedStockComparisons/', button_label = 'Click me')),
                                               button_link = 'https://connect.fisheries.noaa.gov/GSI_Salmon_Comparisons/', button_label = 'Click me')),
                      column(4, thumbnail_label(image = 'LinegraphIcon.png', label = 'Application 3: Yearly Salmon Mortality Estimates',
                                                content = 'Explore the estimates of PSC mortality by fishery and species.',
                                                button_link = 'https://connect.fisheries.noaa.gov/GSI_Salmon_PSCmortality/', button_label = 'Click me'))
                    )))

) # end of fluid page

####Server####
server <- function(input, output, session) {
}

####Run App####
# Run the application
shinyApp(ui = ui, server = server)

