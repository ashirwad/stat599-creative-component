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

