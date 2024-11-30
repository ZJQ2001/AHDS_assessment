# Load required libraries
library(dplyr)
library(tidytext)
library(stringr)
library(SnowballC)

# Read the data
data <- read.delim("clean/processed_data.tsv", sep = "\t")

# Process the 'Title' column
processed_data <- data %>%
  unnest_tokens(word, Title) %>%              # Tokenize the titles into words
  filter(!word %in% stop_words$word) %>%      # Remove stop words
  filter(!str_detect(word, "\\d+")) %>%       # Remove digits
  mutate(word = wordStem(word)) %>%           # Stem the words
  group_by(PMID, Year) %>%                    # Regroup data
  summarise(Processed_Title = paste(word, collapse = " "), .groups = 'drop') # Reconstruct titles

# Merge processed titles back with the original dataset and remove NA values
final_data <- data %>%
  select(-Title) %>%
  left_join(processed_data, by = c("PMID", "Year")) %>%
  filter(!is.na(Processed_Title))             # Remove rows with NA values

# Write or preview the cleaned dataset
head(final_data)
write.table(final_data, "clean/processed_data_output.tsv", sep = "\t", row.names = FALSE)
