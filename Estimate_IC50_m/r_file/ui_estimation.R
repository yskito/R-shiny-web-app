#============================
# Setting
#============================
width = 12;

#============================
# Part
#============================

data_table2 = box(
   title = 'データテーブル (再掲)', status="primary", collapsible = TRUE, collapsed = FALSE, width = width,
   tableOutput('contents2') )

set_est = box(
   title = 'どのデータを用いてIC50とmを推定しますか？', collapsible = TRUE, collapsed = FALSE, width = width, 
   uiOutput('X'),
   uiOutput('Y')
   #uiOutput('est_data_download') 
   )

result = box(
   title = 'IC50とmの推定結果', status="danger", collapsible = TRUE, collapsed = FALSE, width = width, solidHeader = TRUE,
   h3( textOutput( outputId = 'est_m' ) ),
   h3( textOutput( outputId = 'est_IC50' )  ),
   h5( textOutput( outputId = 'cnfm' ) ),
   uiOutput('show_download_button') )

calculation = box(
   title = '何%阻害濃度が知りたいですか (i.e., ICXX)？', status="warning", collapsible = TRUE, collapsed = FALSE, width = width,
   numericInput(inputId = "test" , '', value = 50, min = 10^-100, max = 100 ),
   h3( textOutput( outputId = 'IC90' ) ) )

#============================
# Whole
#============================
estimation = tabPanel("estimation",
                      fluidRow( column(width = 12, data_table2 ) ),
                      fluidRow( column(width = 12, set_est ) ),
                      fluidRow( column(width = 12, result ) ),
                      fluidRow( column(width = 12, calculation ) ))