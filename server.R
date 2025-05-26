library(shiny)

server <- function(input, output, session) {
  game_state <- reactiveValues(
    paddle_center = width_px / 2,
    ball_x = width_px / 2,
    ball_y = height_px / 2,
    vel_x = 2,
    vel_y = -2
  );
  
  autoInvalidate<-reactiveTimer(10);
  
  observe({
    autoInvalidate();
    # 
    # Bounce off sides
    if (isolate(game_state$ball_x <= 0 || game_state$ball_x >= width_px)) {
      message('side bounce');
      game_state$vel_x <- isolate(-game_state$vel_x);
    };
    # Bounce off top/bottom
    if (isolate(game_state$ball_y <= 0 || game_state$ball_y >= height_px)) {
      message('top/bottom bounce')
      game_state$vel_y <- isolate(-game_state$vel_y);
    };
    
    if (isolate(game_state$ball_y <= paddle_y + paddle_height &&
        game_state$ball_x >= game_state$paddle_center - paddle_width/2 && 
        game_state$ball_x <= game_state$paddle_center + paddle_width/2)) {
      game_state$vel_y <- -game_state$vel_y  # Invert up/down direction on paddle hit
    }
  
    game_state$ball_x <- isolate(game_state$ball_x + game_state$vel_x);
    game_state$ball_y <- isolate(game_state$ball_y + game_state$vel_y);
    # If NULL, do nothing; previous value remains
  });
  
  observe({
    message('observe hover');
    if (!is.null(newx<-input$plot_hover$x)) {
      message('update paddle_center');
      # Update only if hover info is present
      foo<-try(game_state$paddle_center <- newx);
      if(is(foo,'try-error')) browser();
    }
  });
  
  
  output$game <- renderPlot({
    autoInvalidate();
    message('renderPlot');
    state <- game_state;
    # Paddle reacts to slider input *while dragging*
    plot(0, type = "n", xlim = c(0, width_px), ylim = c(0, height_px),
         axes = FALSE, xlab = "", ylab = "");
    rect(0,0,width_px,height_px,border='green',lwd=2);
    message('drawing paddle');
    rect(state$paddle_center - paddle_width/2, paddle_y,
         state$paddle_center + paddle_width/2, paddle_y + paddle_height,
         col = paddle_color);
    message('drawing ball');
    try(points(isolate(game_state$ball_x), isolate(game_state$ball_y), pch = 20, cex = 2, col = "red"));
  })
}
