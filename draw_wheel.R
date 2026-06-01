library(fluctuator) # allows setting svg attributes
library(cardargus) # allows saving temp svg
library(tidyverse)

# fluctuator info:
# https://github.com/m-jahn/fluctuator

# 5/30/26 more functions to investigate here:
# https://www.r-bloggers.com/2024/02/create-interactive-figures-from-svg-images-with-bscui/

svg <- fluctuator::read_svg("wheel_template.svg")
wheel_data <- readRDS("wheel_data.rds")
wheel_structure <- readRDS("wheel_structure.rds")
# grid_data <- readRDS("grid_data.rds")

# define color palette
# add 1 to score to get correct fill color
wheel_pal <- c("#96D6EBff", "#5FA4F7ff")

draw_wheel <- function(data = wheel_data){


  # only 1 and 2 change colors
  wheel_display <- wheel_data |>
    filter(assessment %in% c(1, 2)) |>
    mutate(
      color = wheel_pal[assessment]
    )

  svg <- set_attributes(
    svg,
    node = wheel_display$index,
    node_attr = "id",
    attr = "style",
    pattern = "fill:#ffffff",
    replacement = paste0("fill:", wheel_display$color)
  )

  ##### LOOP METHOD - SLOW
  # # loop through wheel_data, set appropriate attributes for svg wheel
  # for (i in 1:nrow(wheel_data)) {
  #
  #   # only change if assessment is not 0
  #   if (wheel_data$assessment[i]>0){
  #
  #     ind <- wheel_data$index[i]
  #     wheel_assess <- wheel_data$assessment[i]
  #     color <- {
  #       ifelse(
  #         wheel_assess > 2,
  #         wheel_pal[[1]],
  #         wheel_pal[[wheel_assess + 1]]
  #       )
  #     }
  #
  #     # change block color
  #     set_attributes(svg, node = ind, node_attr = "id", attr = "style",
  #                    pattern = "fill:#ffffff", replacement = paste0("fill:", color))
  #   }
  # }

  #
  # write_svg_tempfile(svg)
  write_svg(svg, "wheel_temp.svg")
}
