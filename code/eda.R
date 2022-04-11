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
ist_raw <- import(here("data", "IST_corrected.csv"))

# Clean IST data
ist <- ist_raw %>%
  select(RDELAY:STYPE, RXASP, RXHEP, OCCODE) %>%
  mutate(
    RXHEP = fct_collapse(RXHEP, "M" = c("M", "H")),
    treatment = case_when(
      RXASP == "N" & RXHEP == "N" ~ "no_asp_no_hep",
      RXASP == "N" & RXHEP == "L" ~ "no_asp_low_hep",
      RXASP == "N" & RXHEP == "M" ~ "no_asp_med_hep",
      RXASP == "Y" & RXHEP == "N" ~ "yes_asp_no_hep",
      RXASP == "Y" & RXHEP == "L" ~ "yes_asp_low_hep",
      RXASP == "Y" & RXHEP == "M" ~ "yes_asp_med_hep"
    ),
    treatment = fct_relevel(treatment, "no_asp_no_hep") %>%
      fct_relevel("yes_asp_no_hep", after = 3),
    OCCODE = recode(
      OCCODE, `1` = "dead", `2` = "dependent", `3` = "not_recovered",
      `4` = "recovered", .default = "missing"
    ),
    dead_or_dep = case_when(
      OCCODE %in% c("dead", "dependent") ~ "yes",
      OCCODE %in% c("not_recovered", "recovered") ~ "no",
      OCCODE == "missing" ~ "missing"
    ) %>%
      fct_relevel("no")
  ) %>%
  select(-RXASP, -RXHEP, -OCCODE) %>%
  mutate(across(where(is.character), ~ as.factor(.x))) %>%
  filter(
    !is.na(RATRIAL), # discard pilot phase data due to incompleteness
    dead_or_dep != "missing"
  )

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
