# frozen_string_literal: true
require 'test_helper'

class InvoicesControllerTest < ActionDispatch::IntegrationTest
  #setup do
    ##sign_in_test_user
    ##@invoice = invoices(:one)
  #end

  #test "should get index" do
    #skip
    #get invoices_url
    #assert_response :success
  #end

  #test "should get new" do
    #skip
    #get new_invoice_url
    #assert_response :success
  #end

  #test "should create invoice" do
    #skip
    #assert_difference('Invoice.count') do
      #post invoices_url, params: { invoice: { application_id: @invoice.application_id, dac: @invoice.dac, fee: @invoice.fee, gst: @invoice.gst, insurance_levy: @invoice.insurance_levy, invoice_date: @invoice.invoice_date, invoice_number: @invoice.invoice_number, lodgement: @invoice.lodgement, paid: @invoice.paid, percent_invoiced: @invoice.percent_invoiced, stage: @invoice.stage } }
    #end

    #assert_redirected_to invoice_url(Invoice.last)
  #end

  #test "should show invoice" do
    #skip
    #get invoice_url(@invoice)
    #assert_response :success
  #end

  #test "should get edit" do
    #skip
    #get edit_invoice_url(@invoice)
    #assert_response :success
  #end

  #test "should update invoice" do
    #skip
    #patch invoice_url(@invoice), params: { invoice: { application_id: @invoice.application_id, dac: @invoice.dac, fee: @invoice.fee, gst: @invoice.gst, insurance_levy: @invoice.insurance_levy, invoice_date: @invoice.invoice_date, invoice_number: @invoice.invoice_number, lodgement: @invoice.lodgement, paid: @invoice.paid, percent_invoiced: @invoice.percent_invoiced, stage: @invoice.stage } }
    #assert_redirected_to invoice_url(@invoice)
  #end

  #test "should destroy invoice" do
    #skip
    #assert_difference('Invoice.count', -1) do
      #delete invoice_url(@invoice)
    #end

    #assert_redirected_to invoices_url
  #end
end
