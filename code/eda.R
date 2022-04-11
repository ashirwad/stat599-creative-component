## -----------------------------------------------------------------------------
##
## Purpose of script: Create detailed exploratory data analysis (EDA) of the
## variables of interest
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
## Notes: This script creates a detailed EDA report for the variables identified
## for further use with modeling during the preliminary EDA:
## https://public.tableau.com/app/profile/ashirwad.barnwal5453/viz/ist-corrected-eda/ISTEDA
##
## -----------------------------------------------------------------------------

# Setup chunk
library(conflicted)
library(here)
library(tidyverse)
conflict_prefer("filter", "dplyr")
library(rio)
library(dlookr)

options(datatable.na.strings = c("", "NA")) # read these strings as NA

# Import IST data
ist <- here("output", "rds-files", "ist.rds")

# Create EDA report
ist %>%
  eda_web_report(
    output_file = "detailed-eda.html",
    output_dir = here("docs"),
    subtitle = "International Stroke Trial",
    author = "Ashirwad Barnwal"
  )
