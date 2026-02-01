# frozen_string_literal: true

# rubocop:disable Layout/LineLength, Metrics/MethodLength
class ReportsController < ApplicationController
  before_action :authenticate_user!
  include ActionController::Live

  def index
    set_dates
    respond_to do |format|
      format.html
      format.csv do
        report_for(params[:report_type])
        redirect_to reports_path
      end
    end
  end

  private

  def set_dates
    @today = Time.now.in_time_zone('Australia/Adelaide').to_date
    @this_month = Time.now.in_time_zone('Australia/Adelaide').to_date.beginning_of_month
    @last_month = @this_month << 1
    @three_months_ago = @this_month << 3
  end

  def report_for(report_type)
    case report_type
    when 'applications_with_no_final_consent_issued'
      applications_last_rfi_report
    when 'applications_with_no_rfi_sent'
      applications_no_rfi_report
    when 'overdue_pcs'
      overdue_pcs_report
    when 'pcs_with_invoices_sent_and_consent_not_issued'
      pcs_with_invoices_sent_and_consent_not_issued_report
    when 'structural_report'
      structural_report
    else
      flash.now[:alert] = 'Invalid report type'
    end
  end

  def applications_last_rfi_report
    latest_rfi_sent_date = params[:latest_rfi_sent_date]
    applications = Application.applications_with_no_final_consent_issued(latest_rfi_sent_date)
    headers = applications.columns.map(&:name)
    rows = applications.map do |application|
      application.attributes.slice(*headers).values
    end
    filename = "applications_with_latest_rfi_sent_before_#{latest_rfi_sent_date}_and_no_final_consent_issued.csv"
    CsvResponse.new(rows, headers, filename, response).send
  end

  def applications_no_rfi_report
    assessment_assigned_before = params[:assessment_assigned_before]
    applications = Application.applications_with_no_rfi_sent(assessment_assigned_before)
    headers = applications.columns.map(&:name)
    rows = applications.map do |application|
      application.attributes.slice(*headers).values
    end
    filename = "applications_with_assessment_assigned_before_#{assessment_assigned_before}_and_no_rfi_sent.csv"
    CsvResponse.new(rows, headers, filename, response).send
  end

  def overdue_pcs_report
    assessment_assigned_before_date = params[:assessment_assigned_before_date]
    latest_rfi_sent_before_date = params[:latest_rfi_sent_before_date]
    applications = Application.overdue_pcs(assessment_assigned_before_date, latest_rfi_sent_before_date)
    headers = applications.columns
    rows = applications.rows
    filename = "overdue_pcs_with_assessment_assigned_before_#{assessment_assigned_before_date}_and_latest_rfi_sent_before_#{latest_rfi_sent_before_date}.csv"
    CsvResponse.new(rows, headers, filename, response).send
  end

  def pcs_with_invoices_sent_and_consent_not_issued_report
    invoice_date_after = params[:invoice_date_after]
    applications = Application.pcs_with_invoices_sent_and_consent_not_issued(invoice_date_after)
    headers = applications.columns
    rows = applications.rows
    filename = "pcs_with_invoices_sent_after_#{invoice_date_after}_and_consent_not_issued.csv"
    CsvResponse.new(rows, headers, filename, response).send
  end

  def structural_report
    from = params[:external_engineer_date_from]
    to = params[:external_engineer_date_to]
    structural_engineers = StructuralEngineer.report(from, to)
    headers = structural_engineers.columns
    rows = structural_engineers.rows
    filename = "structural_report_from_#{from}_to_#{to}.csv"
    CsvResponse.new(rows, headers, filename, response).send
  end
end
# rubocop:enable Layout/LineLength, Metrics/MethodLength
