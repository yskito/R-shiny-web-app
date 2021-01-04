#============================
# Whole
#============================
server_dropdown <- function(input, output, session){
   
   output$dropdown <- renderMenu({
      dropdownMenu(
         type = "notification", 
         icon = icon('cat'),
         badgeStatus = NULL,
         headerText = "Profile",
         
         notificationItem("github",   icon=icon('github'),   status = "success", href = 'http://github.com/yskito')
         ) })
}
