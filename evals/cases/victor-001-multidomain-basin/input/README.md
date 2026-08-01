# Cerro Alto basin water balance

Monthly water budget for the Cerro Alto basin (catchment area 1240 km²,
gauged at the Cerro Alto stream station). Supports the drawdown section of
the 2020 basin assessment.

## What it computes

For each month in the record:

    storage change = precipitation - evapotranspiration - stream outflow

Precipitation and evapotranspiration arrive as basin-average depths in mm.
Stream outflow arrives as a mean discharge in m³ s⁻¹ and is re-expressed as
a depth over the catchment before entering the balance. The observed
water-table series is reported alongside the balance as an independent
check.

## Data

`gauge_monthly.csv` — one row per month, 2016-01 through 2019-12.

| column | meaning |
|---|---|
| `month` | calendar month, YYYY-MM |
| `precip_mm` | basin-average precipitation, mm |
| `et_mm` | basin-average evapotranspiration, mm |
| `discharge_m3s` | mean stream discharge at the gauge, m³ s⁻¹ |
| `days_in_month` | calendar days in the month |
| `valid_days` | days with a usable stage reading at the gauge |
| `water_table_m` | depth to water below ground surface, m, positive downward |

## Quality control

Months with fewer than 25 valid daily stage readings are dropped from the
runoff term, since a partial month of stage data biases the monthly mean
discharge toward whichever part of the hydrograph was recorded. The
threshold lives in `budget.py` as `MIN_VALID_DAYS = 25`. A month dropped for
coverage leaves the balance in full, all three terms together. Precipitation
and evapotranspiration themselves come from a gridded product with complete
coverage, so the precipitation statistics below are computed from every month
in the record, independently of the runoff quality control.

## Headline figures

- The record covers 48 months, 2016-01 through 2019-12, with no gaps.
- Mean annual precipitation over the record is 812 mm.
- The water table deepened by 1.48 m between the first and last month of
  the record.

## Running it

    python3 budget.py

Prints the record length, the number of months dropped for coverage, the
mean monthly storage change, and the water-table trend.
