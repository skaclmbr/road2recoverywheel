
library(tidyverse)
library(dplyr)
library(viridis)
library(geomtextpath)

# import data structure
wheel_structure <- read.csv("R/wheel_structure.csv")

# main function
drawwheel <- function(data) {
  #' drawwheel function
  #'
  #' This function ingests dataframe of statuses for each aspect
  #' of the Road to Recovery Progress Wheel.
  #'
  #' @param data dataframe of wheel values, with one column named
  #'    "index" - data index of component (e.g., 2.1.2)
  #'    "assessment" - 0-3 value indicating the level of completion
  #'

  # define color palette
  wheel_pal <- c("#dddddd", "lightblue", "blue", "darkblue")
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
    ) |>
    arrange(
      index
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
  # sort wheel_data
  wheel_data <- arrange(wheel_data, index)

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

  # print("base_data:")
  # print(base_data)
  print("wheel_data:")
  print(wheel_data)
  saveRDS(wheel_data, "wheel_data.rds")
  print("grid_data:")
  print(grid_data)
  saveRDS(grid_data, "grid_data.rds")
  # Make the plot
  # p <- ggplot(wheel_data) +
  #
  #   # Add the stacked bar
  #   geom_bar(aes(x=as.factor(id), y=value, fill=as.factor(assessment)), color = grey_outline, stat="identity", alpha=0.5) +
  p <- ggplot(
      data = wheel_data,
      aes(
        x=sub_slice,
        y=value,
        # fill=as.factor(assessment),
        # color = grey_outline,
        alpha = 0.5,
        label = index
      )
    ) +
    geom_col(position = "stack", stat = "identity") +
    coord_curvedpolar() +
    scale_fill_manual(values = wheel_pal) +

    # limits to y-axis scale
    ylim(-10,max(label_data$tot + 30, na.rm=T)) +
    # scale_x_discrete(expand = c(0,0)) +
    theme_minimal() +
    theme(
      legend.position = "none",
      axis.text = element_blank(),
      axis.title = element_blank(),
      panel.grid = element_blank(),
      plot.margin = unit(rep(-1, 4), "cm")
    ) +
    # coord_polar() +
    # coord_radial() +
    # coord_curvedpolar() +

    # labels inside bars for testing
    geom_text(size = 3, position = position_stack(vjust = 0.5)) +

    # Add a val=100/80/60/40/20/0 lines. I do it at the end to make sure barplots are UNDER it.
    geom_hline(aes(yintercept = 0, color= "grey"), alpha = 0.3) +
    geom_hline(aes(yintercept = 20, color= "grey"), alpha = 0.3) +
    geom_hline(aes(yintercept = 40, color= "grey"), alpha = 0.3) +
    geom_hline(aes(yintercept = 60, color= "grey"), alpha = 0.3) +
    geom_hline(aes(yintercept = 80, color= "grey"), alpha = 0.3) +
    geom_hline(aes(yintercept = 100, color= "grey"), alpha = 0.3) +

    # add outer labels for slice groups
    geom_textpath(
      data = base_data,
      aes(
        x = title,
        y = 110,
        label = slice
      ),
      color = "grey",
      size = 6,
      fontface="bold"
    )

    # # Add sub_slice labels inside each slice
    # geom_text(data=label_data, aes(x=id, y=110, label=paste(sub_slice, hjust=hjust), color="black", alpha=0.8, size=5), angle=label_data$angle, inherit.aes = FALSE )

    # Add labels on outer edge of diagram
    # geom_segment(data=base_data, aes(x = start, y = 150, xend = end, yend = 150), colour = "grey", alpha=0.8, size=2 , inherit.aes = FALSE ) +
    # geom_text(data=base_data, aes(x = title, y = 110, label=slice), hjust=c(1,1,1,0,0,0), colour = "grey", alpha=0.8, size=4, fontface="bold", inherit.aes = FALSE)
    # geom_text(data=base_data, aes(x = title, y = 110, label=slice), hjust=c(1,1,0,0), colour = "grey", alpha=0.8, size=4, fontface="bold", inherit.aes = FALSE)

  # ggsave("R/output.png", plot = p, width = 9, height = 9)

  return(p)
}

