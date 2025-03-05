# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :prepare_exception_notifier
  rescue_from ActionController::InvalidAuthenticityToken, with: :invalid_authenticity_token

  # Send exception notifications on error
  def prepare_exception_notifier
    request.env['exception_notifier.exception_data'] = {
      current_user: current_user
    }
  end

  def only_admin
    return if current_user&.admin?

    head :forbidden
  end

  def invalid_authenticity_token
    sign_out(current_user) if current_user
    redirect_to new_user_session_url, alert: 'Your session has expired. Please sign in again.'
  end
end
