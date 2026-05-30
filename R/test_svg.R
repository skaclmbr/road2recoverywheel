library(fluctuator)
svg <- read_svg("wheel_template.svg")
head(svg@summary)
get_attributes(svg, node = "1.2.3", node_attr = "id", attr = c("style"))
set_attributes(svg, node = "1.2.3", node_attr = "id",
               attr = "style", pattern = "fill:#ffffff",
               replacement = "fill:#ff0000")

write_svg(svg, "wheel_123.svg")
