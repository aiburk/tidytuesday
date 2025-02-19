# Description: Shiny App for exploratory analysis of metadata for CDC datasets 
#              uploaded before January 28th, 2025, backed up on archive.org.
#              TidyTuesday, Week 6 2025.
# Author: Aidan Burk
# Date Created: 2/13/2025
# Date Edited: 2/18/2025
# Data: 'https://archive.org/details/20250128-cdc-datasets'

# Packages ----------------------------------------------------------------

library(tidyverse)
library(sqldf) 
library(tidytext)
library(shiny)
library(shinythemes)


# Load Data ---------------------------------------------------------------

cdc_datasets <- read_csv("./Data/cdc_datasets.csv", show_col_types = FALSE)
fpi_codes <- read_csv("./Data/fpi_codes.csv", show_col_types = FALSE)


# Clean Data --------------------------------------------------------------

# Using SQL select query to join program names to cdc_datasets
programs <- sqldf("
SELECT 
  dataset_url,
  NULLIF(tags, 'This dataset does not have any tags') AS tags,
  c.program_code,
  program_name
FROM cdc_datasets AS c
LEFT JOIN fpi_codes AS f
ON c.program_code = f.program_code_pod_format
      ;")

# SQL select query to obtain dataset counts for each program
programs_count <- sqldf("
SELECT 
  program_name,
  COUNT(program_name) AS n
FROM cdc_datasets AS c
LEFT JOIN fpi_codes AS f
ON c.program_code = f.program_code_pod_format
WHERE program_name IS NOT NULL
GROUP BY program_name
ORDER BY n DESC, program_name
      ;")


# Shiny App ---------------------------------------------------------------
## Static alt text -----------------------------
# Alt text for keyword frequency bar chart across all datasets
wordplot_all_alt <-
  "A horizontal bar chart that visualizes the most common keywords
      found in the tags of each CDC dataset, across all datasets.
      The x-axis represents word frequency, and the y-axis shows the 
      highest 15 keywords listed in descending order, with
      labels at the end of each bar displaying the frequency for each word.
      The highest frequency is tied between 2 words having 292
      occurrences each: 'wonder' and 'nndss'.
      Above the plot is a line of text that displays the number of datasets
      this plot includes, reading: 'Number of datasets: 1257'."
# Alt text for keyword frequency bar chart across all datasets excluding
# Program Management
wordplot_all_exclude_pmgmt_alt <-
  "A horizontal bar chart that visualizes the most common keywords
      found in the tags of each CDC dataset, across all datasets
      excluding those related to the program 'Program Management'.
      The x-axis represents word frequency, and the y-axis shows the 
      highest 15 keywords listed in descending order, with
      labels at the end of each bar displaying the frequency for each word.
      The word with the most occurrences is 'covid-19' with a count of 20.
      Above the plot is a line of text that displays the number of datasets
      this plot includes, reading: 'Number of datasets: 208'."
# Alt text for bar chart of count of datasets by program
programplot_alt <-
  "A horizontal bar chart that visualizes the number of datasets related to
      each CDC program, with number of datasets on the x-axis,
      program names on the y-axis listed in descending order, and
      labels at the end of each bar displaying the count for each program.
      The program with the most datasets is 'Program Management', with 1037 
      datasets in total, a significantly higher count than any other program,
      with the second highest dataset count only being 108, belonging to the
      program 'National Institute for Occupational Safety and Health'."

##  UI  ----------------------------------------
ui <- tagList(
  tags$html(lang="en"),
  tags$a(tags$style(HTML("a {color: #6a5eff}"))),
  navbarPage(
    theme = shinythemes::shinytheme("cerulean"),
    title = 'CDC Datasets',
    windowTitle = 'CDC Datasets',
    ### Overview tab ----
    tabPanel('Overview',
             h1(span(HTML('Tidy Tuesday - 2025 Week 6'), 
                     style = 'margin-left: 0px !important;')),
             htmlOutput('overview')
             ),
    ### Programs tab ----
    tabPanel('Programs',
             titlePanel('Number of datasets by program'),
             tabsetPanel(type = 'tabs',
                         tabPanel('Plot',
                                  plotOutput('programplot'),
                                  actionButton("text_programplot", "Show alt text"
                                               )
                                  ),
                         tabPanel('Table',
                                  DT::DTOutput('programtable')
                                  )
                         )
             ),
    ### Keywords tab ----
    tabPanel('Keywords',
             titlePanel('Most common keywords (tags)'),
             sidebarLayout(
               sidebarPanel(
                 radioButtons('selection',
                              'Datasets: ',
                              choices = c('All datasets', 'By program')
                              ),
                 conditionalPanel("input.selection == 'All datasets'",
                                  checkboxInput('exclude_pmgmt',
                                                'Exclude Program Management'
                                                )
                                  ),
                 conditionalPanel("input.selection == 'By program'",
                                  selectInput('program', 
                                              'Select program:',
                                              unique(programs_count$program_name)
                                              )
                                  )
                 ),
               mainPanel(
               conditionalPanel("input.selection == 'All datasets' &&
                                input.exclude_pmgmt == false",
                                titlePanel('All Datasets'),
                                textOutput('datasetcount_all'),
                                tabsetPanel(type = 'tabs',
                                            tabPanel('Plot',
                                                     plotOutput('wordplot_all'),
                                                     actionButton(
                                                       'text_wordplot_all',
                                                       'Show alt text')
                                                     ),
                                            tabPanel('Table',
                                                     DT::DTOutput('wordtable_all')
                                                     )
                                            )
                                ),
               conditionalPanel("input.selection == 'All datasets' &&
                                input.exclude_pmgmt == true",
                                titlePanel(
                                  'All Datasets (Excluding Program Management)'
                                  ),
                                textOutput('datasetcount_all_exclude_pmgmt'),
                                tabsetPanel(type = 'tabs',
                                            tabPanel(
                                              'Plot',
                                              plotOutput(
                                                'wordplot_all_exclude_pmgmt'
                                                ),
                                              actionButton(
                                                'text_wordplot_all_exclude_pmgmt',
                                                'Show alt text'
                                                )
                                            ),
                                            tabPanel('Table',
                                                     DT::DTOutput('wordtable_all_exclude_pmgmt')
                                            )
                                            )
                                ),
               conditionalPanel("input.selection == 'By program'",
                                titlePanel(textOutput('title_program')),
                                textOutput('datasetcount_program'),
                                tabsetPanel(type = 'tabs',
                                            tabPanel('Plot',
                                                     plotOutput(
                                                       'wordplot_program'
                                                       ),
                                                     actionButton(
                                                       'text_wordplot_program',
                                                       'Show alt text'
                                                       )
                                            ),
                                            tabPanel('Table',
                                                     DT::DTOutput('wordtable_program')
                                                     )
                                            )
                                )
               )
               )
             ),
    ### References tab ----
    tabPanel('References',
             htmlOutput('references')
             )
    )
  )

##  Server ------------------------------------
server <- function(input, output, session) {
  ### Reactive expressions ----
  # Reactive - Most frequent keywords across all datasets
  wordcount_all <- reactive({
    programs |> 
      unnest_tokens(word, input = tags, token = str_split, pattern = ', ') |>
      count(word, sort = TRUE) |>
      drop_na()
  })
  # Reactive - Most frequent keywords across all datasets
  # (Excluding Program Management)
  wordcount_all_exclude_pmgmt <- reactive({
    programs |> 
      filter(program_name != 'Program Management') |>
      unnest_tokens(word, input = tags, token = str_split, pattern = ', ') |>
      count(word, sort = TRUE) |>
      drop_na()
  })
  # Reactive - Most frequent keywords based on program
  wordcount_program <- reactive({
    programs |> 
      filter(program_name == input$program) |>
      unnest_tokens(word, input = tags, token = str_split, pattern = ", ") |> 
      count(word, sort = TRUE) |>
      drop_na()
  })
  # Reactive - Value to nudge bar plot labels by, based on program
  program_nudge_y <- reactive({
    wordcount_program() |>
      head(15) |>
      select(n) |>
      min() /8
  })
  # Reactive - alt text for keyword frequency bar chart based on program
  wordplot_program_alt <- reactive({
    ifelse(
      nrow(wordcount_program()) == 0,
      yes = 
        "No plot is displayed here due to there being no tags in the datasets 
        related to this program.",
      no =
        paste(
        "A horizontal bar chart that visualizes the most common keywords
        found in the tags of each CDC dataset related to the program '",
        input$program,
        "'. The x-axis represents word frequency, and the y-axis shows ",
        ifelse(
          nrow(wordcount_program()) < 15,
          yes = 
            ifelse(
              nrow(wordcount_program()) == 1,
              yes = "1 keyword",
              no = paste(
                "all ",
                nrow(wordcount_program()),
                " keywords"
              )
            ),
          no = "the highest 15 keywords listed in descending order"
        ),
        ", with ",
        ifelse(
          nrow(wordcount_program()) == 1,
          yes = 
            paste("a label at the end of the bar displaying its frequency. 
                  The singular keyword associated with this program is ",
                  wordcount_program()[1,1] |> sQuote(),
                  ", having 1 occurrence in the data. ",
                  sep = ""
            ),
          no = "labels at the end of each bar displaying the frequency for 
          each word. "
        ),
        ifelse(
          nrow(wordcount_program()) == 1,
          yes = "",
          no =
            ifelse(
              wordcount_program()[1,2] == wordcount_program()[2,2],
              yes = 
                paste(
                  "The highest frequency is tied between ",
                  wordcount_program() |> filter(n == max(n)) |> nrow(),
                  " words having ",
                  wordcount_program()[1,2],
                  ifelse(
                    wordcount_program()[1,2] == 1,
                    yes = " occurrence each: ",
                    no = " occurrences each: "
                  ),
                  wordcount_program() |> 
                    filter(n == max(n)) |>
                    select(word) |>
                    unlist() |>
                    sQuote() |>
                    str_flatten_comma(last = ', and '),
                  ". ",
                  sep = ""
                ),
              no = 
                paste(
                  "The word with the most occurrences is ",
                  wordcount_program()[1,1],
                  " with a count of ",
                  wordcount_program()[1,2],
                  ". ",
                  sep = ""
                )
            )
        ),
        "Above the plot is a line of text that displays the number of datasets
        this plot includes, reading: 'Number of datasets: ",
        programs |>
          filter(program_name == input$program) |>
          nrow(),
        "'. ",
        sep = ""
    )
    )
  })
  ### Text outputs ----
  # Text - Program name
  output$title_program <- renderText({
    input$program
  })
  # Text - Count of all datasets
  output$datasetcount_all <- renderText({
    paste('Number of datasets: ',
          programs |>
            nrow())
    })
  # Text - Count of all datasets (Excluding Program Management)
  output$datasetcount_all_exclude_pmgmt <- renderText({
    paste('Number of datasets: ',
          programs |>
            filter(program_name != 'Program Management') |>
            nrow())
  })
  # Text - Count of datasets based on program
  output$datasetcount_program <- renderText({
    paste('Number of datasets: ',
          programs |>
            filter(program_name == input$program) |>
            nrow())
    })
  # Text - Overview
  output$overview <- renderText({
    shiny::markdown(
      paste('Shiny app for exploratory analysis of CDC datasets
              that the Trump administration has purged.',
            'The Trump administration has ordered agencies to purge their 
              websites of any references to topics such as LGBTQ+ rights and HIV
              (https://www.npr.org/sections/shots-health-news/2025/01/31/nx-s1-5282274/trump-administration-purges-health-websites).',
            "This week's dataset contains metadata for CDC datasets
              uploaded before January 28th, 2025, backed up on archive.org.",
            "Variables of interest include number of datasets per program, and
              most common keywords (tags) across all datasets as well as within
              each specific program's datasets.",
            'Created by Aidan Burk (https://github.com/aiburk)',
            'Data: https://archive.org/details/20250128-cdc-datasets',
            sep = '\n\n')
    )
  })
  # Text - References
  output$references <- renderText({
    shiny::markdown(
      paste('<b>References</b>',
            'Centers for Disease Control and Prevention (2025). 
              "CDC datasets uploaded before January 28th, 2025."
              https://archive.org/details/20250128-cdc-datasets.',
            'Chang W (2021). _shinythemes: Themes for Shiny_. R package version
              1.2.0, <https://CRAN.R-project.org/package=shinythemes>.',
              'Chang W, Cheng J, Allaire J, Sievert C, Schloerke B, Xie Y, Allen J,
             McPherson J, Dipert A, Borges B (2024). _shiny: Web Application
              Framework for R_. R package version 1.9.1,
              <https://CRAN.R-project.org/package=shiny>.',
            'Data Science Learning Community (2024). 
              Tidy Tuesday: A weekly social data project. https://tidytues.day',
              'Grothendieck G (2017). _sqldf: Manipulate R Data Frames Using SQL_. 
              Rpackage version 0.4-11, 
              <https://CRAN.R-project.org/package=sqldf>.',
            "Harmon J, Hughes E (2024). _tidytuesdayR: Access the Weekly
              'TidyTuesday' Project Dataset_. R package version 1.1.2,
              <https://CRAN.R-project.org/package=tidytuesdayR>.",
            "Henderson E, Scales J, Yates J (2025). 
              _shinya11y: Accessibility (a11y)
              Tooling for 'Shiny'_. R package version 0.0.0.9000, commit
              4f17db8f0c06e7332258e6c499e3c4af36fd4a17,
              <https://github.com/ewenme/shinya11y>.",
            'Silge J, Robinson D (2016). 
              “tidytext: Text Mining and Analysis Using
              Tidy Data Principles in R.” _JOSS_, *1*(3). doi:10.21105/joss.00037
              <https://doi.org/10.21105/joss.00037>, 
              <http://dx.doi.org/10.21105/joss.00037>.',
            'Stone, W. (2025). “Trump administration purges websites across 
              federal health agencies,” NPR.
             https://www.npr.org/sections/shots-health-news/2025/01/31/nx-s1-5282274/trump-administration-purges-health-websites',
            'Wickham H, Averick M, Bryan J, Chang W, McGowan LD, François R,
              Grolemund G, Hayes A, Henry L, Hester J, Kuhn M, Pedersen TL, 
              Miller E, Bache SM, Müller K, Ooms J, Robinson D, Seidel DP, 
              Spinu V, Takahashi K, Vaughan D, Wilke C, Woo K, Yutani H (2019). 
              “Welcome to the tidyverse.” _Journal of Open Source Software_, 
              *4*(43), 1686. doi:10.21105/joss.01686 
              <https://doi.org/10.21105/joss.01686>.',
            sep = '\n\n')
    )
  })
  ### Plots, tables, & alt text ----
  #### Datasets by program ----
  # Plot - Bar chart of count of datasets by program
  output$programplot <- renderPlot({
    programs_count |>
      ggplot(aes(x = reorder(program_name, n), y = n, fill = n)) +
      geom_col() +
      scale_fill_gradient(low ='#B8E8E0', high ="#00A596", guide = 'none') +
      ylab('Number of datasets') +
      geom_text(aes(label = n), nudge_y = 40) +
      theme_minimal() +
      theme(axis.title.y = element_blank(),
            text = element_text(size = 12)) +
      coord_flip()
  },
  alt = 
    programplot_alt
  )
  # Table - Table of count of datasets by program
  output$programtable <- DT::renderDT({
    programs_count
  })
  # Observer - Show alt text for program bar chart
  observeEvent(input$text_programplot, {
    showModal(modalDialog(
      title = "Alternative Text",
      programplot_alt,
      easyClose = TRUE
    ))
  })
  #### Word frequency, based on program ----
  # Plot - Bar chart of most frequent keywords based on program
  output$wordplot_program <- renderPlot({
    validate(need(nrow(wordcount_program()) > 0, "No tags for this selection."))
    wordcount_program() |> 
      head(15) |>
      ggplot(aes(x = reorder(word, n), y = n, fill = n)) +
      geom_col() +
      scale_fill_gradient(low ='#B8E8E0', high ="#00A596", guide = 'none') +
      ylab('Word Frequency') +
      geom_text(aes(label = n), nudge_y = program_nudge_y()) +
      coord_flip() +
      theme_minimal() +
      theme(axis.title.y = element_blank(),
            text = element_text(size = 12))
  },
  alt = reactive({
    wordplot_program_alt()
  })
  )
  # Table - Table of most frequent keywords based on program
  output$wordtable_program <- DT::renderDT({
    wordcount_program()
  })
  # Observer - Show alt text for keyword frequency bar chart based on program
  observeEvent(input$text_wordplot_program, {
    showModal(modalDialog(
      title = "Alternative Text",
      wordplot_program_alt(),
      easyClose = TRUE
      )
    )
  })
  #### Word frequency, across all datasets ----
  # Plot - Bar chart of most frequent keywords across all datasets
  output$wordplot_all <- renderPlot({
    all_nudge_y <- wordcount_all() |>
      head(15) |>
      select(n) |>
      min() /8
    wordcount_all() |> 
      head(15) |>
      ggplot(aes(x = reorder(word, n), y = n, fill = n)) +
      geom_col() +
      scale_fill_gradient(low ='#B8E8E0', high ="#00A596", guide = 'none') +
      ylab('Word Frequency') +
      geom_text(aes(label = n), nudge_y = all_nudge_y) +
      coord_flip() +
      theme_minimal() +
      theme(axis.title.y = element_blank(),
            text = element_text(size = 12))
  },
  alt = wordplot_all_alt
  )
  # Table - Table of most frequent keywords across all datasets
  output$wordtable_all <- DT::renderDT({
    wordcount_all()
  })
  # Observer - Show alt text for keyword frequency bar chart of all datasets
  observeEvent(input$text_wordplot_all, {
    showModal(modalDialog(
      title = "Alternative Text",
      wordplot_all_alt,
      easyClose = TRUE
    ))
  })
  #### Word frequency, all datasets excl. Program Management ----
  # Plot - Bar chart of most frequent keywords across all datasets
  # (Excluding Program Management)
  output$wordplot_all_exclude_pmgmt <- renderPlot({
    all_exclude_pmgmt_nudge_y <- wordcount_all_exclude_pmgmt() |>
      head(15) |>
      select(n) |>
      min() /6
    wordcount_all_exclude_pmgmt() |> 
      head(15) |>
      ggplot(aes(x = reorder(word, n), y = n, fill = n)) +
      geom_col() +
      scale_fill_gradient(low ='#B8E8E0', high ="#00A596", guide = 'none') +
      ylab('Word Frequency') +
      geom_text(aes(label = n), nudge_y = all_exclude_pmgmt_nudge_y) +
      coord_flip() +
      theme_minimal() +
      theme(axis.title.y = element_blank(),
            text = element_text(size = 12))
  },
  alt = wordplot_all_exclude_pmgmt_alt)
  # Table - Table of most frequent keywords across all datasets
  # (Excluding Program Management)
  output$wordtable_all_exclude_pmgmt <- DT::renderDT({
    wordcount_all_exclude_pmgmt()
  })
  # Observer - Show alt text for keyword frequency bar chart of 
  # all datasets excluding Program Management
  observeEvent(input$text_wordplot_all_exclude_pmgmt, {
    showModal(modalDialog(
      title = "Alternative Text",
      wordplot_all_exclude_pmgmt_alt,
      easyClose = TRUE
    ))
  })
}

shinyApp(ui, server)