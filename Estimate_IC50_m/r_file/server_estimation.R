#============================
# whole
#============================
server_estimation <- function(input, output, session, ans, filepath ){
   
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

   observe({
      
      # x-value
      output$X = renderUI({
         if( is.null(ans$file) ) { NULL }
         if( !is.null(ans$file) || is.null(ans$col_X)  ){
            selectInput(inputId = "col_X",
                        label = "どの列が薬剤濃度のデータですか？",
                        choices = c(colnames(data()), '列をご指定ください' = ''),
                        selected = '')}
         if( !is.null(ans$file) && !is.null(ans$col_X) ){
            selectInput(inputId = "col_X",
                        label = "どの列が薬剤濃度のデータですか？",
                        choices = c(colnames(data()), '列をご指定ください' = ''  ),
                        selected = ans$col_X ) } })  
      
      # y-value
      output$Y = renderUI({
         if( is.null(ans$file) ) { NULL }
         if( !is.null(ans$file)|| is.null(ans$col_Y) ){
            checkboxGroupInput(inputId = "col_Y",
                               label = "どの列が実験データですか？(平均データのみでも推定できます。また複数の各々のデータでも推定できます)",
                               choices = c(colnames(data()) ), 
                               selected = ''             )}
         if( !is.null(ans$file)&& !is.null(ans$col_Y) ){
            checkboxGroupInput(inputId = "col_Y",
                               label = "どの列が実験データですか？(平均データのみでも推定できます。また複数の各々のデータでも推定できます)",
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
   
   # est_download_print <- reactive({ 
   #    req( estimate_IC50_m() ) 
   #    return( '推定結果をダウンロードしますか?' ) })
   
   
   # Result part: output
   output$cnfm <- renderText({
      print( paste( "※推定するのに使用したデータ: ", cnfm(), sep="") ) })
   
   output$est_IC50 <- renderText({
      print( paste( "IC50の推定値は、", round(  10^-( estimate_IC50_m()[2,1] / estimate_IC50_m()[1,1]) , 3 ) ,sep="") ) })
   
   output$est_m <- renderText({
      print( paste( "mの推定値は", round( estimate_IC50_m()[1,1], 3 ) ,sep="") ) })
   
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
         est_IC50 = 10^-( estimate_IC50_m()[2,1] / estimate_IC50_m()[1,1]);
         est_m = estimate_IC50_m()[1,1];
         outputfile = data.frame( estimated_IC50 = est_IC50, estimated_m=est_m)
         write.csv( outputfile, filename, row.names = FALSE,col.names = FALSE ) })
   
} #END
