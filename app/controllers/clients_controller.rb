# frozen_string_literal: true

class ClientsController < ApplicationController
  before_action :set_client, only: %i[edit update]
  before_action :prepare_association_lists, only: %i[edit update]

  def edit; end

  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to session[:application_page] }
      else
        format.html { render :edit }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_client
    @client = Client.find(params[:id])
  end

  def prepare_association_lists
    @suburbs = Suburb.pluck(:display_name)
  end

  # Only allow a list of trusted parameters through.
  def client_params
    params
      .require(:client)
      .permit(
        :client_type,
        :client_name,
        :first_name,
        :surname,
        :title,
        :initials,
        :salutation,
        :company_name,
        :street,
        :suburb_id,
        :postal_address,
        :postal_suburb_id,
        :australian_business_number,
        :state,
        :phone,
        :mobile_number,
        :fax,
        :email,
        :notes,
        :bad_payer,
        :suburb_display_name,
        :postal_suburb_display_name
      )
  end
end
