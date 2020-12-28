class Client < ApplicationRecord
  belongs_to :suburb
  belongs_to :postal_suburb, :class_name => 'Suburb'
end
