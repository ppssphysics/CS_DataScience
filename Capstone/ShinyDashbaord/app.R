
options(warn=-1)

source("config.R")
source("functions.R")

infoText <- readLines(con="inforeadme.html")

ui = fluidPage(
	
    includeCSS("style.css"),
    
    mainPanel(
    	
    	width=11,
    	br(),
     
    	fluidRow(
    		align="right",
    		tags$body(" Info "),
    		actionLink("info", icon("info-circle", "fa-4x")),
    		tags$body(" GitHub "),
    		tags$a(href = "https://github.com/ppssphysics", icon("github","fa-4x"))
     ),

    	titlePanel("#GetYourNextWordPredicted"),
			br(),
    	htmlOutput('textintro'),
  
    	br(),
    	br(),
    	fluidRow(textInput(inputId="userinput",label=NULL,width="70%",placeholder = "Start typing your text here")),
    	htmlOutput('wordpredict'),
    	
    	br(),
    	tags$hr(),
    	htmlOutput('textpedag'),
    	
    	br(),
    	br(),
    	fluidRow(
    		column(width=7,DT::dataTableOutput("ngramtable"))
    	)
    	
    ),

    bsModal(id="description", "Information", "info", size = "large",HTML(infoText))
    
)



server = function(input, output, session) {

	objreact <- reactiveValues(
		word1 = as.character(),
		word2 = as.character(),
		word3 = as.character(),
		resultstable = data.frame()
	)

	observeEvent(input$userinput,{
		
	  #print(input$userinput)
	  
		if (input$userinput=="") {
		  dn1$Match <- 0
		  dn1$found <- "pending"
		  dn1$MatchScore <- 0
			objreact$resultstable <- dn1
			objreact$word1 <- dn1[1,4]#"Waiting"
			objreact$word2 <- dn1[2,4]#"Waiting"
			objreact$word3 <- dn1[3,4]#"Waiting"
		}
		else {
			objreact$resultstable <- predictnextword(input$userinput)
			listpredict <- getnextwords(objreact$resultstable)
			objreact$word1 <- listpredict[[1]]
			objreact$word2 <- listpredict[[2]]
			objreact$word3 <- listpredict[[3]]
		}
		
	})
	
	output$textintro <- renderUI({ 
		HTML("This small application predicts your next word while writing a sentence. The prediction is based on most 
							probable combinations of words constructed based on large corpus of english text from 
							news, blogs and twitter posts. More information available in the top-right Information icon.") })
	
	output$wordpredict <- renderUI({
		HTML(paste("The next most probable word is:<br/>",objreact$word1)) })
	
	output$textpedag <- renderUI({
		HTML("The app is constructed with a pedagogical purpose in mind, displaying elements of 
							the underlying processes as they are working towards a prediction. The table below 
							shows the dynamic sub-setting and probability (re)-calculations associated to so-called ngrams that allow to search for the next most 
							probable word.") })
				
				
	output$ngramtable <- DT::renderDataTable({

		datatable(
		  objreact$resultstable[,c(1,3,4,5,7,8)],
		  rownames=FALSE,
		  options = list(
		    pageLength=20,
		    initComplete = JS(
		      "function(settings, json) {",
		      "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
																																													"}"))) %>%
			formatStyle('Unique Words',backgroundColor ="#262626",color="#FFFFFF") %>%
			formatStyle('Probability',backgroundColor ="#262626",color="#FFFFFF") %>%
	    formatStyle('NextWord',backgroundColor ="#262626",color="#FFFFFF") %>%
	    formatStyle('ngram',backgroundColor ="#262626",color="#FFFFFF") %>%
			formatStyle('found',backgroundColor ="#262626",color="#FFFFFF") %>%
	  formatStyle('MatchScore',backgroundColor ="#262626",color="#FFFFFF")
		  
	})
	
}
    

shinyApp(ui = ui, server = server)

