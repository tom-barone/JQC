# frozen_string_literal: true

# Reporting mailer used to automate and send custom SQL reports for JQC
class ReportMailer < ApplicationMailer
  default from: 'jqc.reports@tombarone.net'
  layout 'mailer'

  def last_month_csv_reports
    this_month =
      Time.now.in_time_zone('Australia/Adelaide').to_date.beginning_of_month
    last_month = this_month << 1

    # Set email template values
    @last_month_name = last_month.strftime('%B') # e.g. September
    @year = last_month.strftime('%Y') # e.g. 2022
    @recipient_email =
      Rails.application.credentials.monthly_report_recipient_email
    @recipient_name =
      Rails.application.credentials.monthly_report_recipient_name

    # Add report attachments
    attachments['Quotes_last_3_months.csv'] = {
      mime_type: 'text/csv',
      content: Application.last_3_months_quotes(this_month)
    }
    attachments['Overdue_PCs.csv'] = {
      mime_type: 'text/csv',
      content: Application.overdue_pcs(this_month)
    }
    attachments['PCs_last_month.csv'] = {
      mime_type: 'text/csv',
      content: Application.last_month_pcs(this_month)
    }
    attachments['PCs_invoice_sent_and_consent_not_issued.csv'] = {
      mime_type: 'text/csv',
      content: Application.pcs_with_invoices_sent_and_consent_not_issued
    }

    # Mail it
    mail(
      to: @recipient_email,
      bcc: 'mail@tombarone.net',
      subject: "JQC #{@last_month_name} #{@year} Reports"
    )
  end
end
