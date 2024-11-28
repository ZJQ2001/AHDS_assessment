# Load required libraries
library(dplyr)
library(ggplot2)
library(tidyr)
library(tidytext)  # Ensure tidytext is loaded
library(SnowballC)
library(stringr)  # Load stringr for str_detect

# Read the data
data <- read.delim("clean/processed_data.tsv", sep = "\t", quote = "")  # Handle any quoting issues

# Tokenize titles, remove stop words, and stem words
processed_data <- data %>%
  unnest_tokens(word, Title) %>%              # Tokenize titles into words
  filter(!word %in% stop_words$word) %>%      # Remove stop words
  filter(!str_detect(word, "\\d+")) %>%       # Remove digits
  mutate(word = SnowballC::wordStem(word))    # Stem words

# Count word frequencies by year
word_counts <- processed_data %>%
  group_by(Year, word) %>%
  summarise(Frequency = n(), .groups = 'drop') %>%
  arrange(desc(Frequency))

# Identify the top 10 most frequent words
top_words <- word_counts %>%
  group_by(word) %>%
  summarise(Total_Frequency = sum(Frequency)) %>%
  arrange(desc(Total_Frequency)) %>%
  slice(1:10) %>%
  pull(word)

# Filter for the top words
filtered_data <- word_counts %>%
  filter(word %in% top_words)

# Plot the frequency of top words over time
plot <- ggplot(filtered_data, aes(x = Year, y = Frequency, color = word, group = word)) +
  geom_line(size = 1) +
  scale_x_continuous(limits = c(min(filtered_data$Year), 2024)) +  # Set x-axis limits
  labs(title = "Trends in Top Words Over Time",
       x = "Year",
       y = "Frequency",
       color = "Words") +
  theme_minimal()

# Save the plot
ggsave("graph/word_frequency_trend.png", plot = plot, width = 6, height = 6)

