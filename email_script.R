# Setup
# install.packages("rvest")
library(tidyverse)
library(stringr)
library(magrittr)
library(mailR)
library(htmlTable)

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

# create df of 10 weekly links to send
weekly_links <- make_weekly_links(all_articles_updated) %>%
  dplyr::mutate(Sent = as.character(Sent)) %>%
  dplyr::select(ID, Article, Sent) %>%
  # Convert the data frame into an HTML Table
  htmlTable()

# Send these links in an email
# Define body of email
html_body <- paste0("<p> This is a test email. </p>",
                    weekly_links)

# Configure details to send email using mailR
sender <- "sophie.breitbart@gmail.com"
recipients <- c("sophie.breitbart@gmail.com")

mailR::send.mail(from = sender,
          to = recipients,
          subject = "Subject of the email",
          body = "Body of the email",
          smtp = list(host.name = "aspmx.l.google.com", port = 25),
          authenticate = FALSE,
          send = TRUE)


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


# send in email

# create task w/windows scheduler to open that script and email 
# me those articles every week!
