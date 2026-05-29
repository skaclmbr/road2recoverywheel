# test code for connecting to google sheets

# see docs here: https://googlesheets4.tidyverse.org/index.html

library(googlesheets4)

gs4_deauth()
url <- "https://docs.google.com/spreadsheets/d/1nkB0qh1U80DnpmyAn1X8AC4sG1aHP52gf14cK_z-cAw/edit?usp=sharing"

read_sheet(url, sheet = "GWWA")
