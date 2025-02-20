# frozen_string_literal: true

module NavHelper
  def applications_nav_link_class(params)
    active = params[:controller] == 'applications' && params[:action] == 'index'
    "nav-link #{'active' if active}"
  end

  def surveyor_dashboard_nav_link_class(params)
    active = params[:action] == 'building_surveyor_search'
    "nav-link #{'active' if active}"
  end

  def settings_nav_link_class(params)
    active = params[:controller] == 'application_types'
    "nav-link #{'active' if active}"
  end
end
