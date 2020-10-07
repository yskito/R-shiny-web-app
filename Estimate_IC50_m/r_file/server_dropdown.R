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
         
         notificationItem("Linkedin", icon=icon('linkedin'), status = "primary", href = 'https://www.linkedin.com/in/yusukeito-yskito'),
         notificationItem("github",   icon=icon('github'),   status = "success", href = 'http://github.com/yskito'),
         notificationItem("twitter",  icon=icon('twitter'),  status = "primary", href = 'https://twitter.com/yusukeito_R') ) })
}
