
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

# Define and load required packages
required.packages <- c("shiny", 
                       "dplyr", 
                       "tm", 
                       "wordcloud", 
                       "memoise", 
                       "ggplot2", 
                       "data.table")
new.packages <- required.packages[!(required.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(required.packages, require, character.only = TRUE)

# Load data
source("loaddata.R")

# Set up user interface
shinyUI(navbarPage("SOA PAF Article Index",
                   
                   # Word cloud of most common keywords
                   tabPanel("Word Cloud", 
                            titlePanel("PAF Article Keyword Word Cloud"),
                            
                            # Sidebar with a slider input for number of bins
                            sidebarLayout(
                              sidebarPanel(
                                sliderInput("i.range",
                                            "Frequency range:",
                                            min = 1,  max = 50, value = c(1, 15)),
                                sliderInput("i.max",
                                            "Maximum Number of Words:",
                                            min = 1,  max = 110,  value = 100)
                              ),
                              
                              # Show a plot of the generated distribution
                              mainPanel(
                                plotOutput("plot.wordcloud")
                              )
                            )),    
                   
                   # Frequencies of categorical article descriptors
                   tabPanel("Frequencies", 
                            titlePanel("PAF Article Information Frequencies"),
                            
                            # Sidebar with a slider input for number of bins
                            sidebarLayout(
                              sidebarPanel(
                                selectInput('i.xvar', 'Dimension:', 
                                            names(articledata)[c(1, 2, 7:12, 15, 19)],
                                            selected="Last")
                              ),
                              
                              # Show a plot of the generated distribution
                              mainPanel(
                                plotOutput("plot.frequency")
                              )
                            )),
                   
                   # Table of article descriptors with filters enabled
                   tabPanel("Table", 
                            titlePanel("PAF Article Information Table"),
                            
                            # Set up two filters for table
                            fluidRow(
                              column(4,
                                     selectInput("i.nlast",
                                                 "Author last name:",
                                                 c("All",
                                                   sort(unique(as.character(articledata$Last)))))
                              ),
                              column(4,
                                     selectInput("i.dissue",
                                                 "Newsletter issue date:",
                                                 c("All",
                                                   unique(as.character(articledata$Date))))
                              )
                            ),
                            
                            # Create a new row for the table.
                            fluidRow(
                              DT::dataTableOutput("table.2filters")
                            )
                   ),
                   
                   # Built in Shiny example - translated to multi-tab presentation
                   # Application title
                   tabPanel("Old Faithful Geyser Data", 
                            titlePanel("Old Faithful"),
                            
                            # Sidebar with a slider input for number of bins
                            sidebarLayout(
                              sidebarPanel(
                                sliderInput("bins",
                                            "Number of bins:",
                                            min = 1,
                                            max = 50,
                                            value = 30)
                              ),
                              
                              # Show a plot of the generated distribution
                              mainPanel(
                                plotOutput("distPlot")
                              )
                            )
                   )
                   
))
