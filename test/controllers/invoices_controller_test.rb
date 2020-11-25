require 'test_helper'

class InvoicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @invoice = invoices(:one)
  end

  test "should get index" do
    get invoices_url
    assert_response :success
  end

  test "should get new" do
    get new_invoice_url
    assert_response :success
  end

  test "should create invoice" do
    assert_difference('Invoice.count') do
      post invoices_url, params: { invoice: { ApplicationID_id: @invoice.ApplicationID_id, DAC: @invoice.DAC, Fee: @invoice.Fee, GST: @invoice.GST, InsLevy: @invoice.InsLevy, InvoiceDate: @invoice.InvoiceDate, InvoiceNo: @invoice.InvoiceNo, Lodgement: @invoice.Lodgement, Paid: @invoice.Paid, PercentInvoiced: @invoice.PercentInvoiced, Stage: @invoice.Stage } }
    end

    assert_redirected_to invoice_url(Invoice.last)
  end

  test "should show invoice" do
    get invoice_url(@invoice)
    assert_response :success
  end

  test "should get edit" do
    get edit_invoice_url(@invoice)
    assert_response :success
  end

  test "should update invoice" do
    patch invoice_url(@invoice), params: { invoice: { ApplicationID_id: @invoice.ApplicationID_id, DAC: @invoice.DAC, Fee: @invoice.Fee, GST: @invoice.GST, InsLevy: @invoice.InsLevy, InvoiceDate: @invoice.InvoiceDate, InvoiceNo: @invoice.InvoiceNo, Lodgement: @invoice.Lodgement, Paid: @invoice.Paid, PercentInvoiced: @invoice.PercentInvoiced, Stage: @invoice.Stage } }
    assert_redirected_to invoice_url(@invoice)
  end

  test "should destroy invoice" do
    assert_difference('Invoice.count', -1) do
      delete invoice_url(@invoice)
    end

    assert_redirected_to invoices_url
  end
end
