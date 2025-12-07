# Load Packages
options(repos = c(CRAN = "https://cloud.r-project.org"))
install.packages("quantmod")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("lubridate")

library(quantmod)
library(dplyr)
library(ggplot2)
library(lubridate)

# Create folders
if (!dir.exists("plots")) {
  dir.create("plots")
}
if (!dir.exists("data")) {
  dir.create("data")
}

# Download Data
symbols <- c("AAPL", "TSLA", "MSFT")
all_data <- data.frame()

for (sym in symbols) {
  stock <- getSymbols(sym, src = "yahoo", auto.assign = FALSE)
  price <- Cl(stock)
  ret <- dailyReturn(price)

  temp <- data.frame(
    date = as.Date(index(price)),
    symbol = sym,
    close = as.numeric(price),
    ret = as.numeric(ret)
  )

  all_data <- rbind(all_data, temp)
}

# Sort data
all_data <- all_data %>%
  arrange(symbol, date) %>%
  mutate(ret = ifelse(is.na(ret), 0, ret))

# Cumulative Return
df_cum <- all_data %>%
  group_by(symbol) %>%
  mutate(ret = ifelse(is.na(ret), 0, ret),cumret = cumprod(1 + ret))

# Monthly Return
all_data$month <- floor_date(all_data$date, "month")

df_month <- all_data %>%
  mutate(month = floor_date(date, "month")) %>%
  group_by(symbol, month) %>%
  summarise(
    monthly_ret = prod(1 + ret, na.rm = TRUE) - 1,
    .groups = 'drop'
  )
# Plot: Cumulative Returns
p_cum <- ggplot(df_cum, aes(x = date, y = cumret, color = symbol)) +
  geom_line(linewidth = 1) +
  scale_y_continuous(labels = scales::dollar_format()) +
  labs(title = "Cumulative Return (Growth of $1)", x = "Date", y = "Cumulative Value") +
  theme_minimal() +
  theme(legend.title = element_blank())

ggsave("plots/cumulative_returns.png", p_cum, width = 8, height = 5)

# Plot: Monthly Returns
p_month <- ggplot(df_month, aes(x = month, y = monthly_ret, fill = symbol)) + # color 대신 fill 사용 권장
  geom_bar(stat = "identity", position = "dodge") +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Monthly Returns", x = "Month", y = "Monthly Return (%)") +
  theme_minimal() +
  theme(legend.title = element_blank())

ggsave("plots/monthly_returns.png", p_month, width = 8, height = 5)

# Save data
write.csv(all_data, "data/daily_prices.csv", row.names = FALSE)
write.csv(df_cum, "data/cumulative_returns.csv", row.names = FALSE)
write.csv(df_month, "data/monthly_returns.csv", row.names = FALSE)
