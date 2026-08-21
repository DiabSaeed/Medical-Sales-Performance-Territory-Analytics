// ======================================================
// TABLE: Sales_Raw
// ======================================================

let
    Source = Csv.Document(
        File.Contents("D:\Projects\Medical Sales Performance & Territory Analytics\Sales_Raw.csv"), // Update this with your Dir and do this in the whole doc
        [Delimiter=",", Columns=22, Encoding=65001, QuoteStyle=QuoteStyle.None]
    ),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(
        #"Promoted Headers",
        {
            {"InvoiceLineID", type text},
            {"InvoiceID", type text},
            {"InvoiceDateRaw", type text},
            {"RepID", type text},
            {"RepNameRaw", type text},
            {"TerritoryRaw", type text},
            {"Governorate", type text},
            {"AccountID", type text},
            {"AccountNameRaw", type text},
            {"AccountTypeRaw", type text},
            {"ProductCodeRaw", type text},
            {"ProductNameRaw", type text},
            {"TherapeuticArea", type text},
            {"Qty", Int64.Type},
            {"UnitPrice", type number},
            {"DiscountPct", type number},
            {"GrossSales", type number},
            {"NetSales", type number},
            {"PaymentTerms", type text},
            {"PaymentStatus", type text},
            {"OrderChannel", type text},
            {"DataSource", type text}
        }
    ),
    #"Removed Duplicates" = Table.Distinct(#"Changed Type", {"InvoiceLineID"}),
    #"Removed Columns" = Table.RemoveColumns(
        #"Removed Duplicates",
        {"RepNameRaw", "AccountNameRaw", "ProductNameRaw", "AccountTypeRaw"}
    ),
    #"Trimmed Text" = Table.TransformColumns(#"Removed Columns", {{"TerritoryRaw", Text.Trim, type text}}),
    #"Cleaned Text5" = Table.TransformColumns(#"Trimmed Text", {{"TerritoryRaw", Text.Clean, type text}}),
    #"Capitalized Each Word" = Table.TransformColumns(#"Cleaned Text5", {{"TerritoryRaw", Text.Proper, type text}}),
    #"Trimmed Text1" = Table.TransformColumns(#"Capitalized Each Word", {{"Governorate", Text.Trim, type text}}),
    #"Cleaned Text" = Table.TransformColumns(#"Trimmed Text1", {{"Governorate", Text.Clean, type text}}),
    #"Capitalized Each Word1" = Table.TransformColumns(#"Cleaned Text", {{"Governorate", Text.Proper, type text}}),
    #"Trimmed Text2" = Table.TransformColumns(#"Capitalized Each Word1", {{"TherapeuticArea", Text.Trim, type text}}),
    #"Cleaned Text8" = Table.TransformColumns(#"Trimmed Text2", {{"TherapeuticArea", Text.Clean, type text}}),
    #"Capitalized Each Word2" = Table.TransformColumns(#"Cleaned Text8", {{"TherapeuticArea", Text.Proper, type text}}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Capitalized Each Word2", {{"DiscountPct", Percentage.Type}}),
    #"Trimmed Text3" = Table.TransformColumns(
        #"Changed Type1",
        {
            {"DataSource", Text.Trim, type text},
            {"OrderChannel", Text.Trim, type text},
            {"PaymentStatus", Text.Trim, type text},
            {"PaymentTerms", Text.Trim, type text}
        }
    ),
    #"Cleaned Text1" = Table.TransformColumns(
        #"Trimmed Text3",
        {
            {"DataSource", Text.Clean, type text},
            {"OrderChannel", Text.Clean, type text},
            {"PaymentStatus", Text.Clean, type text},
            {"PaymentTerms", Text.Clean, type text}
        }
    ),
    #"Capitalized Each Word3" = Table.TransformColumns(
        #"Cleaned Text1",
        {
            {"DataSource", Text.Proper, type text},
            {"OrderChannel", Text.Proper, type text},
            {"PaymentStatus", Text.Proper, type text},
            {"PaymentTerms", Text.Proper, type text}
        }
    ),
    #"Trimmed Text4" = Table.TransformColumns(#"Capitalized Each Word3", {{"RepID", Text.Trim, type text}}),
    #"Added Custom" = Table.AddColumn(
        #"Trimmed Text4",
        "InvoiceDate",
        each
            try Date.FromText([InvoiceDateRaw], [Format="dd/MM/yyyy", Culture="en-GB"])
            otherwise try Date.FromText([InvoiceDateRaw], [Format="MM/dd/yyyy", Culture="en-US"])
            otherwise try Date.FromText([InvoiceDateRaw], [Format="yyyy-MM-dd", Culture="en-US"])
            otherwise try Date.FromText([InvoiceDateRaw], [Format="dd-MMM-yyyy", Culture="en-US"])
            otherwise null
    ),
    #"Removed Columns1" = Table.RemoveColumns(#"Added Custom", {"InvoiceDateRaw"}),
    #"Cleaned Text2" = Table.TransformColumns(#"Removed Columns1", {{"RepID", Text.Clean, type text}}),
    #"Trimmed Text6" = Table.TransformColumns(#"Cleaned Text2", {{"InvoiceID", Text.Trim, type text}}),
    #"Cleaned Text3" = Table.TransformColumns(#"Trimmed Text6", {{"InvoiceID", Text.Clean, type text}}),
    #"Trimmed Text7" = Table.TransformColumns(#"Cleaned Text3", {{"InvoiceLineID", Text.Trim, type text}}),
    #"Cleaned Text4" = Table.TransformColumns(#"Trimmed Text7", {{"InvoiceLineID", Text.Clean, type text}}),
    #"Renamed Columns" = Table.RenameColumns(
        #"Cleaned Text4",
        {{"TerritoryRaw", "Territory"}, {"ProductCodeRaw", "ProductCode"}}
    ),
    #"Changed Type2" = Table.TransformColumnTypes(#"Renamed Columns", {{"InvoiceDate", type date}}),
    #"Reordered Columns" = Table.ReorderColumns(
        #"Changed Type2",
        {
            "InvoiceLineID", "InvoiceID", "InvoiceDate", "RepID", "Territory", "Governorate",
            "AccountID", "ProductCode", "TherapeuticArea", "Qty", "UnitPrice", "DiscountPct",
            "GrossSales", "NetSales", "PaymentTerms", "PaymentStatus", "OrderChannel", "DataSource"
        }
    ),
    #"Trimmed Text5" = Table.TransformColumns(#"Reordered Columns", {{"AccountID", Text.Trim, type text}}),
    #"Cleaned Text6" = Table.TransformColumns(#"Trimmed Text5", {{"AccountID", Text.Clean, type text}}),
    #"Trimmed Text8" = Table.TransformColumns(#"Cleaned Text6", {{"ProductCode", Text.Trim, type text}}),
    #"Cleaned Text7" = Table.TransformColumns(#"Trimmed Text8", {{"ProductCode", Text.Clean, type text}}),
    #"Uppercased Text" = Table.TransformColumns(
        #"Cleaned Text7",
        {
            {"InvoiceLineID", Text.Upper, type text},
            {"InvoiceID", Text.Upper, type text},
            {"RepID", Text.Upper, type text},
            {"AccountID", Text.Upper, type text},
            {"ProductCode", Text.Upper, type text}
        }
    )
