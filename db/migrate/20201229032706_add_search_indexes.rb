# frozen_string_literal: true

class AddSearchIndexes < ActiveRecord::Migration[6.0]
  def change
    add_index :applications,
              %i[
                description
                development_application_number
                street_name
                street_number
                lot_number
              ],
              name: 'application_search_fulltext_index',
              type: :fulltext

    add_index :suburbs,
              :display_name,
              type: :fulltext

    add_index :clients,
              :client_name,
              type: :fulltext

    add_index :councils,
              :name,
              type: :fulltext
  end
end
