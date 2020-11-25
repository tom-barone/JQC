# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...

## Invoicing

using jinja2 and weasyprint to make invoices

bean-report jqc.beancount holdings --by=currency

bean-query -f csv jqc.beancount 'select Date, description as Description, number as Hours, cost_number as Rate, value(position) as amount from has_account("HoursWorked") open on 2018-05-01 close on 2018-08-03 where not "invoice" in tags and number > 0'

bean-query -f csv jqc.beancount 'select sum(value(position)) as total from has_account("HoursWorked") open on 2018-05-01 close on 2018-08-03 where not "invoice" in tags and number > 0;'

## Rails Generators From AppMaker Database

Generate
```
scaffold -c -p ./db/old_schema_from_appmaker.rb
```

Scripts. In order of parent models -> child models with foreign key references.
```
# ApplicationType
rails generate scaffold ApplicationType LastUsed:integer --no-migration

# Suburb
rails generate scaffold Suburb DisplayName:text Suburb:text State:text Postcode:text --no-migration

# Client
rails generate scaffold Client ClientType:text ClientName:text FirstName:text Surname:text Title:text Initials:text Salutation:text CompanyName:text Street:text SuburbID:references PostalAddress:text PostalSuburbID:references ABN:text State:string Phone:text MobileNo:text Fax:text Email:text Notes:text BadPayer:boolean --no-migration

# Council
rails generate scaffold Council Name:text City:text Street:text State:string SuburbID:references PostalAddress:text PostalSuburbID:references Phone:text Fax:text Email:text Notes:text --no-migration

# Application
rails generate scaffold Application ApplicationType:string ReferenceNo:text ConvertedToFrom:text DateEntered:date CouncilID:references DANo:text ApplicantID:references ApplicantCouncilID:references OwnerID:references OwnerCouncilID:references ClientID:references ClientCouncilID:references Description:text Cancelled:boolean StreetNo:text LotNo:text StreetName:text SuburbID:references Section93A:date ElectronicLodgement:boolean HardCopy:boolean JobTypeAdministration:text QuoteAcceptedDate:date AdministrationNotes:text FeeAmount:decimal BuildingSurveyor:text StructuralEngineer:text RiskRating:text AssesmentCommenced:date RFIIssued:date ConsentIssued:date VariationIssued:date Staged:date COOIssued:date JobType:text Consent:text Certifier:text CertificationNotes:text InvoiceTo:text CareOf:text InvoiceToID:references CareOfID:references InvoiceEmail:text Attention:text PurchaseOrderNo:text FullyInvoiced:boolean InvoiceDebtorNotes:text ApplicantEmail:text SortPriorityGen:integer --no-migration

# AdditionalInfo
rails generate scaffold AdditionalInfo InfoDate:date InfoText:text ApplicationID:references --no-migration

# Invoice
rails generate scaffold Invoice InvoiceNo:text Stage:text Fee:decimal GST:decimal DAC:decimal Lodgement:decimal InsLevy:decimal PercentInvoiced:decimal InvoiceDate:date Paid:boolean ApplicationID:references --no-migration

# Stage
rails generate scaffold Stage StageDate:date StageText:text ApplicationID:references --no-migration

# Uploaded
rails generate scaffold Uploaded UploadedDate:date UploadedText:text ApplicationID:references --no-migration
```

## Todo

- Create migrations for each database table
- link foreign keys and things
