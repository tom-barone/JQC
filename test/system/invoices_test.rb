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

    fill_in "Application", with: @invoice.application_id
    fill_in "Dac", with: @invoice.dac
    fill_in "Fee", with: @invoice.fee
    fill_in "Gst", with: @invoice.gst
    fill_in "Insurance levy", with: @invoice.insurance_levy
    fill_in "Invoice date", with: @invoice.invoice_date
    fill_in "Invoice number", with: @invoice.invoice_number
    fill_in "Lodgement", with: @invoice.lodgement
    check "Paid" if @invoice.paid
    fill_in "Percent invoiced", with: @invoice.percent_invoiced
    fill_in "Stage", with: @invoice.stage
    click_on "Create Invoice"

    assert_text "Invoice was successfully created"
    click_on "Back"
  end

  test "updating a Invoice" do
    visit invoices_url
    click_on "Edit", match: :first

    fill_in "Application", with: @invoice.application_id
    fill_in "Dac", with: @invoice.dac
    fill_in "Fee", with: @invoice.fee
    fill_in "Gst", with: @invoice.gst
    fill_in "Insurance levy", with: @invoice.insurance_levy
    fill_in "Invoice date", with: @invoice.invoice_date
    fill_in "Invoice number", with: @invoice.invoice_number
    fill_in "Lodgement", with: @invoice.lodgement
    check "Paid" if @invoice.paid
    fill_in "Percent invoiced", with: @invoice.percent_invoiced
    fill_in "Stage", with: @invoice.stage
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
