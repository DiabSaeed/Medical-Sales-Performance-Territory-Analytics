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
| 2 | `Promoted Headers` | All columns | Promoted the first row to column headers. | Apply the correct business field names. |
| 3 | `Changed Type` | All columns | Assigned initial data types: text for identifiers/categorical fields, integer for `ReturnQty`, numeric for `ReturnAmount`, and text for `ReturnDateRaw`. | Establish a controlled schema while preserving the raw date for later parsing. |
| 4 | `Trimmed Text` | `ReturnID` | Removed leading and trailing spaces. | Standardize the unique return identifier. |
| 5 | `Cleaned Text` | `ReturnID` | Removed non-printable/control characters. | Prevent hidden-character inconsistencies in the return key. |
| 6 | `Removed Duplicates` | `ReturnID` | Removed duplicate return records using `ReturnID`. | Enforce one row per return transaction and prevent duplicate return amounts from inflating KPIs. |
| 7 | `Trimmed Text1` | `ReturnDateRaw` | Removed leading and trailing spaces. | Prepare the raw return date for reliable parsing. |
| 8 | `Cleaned Text1` | `ReturnDateRaw` | Removed non-printable/control characters. | Prevent hidden characters from causing date conversion errors. |
| 9 | `Trimmed Text2` | `OriginalInvoiceID` | Removed leading and trailing spaces. | Standardize invoice identifiers used to trace returns back to original sales transactions. |
| 10 | `Cleaned Text2` | `OriginalInvoiceID` | Removed non-printable/control characters. | Ensure reliable matching with the original sales invoice. |
| 11 | `Trimmed Text3` | `RepID` | Removed leading and trailing spaces. | Standardize sales representative identifiers before relationships. |
| 12 | `Cleaned Text3` | `RepID` | Removed non-printable/control characters. | Prevent mismatches with `Dim_Reps`. |
| 13 | `Capitalized Each Word` | `RepID` | Applied Proper Case formatting. | Standardize representative ID text casing. |
| 14 | `Trimmed Text4` | `AccountID` | Removed leading and trailing spaces. | Standardize account identifiers before model relationships. |
| 15 | `Cleaned Text4` | `AccountID` | Removed non-printable/control characters. | Prevent mismatches with `Dim_Accounts`. |
| 16 | `Trimmed Text5` | `ProductCodeRaw` | Removed leading and trailing spaces. | Standardize raw product codes before matching to the product dimension. |
| 17 | `Cleaned Text5` | `ProductCodeRaw` | Removed non-printable/control characters. | Prevent hidden-character mismatches in product relationships. |
| 18 | `Capitalized Each Word1` | `ProductCodeRaw` | Applied Proper Case formatting. | Normalize product-code casing. |
| 19 | `Trimmed Text6` | `ReturnReason` | Removed leading and trailing spaces. | Standardize return-reason values. |
| 20 | `Cleaned Text6` | `ReturnReason` | Removed non-printable/control characters. | Avoid hidden-value inconsistencies in return analysis. |
| 21 | `Capitalized Each Word2` | `ReturnReason`, `Status` | Applied Proper Case formatting. | Standardize return-reason and status labels for reporting. |
| 22 | `Trimmed Text7` | `Status` | Removed leading and trailing spaces. | Standardize return-status values. |
| 23 | `Cleaned Text7` | `Status` | Removed non-printable/control characters. | Prevent hidden-character inconsistencies in filtering and grouping. |
| 24 | `Added Custom` | `ReturnDateRaw` → `ReturnDate` | Created a standardized date field by attempting `en-US` parsing first, then `en-GB`; unresolved values return `null`. | Handle mixed return-date formats while keeping query execution resilient. |
| 25 | `Removed Columns` | `ReturnDateRaw` | Removed the original raw date field after creating `ReturnDate`. | Retain only the standardized analytical date field. |
| 26 | `Changed Type1` | `ReturnDate` | Explicitly converted the new field to Date type. | Enable date relationships and time-based return analysis. |
| 27 | `Reordered Columns` | All retained columns | Reordered fields into a logical analytical structure. | Improve readability and prepare the table for loading into the data model. |
| 28 | `Renamed Columns` | `ProductCodeRaw` | Renamed `ProductCodeRaw` to `ProductCode`. | Remove the `Raw` suffix after product-code standardization. |

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

- Standardized identifiers using Trim and Clean transformations.
- Removed duplicate return transactions using `ReturnID`.
- Standardized product codes, return reasons, and statuses.
- Standardized mixed raw return-date formats into a single `ReturnDate`.
- Explicitly assigned numeric and date data types.
- Preserved the relationship between returns and original sales through `OriginalInvoiceID`.
- Prepared `RepID`, `AccountID`, and `ProductCode` for relationships with their respective dimension tables.

---

## Modeling Note

The final returns table should be treated as a **fact table**. Descriptive attributes such as representative name, account details, product name, therapeutic area, territory, and manager should be retrieved through relationships with the corresponding dimension tables rather than duplicated in `Returns`.

`OriginalInvoiceID` can also be used to trace a return back to the associated sales transaction when invoice-level return analysis is required.

---

## Date Parsing Assumption

The current date-cleaning rule attempts `en-US` before `en-GB`.

This creates an important ambiguity for values where both the day and month are 12 or less. For example:

`05/07/2025`

could be interpreted as:

- **May 7, 2025** under `en-US`, or
- **5 July 2025** under `en-GB`.

Because `en-US` is attempted first in the current query, the value will normally be interpreted as **May 7, 2025**.

For consistency with the `Sales_Raw` and `Visits_Raw` cleaning logic, consider defining a single documented source-date convention or using a deterministic source-system rule where possible.

---

## Review Notes

### 1. `Text.Proper` on Identifier Columns
`RepID` and `ProductCodeRaw` are identifiers rather than descriptive text. `Text.Proper` works with the current values, but identifiers are generally safer to standardize using `Text.Upper` instead.

For example:

`r001` → `R001`  
`p004` → `P004`

This makes the intention of the transformation clearer and avoids unintended casing behavior if future identifiers contain letters in different positions.

### 2. Status Cleaning Order
`Status` is converted to Proper Case before Trim and Clean are applied. The final result is still cleaned, but a more consistent transformation order would normally be:

**Trim → Clean → Proper Case**

This is not a blocker, but using the same order across all categorical fields makes the Power Query pipeline easier to maintain and document.
