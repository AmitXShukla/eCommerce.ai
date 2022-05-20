# working with Data

In this section, we will review and create, ERP data sets required for system analytics.

Please see, most of the datasets discussed below, adhere to ERD discussed earlier.
These datasets are **not real** but **is very close to real** life datasets.

*These scripts do NOT copy any real organization dataset, any resemblance to any real organization working data is pure coincidental.*

!!! note "ERP Systems"

    eCommerce.ai package supports following ERP systems data structures.

    Oracle, PeopleSoft, SAP, Tally, Intuit, QuickBooks etc.
    I will cover examples from ERP Domains like GL (General Ledger), AP (Accounts Payable), AR (Account Receivables), B2P (Buy to Pay), Expense, Travel & Time, HCM Human Capital Management, CRM etc.

!!! note
    GitHub doesn't allow to load GBs/volumes data into GitHub repository.
    
    While most of the scripts used in this project/package is tested on **20+GBs** of data.
    You'll find sample datasets in **../../assets/sampleData** directory.

    Also, you can use following scripts to generate more data by changing *sampleSize* variable in following scripts.

Let's get started, and create ERP commerce dataset.

---
## SUPPLY CHAIN

you will need following packages.

```@example
using Pkg
Pkg.add("DataFrames")
Pkg.add("Dates")
Pkg.add("CategoricalArrays")
Pkg.add("Interact")
Pkg.add("WebIO")
Pkg.add("CSV")
Pkg.add("XLSX")
Pkg.add("DelimitedFiles")
Pkg.add("Distributions")
Pkg.build("WebIO")
Pkg.status();

using DataFrames, Dates, Interact, CategoricalArrays, WebIO, CSV, XLSX, DelimitedFiles, Distributions
```

*rest of this blog, I will assume, you have added all packages and imported in current namespace/notebook scope.*

!!! note
    All of Finance and supply chain data discussed here is also uploaded in GitHub repo under sampleData folder.
    This same script can be used to produce more voluminous data.


## Chartfields

- Item master, Item Attribs, Item Costing

    **UNSPSC:**  The United Nations Standard Products and Services Code® (UNSPSC®) is a global classification system of products and services.
                These codes are used to classify products and services.

    **GTIN:** Global Trade Item Number (GTIN) can be used by a company to uniquely identify all of its trade items. GS1 defines trade items as products or services that are priced, ordered or invoiced at any point in the supply chain.
    
    
- Vendor master, Vendor Attribs, Vendor Costing
    Customer/Buyer/Procurement Officer Attribs
    shipto, warehouse, storage & inventory locations

## Transactions

-   PurchaseOrder
-   MSR - Material Service
-   Voucher
-   Invoice
-   Receipt
-   Shipment
-   Sales, Revenue
-   Travel, Expense, TimeCard
-   Accounting Lines

## Item Master from UNSPSC
```@example
import Pkg
Pkg.add("XLSX")
Pkg.add("CSV")
using XLSX, CSV, DataFrames
###############################
## create SUPPLY CHAIN DATA ###
###############################
# Item master, Item Attribs, Item Costing ##
#       UNSPSC, GTIN
############################################

##########
# UNSPSC #
##########
# UNSPSC file can be downloaded from this link https://www.ungm.org/Public/UNSPSC
# xf = XLSX.readxlsx("../../assets/sampleData/UNGM_UNSPSC_09-Apr-2022..xlsx")
# xf will display names of sheets and rows with data
# let's read this data in to a DataFrame

# using below command will read xlsx data into DataFrame but will not render column labels
# df = DataFrame(XLSX.readdata("../../assets/sampleData/UNGM_UNSPSC_09-Apr-2022..xlsx", "UNSPSC", "A1:D12988"), :auto)
dfUNSPSC = DataFrame(XLSX.readtable("../../assets/sampleData/UNGM_UNSPSC_09-Apr-2022..xlsx", "UNSPSC")...)
# ... operator will splat the tuple (data, column_labels) into the constructor of DataFrame

# replace missing values with an integer 99999
replace!(dfUNSPSC."Parent key", missing => 99999)

# let's export this clean csv, we'll load this into database
# CSV.write("UNSPSC.csv", dfUNSPSC)

# # remember to empty dataFrame after usage
# # Julia will flush it out automatically after session,
# # but often ERP data gets bulky during session
# Base.summarysize(dfUNSPSC)
# empty!(dfUNSPSC)
# Base.summarysize(dfUNSPSC)

first(dfUNSPSC, 5)
```

