# frozen_string_literal: true
class RemoveNewlineCharactersFromSuburbDisplayNames < ActiveRecord::Migration[
  6.0
]
  def up
    execute "update suburbs set display_name = REPLACE(REPLACE(display_name, '\r', ''), '\n', '')"
    execute "update suburbs set state = REPLACE(REPLACE(TRIM(state), '\r', ''), '\n', '')"
  end
end
