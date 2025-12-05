# Load packages
library(dplyr)
library(ggplot2)
library(stringr)
library(readr)

# Load dataset
movies <- read_csv("./data/tmdb_5000_movies.csv")

# Data cleaning, filtering out the invalid data

movies_clean <- movies %>%
  filter(budget > 0,
         revenue > 0,
         vote_average > 0,
         runtime > 0)

# Extract genre (first genre name)
movies_clean <- movies_clean %>%
  mutate(genre = str_extract(genres, "(?<=name\": \")[A-Za-z]+"))


# 1. Scatter Plot: Budget vs Revenue

p1 <- ggplot(movies_clean, aes(x = budget, y = revenue)) +
  geom_point(alpha = 0.3) +
  scale_x_log10() +
  scale_y_log10() +
  geom_smooth(method = "lm", color = "red") +
  labs(
    title = "Budget vs Revenue",
    x = "Budget (log scale)",
    y = "Revenue (log scale)"
  )

ggsave("./plots/scatter_budget_revenue.png", p1, width = 7, height = 5)


# 2. Boxplot: Rating by Genre

movies_genre <- movies_clean %>%
  filter(!is.na(genre))

p2 <- ggplot(movies_genre, aes(x = genre, y = vote_average, fill = genre)) +
  geom_boxplot() +
  coord_flip() +
  labs(
    title = "Movie Ratings by Genre",
    x = "Genre",
    y = "Average Rating"
  ) +
  theme(legend.position = "none")

ggsave("./plots/boxplot_genre_rating.png", p2, width = 7, height = 5)


# 3. Scatter Plot: Runtime vs Rating

p4 <- ggplot(movies_clean, aes(x = runtime, y = vote_average)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", color = "blue") +
  labs(
    title = "Runtime vs Movie Rating",
    x = "Runtime (minutes)",
    y = "Movie Rating"
  )

ggsave("./plots/scatter_runtime_rating.png", p4, width = 7, height = 5)