## GTIN data
```@example
using DataFrames, Dates, Interact, CategoricalArrays, WebIO, CSV, XLSX, DelimitedFiles, Distributions
##########
# GTIN ###
##########

# xf = XLSX.readxlsx("../../assets/sampleData/DS_GTIN_ALL.xlsx")
# xf will display names of sheets and rows with data
# let's read this data in to a DataFrame

# using below command will read xlsx data into DataFrame but will not render column labels
# df = DataFrame(XLSX.readdata("../../assets/sampleData/DS_GTIN_ALL.xlsx", "Worksheet", "A14:E143403   "), :auto)
dfGTIN = DataFrame(XLSX.readtable("../../assets/sampleData/DS_GTIN_ALL.xlsx", "Worksheet";first_row=14)...)
first(dfGTIN,5)
# ... operator will splat the tuple (data, column_labels) into the constructor of DataFrame

# replace missing values with an integer 99999
# replace!(dfUNSPSC."Parent key", missing => 99999)
# size(dfUNSPSC)

# let's export this clean csv, we'll load this into database
# CSV.write("UNSPSC.csv", dfUNSPSC)
# readdir(pwd())

# # remember to empty dataFrame after usage
# # Julia will flush it out automatically after session,
# # but often ERP data gets bulky during session
# Base.summarysize(dfGTIN)
# empty!(dfGTIN)
# Base.summarysize(dfGTIN)
```

## Vendor Master

```@example
using DataFrames, Dates, Interact, CategoricalArrays, WebIO, CSV, XLSX, DelimitedFiles, Distributions
#################
# Vendor master #
#################

#####
## This is big data set (<5GB), uncomments and run only once ##
#####
# data, header = readdlm("../../assets/sampleData/device.txt", '|', header=true)
# dfGUDIDdevice = DataFrame(data, vec(header))
# show(first(dfGUDIDdevice[:,[:brandName, :catalogNumber, :dunsNumber, :companyName, :rx, :otc]],5), allcols=true)

# create Vendor Master from GUDID dataset
# show(first(dfGUDIDdevice,5), allcols=true)
# names(dfGUDIDdevice)
# dfVendor = unique(dfGUDIDdevice[:,[:brandName, :catalogNumber, :dunsNumber, :companyName, :rx, :otc]])
# dfVendor = unique(dfGUDIDdevice[:,[:companyName]]) # 7574 unique vendors

# dfVendor = unique(dfGUDIDdevice[:,[:brandName, :dunsNumber, :companyName, :rx, :otc]])
# dfVendor is a good dataset, have 216k rows for 7574 unique vendors

# # remember to empty dataFrame after usage
# # Julia will flush it out automatically after session,
# # but often ERP data gets bulky during session
# Base.summarysize(dfVendor)
# empty!(dfVendor)
# Base.summarysize(dfVendor)
```

## Locations
```@example
using DataFrames, Dates, Interact, CategoricalArrays, WebIO, CSV, XLSX, DelimitedFiles, Distributions
#### Location Master

data, header = readdlm("../../assets/sampleData/uscities.csv", ',', header=true)
dfLocation = DataFrame(data, vec(header))
first(dfLocation[:,Not(:zips)],5)

# # remember to empty dataFrame after usage
# # Julia will flush it out automatically after session,
# # but often ERP data gets bulky during session
# Base.summarysize(dfLocation)
# empty!(dfLocation)
# Base.summarysize(dfLocation)
```

## ORG
```@example
using DataFrames, Dates, Interact, CategoricalArrays, WebIO, CSV, XLSX, DelimitedFiles, Distributions
dfOrgMaster = DataFrame(
    ORG=repeat(["Galp Inc"], inner=8),
    ENTITY=repeat(["HeadOffice"], inner=8),
    GROUP=repeat(["Operations"], inner=8),
    DEPARTMENT=["Procurement","Procurement","Procurement","Procurement","Procurement","HR","HR","MFG"],
    UNIT=["Sourcing","Sourcing","Maintenance","Support","Services","Helpdesk","ServiceCall","IT"])
first(dfOrgMaster,5)

```

now since we created Supply chain attribute, chartfields / dimensions

- item master
- vendor master
- location master
- org Hierarchy

using above chartfields, let's create following Supply Chain Transactions

- MSR - Material Service request
- PurchaseOrder
- Voucher
- Invoice
- Receipt
- Shipment
- Sales, Revenue
- Travel, Expense, TimeCard
- Accounting Lines


