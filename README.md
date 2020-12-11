# ANALYSIS OF DATASET 5 BY Group 22

## Abstract

The goal of this project is to find which company is undervalued by using 2013 and 2014 data. By using stepwise feature selection, we choose Depreciation, Net.Income, Retained,Earnings and Estimated.Shares.Outstanding as predictors. We build Market.Capital=6.366Net.Income+0.347Retained.Earnings+13.152Estimated.Shares.OutstandingMarket.Capital
As a result, the top 20 undervalued stocks which investors can buy into are found by using 2013 and 2014 data, which include PBCT, EW, IDXX, HBAN, NFLX, SPLS, HPQ, PBI, AIZ, CHD, MAS, DNB, HRL, PDCO, MPC, CNC, WU, XRX, FLIR and ARNC.

# Contributors 
  - Zonglin Wu (B00764717)      
  - Ziwei Wang (B00776666)
  - Yuchan Zhong (B00791155)


# Requirements
  - Rstudio
  - Rmarkdown
  - lubridate
  - car
  - leaps
  - knitr
  
# Usage
  open a terminal and goto the root directory of repo.
  do 
    make:
      create a pdf report. (needs network)
    make clean:
      clean all data used in report and pdf.
