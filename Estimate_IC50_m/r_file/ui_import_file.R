#==============================
# setting
#==============================
width = 28;
color = c('Red'='red',              'Dark Red'='red4', 
          'Blue'='blue',            'Dark Blue'='blue4', 
          'Royal Blue'='royalblue', 'Dark Royal Blue'='royalblue4',
          'Green'='green',          'Dark Green'='green4', 
          'Cyan'='cyan',            'Dark Cyan'='cyan4', 
          'Emerald' = 'aquamarine', 'Dark Emerald' = 'aquamarine4', 
          'Orange'='orange',        'Dark Orange'='orange3', 
          'Purple'='purple',        'Dark Purple'='purple4', 
          'Pink'='pink',            'Dark Pink'='pink3', 
          'Yellow'='yellow',        'Dark yellow'='yellow4',
          'Black'="black",
          'Gray'="gray",            'Dark gray'="gray1")


#==============================
# part 
#==============================
import = box(
   title = 'データのアップロード', status="success", collapsible = TRUE, collapsed = FALSE, width = width,
   
   fileInput('file1', 'どのデータをアップロードしますか？ (csv/xlsx/rds/txtファイルを使用できます)',
             accept=c('text/csv', '.csv',
                      '.xlsx',
                      '.rds',
                      '.txt'
             ),
             buttonLabel = '📁',
             placeholder = '← Push (^^)b'),
   tags$br(),
   uiOutput('csv_header'),
   uiOutput('csv_sep'),
   uiOutput('csv_quote'),
   uiOutput('sheet_names'),
   verbatimTextOutput('xlsx')
)

data_table = box(
   title = 'データテーブル', status="primary", collapsible = TRUE, collapsed = FALSE, width = width,
   tableOutput('contents') %>% withSpinner( type=7 )
)

# data_summary = box(
#    title = 'Summary Table', status="primary",    collapsible = TRUE, collapsed = TRUE, width = width,
#    verbatimTextOutput( "summary_data" ) 
#    )

plot_setting = box(
   title = 'プロットの設定', status="warning", collapsible = TRUE, collapsed = TRUE, width = width,
   
   checkboxInput(inputId = 'ch_mean_color', label = '(2)の色を変更する', FALSE),
   uiOutput('ui_mean_color'),
   uiOutput('ui_mean_alpha'),
   
   checkboxInput(inputId = 'ch_each_color', label = '(3)の色を変更する', FALSE),
   uiOutput('ui_each_color'),
   uiOutput('ui_each_alpha'),
   
   checkboxInput( inputId = 'ch_point', label = 'プロットの点を変更する', FALSE),
   uiOutput('ui_need_point'),
   uiOutput('ui_point_size'),
   
   checkboxInput(inputId = 'ch_line',  label = 'プロットの線を変更する', FALSE),
   uiOutput('ui_need_line'),
   uiOutput('ui_line_size'),
   
   checkboxInput(inputId = 'ch_x_axis', label = 'x軸の仕様を変更する', FALSE),
   uiOutput('ui_lower_xlim'),
   uiOutput('ui_upper_xlim' ),
   uiOutput('ui_x_label' ),
   uiOutput('ui_x_label_size' ),
   uiOutput('ui_logx'),
   
   checkboxInput(inputId = 'ch_y_axis', label = 'y軸の仕様を変更する', FALSE),
   uiOutput('ui_lower_ylim'),
   uiOutput('ui_upper_ylim' ),
   uiOutput('ui_y_label' ),
   uiOutput('ui_y_label_size' ),
   uiOutput('ui_logy'),
   
   checkboxInput(inputId = 'aspectratio',  label = 'プロットの縦横比を変更する', FALSE),
   uiOutput('ui_aspectratio')
)

plot = box(
   title = 'データ可視化', status="warning", collapsible = TRUE, collapsed = FALSE, width = width,
   
   uiOutput('x_value'),
   uiOutput('mean_value'),
   uiOutput('y_value'),
   
   div(plotOutput( outputId = 'visualization', width = "100%", height = "100%" ), style = "height: 40vh"),
   
   h4("プロットした図をダウンロードしますか?"),
   radioButtons(inputId = "png_pdf", label="png? pdf?", choices=list("png","pdf")),
   downloadButton( outputId = 'download', label = "プロットした図をダウンロードする")
);

#==============================
# whole
#==============================
import_file = tabPanel("Upload File",
                       fluidRow(
                          column(width = 3, import),
                          column(width = 9, data_table) ),#column(width = 5, data_summary),
                       fluidRow(
                          column(width = 3, plot_setting),
                          column(width = 9, plot) ) )

