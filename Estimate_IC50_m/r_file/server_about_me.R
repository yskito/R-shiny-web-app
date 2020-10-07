#============================
# whole
#============================
server_about_me <- function(input, output, session){
   my_url <- a("See my web app", href="https://yskito.shinyapps.io/WhoisYusukeIto/")
   output$about_me <- renderUI({
      tagList( h3( my_url) )
   }) }
