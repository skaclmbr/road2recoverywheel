library(fluctuator)
library(tidyverse)
svg <- read_svg("wheel_template.svg")
head(svg@summary)

# 5/30/26 more functions to investigate here:
# https://www.r-bloggers.com/2024/02/create-interactive-figures-from-svg-images-with-bscui/

wheel_data <- readRDS("wheel_data.rds")
wheel_structure <- readRDS("wheel_structure.rds")
grid_data <- readRDS("grid_data.rds")
# define color palette
wheel_pal <- c("#dddddd", "lightblue", "blue", "darkblue")
grey_outline <- "#555555"

for (i in 1:nrow(wheel_structure)) {
  ind <- wheel_structure$index[i]
  attr <-


  set_attributes(svg, node = ind, node_attr = "id", attr = "style",
                 pattern = "fill", replacement:"title:'';fill")
}
# node_data <- get_attributes(svg, node = "1.2.3", node_attr = "id", attr = c("style"))[[1]] |>
#   strsplit(";")
#
# node_data

set_attributes(svg, node = "1.2.3", node_attr = "id",
               attr = "style", pattern = "fill",
               replacement = "title:'';fill")
#
write_svg(svg, "wheel_123.svg")
