# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  ActionMailer::MailDeliveryJob.rescue_from(Exception) do |exception|
    ExceptionNotifier.notify_exception(exception)
    raise exception
  end
end
