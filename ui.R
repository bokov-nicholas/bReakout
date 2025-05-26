library(shiny)

ui <- fluidPage(
  titlePanel("Breakout Game - Paddle controlled by mouse"),
  sidebarLayout(
    position = "right",
    sidebarPanel(
      'Settings'
    ),
    mainPanel(
      plotOutput("game", height = 420
                 , hover = hoverOpts("plot_hover",delay=10,nullOutside = F,delayType = 'throttle'))
    )
  )
)