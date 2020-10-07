#==============================
# setting
#==============================

#==============================
# whole
#==============================
server_IC50_90_99 <- function(input, output, session ){
   ICXX <- reactive({
      return( 0.5*( ( 1 - input$test *(1/100) ) / ( input$test *(1/100) ) )^(1/2) ) 
   })
   
   observe(
      print( ICXX() )
   )
}

# EN