class Application < ApplicationRecord
  validates :reference_number, presence: true, length: { minimum: 5 } 
end
