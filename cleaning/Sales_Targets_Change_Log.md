# Sales_Targets — Data Cleaning Change Log

## Overview
This document records the Power Query transformations applied to `Sales_Targets.csv`.

**Source File:** `Sales_Targets.csv`  
**Transformation Tool:** Microsoft Power Query  
**Final Output Grain:** One monthly sales target record per `RepID × ProductCode × Month`

## Transformation Log

| # | Step | Columns Affected | Transformation | Purpose |
|---:|---|---|---|---|
| 1 | `Source` | All columns | Imported the CSV using comma delimiter and UTF-8 encoding. | Load monthly sales-target data. |
| 2 | `Promoted Headers` | All columns | Promoted the first row to headers. | Apply business field names. |
| 3 | `Changed Type` | All columns | Assigned Date, Text, and Integer data types. | Establish a controlled schema for target analysis. |
| 4 | `Extracted Month Name` | `Month` | Replaced the date value with the month name. | Present month values in a readable categorical format. |
| 5 | `Trimmed Text` | `RepID` | Removed leading/trailing spaces. | Standardize representative identifiers. |
| 6 | `Cleaned Text` | `RepID` | Removed non-printable characters. | Prevent relationship mismatches. |
| 7 | `Capitalized Each Word` | `RepID` | Applied Proper Case. | Standardize identifier casing. |
| 8 | `Trimmed Text1` | `ProductCode` | Removed leading/trailing spaces. | Standardize product identifiers. |
| 9 | `Cleaned Text1` | `ProductCode` | Removed non-printable characters. | Prevent product relationship mismatches. |
| 10 | `Capitalized Each Word1` | `ProductCode`, `TargetStatus` | Applied Proper Case. | Standardize product-code and status casing. |
| 11 | `Cleaned Text2` | `TargetStatus` | Removed non-printable characters. | Standardize target-status labels. |
| 12 | `Trimmed Text2` | `TargetStatus` | Removed leading/trailing spaces. | Eliminate inconsistent status values caused by extra spaces. |

## Final Columns

`Month`, `RepID`, `ProductCode`, `SalesTarget`, `UnitsTarget`, `TargetStatus`
