## Tidy Tuesday - 2025 Week 6: CDC Datasets
R code used to produce a shiny app that visualizes metadata for CDC datasets uploaded before January 28th, 2025 and are backed up on archive.org. 

App can be found here: https://aiburk.shinyapps.io/tidytuesday-cdc-datasets/

<p align="center">
  <img src="/2025/week_6/Images/cdc_datasets_1.png" width="49%" 
    alt="A screenshot showing one section of a shiny app. 
    A horizontal navigation bar at the top displays in order from left to right: the title 'CDC Datasets', 
    an 'Overview' tab panel, a 'Programs' tab panel, a 'Keywords' tab panel' and a 'References' tab panel. 
    The 'Program' tab panel is selected and below the navigation bar is the page associated with this tab. 
    The title at the top of this page reads 'Number of datasets by program', and below it are 2 tab panels 
    'Plot' and 'Table'. The 'Plot' tab panel is selected and displayed below it is 
    a horizontal bar chart that visualizes the number of datasets related to
    each CDC program, with number of datasets on the x-axis,
    program names on the y-axis listed in descending order, and
    labels at the end of each bar displaying the count for each program.
    The program with the most datasets is 'Program Management', with 1037 
    datasets in total, a significantly higher count than any other program,
    with the second highest dataset count only being 108, belonging to the
    program 'National Institute for Occupational Safety and Health'. 
    The 'Table' tab accompanies the plot and displays the same data in table format.">
  &nbsp;
  <img src="/2025/week_6/Images/cdc_datasets_2.png" width="49%">
</p>

<p align="center">
  <img src="/2025/week_6/Images/cdc_datasets_3.png" width="49%">
  &nbsp;
  <img src="/2025/week_6/Images/cdc_datasets_4.png" width="49%">
</p>



## Files:
* __cdc_datasets_app.R__:
  
  Produces shiny app.

  
* __cdc_datasets_app_load_data.R__:

  Pulls TidyTuesday Week 6 2025 data & writes to the files __cdc_datasets.csv__ & __fpi_codes.csv__.


