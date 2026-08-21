# Dim_Doctors — Data Cleaning Change Log

## Overview
This document records the Power Query transformations applied to `Dim_Doctors.csv`.

**Source File:** `Dim_Doctors.csv`  
**Transformation Tool:** Microsoft Power Query  
**Final Output Grain:** One doctor per `DoctorID`

## Transformation Log

| # | Step | Columns Affected | Transformation | Purpose |
|---:|---|---|---|---|
| 1 | `Source` | All columns | Imported the CSV using comma delimiter and UTF-8 encoding. | Load doctor master data. |
| 2 | `Promoted Headers` | All columns | Promoted the first row to headers. | Apply business field names. |
| 3 | `Changed Type` | All columns | Assigned Text and Integer data types. | Establish the doctor-dimension schema. |
| 4 | `Removed Duplicates` | `DoctorID` | Removed duplicate doctor records. | Enforce one row per doctor. |
| 5 | `Trimmed Text` | `DoctorName` | Removed leading/trailing spaces. | Standardize doctor names. |
| 6 | `Cleaned Text` | `DoctorName` | Removed non-printable characters. | Prevent hidden-character inconsistencies. |
| 7 | `Trimmed Text1` | `Specialty` | Removed leading/trailing spaces. | Standardize specialty values. |
| 8 | `Cleaned Text1` | `Specialty` | Removed non-printable characters. | Prevent hidden specialty mismatches. |
| 9 | `Capitalized Each Word` | `Specialty`, `DoctorName` | Applied Proper Case. | Standardize doctor-name and specialty capitalization. |
| 10 | `Removed Columns` | `TerritoryName`, `Governorate` | Removed descriptive territory attributes. | Reduce redundancy and retrieve location attributes through `Dim_Territories`. |
| 11 | `Trimmed Text2` | `PreferredVisitDay` | Removed leading/trailing spaces. | Standardize preferred visit-day values. |
| 12 | `Cleaned Text2` | `PreferredVisitDay` | Removed non-printable characters. | Prevent hidden-value inconsistencies. |

## Final Columns

`DoctorID`, `DoctorName`, `Specialty`, `TerritoryID`, `DoctorClass`, `PotentialScore`, `PreferredVisitDay`, `Status`
