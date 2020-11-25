require 'test_helper'

class ApplicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @application = applications(:one)
  end

  test "should get index" do
    get applications_url
    assert_response :success
  end

  test "should get new" do
    get new_application_url
    assert_response :success
  end

  test "should create application" do
    assert_difference('Application.count') do
      post applications_url, params: { application: { AdministrationNotes: @application.AdministrationNotes, ApplicantCouncilID_id: @application.ApplicantCouncilID_id, ApplicantEmail: @application.ApplicantEmail, ApplicantID_id: @application.ApplicantID_id, ApplicationType: @application.ApplicationType, AssesmentCommenced: @application.AssesmentCommenced, Attention: @application.Attention, BuildingSurveyor: @application.BuildingSurveyor, COOIssued: @application.COOIssued, Cancelled: @application.Cancelled, CareOf: @application.CareOf, CareOfID_id: @application.CareOfID_id, CertificationNotes: @application.CertificationNotes, Certifier: @application.Certifier, ClientCouncilID_id: @application.ClientCouncilID_id, ClientID_id: @application.ClientID_id, Consent: @application.Consent, ConsentIssued: @application.ConsentIssued, ConvertedToFrom: @application.ConvertedToFrom, CouncilID_id: @application.CouncilID_id, DANo: @application.DANo, DateEntered: @application.DateEntered, Description: @application.Description, ElectronicLodgement: @application.ElectronicLodgement, FeeAmount: @application.FeeAmount, FullyInvoiced: @application.FullyInvoiced, HardCopy: @application.HardCopy, InvoiceDebtorNotes: @application.InvoiceDebtorNotes, InvoiceEmail: @application.InvoiceEmail, InvoiceTo: @application.InvoiceTo, InvoiceToID_id: @application.InvoiceToID_id, JobType: @application.JobType, JobTypeAdministration: @application.JobTypeAdministration, LotNo: @application.LotNo, OwnerCouncilID_id: @application.OwnerCouncilID_id, OwnerID_id: @application.OwnerID_id, PurchaseOrderNo: @application.PurchaseOrderNo, QuoteAcceptedDate: @application.QuoteAcceptedDate, RFIIssued: @application.RFIIssued, ReferenceNo: @application.ReferenceNo, RiskRating: @application.RiskRating, Section93A: @application.Section93A, SortPriorityGen: @application.SortPriorityGen, Staged: @application.Staged, StreetName: @application.StreetName, StreetNo: @application.StreetNo, StructuralEngineer: @application.StructuralEngineer, SuburbID_id: @application.SuburbID_id, VariationIssued: @application.VariationIssued } }
    end

    assert_redirected_to application_url(Application.last)
  end

  test "should show application" do
    get application_url(@application)
    assert_response :success
  end

  test "should get edit" do
    get edit_application_url(@application)
    assert_response :success
  end

  test "should update application" do
    patch application_url(@application), params: { application: { AdministrationNotes: @application.AdministrationNotes, ApplicantCouncilID_id: @application.ApplicantCouncilID_id, ApplicantEmail: @application.ApplicantEmail, ApplicantID_id: @application.ApplicantID_id, ApplicationType: @application.ApplicationType, AssesmentCommenced: @application.AssesmentCommenced, Attention: @application.Attention, BuildingSurveyor: @application.BuildingSurveyor, COOIssued: @application.COOIssued, Cancelled: @application.Cancelled, CareOf: @application.CareOf, CareOfID_id: @application.CareOfID_id, CertificationNotes: @application.CertificationNotes, Certifier: @application.Certifier, ClientCouncilID_id: @application.ClientCouncilID_id, ClientID_id: @application.ClientID_id, Consent: @application.Consent, ConsentIssued: @application.ConsentIssued, ConvertedToFrom: @application.ConvertedToFrom, CouncilID_id: @application.CouncilID_id, DANo: @application.DANo, DateEntered: @application.DateEntered, Description: @application.Description, ElectronicLodgement: @application.ElectronicLodgement, FeeAmount: @application.FeeAmount, FullyInvoiced: @application.FullyInvoiced, HardCopy: @application.HardCopy, InvoiceDebtorNotes: @application.InvoiceDebtorNotes, InvoiceEmail: @application.InvoiceEmail, InvoiceTo: @application.InvoiceTo, InvoiceToID_id: @application.InvoiceToID_id, JobType: @application.JobType, JobTypeAdministration: @application.JobTypeAdministration, LotNo: @application.LotNo, OwnerCouncilID_id: @application.OwnerCouncilID_id, OwnerID_id: @application.OwnerID_id, PurchaseOrderNo: @application.PurchaseOrderNo, QuoteAcceptedDate: @application.QuoteAcceptedDate, RFIIssued: @application.RFIIssued, ReferenceNo: @application.ReferenceNo, RiskRating: @application.RiskRating, Section93A: @application.Section93A, SortPriorityGen: @application.SortPriorityGen, Staged: @application.Staged, StreetName: @application.StreetName, StreetNo: @application.StreetNo, StructuralEngineer: @application.StructuralEngineer, SuburbID_id: @application.SuburbID_id, VariationIssued: @application.VariationIssued } }
    assert_redirected_to application_url(@application)
  end

  test "should destroy application" do
    assert_difference('Application.count', -1) do
      delete application_url(@application)
    end

    assert_redirected_to applications_url
  end
end