in
    #"Uppercased Text"


// ======================================================
// TABLE: Visits_Raw
// ======================================================

let
    Source = Csv.Document(
        File.Contents("D:\Projects\Medical Sales Performance & Territory Analytics\Visits_Raw.csv"),
        [Delimiter=",", Columns=15, Encoding=65001, QuoteStyle=QuoteStyle.None]
    ),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Trimmed Text" = Table.TransformColumns(#"Promoted Headers", {{"RepID", Text.Trim, type text}}),
    #"Cleaned Text" = Table.TransformColumns(#"Trimmed Text", {{"RepID", Text.Clean, type text}}),
    #"Trimmed Text1" = Table.TransformColumns(#"Cleaned Text", {{"VisitID", Text.Trim, type text}}),
    #"Cleaned Text1" = Table.TransformColumns(#"Trimmed Text1", {{"VisitID", Text.Clean, type text}}),
    #"Removed Columns" = Table.RemoveColumns(#"Cleaned Text1", {"RepNameRaw"}),
    #"Trimmed Text2" = Table.TransformColumns(#"Removed Columns", {{"DoctorID", Text.Trim, type text}}),
    #"Cleaned Text2" = Table.TransformColumns(#"Trimmed Text2", {{"DoctorID", Text.Clean, type text}}),
    #"Removed Columns1" = Table.RemoveColumns(#"Cleaned Text2", {"DoctorNameRaw", "SpecialtyRaw", "TerritoryRaw", "DoctorClass"}),
    #"Cleaned Text3" = Table.TransformColumns(#"Removed Columns1", {{"VisitStatus", Text.Clean, type text}}),
    #"Trimmed Text3" = Table.TransformColumns(#"Cleaned Text3", {{"VisitStatus", Text.Trim, type text}}),
    #"Capitalized Each Word" = Table.TransformColumns(#"Trimmed Text3", {{"VisitStatus", Text.Proper, type text}}),
    #"Trimmed Text4" = Table.TransformColumns(#"Capitalized Each Word", {{"Outcome", Text.Trim, type text}}),
    #"Cleaned Text4" = Table.TransformColumns(#"Trimmed Text4", {{"Outcome", Text.Clean, type text}}),
    #"Capitalized Each Word1" = Table.TransformColumns(#"Cleaned Text4", {{"Outcome", Text.Proper, type text}}),
    #"Trimmed Text5" = Table.TransformColumns(#"Capitalized Each Word1", {{"VisitType", Text.Trim, type text}}),
    #"Cleaned Text5" = Table.TransformColumns(#"Trimmed Text5", {{"VisitType", Text.Clean, type text}}),
    #"Capitalized Each Word2" = Table.TransformColumns(#"Cleaned Text5", {{"VisitType", Text.Proper, type text}}),
    #"Replaced Value" = Table.ReplaceValue(#"Capitalized Each Word2", "No", "False", Replacer.ReplaceText, {"FollowUpRequired"}),
    #"Replaced Value1" = Table.ReplaceValue(#"Replaced Value", "Yes", "True", Replacer.ReplaceText, {"FollowUpRequired"}),
    #"Added Custom" = Table.AddColumn(
        #"Replaced Value1",
        "VisitDate",
        each
            try Date.FromText([VisitDateRaw], [Culture="en-GB"])
            otherwise try Date.FromText([VisitDateRaw], [Culture="en-US"])
            otherwise try Date.FromText([VisitDateRaw], [Format="dd/MM/yyyy", Culture="en-GB"])
            otherwise null
    ),
    #"Changed Type" = Table.TransformColumnTypes(#"Added Custom", {{"VisitDate", type date}}),
    #"Removed Columns2" = Table.RemoveColumns(#"Changed Type", {"VisitDateRaw"}),
    #"Reordered Columns" = Table.ReorderColumns(
        #"Removed Columns2",
        {"VisitID", "VisitDate", "VisitStatus", "RepID", "DoctorID", "Outcome", "VisitType", "SamplesGiven", "FollowUpRequired", "DurationMin"}
    ),
    #"Changed Type1" = Table.TransformColumnTypes(#"Reordered Columns", {{"DurationMin", Int64.Type}, {"SamplesGiven", Int64.Type}}),
    #"Removed Duplicates" = Table.Distinct(#"Changed Type1", {"VisitID"}),
    #"Changed Type2" = Table.TransformColumnTypes(#"Removed Duplicates", {{"FollowUpRequired", type logical}}),
    #"Uppercased Text" = Table.TransformColumns(
        #"Changed Type2",
        {{"VisitID", Text.Upper, type text}, {"RepID", Text.Upper, type text}, {"DoctorID", Text.Upper, type text}}
    )