## MSR - Material Service request

```@example
using DataFrames, Dates, Interact, CategoricalArrays, WebIO, CSV, XLSX, DelimitedFiles, Distributions
sampleSize = 1000 # number of rows, scale as needed

# data, header = readdlm("../../assets/sampleData/device.txt", '|', header=true)
# df GUDIDdevice = DataFrame(data, vec(header))
# dfVendor = unique(dfGUDIDdevice[:,[:brandName, :dunsNumber, :companyName, :rx, :otc]])
# data, header = readdlm("../../assets/sampleData/uscities.csv", ',', header=true)
# dfLocation = DataFrame(data, vec(header))
# dfOrgMaster = DataFrame(
#    ENTITY=repeat(["HeadOffice"], inner=8),
#    GROUP=repeat(["Operations"], inner=8),
#    DEPARTMENT=["Procurement","Procurement","Procurement","Procurement","Procurement","HR","HR","MFG"],
#    UNIT=["Sourcing","Sourcing","Maintenance","Support","Services","Helpdesk","ServiceCall","IT"])

# dfMSR = DataFrame(
#    UNIT = rand(dfOrgMaster.UNIT, sampleSize),
#    MSR_DATE=rand(collect(Date(2020,1,1):Day(1):Date(2022,5,1)), sampleSize),
#    FROM_UNIT = rand(dfOrgMaster.UNIT, sampleSize),
#    TO_UNIT = rand(dfOrgMaster.UNIT, sampleSize),
#    GUDID = rand(dfGUDIDdevice.PrimaryDI, sampleSize),
#    QTY = rand(dfOrgMaster.UNIT, sampleSize));
# first(dfMSR, 5)
```

## PO - Purchase Order

```@example
using DataFrames, Dates, Interact, CategoricalArrays, WebIO, CSV, XLSX, DelimitedFiles, Distributions
sampleSize = 1000 # number of rows, scale as needed

# data, header = readdlm("../../assets/sampleData/device.txt", '|', header=true)
# dfGUDIDdevice = DataFrame(data, vec(header))
# dfVendor = unique(dfGUDIDdevice[:,[:brandName, :dunsNumber, :companyName, :rx, :otc]])
# data, header = readdlm("../../assets/sampleData/uscities.csv", ',', header=true)
# dfLocation = DataFrame(data, vec(header))
dfOrgMaster = DataFrame(
    ENTITY=repeat(["HeadOffice"], inner=8),
    GROUP=repeat(["Operations"], inner=8),
    DEPARTMENT=["Procurement","Procurement","Procurement","Procurement","Procurement","HR","HR","MFG"],
    UNIT=["Sourcing","Sourcing","Maintenance","Support","Services","Helpdesk","ServiceCall","IT"]);

# dfPO = DataFrame(
#    UNIT = rand(dfOrgMaster.UNIT, sampleSize),
#    PO_DATE=rand(collect(Date(2020,1,1):Day(1):Date(2022,5,1)), sampleSize),
#    VENDOR=rand(unique(dfVendor.companyName), sampleSize),
#    GUDID = rand(dfGUDIDdevice.PrimaryDI, sampleSize),
#    QTY = rand(1:150, sampleSize),
#    UNIT_PRICE = rand(Normal(100, 2), sampleSize)
#    );
# show(first(dfPO, 5),allcols=true)
```

## Invoice - Voucher Invoice
```@example
using DataFrames, Dates, Interact, CategoricalArrays, WebIO, CSV, XLSX, DelimitedFiles, Distributions

sampleSize = 1000 # number of rows, scale as needed

# data, header = readdlm("../../assets/sampleData/device.txt", '|', header=true)
# dfGUDIDdevice = DataFrame(data, vec(header))
# dfVendor = unique(dfGUDIDdevice[:,[:brandName, :dunsNumber, :companyName, :rx, :otc]])
# data, header = readdlm("../../assets/sampleData/uscities.csv", ',', header=true)
# dfLocation = DataFrame(data, vec(header))
dfOrgMaster = DataFrame(
    ENTITY=repeat(["HeadOffice"], inner=8),
    GROUP=repeat(["Operations"], inner=8),
    DEPARTMENT=["Procurement","Procurement","Procurement","Procurement","Procurement","HR","HR","MFG"],
    UNIT=["Sourcing","Sourcing","Maintenance","Support","Services","Helpdesk","ServiceCall","IT"]);

# dfVCHR = DataFrame(
#    UNIT = rand(dfOrgMaster.UNIT, sampleSize),
#    VCHR_DATE=rand(collect(Date(2020,1,1):Day(1):Date(2022,5,1)), sampleSize),
#    STATUS=rand(["Closed","Paid","Open","Cancelled","Exception"], sampleSize),
#    VENDOR_INVOICE_NUM = rand(10001:9999999, sampleSize),
#    VENDOR=rand(unique(dfVendor.companyName), sampleSize),
#    GUDID = rand(dfGUDIDdevice.PrimaryDI, sampleSize),
#    QTY = rand(1:150, sampleSize),
#    UNIT_PRICE = rand(Normal(100, 2), sampleSize)
#    );
# show(first(dfVCHR, 5),allcols=true)
```

