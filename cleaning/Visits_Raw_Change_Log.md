# Visits_Raw — Data Cleaning Change Log

## Overview
This document records all Power Query transformations applied to `Visits_Raw.csv` as part of the **Medical Sales Performance & Territory Analytics** project.

**Source File:** `Visits_Raw.csv`  
**Transformation Tool:** Microsoft Power Query  
**Final Output Grain:** One cleaned medical representative visit per `VisitID`

---

## Transformation Log

| # | Power Query Step | Columns Affected | Transformation | Purpose |
|---:|---|---|---|---|
| 1 | `Source` | All columns | Imported `Visits_Raw.csv` using comma delimiter and UTF-8 encoding. | Load the raw field-force activity dataset into Power Query. |
| 2 | `Promoted Headers` | All columns | Promoted the first row to column headers. | Apply the correct business field names. |
| 3 | `Trimmed Text` | `RepID` | Removed leading and trailing spaces. | Prepare representative IDs for reliable relationships. |
| 4 | `Cleaned Text` | `RepID` | Removed non-printable/control characters. | Prevent hidden-character mismatches with `Dim_Reps`. |
| 5 | `Trimmed Text1` | `VisitID` | Removed leading and trailing spaces. | Standardize the visit-level unique key. |
| 6 | `Cleaned Text1` | `VisitID` | Removed non-printable/control characters. | Prevent hidden-character inconsistencies in the visit key. |
| 7 | `Removed Columns` | `RepNameRaw` | Removed the raw representative name. | Reduce redundancy because representative attributes are available through `Dim_Reps`. |
| 8 | `Trimmed Text2` | `DoctorID` | Removed leading and trailing spaces. | Prepare doctor IDs for reliable model relationships. |
| 9 | `Cleaned Text2` | `DoctorID` | Removed non-printable/control characters. | Prevent hidden-character mismatches with `Dim_Doctors`. |
| 10 | `Removed Columns1` | `DoctorNameRaw`, `SpecialtyRaw`, `TerritoryRaw`, `DoctorClass` | Removed descriptive doctor and territory fields. | Reduce fact-table redundancy and rely on related dimensions for descriptive attributes. |
| 11 | `Cleaned Text3` | `VisitStatus` | Removed non-printable/control characters. | Standardize visit-status values. |
| 12 | `Trimmed Text3` | `VisitStatus` | Removed leading and trailing spaces. | Eliminate inconsistent status values caused by extra spaces. |
| 13 | `Capitalized Each Word` | `VisitStatus` | Applied Proper Case. | Standardize visit-status capitalization for reporting. |
| 14 | `Trimmed Text4` | `Outcome` | Removed leading and trailing spaces. | Prepare visit-outcome values for standardization. |
| 15 | `Cleaned Text4` | `Outcome` | Removed non-printable/control characters. | Prevent hidden-value inconsistencies in outcome analysis. |
| 16 | `Capitalized Each Word1` | `Outcome` | Applied Proper Case. | Standardize outcome labels for reporting. |
| 17 | `Trimmed Text5` | `VisitType` | Removed leading and trailing spaces. | Prepare visit-type values for standardization. |
| 18 | `Cleaned Text5` | `VisitType` | Removed non-printable/control characters. | Prevent hidden-value inconsistencies. |
| 19 | `Capitalized Each Word2` | `VisitType` | Applied Proper Case. | Standardize visit-type labels. |
| 20 | `Replaced Value` | `FollowUpRequired` | Replaced `No` with `False`. | Convert the source Yes/No indicator toward a logical boolean representation. |
| 21 | `Replaced Value1` | `FollowUpRequired` | Replaced `Yes` with `True`. | Complete the value standardization for the follow-up flag. |
| 22 | `Added Custom` | `VisitDateRaw` → `VisitDate` | Created a standardized visit date using `en-GB`, then `en-US`, then explicit `dd/MM/yyyy` parsing; unresolved values return `null`. | Handle mixed raw date formats while maintaining query resilience. |
| 23 | `Changed Type` | `VisitDate` | Converted the standardized visit date to Date type. | Enable date relationships and time-based field-force analysis. |
| 24 | `Removed Columns2` | `VisitDateRaw` | Removed the original raw visit-date field. | Retain only the standardized analytical date. |
| 25 | `Reordered Columns` | All retained columns | Reordered the cleaned fields into a logical analytical structure. | Improve readability and prepare the table for model loading. |
| 26 | `Changed Type1` | `DurationMin`, `SamplesGiven` | Converted both fields to 64-bit integers. | Ensure valid numeric measures for visit-duration and sample analysis. |
| 27 | `Removed Duplicates` | `VisitID` | Removed duplicate visit records based on `VisitID`. | Enforce one row per field visit and prevent overstated activity KPIs. |
| 28 | `Changed Type2` | `FollowUpRequired` | Converted the standardized `True` / `False` values to Logical type. | Store the follow-up flag as a native Boolean field for filtering and calculations. |
| 29 | `Uppercased Text` | `VisitID`, `RepID`, `DoctorID` | Converted all key identifiers to uppercase. | Enforce consistent key formatting across fact and dimension tables. |

---

## Removed Fields

- `RepNameRaw`
- `DoctorNameRaw`
- `SpecialtyRaw`
- `TerritoryRaw`
- `DoctorClass`
- `VisitDateRaw` — replaced by `VisitDate`

These descriptive attributes are intentionally excluded from the final fact table because they can be retrieved through the corresponding dimensions.

---

## Final Columns

1. `VisitID`
2. `VisitDate`
3. `VisitStatus`
4. `RepID`
5. `DoctorID`
6. `Outcome`
7. `VisitType`
8. `SamplesGiven`
9. `FollowUpRequired`
10. `DurationMin`

---

## Data Quality Rules Applied

- Standardized `VisitID`, `RepID`, and `DoctorID` using Trim, Clean, and uppercase formatting.
- Removed duplicate records using `VisitID`.
- Removed redundant descriptive representative, doctor, specialty, territory, and doctor-class fields.
- Standardized `VisitStatus`, `Outcome`, and `VisitType`.
- Converted the follow-up indicator from `Yes` / `No` to a native Logical field.
- Standardized mixed raw visit dates into a single `VisitDate`.
- Explicitly assigned integer types to `DurationMin` and `SamplesGiven`.
- Preserved one-row-per-visit granularity for downstream activity and productivity analysis.

---

## Modeling Preparation

The cleaned dataset is structured as the primary **field-force activity fact table**.

Key relationship fields include:

- `RepID` → `Dim_Reps`
- `DoctorID` → `Dim_Doctors`
- `VisitDate` → Date dimension

Doctor specialty, class, territory, representative name, and other descriptive attributes are intentionally retrieved through related dimensions rather than stored repeatedly in the visit fact table.

---

## Date Parsing Assumption

The parsing logic attempts:

1. Culture-based `en-GB`
2. Culture-based `en-US`
3. Explicit `dd/MM/yyyy` using `en-GB`

For ambiguous dates where both day and month are 12 or below, the first successful parsing rule determines the interpretation.
