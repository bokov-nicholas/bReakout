library(shiny)

server <- function(input, output, session) {
  game_state <- reactiveValues(
    paddle_center = width_px / 2,
    ball_x = width_px / 2,
    ball_y = height_px / 2,
    vel_x = 2,
    vel_y = -2
  );
  
  observe({
    message('observer');
    if (!is.null(newx<-input$plot_hover$x)) {
      # Update only if hover info is present
      foo<-try(game_state$paddle_center <- newx);
      if(is(foo,'try-error')) browser();
    }
    # If NULL, do nothing; previous value remains
  })
  
  output$game <- renderPlot({
    message('renderPlot');
    state <- game_state
    # Paddle reacts to slider input *while dragging*
    plot(0, type = "n", xlim = c(0, width_px), ylim = c(0, height_px),
         axes = FALSE, xlab = "", ylab = "")
    message('drawing rect');
    rect(state$paddle_center - paddle_width/2, paddle_y,
         state$paddle_center + paddle_width/2, paddle_y + paddle_height,
         col = paddle_color)
  })
}

# server <- function(input, output, session) {
#   # Load global variables
# 
#   # Reactive value to hold ball position and velocity
#   game_state <- reactiveVal(list(
#     ball_x = width_px / 2,
#     ball_y = height_px / 2,
#     vel_x = ball_vel_x,
#     vel_y = ball_vel_y
#   ))
# 
#   state <- reactiveVal() # Just to capture dependencies
#   
#   # Render the game display
#   output$game <- renderPlot({
#     req(input$auto_play)   # Only render if auto-play is on
# 
#     # Get paddle center from input
#     paddle_center <- input$paddle_center
#     
#     # Set up plot area
#     plot(0, type = "n", xlim = c(0, width_px), ylim = c(0, height_px),
#          axes = FALSE, xlab = "", ylab = "")
#     
#     
#     # Draw paddle
#     rect(paddle_center - paddle_width/2, paddle_y,
#          paddle_center + paddle_width/2, paddle_y + paddle_height,
#          col = paddle_color)
#     
#     # # Get current ball state
#     # state <- game_state()
#     # ball_x <- state$ball_x
#     # ball_y <- state$ball_y
#     # vel_x <- state$vel_x
#     # vel_y <- state$vel_y
#     # 
#     # # Draw ball
#     # points(ball_x, ball_y, pch=19, cex=ball_radius/2, col=ball_color)
#     # 
#     # # Update ball position
#     # ball_x_new <- ball_x + vel_x
#     # ball_y_new <- ball_y + vel_y
#     # 
#     # # Bounce off walls
#     # if (ball_x_new < ball_radius || ball_x_new > width_px - ball_radius) vel_x <- -vel_x
#     # if (ball_y_new < ball_radius) vel_y <- -vel_y
#     # 
#     # # Bounce off paddle (simplified: y-position checks)
#     # if (ball_y_new > paddle_y - paddle_height/2 &&
#     #     ball_x_new > (paddle_center - paddle_width/2) &&
#     #     ball_x_new < (paddle_center + paddle_width/2)) {
#     #   vel_y <- -vel_y
#     # }
#     # 
#     # # Update ball position and velocity for next frame
#     # game_state(list(
#     #   ball_x = ball_x_new,
#     #   ball_y = ball_y_new,
#     #   vel_x = vel_x,
#     #   vel_y = vel_y
#     #)
#   #)
#   } #, autolayout = TRUE
# )
# }