# Sales_Raw — Data Cleaning Change Log

## Overview
This document records all Power Query transformations applied to `Sales_Raw.csv` as part of the **Medical Sales Performance & Territory Analytics** project.

**Source File:** `Sales_Raw.csv`  
**Transformation Tool:** Microsoft Power Query  
**Final Output Grain:** One cleaned sales invoice line per `InvoiceLineID`

## Transformation Log

| # | Power Query Step | Columns Affected | Transformation | Purpose |
|---:|---|---|---|---|
| 1 | `Source` | All columns | Imported the CSV using comma delimiter and UTF-8 encoding. | Load the raw sales dataset. |
| 2 | `Promoted Headers` | All columns | Promoted the first row to headers. | Use the correct business field names. |
| 3 | `Changed Type` | All columns | Assigned controlled data types while keeping `InvoiceDateRaw` as text. | Preserve raw dates for later parsing and establish the initial schema. |
| 4 | `Removed Duplicates` | `InvoiceLineID` | Removed duplicate records based on `InvoiceLineID`. | Prevent duplicate sales lines from inflating KPIs. |
| 5 | `Removed Columns` | `RepNameRaw`, `AccountNameRaw`, `ProductNameRaw`, `AccountTypeRaw` | Removed descriptive fields available in dimension tables. | Reduce redundancy and prepare the fact table for dimensional modeling. |
| 6 | `Trimmed Text` | `TerritoryRaw` | Removed leading and trailing spaces. | Standardize territory values. |
| 7 | `Capitalized Each Word` | `TerritoryRaw` | Applied Proper Case. | Standardize territory capitalization. |
| 8 | `Trimmed Text1` | `Governorate` | Removed leading and trailing spaces. | Standardize governorate values. |
| 9 | `Cleaned Text` | `Governorate`, `TerritoryRaw` | Removed non-printable characters. | Prevent hidden-character mismatches in joins and grouping. |
| 10 | `Capitalized Each Word1` | `Governorate` | Applied Proper Case. | Standardize governorate naming. |
| 11 | `Trimmed Text2` | `TherapeuticArea` | Removed leading and trailing spaces. | Standardize therapeutic-area values. |
| 12 | `Capitalized Each Word2` | `TherapeuticArea` | Applied Proper Case. | Standardize therapeutic-area capitalization. |
| 13 | `Changed Type1` | `DiscountPct` | Converted to Percentage type. | Ensure discounts are interpreted correctly in calculations. |
| 14 | `Trimmed Text3` | `DataSource`, `OrderChannel`, `PaymentStatus`, `PaymentTerms` | Removed leading and trailing spaces. | Standardize operational categorical fields. |
| 15 | `Cleaned Text1` | `DataSource`, `OrderChannel`, `PaymentStatus`, `PaymentTerms` | Removed non-printable characters. | Avoid hidden-value inconsistencies. |
| 16 | `Capitalized Each Word3` | `DataSource`, `OrderChannel`, `PaymentStatus`, `PaymentTerms` | Applied Proper Case. | Standardize reporting labels. |
| 17 | `Trimmed Text4` | `RepID` | Removed leading and trailing spaces. | Prepare `RepID` for model relationships. |
| 18 | `Added Custom` | `InvoiceDateRaw` → `InvoiceDate` | Parsed multiple date formats: `dd/MM/yyyy`, `MM/dd/yyyy`, `yyyy-MM-dd`, and `dd-MMM-yyyy`; unresolved values return `null`. | Standardize mixed source date formats into one analytical date. |
| 19 | `Removed Columns1` | `InvoiceDateRaw` | Removed the original raw date column. | Retain only the standardized analytical date field. |
| 20 | `Trimmed Text5` | `RepID` | Re-applied trimming. | Reinforce ID standardization. |
| 21 | `Cleaned Text2` | `RepID` | Removed non-printable characters. | Prevent relationship mismatches. |
| 22 | `Trimmed Text6` | `InvoiceID` | Removed leading and trailing spaces. | Standardize invoice identifiers. |
| 23 | `Cleaned Text3` | `InvoiceID` | Removed non-printable characters. | Ensure reliable invoice grouping and matching. |
| 24 | `Trimmed Text7` | `InvoiceLineID` | Removed leading and trailing spaces. | Standardize the transaction-level key. |
| 25 | `Cleaned Text4` | `InvoiceLineID` | Removed non-printable characters. | Protect the unique line identifier from hidden-character issues. |
| 26 | `Renamed Columns` | `TerritoryRaw`, `ProductCodeRaw` | Renamed to `Territory` and `ProductCode`. | Remove the `Raw` suffix after standardization. |
| 27 | `Changed Type2` | `InvoiceDate` | Explicitly assigned Date type. | Support time intelligence and date-model relationships. |
| 28 | `Reordered Columns` | All retained columns | Reordered the final columns into a logical analytical structure. | Improve readability and prepare the table for loading to the model. |

## Removed Fields

- `RepNameRaw`
- `AccountNameRaw`
- `ProductNameRaw`
- `AccountTypeRaw`
- `InvoiceDateRaw` — replaced by `InvoiceDate`

## Final Columns

`InvoiceLineID`, `InvoiceID`, `InvoiceDate`, `RepID`, `Territory`, `Governorate`, `AccountID`, `ProductCode`, `TherapeuticArea`, `Qty`, `UnitPrice`, `DiscountPct`, `GrossSales`, `NetSales`, `PaymentTerms`, `PaymentStatus`, `OrderChannel`, `DataSource`

## Data Quality Rules Applied

- Removed duplicate sales lines using `InvoiceLineID`.
- Standardized text fields with Trim, Clean, and Proper Case transformations.
- Removed redundant descriptive attributes from the fact table.
- Standardized mixed raw date formats into a single `InvoiceDate`.
- Cleaned key identifiers before model relationships.
- Explicitly assigned percentage and date data types.

## Important Date Parsing Assumption

The date logic attempts `dd/MM/yyyy` before `MM/dd/yyyy`. Therefore, an ambiguous value such as `05/07/2025` is interpreted as **5 July 2025** before the US-style interpretation is attempted. This should be documented as a business assumption unless each source system has a deterministic date-format rule.
