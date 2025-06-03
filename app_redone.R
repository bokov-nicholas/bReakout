library(shiny);
library(shinyjs);
library(colourpicker);

ball_x <- 300;
ball_y <- 200;
vel_x <- 20;
vel_y <- -20;
#paddle_center <- 300;
paddle_width <- 80;
paddle_height <- 20;
paddle_y <- 50; 
width_px <- 600;
height_px <- 500;

jsCode <- sprintf("
// --- 1. Declare variables in JS, for mouse and ball/paddle positions ---

// Track mouse x
var mouseX = 0;

// Ball and paddle variables
var ball_x = %d;
var ball_y = %d;
var vel_x = %d;
var vel_y = %d;
var paddle_width = %d;
var paddle_height = %d;
var paddle_y = %d; // paddle at the bottom
var width_px = %d;
var height_px = %d;

document.addEventListener('mousemove', function(event) { 
  mouseX = event.pageX; 
  //paddle_center = Math.max(0, Math.min(width_px, mouseX));
  //Shiny.setInputValue('paddle_center_js', paddle_center);
  });

// --- 2. Define the JS function to do the math and update ball/paddle/respond to R if needed ---

shinyjs.updateBall = function(){
  // Move ball
  ball_x = ball_x + vel_x;
  ball_y = ball_y + vel_y;
  // Bounce off walls
  if (ball_x <= 0 || ball_x >= width_px) {
    vel_x = -vel_x;
  }
  if (ball_y <= 0 || ball_y >= height_px) {
    vel_y = -vel_y;
  }

  // Paddle logic: simple JS if-statement, not Shiny R
  if (ball_y <= paddle_y + paddle_height &&
      ball_x >= paddle_center - paddle_width/2 &&
      ball_x <= paddle_center + paddle_width/2) {
    vel_y = -vel_y;
  }


  // Send ball x/y to R every 100ms (throttled)
  Shiny.setInputValue('ball_x_js', ball_x);
  Shiny.setInputValue('ball_y_js', ball_y);
}

shinyjs.updatePaddle = function() {
  // --- 3. Do all the JS logic here ---

  // Update paddle position from mouse
  paddle_center = Math.max(0, Math.min(width_px, mouseX));
  Shiny.setInputValue('paddle_center_js', paddle_center);
}

// --- 4. Call JS updateGame function every 100ms, non-reactively, from JS, not R
setInterval(shinyjs.updatePaddle, 200);
setInterval(shinyjs.updateBall, 300);
",ball_x,ball_y,vel_x,vel_y,paddle_width,paddle_height,paddle_y,width_px,height_px);

message(jsCode);

ui <- fluidPage(
  useShinyjs(),
  tags$head(tags$script(type = "application/javascript", HTML(jsCode))),
  colourInput("pcol", "Paddle color:", value = "#00FFCC"),
  colourInput("bcol", "Ball color:", value = "#00FF99"),
  sliderInput("bsize", "Ball size:",min = 0.01, max=20,value = 5),
  verbatimTextOutput("show_ball_x"),
  verbatimTextOutput("show_ball_y"),
  verbatimTextOutput("show_mouse_x"),
  plotOutput("game", height = 420)
)

server <- function(input, output, session) {
  # Just observe these JS variables as you would input$ball_x_js etc. in R
  output$show_ball_x <- renderPrint({ input$ball_x_js })
  output$show_mouse_x <- renderPrint({ input$paddle_center_js })
  output$show_ball_y <- renderPrint({ input$ball_y_js })
  output$game <- renderPlot({
    req({ball_x<-input$ball_x_js; ball_y <- input$ball_y_js;
    paddle_center <- input$paddle_center_js});
    plot(0, type = "n", xlim = c(0, width_px), ylim = c(0, height_px),
         axes = FALSE, xlab = "", ylab = "");
    rect(0,0,width_px,height_px,border='green',lwd=2);
    #message('drawing paddle');
    rect(paddle_center - paddle_width/2, paddle_y,
         paddle_center + paddle_width/2, paddle_y + paddle_height,
         col = input$pcol);
    #message('drawing ball');
    try(points(ball_x, ball_y, pch = 20, cex = input$bsize, col = input$bcol));
  })
  
}

shinyApp(ui, server)