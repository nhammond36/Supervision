## Load libraries
library(dplyr)
library(jsonlite)
library(quantmod)
library(zoo)


## Query TSLA price history
tsla <- quantmod::getSymbols("TSLA", from = base::as.Date("2021-12-09"), to = base::as.Date("2022-01-25"), auto.assign = F)


## Calculate percent change on TSLA close prices
tsla <- base::data.frame(Date = zoo::index(tsla), zoo::coredata(tsla)) %>% # Convert to a data frame because dplyr::mutate() cannot be applies to an 'xts' object and keep index as date column
  dplyr::arrange(dplyr::desc(Date)) %>% # Sort dates by descending order to ensure we calculate percent change correctly
  dplyr::mutate(Pct_change = (TSLA.Close / dplyr::lead(TSLA.Close)) - 1) # Calculate percent change


## Get current TSLA quote
quote <- quantmod::getQuote("TSLA")$Last


## Apply current quote to historical percent changes
tsla$VaR <- tsla$Pct_change * quote * 10 # Times 10 because we own 10 shares in our portfolio
