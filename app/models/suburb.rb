class Suburb < ApplicationRecord
  has_many :applications

  STATE = %w[SA VIC TAS WA NSW NT ACT QLD]
end
