# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_user!

  # Main marketing page
  def index; end
end
