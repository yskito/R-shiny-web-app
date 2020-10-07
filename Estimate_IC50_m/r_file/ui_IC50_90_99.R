#============================
# Setting
#============================
width = 12;

#============================
# Part
#============================
formula = box(
   title = '何%阻害濃度が知りたいですか (ICXX)？', collapsible = TRUE, collapsed = FALSE, width = width, 
   numericInput(inputId = "test" , 'test', value = 50, min = 10^-100, max = 100 )
   #uiOutput('est_data_download') 
)

#============================
# Whole
#============================
IC509099 = tabPanel("estimation",
                      fluidRow( column(width = 12, formula ) )
                    )

# mainpanel = mainPanel(
#    # tableOutput('contents')
#    h4( textOutput( outputId = 'est_m' ) ), 
#    h4( textOutput( outputId = 'est_IC50' ) )
# )

#### whole ####
# IC50_90_99 = tabPanel("estimation",
#                        titlePanel("Estimation of IC50 and m"),
#                        sidebarLayout(
#                           sidebarpanel,
#                           mainpanel
#                        )
# )