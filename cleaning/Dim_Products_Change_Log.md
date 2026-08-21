# Dim_Products — Data Cleaning Change Log

## Overview
This document records the Power Query transformations applied to `Dim_Products.csv`.

**Source File:** `Dim_Products.csv`  
**Transformation Tool:** Microsoft Power Query  
**Final Output Grain:** One product per `ProductCode`

## Transformation Log

| # | Step | Columns Affected | Transformation | Purpose |
|---:|---|---|---|---|
| 1 | `Source` | All columns | Imported the CSV using comma delimiter and UTF-8 encoding. | Load product master data. |
| 2 | `Promoted Headers` | All columns | Promoted the first row to headers. | Apply business field names. |
| 3 | `Changed Type` | All columns | Assigned Text, Integer, and Date data types. | Establish the product-dimension schema for pricing, cost, category, and launch-date analysis. |

## Final Columns

`ProductCode`, `ProductName`, `TherapeuticArea`, `Category`, `PackSize`, `ListPrice`, `UnitCost`, `LaunchDate`, `Status`
