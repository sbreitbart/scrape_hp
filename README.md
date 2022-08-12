# Creating a weekly link roundup from a defunct blog with web scraping

I found a fun blog that was active in the 2010s (and sadly is no more) called [The Hairpin](https://www.thehairpin.com/).

I thought, "I wish I knew about this blog 10 years ago so I could keep tabs on the articles!"

But then, I realized I could use R to automatically deliver a weekly link roundup so that I could pretend I was reading the blog every week while it was still active.

## Here's what I did:

1. Scrape all ~15,000 blog post links from The Hairpin and write them into one csv.
2. Each time the script is run, randomly choose 10 articles and put their links into a pretty table (with hyperlinks).
3. Update the original csv with all of the links with a new column showing when each link was chosen so that they are not chosen twice.
4. Set up `taskscheduleR`, an RStudio AddIn, to run the script and export that weekly pretty table into an html that I can peruse.

It was a lot of fun. If I hadn't already grown up with it, I'd also consider doing this with [Rookie](https://www.rookiemag.com/).

## A remaining challenge:
Learning how to send that pretty table in an email. I suspect Google's Gmail servers have gotten pretty selective about what gets through, even though I input my Gmail username and password for security.