in
    #"Uppercased Text"


// ======================================================
// TABLE: Returns_Raw
// ======================================================

let
    Source = Csv.Document(
        File.Contents("D:\Projects\Medical Sales Performance & Territory Analytics\Returns_Raw.csv"),
        [Delimiter=",", Columns=10, Encoding=65001, QuoteStyle=QuoteStyle.None]
    ),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(
        #"Promoted Headers",
        {
            {"ReturnID", type text},
            {"ReturnDateRaw", type text},
            {"OriginalInvoiceID", type text},
            {"RepID", type text},
            {"AccountID", type text},
            {"ProductCodeRaw", type text},
            {"ReturnQty", Int64.Type},
            {"ReturnAmount", type number},
            {"ReturnReason", type text},
            {"Status", type text}
        }
    ),
    #"Trimmed Text" = Table.TransformColumns(#"Changed Type", {{"ReturnID", Text.Trim, type text}}),
    #"Cleaned Text" = Table.TransformColumns(#"Trimmed Text", {{"ReturnID", Text.Clean, type text}}),
    #"Uppercased Text1" = Table.TransformColumns(#"Cleaned Text", {{"ReturnID", Text.Upper, type text}}),
    #"Removed Duplicates" = Table.Distinct(#"Uppercased Text1", {"ReturnID"}),
    #"Trimmed Text1" = Table.TransformColumns(#"Removed Duplicates", {{"ReturnDateRaw", Text.Trim, type text}}),
    #"Cleaned Text1" = Table.TransformColumns(#"Trimmed Text1", {{"ReturnDateRaw", Text.Clean, type text}}),
    #"Trimmed Text2" = Table.TransformColumns(#"Cleaned Text1", {{"OriginalInvoiceID", Text.Trim, type text}}),
    #"Cleaned Text2" = Table.TransformColumns(#"Trimmed Text2", {{"OriginalInvoiceID", Text.Clean, type text}}),
    #"Uppercased Text2" = Table.TransformColumns(#"Cleaned Text2", {{"OriginalInvoiceID", Text.Upper, type text}}),
    #"Trimmed Text3" = Table.TransformColumns(#"Uppercased Text2", {{"RepID", Text.Trim, type text}}),
    #"Cleaned Text3" = Table.TransformColumns(#"Trimmed Text3", {{"RepID", Text.Clean, type text}}),
    #"Upper RepID" = Table.TransformColumns(#"Cleaned Text3", {{"RepID", Text.Upper, type text}}),
    #"Trimmed Text4" = Table.TransformColumns(#"Upper RepID", {{"AccountID", Text.Trim, type text}}),
    #"Cleaned Text4" = Table.TransformColumns(#"Trimmed Text4", {{"AccountID", Text.Clean, type text}}),
    #"Uppercased Text" = Table.TransformColumns(#"Cleaned Text4", {{"AccountID", Text.Upper, type text}}),
    #"Trimmed Text5" = Table.TransformColumns(#"Uppercased Text", {{"ProductCodeRaw", Text.Trim, type text}}),
    #"Cleaned Text5" = Table.TransformColumns(#"Trimmed Text5", {{"ProductCodeRaw", Text.Clean, type text}}),
    #"Upper Product Code" = Table.TransformColumns(#"Cleaned Text5", {{"ProductCodeRaw", Text.Upper, type text}}),
    #"Trimmed Text6" = Table.TransformColumns(#"Upper Product Code", {{"ReturnReason", Text.Trim, type text}}),
    #"Cleaned Text6" = Table.TransformColumns(#"Trimmed Text6", {{"ReturnReason", Text.Clean, type text}}),
    #"Capitalized Each Word2" = Table.TransformColumns(#"Cleaned Text6", {{"ReturnReason", Text.Proper, type text}}),
    #"Trimmed Text7" = Table.TransformColumns(#"Capitalized Each Word2", {{"Status", Text.Trim, type text}}),
    #"Cleaned Text7" = Table.TransformColumns(#"Trimmed Text7", {{"Status", Text.Clean, type text}}),
    #"Capitalized Each Word" = Table.TransformColumns(#"Cleaned Text7", {{"Status", Text.Proper, type text}}),
    #"Added Custom" = Table.AddColumn(
        #"Capitalized Each Word",
        "ReturnDate",
        each
            try Date.FromText([ReturnDateRaw], [Culture="en-GB"])
            otherwise try Date.FromText([ReturnDateRaw], [Culture="en-US"])
            otherwise null
    ),
    #"Removed Columns" = Table.RemoveColumns(#"Added Custom", {"ReturnDateRaw"}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Removed Columns", {{"ReturnDate", type date}}),
    #"Reordered Columns" = Table.ReorderColumns(
        #"Changed Type1",
        {"ReturnID", "ReturnDate", "OriginalInvoiceID", "RepID", "AccountID", "ProductCodeRaw", "ReturnQty", "ReturnAmount", "ReturnReason", "Status"}
    ),
    #"Renamed Columns" = Table.RenameColumns(#"Reordered Columns", {{"ProductCodeRaw", "ProductCode"}})
