# Global variables for the Breakout game
width_px <- 600      # Width of plotting area in pixels
height_px <- 400     # Height of plotting area in pixels

# Initial paddle properties
paddle_height <- 0.05 * height_px
paddle_width <- 0.2 * width_px
paddle_y <- 0.9 * height_px

# Ball properties
ball_radius <- 8
ball_color <- "red"
paddle_color <- "steelblue"

# Ball velocity (pixels per animation step)
ball_vel_x <- 4
ball_vel_y <- -4