## Sales - Revenue Register

```@example
using DataFrames, Dates, Interact, CategoricalArrays, WebIO, CSV, XLSX, DelimitedFiles, Distributions
sampleSize = 1000 # number of rows, scale as needed

# data, header = readdlm("../../assets/sampleData/device.txt", '|', header=true)
# dfGUDIDdevice = DataFrame(data, vec(header))
# dfVendor = unique(dfGUDIDdevice[:,[:brandName, :dunsNumber, :companyName, :rx, :otc]])
# data, header = readdlm("../../assets/sampleData/uscities.csv", ',', header=true)
# dfLocation = DataFrame(data, vec(header))
dfOrgMaster = DataFrame(
    ENTITY=repeat(["HeadOffice"], inner=8),
    GROUP=repeat(["Operations"], inner=8),
    DEPARTMENT=["Procurement","Procurement","Procurement","Procurement","Procurement","HR","HR","MFG"],
    UNIT=["Sourcing","Sourcing","Maintenance","Support","Services","Helpdesk","ServiceCall","IT"]);

# dfREVENUE = DataFrame(
#    UNIT = rand(dfOrgMaster.UNIT, sampleSize),
#    SALES_DATE=rand(collect(Date(2020,1,1):Day(1):Date(2022,5,1)), sampleSize),
#    STATUS=rand(["Sold","Pending","Hold","Cancelled","Exception"], sampleSize),
#    SALES_RECEIPT_NUM = rand(10001:9999999, sampleSize),
#    CUSTOMER=rand(unique(dfVendor.companyName), sampleSize),
#    GUDID = rand(dfGUDIDdevice.PrimaryDI, sampleSize),
#    QTY = rand(1:150, sampleSize),
#    UNIT_PRICE = rand(Normal(100, 2), sampleSize)
#    );
# show(first(dfREVENUE, 5),allcols=true)
```

## Shipment - Receipt

```@example
# using DataFrames, Dates, Interact, CategoricalArrays, WebIO, CSV, XLSX, DelimitedFiles, Distributions
# sampleSize = 1000 # number of rows, scale as needed

# data, header = readdlm("../../assets/sampleData/device.txt", '|', header=true)
# dfGUDIDdevice = DataFrame(data, vec(header))
# dfVendor = unique(dfGUDIDdevice[:,[:brandName, :dunsNumber, :companyName, :rx, :otc]])
# data, header = readdlm("../../assets/sampleData/uscities.csv", ',', header=true)
# dfLocation = DataFrame(data, vec(header))
# dfOrgMaster = DataFrame(
    # ENTITY=repeat(["HeadOffice"], inner=8),
    # GROUP=repeat(["Operations"], inner=8),
    # DEPARTMENT=["Procurement","Procurement","Procurement","Procurement","Procurement","HR","HR","MFG"],
    # UNIT=["Sourcing","Sourcing","Maintenance","Support","Services","Helpdesk","ServiceCall","IT"])

# dfSHIPRECEIPT = DataFrame(
   # UNIT = rand(dfOrgMaster.UNIT, sampleSize),
   # SHIP_DATE=rand(collect(Date(2020,1,1):Day(1):Date(2022,5,1)), sampleSize),
   # STATUS=rand(["Shipped","Returned","In process","Cancelled","Exception"], sampleSize),
   # SHIPMENT_NUM = rand(10001:9999999, sampleSize),
   # CUSTOMER=rand(unique(dfVendor.companyName), sampleSize),
   # GUDID = rand(dfGUDIDdevice.PrimaryDI, sampleSize),
   # QTY = rand(1:150, sampleSize),
   # UNIT_PRICE = rand(Normal(100, 2), sampleSize)
   # );
# show(first(dfSHIPRECEIPT, 5),allcols=true)
```

---
## FINANCE Data model

