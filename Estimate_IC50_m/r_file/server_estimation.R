#============================
# whole
#============================
server_estimation <- function(input, output, session, ans, filepath ){
   
   #============================
   # 0. data table
   #============================
   data <- reactive({
      filepath = filepath();
      #====== Judge what type of file? ======#
      if( is.null( ans$filename ) ){ return(NULL) } #case1: NULL
      if( str_detect(string=ans$filename, pattern = ".csv") == TRUE ){ #case2: csv
         df <- read.csv( filepath, header = input$header, sep = input$sep, quote = input$quote)
         return( df ) }
      if( str_detect(string=ans$filename, pattern = ".xlsx") == TRUE ){ #case3: xlsx
         df <- read.xlsx(filepath, sheet = defalt$read_sheet )
         return( df ) }
      if( str_detect(string=ans$filename, pattern = ".rds") == TRUE ){ df <- readRDS(filepath); return( df ) } #case4: rds
      if( str_detect(string=ans$filename, pattern = ".txt") == TRUE ){ #case5: csv
         df <- read.table( filepath, header = input$header, sep = input$sep, quote = input$quote)
         return( df ) } })
   
   # data table (again)
   output$contents2 <- renderTable({ 
      req( ans$file )
      head( data(), ans$head_data ) })

   #============================
   # 1. Select x- and y-value
   #============================
   observe({
      
      # x-value
      output$X = renderUI({
         if( is.null(ans$file) ) { NULL }
         if( !is.null(ans$file) || is.null(ans$col_X)  ){
            selectInput(inputId = "col_X",
                        label = 'どの"列"が薬剤濃度のデータですか？',
                        choices = c(colnames(data()), '列をご指定ください' = ''),
                        selected = '')}
         if( !is.null(ans$file) && !is.null(ans$col_X) ){
            selectInput(inputId = "col_X",
                        label = 'どの"列"が薬剤濃度のデータですか？',
                        choices = c(colnames(data()), '列をご指定ください' = ''  ),
                        selected = ans$col_X ) } })  
      
      # y-value
      output$Y = renderUI({
         if( is.null(ans$file) ) { NULL }
         if( !is.null(ans$file)|| is.null(ans$col_Y) ){
            checkboxGroupInput(inputId = "col_Y",
                               label = 'どの"列"が実験データですか？(平均データだけでも推定できます。また個別のデータ(複数可)でも推定できます)',
                               choices = c(colnames(data()) ), 
                               selected = ''             )}
         if( !is.null(ans$file)&& !is.null(ans$col_Y) ){
            checkboxGroupInput(inputId = "col_Y",
                               label = 'どの"列"が実験データですか？(平均データだけでも推定できます。また個別のデータ(複数可)でも推定できます)',
                               choices = c(colnames(data()) ), 
                               selected = ans$col_Y )} }) })
   
   # y-value
   ans_col_X <- reactive({
      if( is.null (ans$file) ) { ans$col_X = ''}
      if( !is.null(ans$file) ) { 
         if( is.null(input$col_X) ) { ans$col_X = '' }
         if( !is.null(input$col_X) ){ ans$col_X = input$col_X }
      }
      return( ans$col_X ) })
   
   # y-value
   ans_col_Y <- reactive({
      if( is.null (ans$file) ) { ans$col_Y = ''}
      if( !is.null(ans$file) ) { 
         if( is.null(input$col_Y) ) { ans$col_Y = '' }
         if( !is.null(input$col_Y) ){ ans$col_Y = input$col_Y } }
      return( ans$col_Y ) })
   
   observe({
      ans$col_X = ans_col_X(); 
      ans$col_Y = ans_col_Y(); })

   #============================
   # 2. Estimate IC50 and m
   #============================
   estimate_IC50_m <- reactive({
      # judge stop?
      req( ans$col_X ) 
      req( ans$col_Y )
      
      # setting
      data = data();
      est_col_X = ans$col_X; 
      est_col_Y = ans$col_Y;
      ex_num    = length( est_col_Y );
  
      # function
      newdf = data.frame();
      df_est_func <- function(i){
         d = data.frame( data[,est_col_X], data[,est_col_Y[i]] )
         names( d ) <- c("conc","fu")
         d = d[( 0<d[,"conc"] & 0<d[,"fu"] & d[,"fu"]<1 ), ] # &は1つで良い #d[(),]: ,は必要 #水田さんのと異なる理由；閾値の設定
         newdf <<- rbind( newdf, d )
         return( newdf ) }

      # make df for estimation
      df_est = lapply( 1:ex_num, df_est_func );
      
      nrow = dim( df_est[[ex_num]] )[1];
      ncol = dim( df_est[[ex_num]] )[2];
      
      x = matrix( c( log10(df_est[[ex_num]]$conc), rep( 1, nrow ) ), nrow = nrow, ncol = ncol )
      y = matrix( log10( (1-df_est[[ex_num]]$fu)/df_est[[ex_num]]$fu), nrow = nrow, ncol = 1 )
      
      sol = ginv( t(x) %*% x ) %*% t(x) %*% y
      return( sol ) })
   
   cnfm <- reactive({ 
      req( ans$col_Y ) 
      return( ans$col_Y ) })
   
   # summary
   est_IC50 <- reactive({ 
      return( 10^-( estimate_IC50_m()[2,1] / estimate_IC50_m()[1,1]) ) })
   
   est_m <- reactive({ 
      return( estimate_IC50_m()[1,1] ) })
   
   
   
   # est_download_print <- reactive({ 
   #    req( estimate_IC50_m() ) 
   #    return( '推定結果をダウンロードしますか?' ) })
   
   
   # Result part: output
   output$cnfm <- renderText({
      paste( "※推定するのに使用したデータ: ", cnfm(), sep="") })
   
   output$est_IC50 <- renderText({
      paste( "IC50の推定値は、", round(  10^-( estimate_IC50_m()[2,1] / estimate_IC50_m()[1,1]) , 3 ) ,sep="") })
   
   output$est_m <- renderText({
      paste( "mの推定値は", round( estimate_IC50_m()[1,1], 3 ) ,sep="") })
   
   # output$est_data_download = renderUI({
   #    if( !is.null( estimate_IC50_m() ) ){ 
   #       downloadButton( outputId = 'est', label = "test") } })
   # 
   # output$est = downloadHandler(
   #    filename1 = function(){"test.xlsx"},
   #    content1 = function( filename1 ) {
   #       x = matrix( c( log10(df_est[[ex_num]]$conc), rep( 1, nrow ) ), nrow = nrow, ncol = ncol )
   #       y = matrix( log10( (1-df_est[[ex_num]]$fu)/df_est[[ex_num]]$fu), nrow = nrow, ncol = 1 )
   #       write.xlsx( data.frame( x=x, y=y), filename, row.names = FALSE,col.names = FALSE ) 
   #    })
      
   
   output$show_download_button = renderUI({
      if( !is.null( estimate_IC50_m() ) ){ 
         downloadButton( outputId = 'est_summary', label = "推定結果のダウンロード (csvファイルをダウンロードします)") } })
   
   output$est_summary <- downloadHandler(
      filename = function(){"est_summary.csv"},
      content = function( filename ) {
         #est_IC50 = 10^-( estimate_IC50_m()[2,1] / estimate_IC50_m()[1,1]);
         #est_m = estimate_IC50_m()[1,1];
         outputfile = data.frame( estimated_IC50 = est_IC50(), estimated_m=est_m() )
         write.csv( outputfile, filename, row.names = FALSE,col.names = FALSE ) })
   
   #============================
   # 3. IC90_99
   #============================
   ICXX <- reactive({
      #return( 0.5*( ( 1 - (input$test *(1/100)) ) / ( input$test *(1/100) ) )^(1/2) ) 
      return( est_IC50()*( ( input$test *(1/100) ) / ( 1 - ( input$test *(1/100) ) ) )^(1/est_m()) ) 
   })
   
   # observe({
   #    print( ICXX() )
   # })
   
   output$IC90 <- renderText({
      paste( 'IC', input$test,'は、', ICXX(), 'です',  sep="") })
   
} #END








