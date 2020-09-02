library(palmerpenguins)
library(tidyverse)
library(knitr)
library(rmarkdown)

#read in and pre-process data
pdata <- palmerpenguins::penguins_raw %>%
  janitor::clean_names() %>%
  mutate(label = str_replace(
    string = species,
    pattern = " \\(",
    replacement = "\n("
  ))

#create a list for mapping
studies <- unique(pdata$study_name)

generate_reports <- function(study) {
  #I like to superassign some objects for troubleshooting, but it isn't necessary
  study <<- study
  p_df <<- pdata %>% filter(study_name == study)
  min_date <- min(p_df$date_egg, na.rm = TRUE)
  max_date <- max(p_df$date_egg, na.rm = TRUE)
  title <- paste("Study: ", study)
  subtitle <- paste("From: ", min_date, "To: ", max_date)

  rmarkdown::render(
    input = "penguin report.Rmd",
    #The RMarkdown file that will produce the report
    output_format = "word_document",
    #How should the report be produced. Can be a single value or a vector
    output_dir = "./reports",
    #Directory to write reports to if not the working directory
    params = list(
      #Values to pass to the frontmatter.
      Date = Sys.Date(),
      Title = title,
      Subtitle = subtitle,
      Study = study
    ),
    output_file = paste0("Report_", study) #Give each file a unique name
  )
}
map(studies, ~ generate_reports(.x))