in
    #"Renamed Columns"


// ======================================================
// TABLE: Sales_Targets
// ======================================================

let
    Source = Csv.Document(
        File.Contents("D:\Projects\Medical Sales Performance & Territory Analytics\Sales_Targets.csv"),
        [Delimiter=",", Columns=6, Encoding=65001, QuoteStyle=QuoteStyle.None]
    ),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(
        #"Promoted Headers",
        {
            {"Month", type date},
            {"RepID", type text},
            {"ProductCode", type text},
            {"SalesTarget", Int64.Type},
            {"UnitsTarget", Int64.Type},
            {"TargetStatus", type text}
        }
    ),
    #"Trimmed Text" = Table.TransformColumns(#"Changed Type", {{"RepID", Text.Trim, type text}}),
    #"Cleaned Text" = Table.TransformColumns(#"Trimmed Text", {{"RepID", Text.Clean, type text}}),
    #"Trimmed Text1" = Table.TransformColumns(#"Cleaned Text", {{"ProductCode", Text.Trim, type text}}),
    #"Cleaned Text1" = Table.TransformColumns(#"Trimmed Text1", {{"ProductCode", Text.Clean, type text}}),
    #"Cleaned Text2" = Table.TransformColumns(#"Cleaned Text1", {{"TargetStatus", Text.Clean, type text}}),
    #"Trimmed Text2" = Table.TransformColumns(#"Cleaned Text2", {{"TargetStatus", Text.Trim, type text}}),
    #"Capitalized Each Word" = Table.TransformColumns(#"Trimmed Text2", {{"TargetStatus", Text.Proper, type text}}),
    #"Renamed Columns" = Table.RenameColumns(#"Capitalized Each Word", {{"Month", "Date"}}),
    #"Inserted Month Name" = Table.AddColumn(#"Renamed Columns", "Month Name", each Date.MonthName([Date]), type text),
    #"Inserted Year" = Table.AddColumn(#"Inserted Month Name", "Year", each Date.Year([Date]), Int64.Type),
    #"Uppercased Text" = Table.TransformColumns(
        #"Inserted Year",
        {{"RepID", Text.Upper, type text}, {"ProductCode", Text.Upper, type text}}
    )
