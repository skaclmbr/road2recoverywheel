source("R/drawwheel.R")


data <- data.frame(
  index = c("2.1.5", "3.1.4", ".1.2", "1.3.2", "3.2.5", "6.3.4" ),
  assessment = c(1, 2, 3, 1, 1, 3)
)

d <- drawwheel(data)
d

