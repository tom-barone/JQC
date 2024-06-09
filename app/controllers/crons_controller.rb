# frozen_string_literal: true

# Controller to receive requests from Google App Engine's cron service
# https://cloud.google.com/appengine/docs/flexible/scheduling-jobs-with-cron-yaml
class CronsController < ApplicationController
  def last_month_csv_reports
    if request.headers['X-Appengine-Cron']
      ReportMailer.last_month_csv_reports.deliver_now
      head :ok
    else
      head :not_found
    end
  end
end
