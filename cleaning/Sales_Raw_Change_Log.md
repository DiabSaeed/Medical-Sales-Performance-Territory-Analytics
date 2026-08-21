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
| 2 | `Promoted Headers` | All columns | Promoted the first row to headers. | Apply business field names. |
| 3 | `Changed Type` | All columns | Assigned initial text, integer, and numeric data types while retaining `InvoiceDateRaw` as text. | Establish a controlled schema while preserving raw dates for custom parsing. |
| 4 | `Removed Duplicates` | `InvoiceLineID` | Removed duplicates based on `InvoiceLineID`. | Enforce one row per invoice line and prevent inflated sales KPIs. |
| 5 | `Removed Columns` | `RepNameRaw`, `AccountNameRaw`, `ProductNameRaw`, `AccountTypeRaw` | Removed descriptive attributes available from dimensions. | Reduce fact-table redundancy. |
| 6 | `Trimmed Text` | `TerritoryRaw` | Removed leading/trailing spaces. | Prepare territory values for standardization. |
| 7 | `Cleaned Text5` | `TerritoryRaw` | Removed non-printable characters. | Prevent hidden-character mismatches. |
| 8 | `Capitalized Each Word` | `TerritoryRaw` | Applied Proper Case. | Standardize territory capitalization. |
| 9 | `Trimmed Text1` | `Governorate` | Removed leading/trailing spaces. | Prepare governorate values for standardization. |
| 10 | `Cleaned Text` | `Governorate` | Removed non-printable characters. | Prevent hidden-character inconsistencies. |
| 11 | `Capitalized Each Word1` | `Governorate` | Applied Proper Case. | Standardize governorate naming. |
| 12 | `Trimmed Text2` | `TherapeuticArea` | Removed leading/trailing spaces. | Prepare therapeutic-area values for standardization. |
| 13 | `Cleaned Text8` | `TherapeuticArea` | Removed non-printable characters. | Prevent hidden-value inconsistencies. |
| 14 | `Capitalized Each Word2` | `TherapeuticArea` | Applied Proper Case. | Standardize therapeutic-area capitalization. |
| 15 | `Changed Type1` | `DiscountPct` | Converted the field to Percentage type. | Ensure correct interpretation in calculations and reports. |
| 16 | `Trimmed Text3` | `DataSource`, `OrderChannel`, `PaymentStatus`, `PaymentTerms` | Removed leading/trailing spaces. | Prepare operational categorical fields for standardization. |
| 17 | `Cleaned Text1` | `DataSource`, `OrderChannel`, `PaymentStatus`, `PaymentTerms` | Removed non-printable characters. | Prevent hidden-value inconsistencies. |
| 18 | `Capitalized Each Word3` | `DataSource`, `OrderChannel`, `PaymentStatus`, `PaymentTerms` | Applied Proper Case. | Standardize reporting labels. |
| 19 | `Trimmed Text4` | `RepID` | Removed leading/trailing spaces. | Prepare the representative key for relationships. |
| 20 | `Added Custom` | `InvoiceDateRaw` → `InvoiceDate` | Parsed `dd/MM/yyyy`, `MM/dd/yyyy`, `yyyy-MM-dd`, and `dd-MMM-yyyy`; unresolved values return `null`. | Standardize mixed raw date formats. |
| 21 | `Removed Columns1` | `InvoiceDateRaw` | Removed the raw date after creating `InvoiceDate`. | Retain the standardized analytical date only. |
| 22 | `Cleaned Text2` | `RepID` | Removed non-printable characters. | Prevent relationship mismatches with `Dim_Reps`. |
| 23 | `Trimmed Text6` | `InvoiceID` | Removed leading/trailing spaces. | Standardize invoice identifiers. |
| 24 | `Cleaned Text3` | `InvoiceID` | Removed non-printable characters. | Ensure reliable invoice grouping and matching. |
| 25 | `Trimmed Text7` | `InvoiceLineID` | Removed leading/trailing spaces. | Standardize the transaction-level key. |
| 26 | `Cleaned Text4` | `InvoiceLineID` | Removed non-printable characters. | Protect the unique invoice-line key. |
| 27 | `Renamed Columns` | `TerritoryRaw`, `ProductCodeRaw` | Renamed to `Territory` and `ProductCode`. | Remove the `Raw` suffix after preparation for analytical use. |
| 28 | `Changed Type2` | `InvoiceDate` | Assigned Date type. | Enable date relationships and time intelligence. |
| 29 | `Reordered Columns` | All retained columns | Reordered the final fields. | Improve readability and model preparation. |
| 30 | `Trimmed Text5` | `AccountID` | Removed leading/trailing spaces. | Prepare the account key for relationships. |
| 31 | `Cleaned Text6` | `AccountID` | Removed non-printable characters. | Prevent mismatches with `Dim_Accounts`. |
| 32 | `Trimmed Text8` | `ProductCode` | Removed leading/trailing spaces. | Prepare the product key for relationships. |
| 33 | `Cleaned Text7` | `ProductCode` | Removed non-printable characters. | Prevent mismatches with `Dim_Products`. |
| 34 | `Uppercased Text` | `InvoiceLineID`, `InvoiceID`, `RepID`, `AccountID`, `ProductCode` | Converted key identifiers to uppercase. | Enforce consistent key formatting across the analytical model. |

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
- Standardized descriptive fields with Trim, Clean, and Proper Case.
- Standardized key fields with Trim, Clean, and uppercase formatting.
- Removed redundant descriptive attributes from the fact table.
- Standardized mixed raw date formats into `InvoiceDate`.
- Explicitly assigned percentage and date data types.
- Prepared `RepID`, `AccountID`, and `ProductCode` for dimension relationships.
- Preserved one-row-per-invoice-line granularity.

## Modeling Preparation

The cleaned dataset is structured as the primary **sales fact table**.

- `RepID` → `Dim_Reps`
- `AccountID` → `Dim_Accounts`
- `ProductCode` → `Dim_Products`
- `InvoiceDate` → Date dimension

Descriptive representative, account, and product attributes are intentionally excluded from the fact table to reduce redundancy and support a star-schema design.

## Date Parsing Assumption

The parsing logic attempts:

1. `dd/MM/yyyy` (`en-GB`)
2. `MM/dd/yyyy` (`en-US`)
3. `yyyy-MM-dd`
4. `dd-MMM-yyyy`

For ambiguous dates, `dd/MM/yyyy` takes precedence. For example, `05/07/2025` is interpreted as **5 July 2025**.
