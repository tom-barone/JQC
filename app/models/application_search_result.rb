# frozen_string_literal: true

class ApplicationSearchResult < ApplicationRecord
  include Filterable

  self.primary_key = :id
end
