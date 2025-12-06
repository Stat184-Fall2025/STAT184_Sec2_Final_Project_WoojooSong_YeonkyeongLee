
# Load Packages
options(repos = c(CRAN = "https://cloud.r-project.org"))

pkgs <- c("quantmod", "dplyr", "tidyr", "ggplot2", "lubridate", "scales")
invisible(lapply(pkgs, function(p){
  if(!requireNamespace(p, quietly = TRUE)) install.packages(p)
  library(p, character.only = TRUE)
}))

#Create needed folders
if(!dir.exists("plots")) dir.create("plots")
if(!dir.exists("data")) dir.create("data")

# Download Data
symbols <- c("AAPL", "TSLA", "MSFT")

get_stock <- function(sym) {
  xt <- quantmod::getSymbols(sym, src="yahoo", auto.assign = FALSE)
  price <- Cl(xt)
  ret <- dailyReturn(price)

  tibble(
    date   = as.Date(index(price)),
    symbol = sym,
    close  = as.numeric(price),
    ret    = as.numeric(ret)
  )
}

df <- bind_rows(lapply(symbols, get_stock)) %>%
  arrange(symbol, date)

# Cumulative Return
df_cum <- df %>%
  group_by(symbol) %>%
  arrange(date, .by_group = TRUE) %>%
  mutate(cumret = cumprod(1 + replace_na(ret, 0)))

# Monthly Return
df_monthly <- df %>%
  mutate(month = floor_date(date, "month")) %>%
  group_by(symbol, month) %>%
  summarize(monthly_ret = prod(1 + ret, na.rm = TRUE) - 1,
            .groups = "drop")

# Plot 1: Closing Price
p_price <- df %>%
  ggplot(aes(date, close, color = symbol)) +
  geom_line(linewidth = 0.8) +
  labs(title="Closing Price Over Time",
       x="Date", y="Price (USD)") +
  theme_minimal()

ggsave("plots/closing_price.png", p_price, width=8, height=5, dpi=300)

# Plot 2: Cumulative Returns
p_cum <- df_cum %>%
  ggplot(aes(date, cumret, color=symbol)) +
  geom_line(linewidth = 0.8) +
  labs(title="Cumulative Return (Growth of $1)",
       x="Date", y="Cumulative Value") +
  theme_minimal()

ggsave("plots/cumulative_returns.png", p_cum, width=8, height=5, dpi=300)

# Plot 3: Distribution of Daily Returns
p_hist <- df %>%
  ggplot(aes(ret, fill=symbol)) +
  geom_histogram(alpha=0.6, bins=50, position="identity") +
  labs(title="Distribution of Daily Returns",
       x="Daily Return", y="Frequency") +
  scale_x_continuous(labels = percent_format(accuracy=0.1)) +
  theme_minimal()

ggsave("plots/daily_return_hist.png", p_hist, width=8, height=5, dpi=300)

# Plot 4: Monthly Returns
p_month <- df_monthly %>%
  ggplot(aes(month, monthly_ret, color=symbol)) +
  geom_line(linewidth=0.9) +
  labs(title="Monthly Returns",
       x="Month", y="Monthly Return") +
  scale_y_continuous(labels = percent_format(accuracy = 1)) +
  theme_minimal()

ggsave("plots/monthly_returns.png", p_month, width=8, height=5, dpi=300)

