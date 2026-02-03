# frozen_string_literal: true

module Settings
  class SuburbsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_suburb, only: %i[edit update destroy]
    include Pagy::Backend

    def index
      @params = search_params
      @limit = 10
      @pagy, @suburbs = pagy(Suburb.search(@params).order(:suburb, :postcode), limit: @limit)
    end

    def new
      @suburb = Suburb.new
    end

    def edit; end

    def create
      @suburb = Suburb.new(suburb_params)
      if @suburb.save
        redirect_to settings_suburbs_path, flash:
          { success: ['Suburb ',
                      { 'text' => @suburb[:suburb],
                        'link_to' => edit_settings_suburb_path(@suburb) },
                      ' created successfully.'] }
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      if @suburb.update(suburb_params)
        redirect_to settings_suburbs_path, flash:
          { success: ['Suburb ',
                      { 'text' => @suburb[:suburb],
                        'link_to' => edit_settings_suburb_path(@suburb) },
                      ' updated successfully.'] }
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      name = @suburb[:suburb]
      @suburb.destroy!
      redirect_to settings_suburbs_path, flash: { success: ["Suburb #{name} deleted successfully."] }
    end

    private

    def set_suburb
      @suburb = Suburb.find(params.expect(:id))
    end

    def search_params
      params.permit(:search_text, :state, :page)
    end

    def suburb_params
      params.expect(suburb: %i[suburb state postcode])
    end
  end
end
