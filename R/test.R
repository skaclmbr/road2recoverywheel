# library
library(tidyverse)
library(viridis)
library(geomtextpath)

# import data structure
wheel_structure <- read.csv("R/wheel_structure.csv")

data <- data.frame(
  index = c("2.1.5", "3.1.4", ".1.2", "1.3.2", "3.2.5", "6.3.4" ),
  assessment = c(1, 2, 3, 1, 1, 3)
)


wheel_pal <- c("white", "lightblue", "blue", "darkblue")
grey_outline <- "#555555"

# add columns to wheel structure
wheel_data <- wheel_structure |>
  mutate(
    level_txt = paste0("level", level),
    index = as.character(index)
  ) |>
  merge(
    y = data,
    by = "index",
    all.x = TRUE
  ) |>
  mutate(
    assessment = ifelse(is.na(assessment), 0, assessment)
  )

# group = slice
# individual = sub_slice

nLevelType <- nlevels(as.factor(wheel_data$level_txt)) # number of rings
to_add <- data.frame( matrix(NA, nlevels(wheel_data$slice)*nLevelType, ncol(wheel_data)) )
colnames(to_add) <- colnames(wheel_data)
to_add$group <- rep(levels(wheel_data$slice), each=nLevelType )
wheel_data <- rbind(wheel_data, to_add)
wheel_data <- wheel_data |> arrange(slice, sub_slice)
wheel_data$id <- rep( seq(1, nrow(wheel_data)/nLevelType) , each=nLevelType)

# Get the name and the y position of each label
# create data for each sub_slice
label_data <- wheel_data |> group_by(id, sub_slice) |> summarize(tot=sum(value))
number_of_bar <- nrow(label_data) # number of sub_slices
angle <- 90 - 360 * (label_data$id - 0.5) /number_of_bar     # I substract 0.5 because the letter must have the angle of the center of the bars. Not extreme right(1) or extreme left (0)
# angle <- 90 - 360 * (label_data$id - 0.5) /number_of_bar     # I substract 0.5 because the letter must have the angle of the center of the bars. Not extreme right(1) or extreme left (0)
label_data$hjust <- ifelse( angle < -90, 1, 0)
label_data$angle <- ifelse( angle < -90, angle + 180, angle)

# prepare a data frame for base lines
base_data <- wheel_data |>
  group_by(slice) |>
  summarize(start=min(id), end=max(id)) |>
  rowwise() |>
  mutate(title = mean(c(start, end))) # center angle for title

# prepare a data frame for grid (scales)
grid_data <- base_data
grid_data$end <- grid_data$end[ c( nrow(grid_data), 1:nrow(grid_data)-1)] + 1
grid_data$start <- grid_data$start - 1
grid_data <- grid_data[-1,]

p <- ggplot(wheel_data) +

  # Add the stacked bar
  geom_bar(aes(x=as.factor(sub_slice), y=value, fill=as.factor(assessment)), color = grey_outline, stat="stack", alpha=0.5) +
  scale_fill_manual(values = wheel_pal) +

  # limits to y-axis scale
  # ylim(-10,max(label_data$tot + 30, na.rm=T)) +
  # scale_x_discrete(expand = c(0,0)) +
  theme_minimal() +
  theme(
    legend.position = "none"
    # axis.text = element_blank(),
    # axis.title = element_blank(),
    # panel.grid = element_blank(),
    # plot.margin = unit(rep(-1, 4), "cm")
  )
  # coord_polar() +
  # coord_radial() +
  # coord_curvedpolar() +

p


test_data <- data.frame(
  sub_slice = c("1", "1", "1", "2", "2", "2"),
  index = c("1.1", "1.2", "1.3", "2.1", "2.2", "2.3"),
  level = c("1", "2", "3", "1", "2", "3"),
  values = c(20,20,20,20,20,20)
)
ggplot(
  data = test_data,
  aes(
    x = group,
    y = values,
    fill = level
  )
) +
  geom_bar(position = "stack", stat = "identity")



# create a dataset
specie <- c(rep("sorgho" , 3) , rep("poacee" , 3) , rep("banana" , 3) , rep("triticum" , 3) )
condition <- rep(c("normal" , "stress" , "Nitrogen") , 4)
value <- rep(20, 12)
# value <- abs(rnorm(12 , 0 , 15))
data <- data.frame(specie,condition,value)

# Stacked
ggplot(data, aes(fill=condition, y=value, x=specie)) +
  geom_bar(position="stack", stat="identity")
