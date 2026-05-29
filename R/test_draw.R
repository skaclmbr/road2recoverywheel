library(tidyverse)

wheel_data <- readRDS("wheel_data.rds")
grid_data <- readRDS("grid_data.rds")
# define color palette
wheel_pal <- c("#dddddd", "lightblue", "blue", "darkblue")
grey_outline <- "#555555"


sub_slice_order <- c("Team Formation", "Connections", "Network Action", "Vulnerability",
                     "Population Structure", "Migratory Connectivity", "Demographics",
                     "Focus Areas", "Local Knowledge", "Habitat and Ecology", "Landscape Challenges",
                     "Limiting Factors", "Landscape Opportunities", "Limiting Factor Mitigation",
                     "Partnerships and Funding", "Adaptive Research", "Ecosystem Change",
                     "Sustainability")

# wheel_data$index <- factor(wheel_data$index, levels = order(wheel_data$index))

wheel_data$sub_slice <- factor(wheel_data$sub_slice, levels = sub_slice_order)


ggplot(
  data = wheel_data,
  aes(
    x=sub_slice,
    y=value,
    fill=assessment,
    alpha = 0.5,
    label = index
  )
) +
  geom_text(size = 3, position = position_stack(vjust = 0.5), color = "black") + # for testing
  scale_fill_manual(values = wheel_pal) + # fill with color indicating completion
  geom_col(
    position = "stack",
    stat = "identity"
  ) + # stacks the levels
  theme(
    axis.text.x = element_text(angle = 90) # testing
  )
