# Dim_Accounts — Data Cleaning Change Log

## Overview
This document records the Power Query transformations applied to `Dim_Accounts.csv`.

**Source File:** `Dim_Accounts.csv`  
**Transformation Tool:** Microsoft Power Query  
**Final Output Grain:** One commercial account per `AccountID`

## Transformation Log

| # | Step | Columns Affected | Transformation | Purpose |
|---:|---|---|---|---|
| 1 | `Source` | All columns | Imported the CSV using comma delimiter and UTF-8 encoding. | Load commercial account master data. |
| 2 | `Promoted Headers` | All columns | Promoted the first row to headers. | Apply business field names. |
| 3 | `Changed Type` | All columns | Assigned Text, Integer, Date, and Numeric data types. | Establish the account-dimension schema. |
| 4 | `Removed Columns` | `TerritoryName`, `Governorate`, `Region` | Removed descriptive geography attributes. | Reduce redundancy and retrieve geography through `Dim_Territories`. |

## Final Columns

`AccountID`, `AccountName`, `AccountType`, `TerritoryID`, `Segment`, `CreditLimit`, `JoinDate`, `Status`, `PotentialIndex`
