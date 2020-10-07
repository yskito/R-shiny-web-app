#==============================
# setting
#==============================
defalt = list( 
   read_sheet   = 1,
   each_color   = 'gray',
   each_alpha   = 0.8,
   
   mean_color   = 'red',
   mean_alpha   = 0.8,
   
   point_size   = 5,
   line_size    = 1.5,
   
   lower_xlim   = 10^-2,
   upper_xlim   = 30,
   x_label_size = 13,
   x_label      = '',
   
   lower_ylim   = 10^-5,
   upper_ylim   = 1,
   y_label_size = 13,
   y_label      = '',
   
   asp          = 0.3,
   
   png_height   = 600,
   png_width    = 600,
   pdf_height   = 10,
   pdf_width    = 7
);

#==============================
# whole
#==============================
server_import_file <- function(input, output, session, ans, filepath ){
   
   #============================
   # 1. Setting of import file
   #============================
   output$csv_header <- renderUI({
      req( ans$file )
      if( str_detect(string=ans$filename, pattern = ".csv") == TRUE || str_detect(string=ans$filename, pattern = ".txt") == TRUE ){
         checkboxInput('header', 'ヘッダー', TRUE) } })
   
   output$csv_sep <- renderUI({
      req( ans$file )
      if( str_detect(string=ans$filename, pattern = ".csv") == TRUE || str_detect(string=ans$filename, pattern = ".txt") == TRUE ){
         radioButtons('sep', 'セパレーター',
                      c(Comma=',',
                        Semicolon=';',
                        Tab='\t'),
                      ',') } })
   
   output$csv_quote <- renderUI({
      req( ans$file )
      if( str_detect(string=ans$filename, pattern = ".csv") == TRUE || str_detect(string=ans$filename, pattern = ".txt") == TRUE ){
         radioButtons('quote', 'クォーター',
                      c(None='',
                        'Double Quote'='"',
                        'Single Quote'="'"),
                      '"') } })
   
   output$xlsx <- renderText({
      req( ans$file )
      if( str_detect(string=ans$filename, pattern = ".xlsx") == TRUE ){
         'シート1を読みこんでいます'} })
   
   #============================
   # 2. Read data
   #============================
   data <- reactive({
      filepath = filepath();
      
      #====== Judge what type of file? ======#
      # if( is.null( ans$filename ) ){ return(NULL) } #case1: NULL
      req( ans$filename )
      
      if( str_detect(string=ans$filename, pattern = ".csv") == TRUE ){ #case2: csv
         req( input$header, input$sep, input$quote ); 
         df <- read.csv( filepath, header = input$header, sep = input$sep, quote = input$quote);
         return( df ) }
      if( str_detect(string=ans$filename, pattern = ".xlsx") == TRUE ){ #case3: xlsx
         df <- read.xlsx(filepath, sheet = defalt$read_sheet )
         return( df ) }
      if( str_detect(string=ans$filename, pattern = ".rds") == TRUE ){ df <- readRDS(filepath); return( df ) } #case4: rds
      if( str_detect(string=ans$filename, pattern = ".txt") == TRUE ){ #case5: csv
         req( input$header, input$sep, input$quote ); 
         df <- read.table( filepath, header = input$header, sep = input$sep, quote = input$quote)
         return( df ) } })
   
   #============================
   # 3. Data Table
   #============================
   output$contents <- renderTable({
      req( ans$file, ans$head_data ); 
      return ( head( data(), ans$head_data ) ) })
   
   #============================
   # X. Data Summary
   #============================
   # output$summary_data <- renderPrint({ summary( data() ) })
   
   #============================
   # 4. Setting: select x_value and y_value
   #============================
   observe({
      
      # Customize color of y-value #
      ans$ch_each_color = input$ch_each_color;
      
      output$ui_each_color = renderUI({
         if( ans$ch_each_color == FALSE ){ NULL }
         if( ans$ch_each_color == TRUE ){
            selectInput(inputId = "each_color",
                        label = "色",
                        choices = c(color),
                        selected = defalt$each_color) }})
      
      output$ui_each_alpha = renderUI({
         if( ans$ch_each_color == FALSE ){ NULL }
         if( ans$ch_each_color == TRUE ){
            numericInput(inputId = "each_alpha" , '色の濃さ', value = defalt$each_alpha, min = 0, max = 1, step=0.1) }})
      
      # Customize color of mean-value #
      ans$ch_mean_color = input$ch_mean_color;
      
      output$ui_mean_color = renderUI({
         if( ans$ch_mean_color == FALSE ){ NULL }
         if( ans$ch_mean_color == TRUE ){
            selectInput(inputId = "mean_color",
                        label = "色",
                        choices = c(color),
                        selected = defalt$mean_color) }})
      
      output$ui_mean_alpha = renderUI({
         if( ans$ch_mean_color == FALSE ){ NULL }
         if( ans$ch_mean_color == TRUE ){
            numericInput(inputId = "mean_alpha" , '色の濃さ', value = defalt$mean_alpha, min = 0, max = 1, step=0.1) }})
      
      # #====== Customize Point ======#
      ans$ch_point = input$ch_point;
      
      output$ui_need_point= renderUI({
         if( ans$ch_point == FALSE ){ NULL }
         if( ans$ch_point == TRUE ){ checkboxInput(inputId = 'point', label = 'プロットの点を表示しますか？', TRUE) }})
      
      output$ui_point_size= renderUI({
         if( ans$ch_point == FALSE || is.null(ans$point) || ans$point == FALSE ){ NULL } #|| is.null(input$point) || input$point == FALSE || sample() == FALSE
         if( ans$ch_point == TRUE && ans$point == TRUE ){ numericInput(inputId = "point_size" , 'プロットの点の大きさ', value = defalt$point_size,  min = 0, max = 50, step=0.5) }})
      
      
      # #====== Customize Line ======#
      ans$ch_line = input$ch_line;
      
      output$ui_need_line= renderUI({
         if( ans$ch_line == FALSE ){ NULL }
         if( ans$ch_line == TRUE ){ checkboxInput(inputId = 'line', label = 'プロットの線を表示しますか', TRUE) }})
      
      output$ui_line_size= renderUI({
         if( ans$ch_line == FALSE || is.null(ans$line) || ans$line == FALSE ){ NULL } #|| is.null(input$point) || input$point == FALSE || sample() == FALSE
         if( ans$ch_line == TRUE && ans$line == TRUE ){ numericInput(inputId = "line_size" ,  'プロットの線の太さ', value = defalt$line_size, min = 0, max = 50, step=0.1) }})
      # if( input$point == TRUE ){ numericInput(inputId = "point_size" , 'Size of point', value = 5,  min = 0, max = 50, step=0.1, width="100%") }})
      
      #====== Customize range of x-axis ======#
      ans$ch_x_axis = input$ch_x_axis;
      
      output$ui_lower_xlim = renderUI({
         if( ans$ch_x_axis == FALSE ){ NULL }
         if( ans$ch_x_axis == TRUE ){ numericInput(inputId = "lower_xlim" , 'x軸の下限値',  value = defalt$lower_xlim, min = 0, max = 10^5) }})
      
      output$ui_upper_xlim = renderUI({
         if( ans$ch_x_axis == FALSE ){ NULL }
         if( ans$ch_x_axis == TRUE ){ numericInput(inputId = "upper_xlim" , 'x軸の上限値',  value = defalt$upper_xlim, min = 0, max = 10^5) }})
      
      output$ui_x_label = renderUI({
         if( ans$ch_x_axis == FALSE ){ NULL }
         if( ans$ch_x_axis == TRUE ){
            textInput(   inputId = "x_label", "x軸ラベル", defalt$x_label, placeholder = "ex) 濃度" ) } })
      
      output$ui_x_label_size = renderUI({
         if( ans$ch_x_axis == FALSE ){ NULL }
         if( ans$ch_x_axis == TRUE ){
            numericInput(inputId = "x_label_size" , 'x軸ラベルの大きさ', value = defalt$x_label_size, min = 1, max = 50) } })
      
      output$ui_logx = renderUI({
         if( ans$ch_x_axis == FALSE ){ NULL }
         if( ans$ch_x_axis == TRUE ){ checkboxInput(inputId = 'logx', label = 'x軸を対数表示する', FALSE) }})
      
      #====== Customize range of y-axis ======#
      ans$ch_y_axis = input$ch_y_axis;
      
      output$ui_lower_ylim = renderUI({
         if( ans$ch_y_axis == FALSE ){ NULL }
         if( ans$ch_y_axis == TRUE ){ numericInput(inputId = "lower_ylim" , 'y軸の下限値',  value = defalt$lower_ylim, min = 10^-20, max = 10^2) }})
      output$ui_upper_ylim = renderUI({
         if( ans$ch_y_axis == FALSE ){ NULL }
         if( ans$ch_y_axis == TRUE ){ numericInput(inputId = "upper_ylim" , 'y軸の上限値',  value = defalt$upper_ylim, min = 1, max = 10^2) }})
      
      output$ui_y_label = renderUI({
         if( ans$ch_y_axis == FALSE ){ NULL }
         if( ans$ch_y_axis == TRUE ){
            textInput( inputId = "y_label", "y軸ラベル", defalt$y_label, placeholder = "ex) 相対値" ) } })
      
      output$ui_y_label_size = renderUI({
         if( ans$ch_y_axis == FALSE ){ NULL }
         if( ans$ch_y_axis == TRUE ){
            numericInput(inputId = "y_label_size" , 'y軸ラベルの大きさ', value = defalt$y_label_size, min = 1, max = 50 ) } })
      
      output$ui_logy = renderUI({
         if( ans$ch_y_axis == FALSE ){ NULL }
         if( ans$ch_y_axis == TRUE ){ checkboxInput(inputId = 'logy', label = 'y軸を対数表示する', FALSE) }})
      
      #====== Customize aspectratio ======#
      output$ui_aspectratio = renderUI({
         if( input$aspectratio == FALSE ){ NULL }
         if( input$aspectratio == TRUE ){ numericInput(inputId = "asp" , '縦横比', value = defalt$asp, min = 0, max = 100, step=0.1 ) } }) 
      
      #====== Select x-value ======#
      output$x_value = renderUI({
         if( is.null(ans$file) ) { NULL }
         if( !is.null(ans$file) || is.null(ans$colname_x)  ){
            selectInput(inputId = "colname_x",
                        label = "(1) どの列をx軸に設定しますか？",
                        choices = c(colnames(data()), '列をご指定ください' = ''),
                        selected = '')}
         if( !is.null(ans$file) && !is.null(ans$colname_x) ){ #更新: もしans$colname_meanが入力されていたら、それをselectedで固定する
            selectInput(inputId = "colname_x",
                        label = "(1) どの列をx軸に設定しますか？",
                        choices = c(colnames(data()), '列をご指定ください' = ''  ),
                        selected = ans$colname_x ) }
      })
      
      #====== Select mean-value ======#
      output$mean_value = renderUI({
         if( is.null(ans$file) ) { NULL }
         if( !is.null(ans$file) || is.null(ans$colname_mean) ){
            selectInput(inputId = "colname_mean",
                        label = "(2) どの列をy軸にプロットしますか？(赤で表示されます。色や仕様は「プロットの設定」で変更できます。)",
                        choices = c(colnames(data()), '列をご指定ください' = '' ),
                        selected = ''  ) } #colnames(data())[2]
         
         if( !is.null(ans$file) && !is.null(ans$colname_mean) ){ #更新: もしans$colname_meanが入力されていたら、それをselectedで固定する
            selectInput(inputId = "colname_mean",
                        label = "(2) どの列をy軸にプロットしますか？(赤で表示されます。色や仕様は「プロットの設定」で変更できます。)",
                        choices = c(colnames(data()), '列をご指定ください' = ''  ),
                        selected = ans$colname_mean ) }
      })
      
      
      #====== Select y-value ======#
      output$y_value = renderUI({
         if( is.null(ans$file) ) { NULL }
         if( !is.null(ans$file)|| is.null(ans$colname_y) ){
            checkboxGroupInput(inputId = "colname_y",
                               label = "(3) 同時にy軸にプロットしたいor比較したいデータはありますか？(グレーで表示されます。色や仕様は「プロットの設定」で変更できます。)",
                               choices = c(colnames(data()) ), 
                               selected = ''             )}
         if( !is.null(ans$file)&& !is.null(ans$colname_y) ){
            checkboxGroupInput(inputId = "colname_y",
                               label = "(3) 同時にy軸にプロットしたいor比較したいデータはありますか？(グレーで表示されます。色や仕様は「プロットの設定」で変更できます。)",
                               choices = c(colnames(data()) ), 
                               selected = ans$colname_y )}
      })
      
   })
   
   #============================
   # 5. Reactive summary
   #============================
   
   #===== each color =====#
   ans_each_color <- reactive({
      if( ans$ch_each_color == TRUE  ) { ans$each_color = input$each_color }
      if( ans$ch_each_color == FALSE ) { ans$each_color = defalt$each_color }
      return( ans$each_color ) })
   #===== each alpha =====#
   ans_each_alpha <- reactive({
      if( ans$ch_each_color == TRUE  ){ ans$each_alpha = input$each_alpha }
      if( ans$ch_each_color == FALSE ){ ans$each_alpha = defalt$each_alpha }
      return( ans$each_alpha ) })
   
   #===== mean color =====#
   ans_mean_color <- reactive({
      if( ans$ch_mean_color == TRUE  ) { ans$mean_color = input$mean_color }
      if( ans$ch_mean_color == FALSE ) { ans$mean_color = defalt$mean_color }
      return( ans$mean_color ) })
   #===== mean alpha =====#
   ans_mean_alpha <- reactive({
      if( ans$ch_mean_color == TRUE  ){ ans$mean_alpha = input$mean_alpha }
      if( ans$ch_mean_color == FALSE ){ ans$mean_alpha = defalt$mean_alpha }
      return( ans$mean_alpha ) })
   
   #===== x label =====#
   ans_lower_xlim <- reactive({
      if( ans$ch_x_axis == TRUE  ){ ans$lower_xlim = input$lower_xlim }
      if( ans$ch_x_axis == FALSE ){ ans$lower_xlim = defalt$lower_xlim }
      return( ans$lower_xlim ) })
   
   ans_upper_xlim <- reactive({
      if( ans$ch_x_axis == TRUE  ){ ans$upper_xlim = input$upper_xlim }
      if( ans$ch_x_axis == FALSE ){ ans$upper_xlim = defalt$upper_xlim }
      return( ans$upper_xlim ) })
   
   ans_x_label <- reactive({
      if( ans$ch_x_axis == TRUE  ){ ans$x_label = input$x_label }
      if( ans$ch_x_axis == FALSE ){ ans$x_label = defalt$x_label }
      return( ans$x_label ) })
   
   ans_x_label_size <- reactive({
      if( ans$ch_x_axis == TRUE  ){ ans$x_label_size = input$x_label_size }
      if( ans$ch_x_axis == FALSE ){ ans$x_label_size = '' }
      return( ans$x_label_size ) })
   
   ans_logx <- reactive({
      if( ans$ch_x_axis == TRUE  ){ ans$logx = input$logx }
      if( ans$ch_x_axis == FALSE ){ ans$logx = FALSE }
      return( ans$logx ) })
   
   #===== y label =====#
   ans_lower_ylim <- reactive({
      if( ans$ch_y_axis == TRUE  ){ ans$lower_ylim = input$lower_ylim; }
      if( ans$ch_y_axis == FALSE ){ ans$lower_ylim = defalt$lower_ylim }
      return( ans$lower_ylim ) })
   
   ans_upper_ylim <- reactive({
      if( ans$ch_y_axis == TRUE  ){ ans$upper_ylim = input$upper_ylim }
      if( ans$ch_y_axis == FALSE ){ ans$upper_ylim = defalt$upper_ylim }
      return( ans$upper_ylim ) })
   
   ans_y_label <- reactive({
      if( ans$ch_y_axis == TRUE  ){ ans$y_label = input$y_label }
      if( ans$ch_y_axis == FALSE ){ ans$y_label = defalt$y_label }
      return( ans$y_label ) })
   
   ans_y_label_size <- reactive({
      if( ans$ch_y_axis == TRUE  ){ ans$y_label_size = input$y_label_size }
      if( ans$ch_y_axis == FALSE ){ ans$y_label_size = '' }
      return( ans$y_label_size ) })
   
   ans_logy <- reactive({
      if( ans$ch_y_axis == TRUE  ){ ans$logy = input$logy }
      if( ans$ch_y_axis == FALSE ){ ans$logy = FALSE }
      return( ans$logy ) })
   
   #===== point size =====#
   ui_point_size <- reactive({
      if( is.null(input$point)  )  { ans$point = TRUE } #initial
      if( !is.null(input$point)  ) {
         if( ans$ch_point == TRUE  ) { ans$point = input$point }
         if( ans$ch_point == FALSE ) { ans$point = TRUE } }#default 
      return( ans$point ) })
   
   point_size <- reactive({
      if( ans$ch_point == FALSE )  { ans$point_size = defalt$point_size } #default
      if( ans$ch_point == TRUE ) {
         if( is.null(input$point)  )  { ans$point_size = defalt$point_size } #initial
         if( !is.null(input$point)  ) {
            if( ans$point == FALSE  ) { ans$point_size = defalt$point_size }
            if( ans$point == TRUE  )  { ans$point_size = input$point_size } } }
      return( ans$point_size ) })
   
   #===== line size =====#
   ui_line_size <- reactive({
      if( is.null(input$line)  )  { ans$line = TRUE } #initial
      if( !is.null(input$line)  ) {
         if( ans$ch_line == TRUE  ) { ans$line = input$line }
         if( ans$ch_line == FALSE ) { ans$line = TRUE } } #default
      return( ans$line ) })
   
   line_size <- reactive({
      if( ans$ch_line == FALSE )  { ans$line_size = defalt$line_size } #default
      if( ans$ch_line == TRUE ) {
         if( is.null(input$line)  )  { ans$line_size = defalt$line_size } #initial
         if( !is.null(input$line)  ) {
            if( ans$line == FALSE  ) { ans$line_size = defalt$line_size }
            if( ans$line == TRUE  )  { ans$line_size = input$line_size } } }
      return( ans$line_size ) })
   
   #===== aspectratio =====#
   ans_asp <- reactive({
      if( input$aspectratio == TRUE  ){ ans$asp = input$asp }
      if( input$aspectratio == FALSE ){ ans$asp = defalt$asp }
      return( ans$asp ) })
   
   # x-value
   ans_colname_x <- reactive({
      if( is.null (ans$file) ) { ans$colname_x = ''}
      if( !is.null(ans$file) ) { 
         if( is.null(input$colname_x) ) { ans$colname_x = '' }
         if( !is.null(input$colname_x) ){ ans$colname_x = input$colname_x }
      }
      return( ans$colname_x ) })
   
   # mean-value
   ans_colname_mean <- reactive({
      if( is.null (ans$file) ) { ans$colname_mean = ''}
      if( !is.null(ans$file) ) { 
         if( is.null(input$colname_mean) ) { ans$colname_mean = '' }
         if( !is.null(input$colname_mean) ){ ans$colname_mean = input$colname_mean }
      }
      return( ans$colname_mean ) })
   
   # mean-value
   ans_colname_y <- reactive({
      if( is.null (ans$file) ) { ans$colname_y = ''}
      if( !is.null(ans$file) ) { 
         if( is.null(input$colname_y) ) { ans$colname_y = '' }
         if( !is.null(input$colname_y) ){ ans$colname_y = input$colname_y }
      }
      return( ans$colname_y ) })
   
   #============================
   # 6. plotInput setting
   #============================
   observe({
      
      ans$colname_x    = ans_colname_x(); 
      ans$colname_mean = ans_colname_mean();
      ans$colname_y    = ans_colname_y(); 
      
      ans$each_color   = ans_each_color();  
      ans$each_alpha   = ans_each_alpha();
      
      ans$mean_color   = ans_mean_color(); 
      ans$mean_alpha   = ans_mean_alpha();
      
      ans$x_label_size = ans_x_label_size();
      ans$y_label_size = ans_y_label_size();
      
      ans$x_label      = ans_x_label();
      ans$y_label      = ans_y_label();
      
      ans$lower_xlim   = ans_lower_xlim();
      ans$upper_xlim   = ans_upper_xlim();
      
      ans$lower_ylim   = ans_lower_ylim(); 
      ans$upper_ylim   = ans_upper_ylim(); 
      
      ans$logx         = ans_logx();
      ans$logy         = ans_logy();
      
      ans$xlim         = c(ans$lower_xlim, ans$upper_xlim );
      ans$ylim         = c(ans$lower_ylim, ans$upper_ylim); 
      
      ans$point        = ui_point_size(); 
      ans$line         = ui_line_size(); 
      
      ans$point_size   = point_size(); 
      ans$line_size    = line_size(); 
      
      ans$asp = ans_asp();  })
   
   #============================
   # 7. plotInput 
   #============================
   plotInput <- reactive({
      #===== input setting =====#
      req( ans$file )
      
      #===== input setting =====#
      data       = data();
      
      #===== ggplot: dose-response-curve =====#
      req( ans$colname_x )
      p<- ggplot( data, aes_string( x=ans$colname_x ) )
      
      #===== each =====#
      req( ans$each_color )
      if( !is.null(input$colname_y)){
         for(i in 1:length(input$colname_y) ){
            if( ans$point == TRUE ){ p <- p + geom_point( aes_string( y=input$colname_y[i] ), color = ans$each_color, size = ans$point_size  , alpha = ans$each_alpha ) }
            if( ans$line  == TRUE ){ p <- p + geom_line(  aes_string( y=input$colname_y[i] ), color = ans$each_color, size = ans$line_size,    alpha = ans$each_alpha ) } }
      }
      
      #===== mean =====#
      req( ans$colname_mean, ans$mean_color )
      if( ans$point == TRUE ){ p <- p + geom_point( aes_string( y=ans$colname_mean ), color = ans$mean_color, size = ans$point_size, alpha = ans$mean_alpha )  }
      if( ans$line  == TRUE ){ p <- p + geom_line(  aes_string( y=ans$colname_mean ), color = ans$mean_color, size = ans$line_size,  alpha = ans$mean_alpha ) }
      
      #===== option =====#
      req( ans$xlim, ans$ylim )
      p<- p + theme_classic() + theme(aspect.ratio = ans$asp)
      p<- p + coord_cartesian( xlim=ans$xlim, ylim=ans$ylim ) + xlab(ans$x_label) +  ylab(ans$y_label)
      if( ans$logx == TRUE ){ p<- p + scale_x_log10(breaks=10^(seq(-20,10,1)), labels=trans_format("log10",math_format(10^.x))) }
      if( ans$logy == TRUE ){ p<- p + scale_y_log10(breaks=10^(seq(-20,10,1)), labels=trans_format("log10",math_format(10^.x))) }
      p<- p + theme( axis.text.x = element_text(colour="black", size=ans$x_label_size), axis.text.y = element_text(colour="black", size=ans$y_label_size) )
      
      #===== show all plot =====#
      return( p )
      })
   
   #============================
   # 8. plotInput visualization
   #============================
   output$visualization <- renderPlot({
      print( plotInput() ) })
   
   #============================
   # 9. download image
   #============================
   output$download <- downloadHandler(
      filename = function(){
         paste( "data", input$png_pdf, sep=".") },
      content = function(file) {
         if( input$png_pdf == "png" )
            png(file, height=defalt$png_height, width=defalt$png_width )
         if( input$png_pdf == "pdf" )
            pdf(file, width=defalt$pdf_height, height=defalt$pdf_width )
         print( plotInput() )
         dev.off() })
}

# EN