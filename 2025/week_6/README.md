## Tidy Tuesday - 2025 Week 6: CDC Datasets
R code used to produce a shiny app that visualizes metadata for CDC datasets uploaded before January 28th, 2025 and backed up on archive.org. 

App can be found here: https://aiburk.shinyapps.io/tidytuesday-cdc-datasets/

<p align="center">
  <img src="/2025/week_6/Images/cdc_datasets_0.png" width="60%" 
    alt="A screenshot showing one section of the shiny app. A horizontal navigation bar at the top displays in order from left to right: the title 'CDC Datasets', an 'Overview' tab panel, a 'Programs' tab panel, a 'Keywords' tab panel' and a 'References' tab panel. The 'Overview' tab panel is selected and below the navigation bar is the page associated with this tab. The title at the top left of this page reads 'Tidy Tuesday - 2025 Week 6', and below it is a text output that reads: 'Shiny app for exploratory analysis of CDC datasets that the Trump administration has purged. The Trump administration has ordered agencies to purge their websites of any references to topics such as LGBTQ+ rights and HIV (https://www.npr.org/sections/shots-health-news/2025/01/31/nx-s1-5282274/trump-administration-purges-health-websites). This week's dataset contains metadata for CDC datasets uploaded before January 28th, 2025, backed up on archive.org. Variables of interest include number of datasets per program, and most common keywords (tags) across all datasets as well as within each specific program's datasets. Created by Aidan Burk (https://github.com/aiburk) Data: https://archive.org/details/20250128-cdc-datasets'">
</p>

<p align="center">
  <img src="/2025/week_6/Images/cdc_datasets_1.png" width="49%" 
    alt="A screenshot showing one section of the shiny app. A horizontal navigation bar at the top displays in order from left to right: the title 'CDC Datasets', an 'Overview' tab panel, a 'Programs' tab panel, a 'Keywords' tab panel' and a 'References' tab panel. The 'Program' tab panel is selected and below the navigation bar is the page associated with this tab. The title at the top left of this page reads 'Number of datasets by program', and below it are 2 tab panels 'Plot' and 'Table'. The 'Plot' tab panel is selected and displayed below it is a horizontal bar chart that visualizes the number of datasets related to each CDC program, with number of datasets on the x-axis, program names on the y-axis listed in descending order, and labels at the end of each bar displaying the count for each program. The program with the most datasets is 'Program Management', with 1037 datasets in total, a significantly higher count than any other program, with the second highest dataset count only being 108, belonging to the program 'National Institute for Occupational Safety and Health'. The 'Table' tab accompanies the plot and displays the same data in table format.">
  &nbsp;
  <img src="/2025/week_6/Images/cdc_datasets_2.png" width="49%" 
    alt="A screenshot showing one section of the shiny app, a page with the title 'Most common keywords (tags)' at the top left. Below the title on the left is a sidebar panel with the label 'Datasets:', followed by 2 radio buttons underneath, labeled 'All datasets' and 'By program'. The radio button labeled 'All datasets' is selected, and beneath the radio buttons is a single checkbox with the label 'Exclude Program Management', which has been left un-checked. To the right of the sidebar, in the main panel, the title 'All Datasets' is displayed, and below is a line of text that displays the number of datasets this plot includes, reading: 'Number of datasets: 1257'. Further below there are 2 tab panels 'Plot' and 'Table'. The 'Plot' tab panel is selected and displayed below it is a horizontal bar chart that visualizes the most common keywords found in the tags of each CDC dataset, across all datasets. The x-axis represents word frequency, and the y-axis shows the highest 15 keywords listed in descending order, with labels at the end of each bar displaying the frequency for each word. The highest frequency is tied between 2 words having 292 occurrences each: 'wonder' and 'nndss'. The 'Table' tab accompanies the plot and displays the same data in table format, not limited to the highest 15 words.">
</p>

<p align="center">
  <img src="/2025/week_6/Images/cdc_datasets_3.png" width="49%" 
    alt="A screenshot showing one section of the shiny app, a page with the title 'Most common keywords (tags)' at the top left. Below the title on the left is a sidebar panel with the label 'Datasets:', followed by 2 radio buttons underneath, labeled 'All datasets' and 'By program'. The radio button labeled 'All datasets' is selected, and beneath the radio buttons is a single checkbox with the label 'Exclude Program Management', which has been checked. To the right of the sidebar, in the main panel, the title 'All Datasets (Excluding Program Management)' is displayed, and below is a line of text that displays the number of datasets this plot includes, reading: 'Number of datasets: 208'. Further below there are 2 tab panels 'Plot' and 'Table'. The 'Plot' tab panel is selected and displayed below it is a horizontal bar chart that visualizes the most common keywords found in the tags of each CDC dataset, across all datasets excluding those related to the program 'Program Management'. The x-axis represents word frequency, and the y-axis shows the highest 15 keywords listed in descending order, with labels at the end of each bar displaying the frequency for each word. The word with the most occurrences is 'covid-19' with a count of 20. The 'Table' tab accompanies the plot and displays the same data in table format, not limited to the highest 15 words.">
  &nbsp;
  <img src="/2025/week_6/Images/cdc_datasets_4.png" width="49%" 
    alt="A screenshot showing one section of the shiny app, a page with the title 'Most common keywords (tags)' at the top left. Below the title on the left is a sidebar panel with the label 'Datasets:', followed by 2 radio buttons underneath, labeled 'All datasets' and 'By program'. The radio button labeled 'By program' is selected, and beneath the radio buttons is a select list control with the label 'Select Program:', used to choose a single item from a list of program names. The currently selected program is 'Environmental Health'. To the right of the sidebar, in the main panel, the title 'Environmental Health' is displayed, and below is a line of text that displays the number of datasets this plot includes, reading: 'Number of datasets: 9'. Further below there are 2 tab panels 'Plot' and 'Table'. The 'Plot' tab panel is selected and displayed below it is a horizontal bar chart that visualizes the most common keywords found in the tags of each CDC dataset related to the program 'Environmental Health'. The x-axis represents word frequency, and the y-axis shows the highest 15 keywords listed in descending order, with labels at the end of each bar displaying the frequency for each word. The word with the most occurrences is ‘environmental health’ with a count of 7. The 'Table' tab accompanies the plot and displays the same data in table format, not limited to the highest 15 words.">
</p>

## Files:
* __cdc_datasets_app.R__:
  
  Produces shiny app.

  
* __cdc_datasets_app_load_data.R__:

  Pulls TidyTuesday Week 6 2025 data & writes to the files __cdc_datasets.csv__ & __fpi_codes.csv__.


