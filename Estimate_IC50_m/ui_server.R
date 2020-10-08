#============================
# Setting
#============================
rm(list=ls(all=TRUE));
require( shiny ); require( shinydashboard ); require( shinycssloaders );
require( openxlsx );
require( stringr );
require( ggplot2 ); require(scales);
require( png );
require( MASS );

#============================
# Read other R file
#============================
setwd("./r_file");
R_file = list.files( pattern = ".R");
lapply( 1:length(R_file), function( i ){ source( R_file[i] ); } );
setwd("../");

#============================
# ui
#============================
# Header
Header_title = "Estimate IC50 and m";

# Sidebar
sidebar_menu = sidebarMenu(
   menuItem( "ホーム",        tabName = "home",        icon = icon("home")),
   menuItem( "データ可視化",  tabName = "import_file", icon = icon("file-upload"), badgeLabel = "new",     badgeColor = "green"),
   menuItem( "IC50とmの推定", tabName = "estimation",  icon = icon("diagnoses")  , badgeLabel = "new",     badgeColor = "green" ),
   #menuItem( "IC90,99の推定", tabName = "IC50_90_99",  icon = icon("calculator") , badgeLabel = "not yet", badgeColor = "purple"),
   menuItem( "理論的背景",    tabName = "background",  icon = icon("history"),     badgeLabel = "not yet", badgeColor = "purple"),
   menuItem( "webアプリ一覧", tabName = "about_me",    icon = icon("user-tie"))
)

# Body
body = tabItems(
   tabItem( tabName = "home",           home ),
   tabItem( tabName = "background",     background    ),
   tabItem( tabName = "import_file",    import_file    ),
   tabItem( tabName = "estimation",     estimation    ),
   #tabItem( tabName = "IC50_90_99",     IC509099    ),
   tabItem( tabName = "about_me",       about_me)
)

ui <- dashboardPage(
   dashboardHeader ( dropdownMenuOutput("dropdown"), title = Header_title ),
   dashboardSidebar( sidebar_menu ),
   dashboardBody　 ( colorDIY,  body )
)

#============================
# Server
#============================
server <- function(input, output, session){

   # header dropdown
   server_dropdown(input, output, session)

   # Tab: home
   server_home(input, output, session)

   #===== Server setting =====#
   ans <- reactiveValues()

   filepath = reactive({
      req(input$file1)
      file <- input$file1;
      return(file$datapath)
   })

   observe({
      ans$file　　  <- input$file1
      ans$filename  <- input$file1$name
      ans$head_data <- 10;
   })

   # Tab: import_file
   server_import_file(input, output, session, ans, filepath)

   # Tab: estimation
   server_estimation(input, output, session, ans, filepath)

   # Tab: IC50_90_99
   server_IC50_90_99(input, output, session, ans, filepath )

   # Tab: about_me
   server_about_me(input, output, session)
}

#============================
# Show Dashboard
#============================
shinyApp(ui, server)
