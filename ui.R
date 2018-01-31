
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(tm)
library(wordcloud)
library(memoise)
library(dplyr)
library(ggplot2)
library(data.table)
source("loaddata.R")

shinyUI(navbarPage("SOA PAF Article Index",
                   
                   # Word cloud of most common keywords
                   tabPanel("Word Cloud", 
                            titlePanel("PAF Article Keyword Word Cloud"),
                            
                            # Sidebar with a slider input for number of bins
                            sidebarLayout(
                              sidebarPanel(
                                sliderInput("range",
                                            "Frequency range:",
                                            min = 1,  max = 50, value = c(1,15)),
                                sliderInput("max",
                                            "Maximum Number of Words:",
                                            min = 1,  max = 110,  value = 100)
                              ),
                              
                              # Show a plot of the generated distribution
                              mainPanel(
                                plotOutput("articlePlot2")
                              )
                            )),    
                   
                   # Frequencies of categorical article descriptors
                   tabPanel("Frequencies", 
                            titlePanel("PAF Article Information Frequencies"),
                            
                            # Sidebar with a slider input for number of bins
                            sidebarLayout(
                              sidebarPanel(
                                selectInput('xvar', 'Dimension:', 
                                            names(articledata)[c(1, 2, 7:12, 15, 19, 22, 23)],
                                            selected="Last")
                              ),
                              
                              # Show a plot of the generated distribution
                              mainPanel(
                                plotOutput("articlePlot")
                              )
                            )),
                   
                   # Table of article descriptors with filters enabled
                   tabPanel("Table", 
                            titlePanel("PAF Article Information Table"),
                            
                            fluidRow(
                              column(4,
                                     selectInput("nlast",
                                                 "Author last name:",
                                                 c("All",
                                                   sort(unique(as.character(articledata$Last)))))
                              ),
                              column(4,
                                     selectInput("dissue",
                                                 "Newsletter issue date:",
                                                 c("All",
                                                   unique(as.character(articledata$Date))))
                              )
                            ),
                            # Create a new row for the table.
                            fluidRow(
                              DT::dataTableOutput("articleTable")
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
