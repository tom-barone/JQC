# frozen_string_literal: true

class ReportMailerPreview < ActionMailer::Preview
  def last_month_csv_reports
    ReportMailer.last_month_csv_reports
  end
end