in
    #"Uppercased Text"


// ======================================================
// TABLE: Activity_Targets
// ======================================================

let
    Source = Csv.Document(
        File.Contents("D:\Projects\Medical Sales Performance & Territory Analytics\Activity_Targets.csv"),
        [Delimiter=",", Columns=4, Encoding=65001, QuoteStyle=QuoteStyle.None]
    ),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(
        #"Promoted Headers",
        {
            {"Month", type date},
            {"RepID", type text},
            {"VisitsTarget", Int64.Type},
            {"ProductiveCallsTarget", Int64.Type}
        }
    ),
    #"Renamed Columns" = Table.RenameColumns(#"Changed Type", {{"Month", "Date"}}),
    #"Inserted Month Name" = Table.AddColumn(#"Renamed Columns", "Month Name", each Date.MonthName([Date]), type text),
    #"Inserted Year" = Table.AddColumn(#"Inserted Month Name", "Year", each Date.Year([Date]), Int64.Type),
    #"Trimmed Text" = Table.TransformColumns(#"Inserted Year", {{"RepID", Text.Trim, type text}}),
    #"Cleaned Text" = Table.TransformColumns(#"Trimmed Text", {{"RepID", Text.Clean, type text}}),
    #"Uppercased Text" = Table.TransformColumns(#"Cleaned Text", {{"RepID", Text.Upper, type text}})
in
    #"Uppercased Text"


// ======================================================
// TABLE: Dim_Territories
// ======================================================

