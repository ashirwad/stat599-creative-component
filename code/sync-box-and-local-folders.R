## -----------------------------------------------------------------------------
##
## Purpose of script: Sync local files to Box
##
## Author: Ashirwad Barnwal
##
## Date Created: 2022-04-12
##
## Copyright (c) Ashirwad Barnwal, 2022
## Email: ashirwad@iastate.edu; ashirwad1992@gmail.com
##
## -----------------------------------------------------------------------------
##
## Notes: This script syncs binary files generated locally to Box. Binary files
## are not suited for version control via git, so they are versioned separately
## via Box.
##
## -----------------------------------------------------------------------------

# Load packages
library(conflicted)
library(here)
library(boxr)
box_auth()

# Upload local "output" folder to Box
box_push(
  159333282514,
  here("output"),
  overwrite = TRUE,
  delete = TRUE
)
