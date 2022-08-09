# USE THIS SITE AS TUTORIAL:
# https://www.analyticsvidhya.com/blog/2017/03/beginners-guide-on-web-scraping-in-r-using-rvest-with-hands-on-knowledge/


# Setup
# install.packages("rvest")
library(rvest)
library(tidyverse)
library(stringr)
library(flextable)
library(magrittr)
library(polite)

####################################################################
# The Hairpin website
####################################################################

#Specifying the url for desired website to be scraped
url <- 'https://www.thehairpin.com/'

# url for each of 1-715 pages
new_urls <- "https://www.thehairpin.com/page/%s"

# Reading the HTML code from the website
page1 <- bow(url) %>%
 scrape() %>%
  # scraping the linked article paths
  html_elements("[href]") %>%
  html_attr("href") %>%
  # remove slugs (not what I want)
  purrr::discard(.p = ~stringr::str_detect(.x,
                                           "slug")) %>%
  purrr::keep(.p = ~stringr::str_detect(.x,
                      "https://www.thehairpin.com/20")) %>%
  unique()  %>%
  unlist() %>%
  sort() %T>%
  print()
  

my_list <- list()
i = 2
for (i in 2:715){
  
  subbed_url <- gsub("%s", i, new_urls)
  
  new_list <- bow(subbed_url) %>%
  scrape() %>%
  # scraping the linked article paths
  html_elements("[href]") %>%
  html_attr("href")
  my_list <- c(my_list, new_list)
  
  i = i + 1
  
  if (i == 715){
    # remove duplicates
    my_list <- unique(my_list) %>%
      # remove slugs (not what I want)
      purrr::discard(.p = ~stringr::str_detect(.x,
                                               "slug")) %>%
      purrr::keep(.p = ~stringr::str_detect(.x,
                                            "https://www.thehairpin.com/20")) %>%
      unlist() %>%
      sort()
    return(my_list)
    }
  }

all_articles <- c(page1, my_list)

# save list of article links as csv
write.csv(all_articles,
          file = "all_articles.csv")


# create a new script that opens up that csv
# 
# within that script, create function that selects 5 unique
# articles from it
# 
# create task w/windows scheduler to open that script and email 
# me those articles every week!
