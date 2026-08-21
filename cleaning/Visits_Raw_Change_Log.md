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
| 1 | `Source` | All columns | Imported `Visits_Raw.csv` using comma delimiter and UTF-8 encoding. | Load raw field-force activity data into Power Query. |
| 2 | `Promoted Headers` | All columns | Promoted the first row to column headers. | Apply the correct business field names. |
| 3 | `Trimmed Text` | `RepID` | Removed leading and trailing spaces. | Standardize representative identifiers before relationships and grouping. |
| 4 | `Cleaned Text` | `RepID` | Removed non-printable/control characters. | Prevent hidden-character mismatches with `Dim_Reps`. |
| 5 | `Trimmed Text1` | `VisitID` | Removed leading and trailing spaces. | Standardize the visit-level unique key. |
| 6 | `Cleaned Text1` | `VisitID` | Removed non-printable/control characters. | Protect the visit key from hidden-character inconsistencies. |
| 7 | `Removed Columns` | `RepNameRaw` | Removed the representative name from the raw fact table. | Reduce redundancy because representative descriptive attributes are available in `Dim_Reps`. |
| 8 | `Trimmed Text2` | `DoctorID` | Removed leading and trailing spaces. | Standardize doctor identifiers before model relationships. |
| 9 | `Cleaned Text2` | `DoctorID` | Removed non-printable/control characters. | Prevent relationship mismatches with `Dim_Doctors`. |
| 10 | `Removed Columns1` | `DoctorNameRaw`, `SpecialtyRaw`, `TerritoryRaw`, `DoctorClass` | Removed descriptive doctor and territory fields from the visit fact table. | Reduce duplication and support dimensional modeling through related dimension tables. |
| 11 | `Cleaned Text3` | `VisitStatus` | Removed non-printable/control characters. | Standardize visit-status values before reporting. |
| 12 | `Trimmed Text3` | `VisitStatus` | Removed leading and trailing spaces. | Eliminate inconsistent status labels caused by extra spaces. |
| 13 | `Capitalized Each Word` | `VisitStatus` | Applied Proper Case. | Standardize visit-status capitalization for reporting and filtering. |
| 14 | `Trimmed Text4` | `Outcome` | Removed leading and trailing spaces. | Standardize visit-outcome values. |
| 15 | `Cleaned Text4` | `Outcome` | Removed non-printable/control characters. | Prevent hidden-value inconsistencies in visit outcome analysis. |
| 16 | `Capitalized Each Word1` | `Outcome` | Applied Proper Case. | Standardize outcome labels for reporting. |
| 17 | `Trimmed Text5` | `VisitType` | Removed leading and trailing spaces. | Standardize visit-type values. |
| 18 | `Cleaned Text5` | `VisitType` | Removed non-printable/control characters. | Prevent hidden inconsistencies in visit-type analysis. |
| 19 | `Capitalized Each Word2` | `VisitType` | Applied Proper Case. | Standardize visit-type labels. |
| 20 | `Replaced Value` | `FollowUpRequired` | Replaced `No` with `False`. | Convert the source yes/no indicator into a boolean-style value. |
| 21 | `Replaced Value1` | `FollowUpRequired` | Replaced `Yes` with `True`. | Complete standardization of the follow-up indicator. |
| 22 | `Added Custom` | `VisitDateRaw` → `VisitDate` | Created a standardized date field using multiple parsing attempts: `en-GB`, `en-US`, and explicit `dd/MM/yyyy`. Unresolved values return `null`. | Handle mixed raw visit-date formats while preserving query execution. |
| 23 | `Changed Type` | `VisitDate` | Explicitly converted the new field to Date type. | Enable date relationships and time-based activity analysis. |
| 24 | `Removed Columns2` | `VisitDateRaw` | Removed the original raw visit-date field. | Retain only the standardized analytical visit date. |
| 25 | `Reordered Columns` | All retained columns | Reordered columns into a logical analytical structure. | Improve readability and prepare the table for model loading. |
| 26 | `Changed Type1` | `DurationMin`, `SamplesGiven` | Converted both fields to 64-bit integers. | Ensure visit duration and sample counts are valid numeric measures. |
| 27 | `Removed Duplicates` | `VisitID` | Removed duplicate visit records based on `VisitID`. | Enforce one row per field visit and avoid overstating activity KPIs. |

---

## Removed Fields

The following descriptive fields were intentionally removed from the visit fact table because they are available through related dimensions:

- `RepNameRaw`
- `DoctorNameRaw`
- `SpecialtyRaw`
- `TerritoryRaw`
- `DoctorClass`
- `VisitDateRaw` — replaced by the standardized `VisitDate`

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

- Standardized key identifiers using Trim and Clean transformations.
- Removed redundant representative, doctor, specialty, territory, and doctor-class attributes from the fact table.
- Standardized categorical text fields using Trim, Clean, and Proper Case.
- Converted the follow-up field from `Yes` / `No` to `True` / `False`.
- Standardized mixed raw visit-date formats into a single `VisitDate`.
- Explicitly converted duration and sample counts into integer types.
- Removed duplicate visit records using `VisitID`.

---

## Modeling Note

The final visit table is intentionally structured as a **fact table**. Representative, doctor, specialty, territory, and doctor-class attributes should be retrieved through relationships with `Dim_Reps` and `Dim_Doctors` rather than stored repeatedly in the visit table.

## Date Parsing Assumption

The date logic first attempts culture-based parsing with `en-GB`, then `en-US`, and finally an explicit `dd/MM/yyyy` format. Ambiguous date values such as `05/07/2025` will normally be interpreted according to the first successful parsing rule, so the source-date convention should be documented as a business assumption if no deterministic source-system rule exists.
