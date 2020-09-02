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

#create a list of study names over which we'll map the function
studies <- unique(pdata$study_name)

generate_reports <- function(study) {
  #I like to superassign some objects for troubleshooting, but it isn't necessary
  study <<- study
  #I used the below in my talk, but have changed to passing the data via the params argument in the rmarkdown::render() function
  # p_df <<- pdata %>% filter(study_name == study)
  min_date <- min(p_df$date_egg, na.rm = TRUE)
  max_date <- max(p_df$date_egg, na.rm = TRUE)
  title <- paste("Study: ", study)
  subtitle <- paste("From: ", min_date, "To: ", max_date)

  rmarkdown::render(
    #The RMarkdown file that will produce the report
    input = "penguin report.Rmd",
    #How should the report be produced. Can be a single value or a vector
    output_format = "word_document",
    #Directory to write reports to if not the working directory
    output_dir = "./reports",
    params = list(
      #Values to pass to the YAML header or to use as a variable within the .rmd file
      Date = Sys.Date(),
      Title = title,
      Subtitle = subtitle,
      Study = study,
      Min_Date = min_date,
      Max_Date = max_date,
      Data = pdata %>% filter(study_name == study) #you can pass the data as a parameter!
    ),
    output_file = paste0("Report_", study) #Give each file a unique name
  )
}

#run the function on each element of the list of Palmer penguin studies
purrr::map(studies, ~ generate_reports(.x))
