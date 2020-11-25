require "application_system_test_case"

class InvoicesTest < ApplicationSystemTestCase
  setup do
    @invoice = invoices(:one)
  end

  test "visiting the index" do
    visit invoices_url
    assert_selector "h1", text: "Invoices"
  end

  test "creating a Invoice" do
    visit invoices_url
    click_on "New Invoice"

    fill_in "Applicationid", with: @invoice.ApplicationID_id
    fill_in "Dac", with: @invoice.DAC
    fill_in "Fee", with: @invoice.Fee
    fill_in "Gst", with: @invoice.GST
    fill_in "Inslevy", with: @invoice.InsLevy
    fill_in "Invoicedate", with: @invoice.InvoiceDate
    fill_in "Invoiceno", with: @invoice.InvoiceNo
    fill_in "Lodgement", with: @invoice.Lodgement
    check "Paid" if @invoice.Paid
    fill_in "Percentinvoiced", with: @invoice.PercentInvoiced
    fill_in "Stage", with: @invoice.Stage
    click_on "Create Invoice"

    assert_text "Invoice was successfully created"
    click_on "Back"
  end

  test "updating a Invoice" do
    visit invoices_url
    click_on "Edit", match: :first

    fill_in "Applicationid", with: @invoice.ApplicationID_id
    fill_in "Dac", with: @invoice.DAC
    fill_in "Fee", with: @invoice.Fee
    fill_in "Gst", with: @invoice.GST
    fill_in "Inslevy", with: @invoice.InsLevy
    fill_in "Invoicedate", with: @invoice.InvoiceDate
    fill_in "Invoiceno", with: @invoice.InvoiceNo
    fill_in "Lodgement", with: @invoice.Lodgement
    check "Paid" if @invoice.Paid
    fill_in "Percentinvoiced", with: @invoice.PercentInvoiced
    fill_in "Stage", with: @invoice.Stage
    click_on "Update Invoice"

    assert_text "Invoice was successfully updated"
    click_on "Back"
  end

  test "destroying a Invoice" do
    visit invoices_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Invoice was successfully destroyed"
  end
end
