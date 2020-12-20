class Council < ApplicationRecord
  belongs_to :suburb
  belongs_to :postal_suburb
end
