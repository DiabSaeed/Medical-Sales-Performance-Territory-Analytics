# Activity_Targets — Data Cleaning Change Log

## Overview
This document records the Power Query transformations applied to `Activity_Targets.csv`.

**Source File:** `Activity_Targets.csv`  
**Transformation Tool:** Microsoft Power Query  
**Final Output Grain:** One monthly activity target per `RepID × Month`

## Transformation Log

| # | Step | Columns Affected | Transformation | Purpose |
|---:|---|---|---|---|
| 1 | `Source` | All columns | Imported the CSV using comma delimiter and UTF-8 encoding. | Load monthly field-activity targets. |
| 2 | `Promoted Headers` | All columns | Promoted the first row to headers. | Apply business field names. |
| 3 | `Changed Type` | All columns | Assigned Date, Text, and Integer data types. | Establish the activity-target schema. |
| 4 | `Extracted Month Name` | `Month` | Replaced the original date with the month name. | Present the target period as a readable month category. |

## Final Columns

`Month`, `RepID`, `VisitsTarget`, `ProductiveCallsTarget`
