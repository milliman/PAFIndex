
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

# Ensure for word cloud that plot is repeatable within a single session despite random component
wordcloud_rep <- repeatable(wordcloud)


shinyServer(function(input, output) {

  # Word Cloud  
  output$plot.wordcloud <- renderPlot({
    
    # #Create table to hold keywords by article
    # KeywordList <- data.table(Name = articledata$Keywords,
    #                           Index = 1:dim(articledata)[1])
    # 
    # # Create table to count articles with individual keywords
    # KeywordCount <- data.frame(keywords, Count = 0)
    # 
    # # Fill in table with frequency of keywords
    # for (i in 1:dim(KeywordCount)[1]){
    #   KeywordCount[i, 2] <- dim(KeywordList[like(Name, KeywordCount[i, 1])])[1]
    # }
    # 
    # # Generate a wordcloud of the relative frequencies
    # # Implement upper bound on frequency
    # KeywordCount.filter <- filter(KeywordCount,
    #                               Count < input$i.range[2])
    
    KeywordCount.filter <- data.frame(keywords) %>% 
      mutate(Count = sapply(keywords, function(x) length(grep(x, articledata$Keywords)))) %>%
      filter(Count < input$i.range[2])
    
    par(mar = c(0,0,0,0))
    
    # Implement lower bound on frequency and max words in cloud
    wordcloud_rep(KeywordCount.filter$keywords, 
                  KeywordCount.filter$Count, 
                  scale=c(4,0.5),
                  min.freq = input$i.range[1], 
                  max.words=input$i.max,
                  colors=brewer.pal(8, "Dark2"))
  })
  
  # Barplot of frequencies
  output$plot.frequency <- renderPlot({
    
    # Generate a barplot of the relative frequencies
    # Simpler code that produces a plot without filter
    # ggplot(articledata, aes_string(input$i.xvar)) + geom_bar() + coord_flip()
    
    # Two-step code that summarizes data and implements count filter
    articledata %>% 
      group_by_(input$i.xvar) %>% 
      mutate(N = n()) %>% 
      filter(N >= input$i.countrange[1]) %>% 
      filter(N <= input$i.countrange[2]) %>% 
      ggplot(aes_string(input$i.xvar)) + geom_bar() + coord_flip()  

  })

  # Table  
  output$table.2filters <- DT::renderDataTable(DT::datatable({      
    
    # Generate a table of articles fitting two criterion
    data <- articledata
    if (input$i.nlast != "All") {
      data <- data[data$Last == input$i.nlast,]
    }
    if (input$i.dissue != "All") {
      data <- data[data$Date == input$i.dissue,]
    }
    data[, c(2, 9:10, 13, 21, 16, 24, 17, 6)]
  }))
  
  # Built in Shiny example of dynamic histogram
  output$distPlot <- renderPlot({

    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')

  })
  

})
# select keyword to search for (UI)
# apply search for keyword in x and count yesses
# plot bar chart of sorted keywords found
# make case insensitive and repeat