# frozen_string_literal: true

class DropOldView < ActiveRecord::Migration[6.0]
  def up
    execute 'drop view ApplicationsAll'
  end
end