let
    Source = Csv.Document(
        File.Contents("D:\Projects\Medical Sales Performance & Territory Analytics\Dim_Territories.csv"),
        [Delimiter=",", Columns=5, Encoding=65001, QuoteStyle=QuoteStyle.None]
    ),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(
        #"Promoted Headers",
        {
            {"TerritoryID", type text},
            {"TerritoryName", type text},
            {"Governorate", type text},
            {"Region", type text},
            {"MarketPotentialIndex", type number}
        }
    ),
    #"Trimmed ID" = Table.TransformColumns(#"Changed Type", {{"TerritoryID", Text.Trim, type text}}),
    #"Cleaned ID" = Table.TransformColumns(#"Trimmed ID", {{"TerritoryID", Text.Clean, type text}}),
    #"Uppercased ID" = Table.TransformColumns(#"Cleaned ID", {{"TerritoryID", Text.Upper, type text}}),
    #"Removed Duplicates" = Table.Distinct(#"Uppercased ID", {"TerritoryID"}),
    #"Trimmed Text" = Table.TransformColumns(
        #"Removed Duplicates",
        {
            {"TerritoryName", Text.Trim, type text},
            {"Governorate", Text.Trim, type text},
            {"Region", Text.Trim, type text}
        }
    ),
    #"Cleaned Text" = Table.TransformColumns(
        #"Trimmed Text",
        {
            {"TerritoryName", Text.Clean, type text},
            {"Governorate", Text.Clean, type text},
            {"Region", Text.Clean, type text}
        }
    ),
    #"Proper Text" = Table.TransformColumns(
        #"Cleaned Text",
        {
            {"TerritoryName", Text.Proper, type text},
            {"Governorate", Text.Proper, type text},
            {"Region", Text.Proper, type text}
        }
    )
in
    #"Proper Text"


// ======================================================
// TABLE: Dim_Reps
// ======================================================

let
    Source = Csv.Document(
        File.Contents("D:\Projects\Medical Sales Performance & Territory Analytics\Dim_Reps.csv"),
        [Delimiter=",", Columns=11, Encoding=65001, QuoteStyle=QuoteStyle.None]
    ),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(
        #"Promoted Headers",
        {
            {"RepID", type text},
            {"RepName", type text},
            {"Team", type text},
            {"Manager", type text},
            {"HireDate", type date},
            {"TerminationDate", type date},
            {"TerritoryID", type text},
            {"TerritoryName", type text},
            {"Governorate", type text},
            {"BaseMonthlyTarget", Int64.Type},
            {"Status", type text}
        }
    ),
    #"Removed Columns" = Table.RemoveColumns(#"Changed Type", {"TerritoryName", "Governorate"}),
    #"Trimmed RepID" = Table.TransformColumns(#"Removed Columns", {{"RepID", Text.Trim, type text}}),
    #"Cleaned RepID" = Table.TransformColumns(#"Trimmed RepID", {{"RepID", Text.Clean, type text}}),
    #"Upper RepID" = Table.TransformColumns(#"Cleaned RepID", {{"RepID", Text.Upper, type text}}),
    #"Removed Duplicates" = Table.Distinct(#"Upper RepID", {"RepID"}),
    #"Trimmed TerritoryID" = Table.TransformColumns(#"Removed Duplicates", {{"TerritoryID", Text.Trim, type text}}),
    #"Cleaned TerritoryID" = Table.TransformColumns(#"Trimmed TerritoryID", {{"TerritoryID", Text.Clean, type text}}),
    #"Upper TerritoryID" = Table.TransformColumns(#"Cleaned TerritoryID", {{"TerritoryID", Text.Upper, type text}}),
    #"Trimmed Descriptive Text" = Table.TransformColumns(
        #"Upper TerritoryID",
        {
            {"RepName", Text.Trim, type text},
            {"Team", Text.Trim, type text},
            {"Manager", Text.Trim, type text},
            {"Status", Text.Trim, type text}
        }
    ),
    #"Cleaned Descriptive Text" = Table.TransformColumns(
        #"Trimmed Descriptive Text",
        {
            {"RepName", Text.Clean, type text},
            {"Team", Text.Clean, type text},
            {"Manager", Text.Clean, type text},
            {"Status", Text.Clean, type text}
        }
    ),
    #"Proper Descriptive Text" = Table.TransformColumns(
        #"Cleaned Descriptive Text",
        {
            {"RepName", Text.Proper, type text},
            {"Team", Text.Proper, type text},
            {"Manager", Text.Proper, type text},
            {"Status", Text.Proper, type text}
        }
    )
in
    #"Proper Descriptive Text"


// ======================================================
// TABLE: Dim_Products
// ======================================================

