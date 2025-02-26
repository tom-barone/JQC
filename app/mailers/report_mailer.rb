# frozen_string_literal: true

# Reporting mailer used to automate and send custom SQL reports for JQC
class ReportMailer < ApplicationMailer
  default from: 'jqc.reports@tombarone.net'
  layout 'mailer'

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def last_month_csv_reports
    # Don't send in the staging environment
    if ENV['STAGING'].present?
      Rails.logger.info('Skipping report email in staging environment')
      return
    end

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
    attachments['Applications_with_last_RFI_sent_3_months_ago_and_no_final_consent_issued.csv'] = {
      mime_type: 'text/csv',
      content: Application.last_rfi_sent_over_3_months_ago_and_no_final_consent_issued(this_month)
    }

    # Mail it
    mail(
      to: @recipient_email,
      bcc: 'mail@tombarone.net',
      subject: "JQC #{@last_month_name} #{@year} Reports"
    )
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
