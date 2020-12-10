#' ---
#' output:
#'    pdf_document:
#'        keep_tex: yes
#'        latex_engine: lualatex
#' ---


## ----setup, include=FALSE-------------------------------------------------
library(knitr)
knitr::opts_chunk$set(cache = TRUE, warning = FALSE, message = FALSE,
                      echo = TRUE, dpi = 300, cache.lazy = FALSE,
                      tidy = "styler", fig.width = 8, fig.height = 5)
options(cli.width = 85)
options(crayon.enabled = FALSE)
library(ggplot2)
theme_set(theme_light())

# example of using library: janeustenr
## ----original_books-------------------------------------------------------
library(janeaustenr)
library(dplyr)
library(stringr)

original_books <- austen_books() %>%
  group_by(book) %>%
  mutate(linenumber = row_number(),
         chapter = cumsum(str_detect(text, regex("^chapter [\\divxlc]",
                                                 ignore_case = TRUE)))) %>%
  ungroup()

original_books


## ----tidy_books_raw, dependson = "original_books"-------------------------
library(tidytext)
tidy_books <- original_books %>%
  unnest_tokens(word, text)

tidy_books


## ----tidy_books, dependson = "tidy_books_raw"-----------------------------
data(stop_words)

tidy_books <- tidy_books %>%
  anti_join(stop_words)


## ----dependson = "tidy_books"---------------------------------------------
tidy_books %>%
  count(word, sort = TRUE)


## ----plotcount, dependson = "tidy_books", fig.width=6, fig.height=5, fig.cap="The most common words in Jane Austen's novels"----
library(ggplot2)

tidy_books %>%
  count(word, sort = TRUE) %>%
  filter(n > 600) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()

# the same but with gutenberg download
## To learn more about gutenbergr, check out the [package's tutorial at rOpenSci](https://ropensci.org/tutorials/gutenbergr_tutorial.html), where it is one of rOpenSci's packages for data access.


## ----eval = TRUE---------------------------------------------------------
library(gutenbergr)

## Own example: Alice

alice <- gutenberg_download(11)

tidy_alice <- alice %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

tidy_alice %>%
  count(word, sort = TRUE)


library(ggplot2)


tidy_alice %>%
  count(word, sort = TRUE) %>%
  filter(n > 50) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
  ggtitle("Alice: most common words")