let
    Source = Csv.Document(
        File.Contents("D:\Projects\Medical Sales Performance & Territory Analytics\Dim_Products.csv"),
        [Delimiter=",", Columns=9, Encoding=65001, QuoteStyle=QuoteStyle.None]
    ),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(
        #"Promoted Headers",
        {
            {"ProductCode", type text},
            {"ProductName", type text},
            {"TherapeuticArea", type text},
            {"Category", type text},
            {"PackSize", type text},
            {"ListPrice", Int64.Type},
            {"UnitCost", Int64.Type},
            {"LaunchDate", type date},
            {"Status", type text}
        }
    ),
    #"Trimmed ProductCode" = Table.TransformColumns(#"Changed Type", {{"ProductCode", Text.Trim, type text}}),
    #"Cleaned ProductCode" = Table.TransformColumns(#"Trimmed ProductCode", {{"ProductCode", Text.Clean, type text}}),
    #"Upper ProductCode" = Table.TransformColumns(#"Cleaned ProductCode", {{"ProductCode", Text.Upper, type text}}),
    #"Removed Duplicates" = Table.Distinct(#"Upper ProductCode", {"ProductCode"}),
    #"Trimmed Text" = Table.TransformColumns(
        #"Removed Duplicates",
        {
            {"ProductName", Text.Trim, type text},
            {"TherapeuticArea", Text.Trim, type text},
            {"Category", Text.Trim, type text},
            {"PackSize", Text.Trim, type text},
            {"Status", Text.Trim, type text}
        }
    ),
    #"Cleaned Text" = Table.TransformColumns(
        #"Trimmed Text",
        {
            {"ProductName", Text.Clean, type text},
            {"TherapeuticArea", Text.Clean, type text},
            {"Category", Text.Clean, type text},
            {"PackSize", Text.Clean, type text},
            {"Status", Text.Clean, type text}
        }
    ),
    #"Proper Text" = Table.TransformColumns(
        #"Cleaned Text",
        {
            {"ProductName", Text.Proper, type text},
            {"TherapeuticArea", Text.Proper, type text},
            {"Category", Text.Proper, type text},
            {"PackSize", Text.Proper, type text},
            {"Status", Text.Proper, type text}
        }
    )
in
    #"Proper Text"


// ======================================================
// TABLE: Dim_Doctors
// ======================================================

let
    Source = Csv.Document(
        File.Contents("D:\Projects\Medical Sales Performance & Territory Analytics\Dim_Doctors.csv"),
        [Delimiter=",", Columns=10, Encoding=65001, QuoteStyle=QuoteStyle.None]
    ),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(
        #"Promoted Headers",
        {
            {"DoctorID", type text},
            {"DoctorName", type text},
            {"Specialty", type text},
            {"TerritoryID", type text},
            {"TerritoryName", type text},
            {"Governorate", type text},
            {"DoctorClass", type text},
            {"PotentialScore", Int64.Type},
            {"PreferredVisitDay", type text},
            {"Status", type text}
        }
    ),
    #"Trimmed DoctorID" = Table.TransformColumns(#"Changed Type", {{"DoctorID", Text.Trim, type text}}),
    #"Cleaned DoctorID" = Table.TransformColumns(#"Trimmed DoctorID", {{"DoctorID", Text.Clean, type text}}),
    #"Upper DoctorID" = Table.TransformColumns(#"Cleaned DoctorID", {{"DoctorID", Text.Upper, type text}}),
    #"Removed Duplicates" = Table.Distinct(#"Upper DoctorID", {"DoctorID"}),
    #"Trimmed Text" = Table.TransformColumns(#"Removed Duplicates", {{"DoctorName", Text.Trim, type text}}),
    #"Cleaned Text" = Table.TransformColumns(#"Trimmed Text", {{"DoctorName", Text.Clean, type text}}),
    #"Trimmed Text1" = Table.TransformColumns(#"Cleaned Text", {{"Specialty", Text.Trim, type text}}),
    #"Cleaned Text1" = Table.TransformColumns(#"Trimmed Text1", {{"Specialty", Text.Clean, type text}}),
    #"Capitalized Each Word" = Table.TransformColumns(
        #"Cleaned Text1",
        {{"Specialty", Text.Proper, type text}, {"DoctorName", Text.Proper, type text}}
    ),
    #"Removed Columns" = Table.RemoveColumns(#"Capitalized Each Word", {"TerritoryName", "Governorate"}),
    #"Trimmed Text2" = Table.TransformColumns(#"Removed Columns", {{"PreferredVisitDay", Text.Trim, type text}}),
    #"Cleaned Text2" = Table.TransformColumns(#"Trimmed Text2", {{"PreferredVisitDay", Text.Clean, type text}}),
    #"Trimmed TerritoryID" = Table.TransformColumns(#"Cleaned Text2", {{"TerritoryID", Text.Trim, type text}}),
    #"Cleaned TerritoryID" = Table.TransformColumns(#"Trimmed TerritoryID", {{"TerritoryID", Text.Clean, type text}}),
    #"Upper TerritoryID" = Table.TransformColumns(#"Cleaned TerritoryID", {{"TerritoryID", Text.Upper, type text}}),
    #"Trimmed Categories" = Table.TransformColumns(
        #"Upper TerritoryID",
        {{"DoctorClass", Text.Trim, type text}, {"Status", Text.Trim, type text}}
    ),
    #"Cleaned Categories" = Table.TransformColumns(
        #"Trimmed Categories",
        {{"DoctorClass", Text.Clean, type text}, {"Status", Text.Clean, type text}}
    ),
    #"Proper Categories" = Table.TransformColumns(
        #"Cleaned Categories",
        {{"DoctorClass", Text.Proper, type text}, {"Status", Text.Proper, type text}}
    )
