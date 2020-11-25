require "application_system_test_case"

class ApplicationsTest < ApplicationSystemTestCase
  setup do
    @application = applications(:one)
  end

  test "visiting the index" do
    visit applications_url
    assert_selector "h1", text: "Applications"
  end

  test "creating a Application" do
    visit applications_url
    click_on "New Application"

    fill_in "Administrationnotes", with: @application.AdministrationNotes
    fill_in "Applicantcouncilid", with: @application.ApplicantCouncilID_id
    fill_in "Applicantemail", with: @application.ApplicantEmail
    fill_in "Applicantid", with: @application.ApplicantID_id
    fill_in "Applicationtype", with: @application.ApplicationType
    fill_in "Assesmentcommenced", with: @application.AssesmentCommenced
    fill_in "Attention", with: @application.Attention
    fill_in "Buildingsurveyor", with: @application.BuildingSurveyor
    fill_in "Cooissued", with: @application.COOIssued
    check "Cancelled" if @application.Cancelled
    fill_in "Careof", with: @application.CareOf
    fill_in "Careofid", with: @application.CareOfID_id
    fill_in "Certificationnotes", with: @application.CertificationNotes
    fill_in "Certifier", with: @application.Certifier
    fill_in "Clientcouncilid", with: @application.ClientCouncilID_id
    fill_in "Clientid", with: @application.ClientID_id
    fill_in "Consent", with: @application.Consent
    fill_in "Consentissued", with: @application.ConsentIssued
    fill_in "Convertedtofrom", with: @application.ConvertedToFrom
    fill_in "Councilid", with: @application.CouncilID_id
    fill_in "Dano", with: @application.DANo
    fill_in "Dateentered", with: @application.DateEntered
    fill_in "Description", with: @application.Description
    check "Electroniclodgement" if @application.ElectronicLodgement
    fill_in "Feeamount", with: @application.FeeAmount
    check "Fullyinvoiced" if @application.FullyInvoiced
    check "Hardcopy" if @application.HardCopy
    fill_in "Invoicedebtornotes", with: @application.InvoiceDebtorNotes
    fill_in "Invoiceemail", with: @application.InvoiceEmail
    fill_in "Invoiceto", with: @application.InvoiceTo
    fill_in "Invoicetoid", with: @application.InvoiceToID_id
    fill_in "Jobtype", with: @application.JobType
    fill_in "Jobtypeadministration", with: @application.JobTypeAdministration
    fill_in "Lotno", with: @application.LotNo
    fill_in "Ownercouncilid", with: @application.OwnerCouncilID_id
    fill_in "Ownerid", with: @application.OwnerID_id
    fill_in "Purchaseorderno", with: @application.PurchaseOrderNo
    fill_in "Quoteaccepteddate", with: @application.QuoteAcceptedDate
    fill_in "Rfiissued", with: @application.RFIIssued
    fill_in "Referenceno", with: @application.ReferenceNo
    fill_in "Riskrating", with: @application.RiskRating
    fill_in "Section93a", with: @application.Section93A
    fill_in "Sortprioritygen", with: @application.SortPriorityGen
    fill_in "Staged", with: @application.Staged
    fill_in "Streetname", with: @application.StreetName
    fill_in "Streetno", with: @application.StreetNo
    fill_in "Structuralengineer", with: @application.StructuralEngineer
    fill_in "Suburbid", with: @application.SuburbID_id
    fill_in "Variationissued", with: @application.VariationIssued
    click_on "Create Application"

    assert_text "Application was successfully created"
    click_on "Back"
  end

  test "updating a Application" do
    visit applications_url
    click_on "Edit", match: :first

    fill_in "Administrationnotes", with: @application.AdministrationNotes
    fill_in "Applicantcouncilid", with: @application.ApplicantCouncilID_id
    fill_in "Applicantemail", with: @application.ApplicantEmail
    fill_in "Applicantid", with: @application.ApplicantID_id
    fill_in "Applicationtype", with: @application.ApplicationType
    fill_in "Assesmentcommenced", with: @application.AssesmentCommenced
    fill_in "Attention", with: @application.Attention
    fill_in "Buildingsurveyor", with: @application.BuildingSurveyor
    fill_in "Cooissued", with: @application.COOIssued
    check "Cancelled" if @application.Cancelled
    fill_in "Careof", with: @application.CareOf
    fill_in "Careofid", with: @application.CareOfID_id
    fill_in "Certificationnotes", with: @application.CertificationNotes
    fill_in "Certifier", with: @application.Certifier
    fill_in "Clientcouncilid", with: @application.ClientCouncilID_id
    fill_in "Clientid", with: @application.ClientID_id
    fill_in "Consent", with: @application.Consent
    fill_in "Consentissued", with: @application.ConsentIssued
    fill_in "Convertedtofrom", with: @application.ConvertedToFrom
    fill_in "Councilid", with: @application.CouncilID_id
    fill_in "Dano", with: @application.DANo
    fill_in "Dateentered", with: @application.DateEntered
    fill_in "Description", with: @application.Description
    check "Electroniclodgement" if @application.ElectronicLodgement
    fill_in "Feeamount", with: @application.FeeAmount
    check "Fullyinvoiced" if @application.FullyInvoiced
    check "Hardcopy" if @application.HardCopy
    fill_in "Invoicedebtornotes", with: @application.InvoiceDebtorNotes
    fill_in "Invoiceemail", with: @application.InvoiceEmail
    fill_in "Invoiceto", with: @application.InvoiceTo
    fill_in "Invoicetoid", with: @application.InvoiceToID_id
    fill_in "Jobtype", with: @application.JobType
    fill_in "Jobtypeadministration", with: @application.JobTypeAdministration
    fill_in "Lotno", with: @application.LotNo
    fill_in "Ownercouncilid", with: @application.OwnerCouncilID_id
    fill_in "Ownerid", with: @application.OwnerID_id
    fill_in "Purchaseorderno", with: @application.PurchaseOrderNo
    fill_in "Quoteaccepteddate", with: @application.QuoteAcceptedDate
    fill_in "Rfiissued", with: @application.RFIIssued
    fill_in "Referenceno", with: @application.ReferenceNo
    fill_in "Riskrating", with: @application.RiskRating
    fill_in "Section93a", with: @application.Section93A
    fill_in "Sortprioritygen", with: @application.SortPriorityGen
    fill_in "Staged", with: @application.Staged
    fill_in "Streetname", with: @application.StreetName
    fill_in "Streetno", with: @application.StreetNo
    fill_in "Structuralengineer", with: @application.StructuralEngineer
    fill_in "Suburbid", with: @application.SuburbID_id
    fill_in "Variationissued", with: @application.VariationIssued
    click_on "Update Application"

    assert_text "Application was successfully updated"
    click_on "Back"
  end

  test "destroying a Application" do
    visit applications_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Application was successfully destroyed"
  end
end
