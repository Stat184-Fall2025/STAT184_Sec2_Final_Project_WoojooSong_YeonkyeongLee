# Stock Return Analysis Using Yahoo Finance Data

This project analyzes daily, cumulative, and monthly returns of selected stocks using historical price data from Yahoo Finance. The goal is to demonstrate data collection, transformation, and visualization workflows in R.

## Overview

In this project, we collect historical stock price data for AAPL, TSLA, and MSFT using the `quantmod` package. Daily returns are calculated and aggregated to produce cumulative returns and monthly returns. The results are visualized using `ggplot2` and exported as figures, while processed datasets are saved for reproducibility and further analysis.

### Interesting Insight (Optional)

One interesting insight from this analysis is how differently cumulative growth trajectories evolve across stocks even when observed over the same time period. The cumulative return plot highlights how volatility and compounding interact to produce diverging long-term outcomes.  
(See `plots/cumulative_returns.png`.)

## Data Sources and Acknowledgements

- Stock price data are obtained from Yahoo Finance via the `quantmod` R package.
- This project uses the following R packages: `quantmod`, `dplyr`, `ggplot2`, and `lubridate`.

## Current Plan

The current focus of the project is exploratory analysis and visualization of stock returns. Future extensions may include adding more assets, comparing different time periods, or incorporating risk metrics such as volatility and drawdowns.

## Repo Structure

- `data/`  
  Contains processed CSV files including daily prices, cumulative returns, and monthly returns.
- `plots/`  
  Stores generated visualizations such as cumulative return and monthly return plots.
- `scripts/`  
  Contains R scripts used for data collection, processing, and visualization.
- `report.qmd`  
  Quarto source file used to generate the final report.
- `report.pdf`  
  Rendered PDF report of the analysis.

## Authors

- Woojoo Song  
- Yeonkyeong Lee  

For questions regarding this project, please contact the authors through GitHub.