in
    #"Proper Categories"


// ======================================================
// TABLE: Dim_Accounts
// ======================================================

let
    Source = Csv.Document(
        File.Contents("D:\Projects\Medical Sales Performance & Territory Analytics\Dim_Accounts.csv"),
        [Delimiter=",", Columns=12, Encoding=65001, QuoteStyle=QuoteStyle.None]
    ),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(
        #"Promoted Headers",
        {
            {"AccountID", type text},
            {"AccountName", type text},
            {"AccountType", type text},
            {"TerritoryID", type text},
            {"TerritoryName", type text},
            {"Governorate", type text},
            {"Region", type text},
            {"Segment", type text},
            {"CreditLimit", Int64.Type},
            {"JoinDate", type date},
            {"Status", type text},
            {"PotentialIndex", type number}
        }
    ),
    #"Removed Columns" = Table.RemoveColumns(#"Changed Type", {"TerritoryName", "Governorate", "Region"}),
    #"Trimmed AccountID" = Table.TransformColumns(#"Removed Columns", {{"AccountID", Text.Trim, type text}}),
    #"Cleaned AccountID" = Table.TransformColumns(#"Trimmed AccountID", {{"AccountID", Text.Clean, type text}}),
    #"Upper AccountID" = Table.TransformColumns(#"Cleaned AccountID", {{"AccountID", Text.Upper, type text}}),
    #"Removed Duplicates" = Table.Distinct(#"Upper AccountID", {"AccountID"}),
    #"Trimmed TerritoryID" = Table.TransformColumns(#"Removed Duplicates", {{"TerritoryID", Text.Trim, type text}}),
    #"Cleaned TerritoryID" = Table.TransformColumns(#"Trimmed TerritoryID", {{"TerritoryID", Text.Clean, type text}}),
    #"Upper TerritoryID" = Table.TransformColumns(#"Cleaned TerritoryID", {{"TerritoryID", Text.Upper, type text}}),
    #"Trimmed Text" = Table.TransformColumns(
        #"Upper TerritoryID",
        {
            {"AccountName", Text.Trim, type text},
            {"AccountType", Text.Trim, type text},
            {"Segment", Text.Trim, type text},
            {"Status", Text.Trim, type text}
        }
    ),
    #"Cleaned Text" = Table.TransformColumns(
        #"Trimmed Text",
        {
            {"AccountName", Text.Clean, type text},
            {"AccountType", Text.Clean, type text},
            {"Segment", Text.Clean, type text},
            {"Status", Text.Clean, type text}
        }
    ),
    #"Proper Text" = Table.TransformColumns(
        #"Cleaned Text",
        {
            {"AccountName", Text.Proper, type text},
            {"AccountType", Text.Proper, type text},
            {"Segment", Text.Proper, type text},
            {"Status", Text.Proper, type text}
        }
    )
in
    #"Proper Text"
