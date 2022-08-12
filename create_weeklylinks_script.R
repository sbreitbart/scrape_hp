# Setup
library(tidyverse) # Easily Install and Load the 'Tidyverse'
library(stringr) # Simple, Consistent Wrappers for Common String Operations
library(magrittr) # A Forward-Pipe Operator for R
library(gt) # Easily Create Presentation-Ready Display Tables
library(gtExtras) # Extending 'gt' for Beautiful HTML Tables
library(taskscheduleR) # Schedule R Scripts and Processes with the Windows Task Scheduler

# import list of article links as csv
all_articles_updated <- read.csv("all_articles_updated.csv")

# make function that selects 10 random links and puts them
# in new df
make_weekly_links <- function(all_articles_df){
  
  unsent_articles <- all_articles_df %>%
    dplyr::filter(is.na(Sent) == TRUE)
  
  selected_articles <- unsent_articles %>%
    dplyr::slice_sample(n = 10) %>%
    dplyr::mutate(Sent = Sys.Date())
  
  return(selected_articles)
  
}

make_hyperlink = function(myurl,mytext=myurl) {
  paste('<a href="',myurl,'">',mytext,'</a>')
}

# create df of 10 weekly links to send
weekly_links <- make_weekly_links(all_articles_updated) %>%
  dplyr::mutate(Sent = as.character(Sent)) %>%
  dplyr::select(ID, Article, Sent)

# create file of 10 weekly links
thedate <- strftime(Sys.Date(),"%Y_%m_%d")
thefile <- paste0("weekly_links/",thedate,".html")

weekly_links %>%
  gt() %>%
  fmt (
    columns = 'Article',
    fns = make_hyperlink
  ) %>%
  cols_align(
    align = "left",
    columns = c(ID, Article, Sent)
  ) %>%
  opt_row_striping() %>%
  opt_table_outline() %>% 
  gt_theme_guardian()  %>%
  gtsave(.,
       filename = thefile)


#######################################
# UPDATE: sending stuff through gmail is
# too complicated with the 2-factor
# authentication, unfortunately.
# 
# So instead, I'll just ask Windows to
# run a script that creates a new csv
# with 10 links every week and labels
# the filename with the date.
#######################################

# create df of unsent articles, export
unsent_articles <- anti_join(all_articles_updated,
                             weekly_links,
                             by = "ID") %T>%
  write.csv("unsent_articles.csv")

# update all_articles csv to include dates of sent links
all_articles_updated %<>%
  full_join(weekly_links,
            by = c("ID", "Article", "Sent")) %>%
  dplyr::mutate(Sent = as.factor(Sent)) %T>%
  write.csv("all_articles_updated.csv")


# used the Rstudio addin with taskscheduleR to run this every
# week!