Chart of accounts (organized hierarchy of account groups in tree form), Location/Department or Product based hierarchy allows businesses to group and report organization activities based on business processes.

These hierarchical grouping help capture monetary and statistical values of organization in finance statements.

---

To create Finance Data model and 
[Ledger Cash-flow or Balance Sheet like statements](https://s2.q4cdn.com/470004039/files/doc_financials/2020/q4/FY20_Q4_Consolidated_Financial_Statements.pdf),
We need associated dimensions (chartfields like chart of accounts).

## Accounts chartfield

```@example
using Pkg, DataFrames, CategoricalArrays, PooledArrays, Dates

# here CLASSIFICATION column vector stores 3500 distinct values in an array
CLASSIFICATION=repeat(["OPERATING_EXPENSES","NON-OPERATING_EXPENSES", "ASSETS","LIABILITIES","NET_WORTH","STATISTICS","REVENUE"
                ], inner=500)

cl = categorical(CLASSIFICATION)
levels(cl)

# using PooledArrays
pl = categorical(CLASSIFICATION)
levels(pl)

# show values in tabular format
# run one command at a time
df = DataFrame(Dict("Descr" => "CLASSIFICATION...ARR...", "Value" => size(CLASSIFICATION)[1]))
push!(df,("CAT...ARR...",size(cl)[1]))
push!(df,("CAT...ARR..COMPRESS.",size(compress(cl))[1]))
push!(df,("POOL...ARR...",size(pl)[1]))
push!(df,("POOL...ARR..COMPRESS.",size(compress(pl))[1]))
push!(df,("CAT...LEVELs...",size(levels(cl))[1]))
push!(df,("POOL...LEVELs...",size(levels(pl))[1]))
push!(df,("CLASSIFICATION...MEMSIZE", Base.summarysize(CLASSIFICATION)))
push!(df,("CAT...ARR...MEMSIZE", Base.summarysize(cl)))
push!(df,("POOL...ARR...MEMSIZE", Base.summarysize(pl)))
push!(df,("CAT...ARR..COMPRESS...MEMSIZE", Base.summarysize(compress(cl))))
push!(df,("POOL...ARR..COMPRESS...MEMSIZE", Base.summarysize(compress(pl))))

first(df,5)

accountsDF = DataFrame(
    ENTITY = "Galp Retail Inc.",
    AS_OF_DATE=Date("1900-01-01", dateformat"y-m-d"),
    ID = 11000:1000:45000,
    CLASSIFICATION=repeat([
        "OPERATING_EXPENSES","NON-OPERATING_EXPENSES", "ASSETS","LIABILITIES","NET_WORTH","STATISTICS","REVENUE"
                ], inner=5),
    CATEGORY=[
        "Travel","Payroll","non-Payroll","Allowance","Cash",
        "Facility","Supply","Services","Investment","Misc.",
        "Depreciation","Gain","Service","Retired","Fault.",
        "Receipt","Accrual","Return","Credit","ROI",
        "Cash","Funds","Invest","Transfer","Roll-over",
        "FTE","Members","Non_Members","Temp","Contractors",
        "Sales","Merchant","Service","Consulting","Subscriptions"],
    STATUS="A",
    DESCR=repeat([
    "operating expenses","non-operating expenses","ASSETS","liability","net-worth","stats","revenue"], inner=5),
    ACCOUNT_TYPE=repeat(["E","E","A","L","N","S","R"],inner=5))
accountsDF[collect(1:5),:]
```

## Department chartfield
```@example
using DataFrames, Dates
## create Accounts chartfield
# DEPARTMENT Chartfield
deptDF = DataFrame(
    AS_OF_DATE=Date("2000-01-01", dateformat"y-m-d"), 
    ID = 1100:100:1500,
    CLASSIFICATION=["SALES","HR", "IT","BUSINESS","OTHERS"],
    CATEGORY=["sales","human_resource","IT_Staff","business","others"],
    STATUS="A",
    DESCR=[
    "Sales & Marketing","Human Resource","Information Technology","Business leaders","other temp"
        ],
    DEPT_TYPE=["S","H","I","B","O"]);
deptDF[collect(1:5),:]
```

## Location chartfield
```@example
using DataFrames, Dates
locationDF = DataFrame(
    AS_OF_DATE=Date("2000-01-01", dateformat"y-m-d"), 
    ID = 11:1:22,
    CLASSIFICATION=repeat([
        "Galp Region A","Galp Region B", "Galp Region C"], inner=4),
    CATEGORY=repeat([
        "Galp Region A","Galp Region B", "Galp Region C"], inner=4),
    STATUS="A",
    DESCR=[
"Boston","New York","Philadelphia","Cleveland","Richmond",
"Atlanta","Chicago","St. Louis","Minneapolis","Kansas City",
"Dallas","San Francisco"],
    LOC_TYPE="Physical");
locationDF[:,:]
```

## Ledger RECORD
```@example
## pu
using DataFrames, Dates
accountsDF = DataFrame(
    ENTITY = "Galp Retail Inc.",
    AS_OF_DATE=Date("1900-01-01", dateformat"y-m-d"),
    ID = 11000:1000:45000,
    CLASSIFICATION=repeat([
        "OPERATING_EXPENSES","NON-OPERATING_EXPENSES", "ASSETS","LIABILITIES","NET_WORTH","STATISTICS","REVENUE"
                ], inner=5),
    CATEGORY=[
        "Travel","Payroll","non-Payroll","Allowance","Cash",
        "Facility","Supply","Services","Investment","Misc.",
        "Depreciation","Gain","Service","Retired","Fault.",
        "Receipt","Accrual","Return","Credit","ROI",
        "Cash","Funds","Invest","Transfer","Roll-over",
        "FTE","Members","Non_Members","Temp","Contractors",
        "Sales","Merchant","Service","Consulting","Subscriptions"],
    STATUS="A",
    DESCR=repeat([
    "operating expenses","non-operating expenses","ASSETS","liability","net-worth","stats","revenue"], inner=5),
    ACCOUNT_TYPE=repeat(["E","E","A","L","N","S","R"],inner=5))
# DEPARTMENT Chartfield
deptDF = DataFrame(
    AS_OF_DATE=Date("2000-01-01", dateformat"y-m-d"), 
    ID = 1100:100:1500,
    CLASSIFICATION=["SALES","HR", "IT","BUSINESS","OTHERS"],
    CATEGORY=["sales","human_resource","IT_Staff","business","others"],
    STATUS="A",
    DESCR=[
    "Sales & Marketing","Human Resource","Information Technology","Business leaders","other temp"
        ],
    DEPT_TYPE=["S","H","I","B","O"]);
size(deptDF),deptDF[collect(1:5),:]

locationDF = DataFrame(
    AS_OF_DATE=Date("2000-01-01", dateformat"y-m-d"), 
    ID = 11:1:22,
    CLASSIFICATION=repeat([
        "Galp Region A","Galp Region B", "Galp Region C"], inner=4),
    CATEGORY=repeat([
        "Galp Region A","Galp Region B", "Galp Region C"], inner=4),
    STATUS="A",
    DESCR=[
"Boston","New York","Philadelphia","Cleveland","Richmond",
"Atlanta","Chicago","St. Louis","Minneapolis","Kansas City",
"Dallas","San Francisco"],
    LOC_TYPE="Physical");
locationDF[:,:]

# creating Ledger
ledgerDF = DataFrame(
            LEDGER = String[], FISCAL_YEAR = Int[], PERIOD = Int[], ORGID = String[],
            OPER_UNIT = String[], ACCOUNT = Int[], DEPT = Int[], LOCATION = Int[],
            POSTED_TOTAL = Float64[]
            );

# create 2020 Period 1-12 Actuals Ledger 
l = "Actuals";
fy = 2020;
for p = 1:12
    for i = 1:10^5
        push!(ledgerDF, (l, fy, p, "Galp Inc.", rand(locationDF.CATEGORY),
            rand(accountsDF.ID), rand(deptDF.ID), rand(locationDF.ID), rand()*10^8))
    end
end

# create 2021 Period 1-4 Actuals Ledger 
l = "Actuals";
fy = 2021;
for p = 1:4
    for i = 1:10^5
        push!(ledgerDF, (l, fy, p, "Galp Inc.", rand(locationDF.CATEGORY),
            rand(accountsDF.ID), rand(deptDF.ID), rand(locationDF.ID), rand()*10^8))
    end
end

# create 2021 Period 1-4 Budget Ledger 
l = "Budget";
fy = 2021;
for p = 1:12
    for i = 1:10^5
        push!(ledgerDF, (l, fy, p, "Galp Inc.", rand(locationDF.CATEGORY),
            rand(accountsDF.ID), rand(deptDF.ID), rand(locationDF.ID), rand()*10^8))
    end
end

# here is ~3 million rows ledger dataframe
first(ledgerDF,5)
```