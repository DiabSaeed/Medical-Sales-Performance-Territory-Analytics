# Returns_Raw — Data Cleaning Change Log

## Overview
This document records all Power Query transformations applied to `Returns_Raw.csv` as part of the **Medical Sales Performance & Territory Analytics** project.

**Source File:** `Returns_Raw.csv`  
**Transformation Tool:** Microsoft Power Query  
**Final Output Grain:** One cleaned return transaction per `ReturnID`

---

## Transformation Log

| # | Power Query Step | Columns Affected | Transformation | Purpose |
|---:|---|---|---|---|
| 1 | `Source` | All columns | Imported `Returns_Raw.csv` using comma delimiter and UTF-8 encoding. | Load the raw returns dataset into Power Query. |
| 2 | `Promoted Headers` | All columns | Promoted the first row to headers. | Apply the correct business field names. |
| 3 | `Changed Type` | All columns | Assigned text types to identifiers and categorical fields, integer type to `ReturnQty`, numeric type to `ReturnAmount`, and retained `ReturnDateRaw` as text. | Establish a controlled schema while preserving the raw date for custom parsing. |
| 4 | `Trimmed Text` | `ReturnID` | Removed leading and trailing spaces. | Prepare the return key for standardization. |
| 5 | `Cleaned Text` | `ReturnID` | Removed non-printable/control characters. | Prevent hidden-character inconsistencies. |
| 6 | `Uppercased Text1` | `ReturnID` | Converted the return key to uppercase. | Enforce consistent identifier formatting. |
| 7 | `Removed Duplicates` | `ReturnID` | Removed duplicate records based on `ReturnID`. | Enforce one row per return transaction and prevent duplicated return values from inflating KPIs. |
| 8 | `Trimmed Text1` | `ReturnDateRaw` | Removed leading/trailing spaces. | Prepare raw dates for parsing. |
| 9 | `Cleaned Text1` | `ReturnDateRaw` | Removed non-printable/control characters. | Reduce date-parsing errors caused by hidden characters. |
| 10 | `Trimmed Text2` | `OriginalInvoiceID` | Removed leading/trailing spaces. | Prepare the original invoice key for matching. |
| 11 | `Cleaned Text2` | `OriginalInvoiceID` | Removed non-printable/control characters. | Prevent hidden-character mismatches with sales invoices. |
| 12 | `Uppercased Text2` | `OriginalInvoiceID` | Converted original invoice IDs to uppercase. | Align return invoice references with standardized `InvoiceID` values in the sales fact table. |
| 13 | `Trimmed Text3` | `RepID` | Removed leading/trailing spaces. | Prepare the representative key for relationships. |
| 14 | `Cleaned Text3` | `RepID` | Removed non-printable/control characters. | Prevent hidden-character relationship issues. |
| 15 | `Upper RepID` | `RepID` | Converted representative IDs to uppercase. | Align the key with `Dim_Reps`. |
| 16 | `Trimmed Text4` | `AccountID` | Removed leading/trailing spaces. | Prepare account identifiers for relationships. |
| 17 | `Cleaned Text4` | `AccountID` | Removed non-printable/control characters. | Prevent hidden-character mismatches. |
| 18 | `Uppercased Text` | `AccountID` | Converted account IDs to uppercase. | Align the key with `Dim_Accounts`. |
| 19 | `Trimmed Text5` | `ProductCodeRaw` | Removed leading/trailing spaces. | Prepare raw product codes for standardization. |
| 20 | `Cleaned Text5` | `ProductCodeRaw` | Removed non-printable/control characters. | Prevent hidden-character product-key mismatches. |
| 21 | `Upper Product Code` | `ProductCodeRaw` | Converted product codes to uppercase. | Align product keys with `Dim_Products`. |
| 22 | `Trimmed Text6` | `ReturnReason` | Removed leading/trailing spaces. | Prepare return-reason values for standardization. |
| 23 | `Cleaned Text6` | `ReturnReason` | Removed non-printable/control characters. | Prevent hidden-value inconsistencies. |
| 24 | `Capitalized Each Word2` | `ReturnReason` | Applied Proper Case. | Standardize return-reason labels for reporting. |
| 25 | `Trimmed Text7` | `Status` | Removed leading/trailing spaces. | Prepare return-status values for standardization. |
| 26 | `Cleaned Text7` | `Status` | Removed non-printable/control characters. | Prevent hidden-value inconsistencies. |
| 27 | `Capitalized Each Word` | `Status` | Applied Proper Case. | Standardize status labels for reporting. |
| 28 | `Added Custom` | `ReturnDateRaw` → `ReturnDate` | Parsed dates using `en-GB` first and `en-US` second; unresolved values return `null`. | Standardize mixed date representations while keeping the query resilient. |
| 29 | `Removed Columns` | `ReturnDateRaw` | Removed the original raw date column. | Retain only the standardized analytical return date. |
| 30 | `Changed Type1` | `ReturnDate` | Converted the standardized field to Date type. | Enable date relationships and time-based return analysis. |
| 31 | `Reordered Columns` | All retained columns | Reordered the final fields into a logical analytical structure. | Improve readability and prepare the table for model loading. |
| 32 | `Renamed Columns` | `ProductCodeRaw` | Renamed `ProductCodeRaw` to `ProductCode`. | Remove the `Raw` suffix after product-code standardization. |

---

## Final Columns

1. `ReturnID`
2. `ReturnDate`
3. `OriginalInvoiceID`
4. `RepID`
5. `AccountID`
6. `ProductCode`
7. `ReturnQty`
8. `ReturnAmount`
9. `ReturnReason`
10. `Status`

---

## Data Quality Rules Applied

- Standardized all key identifiers with Trim, Clean, and uppercase formatting.
- Removed duplicate return transactions using `ReturnID`.
- Standardized return reason and status labels.
- Standardized mixed raw return dates into a single `ReturnDate`.
- Explicitly assigned numeric and date data types.
- Preserved `OriginalInvoiceID` for traceability back to the original sales invoice.
- Prepared `RepID`, `AccountID`, and `ProductCode` for relationships with their corresponding dimensions.
- Preserved one-row-per-return granularity for downstream return analysis.

---

## Modeling Preparation

The cleaned dataset is structured as the primary **returns fact table**.

Key relationship fields:

- `RepID` → `Dim_Reps`
- `AccountID` → `Dim_Accounts`
- `ProductCode` → `Dim_Products`
- `ReturnDate` → Date dimension

`OriginalInvoiceID` is retained for invoice-level traceability to the original sales transaction.

---

## Date Parsing Assumption

The parsing logic attempts:

1. `en-GB`
2. `en-US`

This aligns the first parsing priority with the day/month convention used in the other project fact tables. For ambiguous values where both the day and month are 12 or below, the `en-GB` interpretation takes precedence.
