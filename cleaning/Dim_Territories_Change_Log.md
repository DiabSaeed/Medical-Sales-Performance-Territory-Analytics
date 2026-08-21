# Dim_Territories — Data Cleaning Change Log

## Overview
This document records the Power Query transformations applied to `Dim_Territories.csv`.

**Source File:** `Dim_Territories.csv`  
**Transformation Tool:** Microsoft Power Query  
**Final Output Grain:** One territory per `TerritoryID`

## Transformation Log

| # | Step | Columns Affected | Transformation | Purpose |
|---:|---|---|---|---|
| 1 | `Source` | All columns | Imported the CSV using comma delimiter and UTF-8 encoding. | Load territory master data. |
| 2 | `Promoted Headers` | All columns | Promoted the first row to headers. | Apply business field names. |
| 3 | `Changed Type` | All columns | Assigned Text and Numeric data types. | Establish the territory-dimension schema. |
| 4 | `Trimmed Text` | `TerritoryName` | Removed leading/trailing spaces. | Standardize territory names. |
| 5 | `Cleaned Text` | `TerritoryName` | Removed non-printable characters. | Prevent hidden-character mismatches. |
| 6 | `Capitalized Each Word` | `TerritoryName` | Applied Proper Case. | Standardize territory-name capitalization. |

## Final Columns

`TerritoryID`, `TerritoryName`, `Governorate`, `Region`, `MarketPotentialIndex`
