# frozen_string_literal: true

class ClientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_client, only: %i[edit update]
  before_action :prepare_association_lists, only: %i[edit]

  # GET /clients/1/edit
  def edit; end

  # PATCH/PUT /clients/1
  # rubocop:disable Metrics/MethodLength
  def update
    respond_to do |format|
      format.html do
        if @client.update(client_params)
          flash[:success] = [
            'Successfully updated ',
            { 'text' => @client[:client_name], 'link_to' => edit_client_path(@client) }
          ]
          redirect_to params[:previous_request]
        else
          render :edit, status: :unprocessable_entity
        end
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_client
    @client = Client.eager_load_associations.find(params.expect(:id))
  end

  def prepare_association_lists
    # Cache the lists of suburbs, since they'll never change really
    @suburbs = Rails.cache.fetch('association_lists_suburbs', expires_in: 1.day) do
      Suburb.pluck(:display_name)
    end
  end

  # Only allow a list of trusted parameters through.
  def client_params
    params.expect(client: %i[client_type client_name first_name surname title initials salutation
                             company_name street postal_address australian_business_number state phone mobile_number
                             fax email notes bad_payer suburb_display_name postal_suburb_display_name])
  end
end
