# Capek attempt: problems with diacritics, lemmatization, etc.
# lemmatizator: http://lindat.mff.cuni.cz/services/morphodita/

library(tidyverse)

capek <- read_lines("capek_rur_lemma.txt")

library(tidytext)

# text_df <- as.tibble(capek)

text_df <- tibble(line = 1:4483, text = capek)

tidy_capek <- text_df %>%
  unnest_tokens(word, text)

tidy_capek %>%
  count(word, sort = TRUE)

library(ggplot2)

tidy_capek %>%
  count(word, sort = TRUE) %>%
  filter(n > 50) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()
