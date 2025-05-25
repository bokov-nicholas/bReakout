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
