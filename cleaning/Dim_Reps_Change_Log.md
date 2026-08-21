# Dim_Reps — Data Cleaning Change Log

## Overview
This document records the Power Query transformations applied to `Dim_Reps.csv`.

**Source File:** `Dim_Reps.csv`  
**Transformation Tool:** Microsoft Power Query  
**Final Output Grain:** One sales representative per `RepID`

## Transformation Log

| # | Step | Columns Affected | Transformation | Purpose |
|---:|---|---|---|---|
| 1 | `Source` | All columns | Imported the CSV using comma delimiter and UTF-8 encoding. | Load sales-representative master data. |
| 2 | `Promoted Headers` | All columns | Promoted the first row to headers. | Apply business field names. |
| 3 | `Changed Type` | All columns | Assigned Text, Date, and Integer data types. | Establish a controlled representative-dimension schema. |
| 4 | `Removed Columns` | `TerritoryName`, `Governorate` | Removed descriptive territory attributes. | Reduce redundancy and retrieve territory attributes through `Dim_Territories`. |

## Final Columns

`RepID`, `RepName`, `Team`, `Manager`, `HireDate`, `TerminationDate`, `TerritoryID`, `BaseMonthlyTarget`, `Status`
