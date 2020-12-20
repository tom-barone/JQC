class Application < ApplicationRecord
  belongs_to :council, :class_name => 'Council'
  belongs_to :applicant, :class_name => 'Client'
  belongs_to :applicant_council, :class_name => 'Council'
  belongs_to :owner, :class_name => 'Client'
  belongs_to :owner_council, :class_name => 'Council'
  belongs_to :client, :class_name => 'Client'
  belongs_to :client_council, :class_name => 'Council'
  belongs_to :suburb
  belongs_to :invoice_to, :class_name => 'Client'
  belongs_to :care_of, :class_name => 'Client'
end
