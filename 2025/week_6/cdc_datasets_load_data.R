# Description: R Code for pulling & saving TidyTuesday Week 6 2025 data
# Author: Aidan Burk
# Date Created: 2/18/2025
# Date Edited: 2/18/2025
# Data: 'https://archive.org/details/20250128-cdc-datasets'

# Packages ----------------------------------------------------------------

library(tidytuesdayR)
library(tidyverse)


# Load Data ---------------------------------------------------------------

tuesdata <- tidytuesdayR::tt_load(2025, week = 6)

cdc_datasets <- tuesdata$cdc_datasets
fpi_codes <- tuesdata$fpi_codes


# Write Data --------------------------------------------------------------

write_csv(cdc_datasets, "cdc_datasets.csv")
write_csv(fpi_codes, "fpi_codes.csv")

