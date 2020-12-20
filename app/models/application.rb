class Application < ApplicationRecord
  belongs_to :council
  belongs_to :applicant
  belongs_to :applicant_council
  belongs_to :owner
  belongs_to :owner_council
  belongs_to :client
  belongs_to :client_council
  belongs_to :suburb
  belongs_to :invoice_to
  belongs_to :care_of
end
