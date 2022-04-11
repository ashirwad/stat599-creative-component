## -----------------------------------------------------------------------------
##
## Purpose of script:
##
## Author: Ashirwad Barnwal
##
## Date Created: 2022-04-11
##
## Copyright (c) Ashirwad Barnwal, 2022
## Email: ashirwad@iastate.edu; ashirwad1992@gmail.com
##
## -----------------------------------------------------------------------------
##
## Notes:
##
##
## -----------------------------------------------------------------------------

# Setup chunk
library(conflicted)
library(here)
library(tidyverse)
library(rio)
library(dlookr)

options(datatable.na.options = c("", "NA")) # read these strings as NA

# Import IST data
ist_raw <- import(here("data", "IST_corrected.csv"))

# Create EDA report
ist_raw %>%
  select(RDELAY, RSBP, RDEF1:RDEF8) %>%
  eda_web_report(
    output_file = "detailed-eda.html",
    output_dir = here("docs"),
    subtitle = "International Stroke Trial",
    author = "Ashirwad Barnwal",
    sample_percent = 10
  )
