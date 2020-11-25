class Application < ApplicationRecord
  belongs_to :CouncilID
  belongs_to :ApplicantID
  belongs_to :ApplicantCouncilID
  belongs_to :OwnerID
  belongs_to :OwnerCouncilID
  belongs_to :ClientID
  belongs_to :ClientCouncilID
  belongs_to :SuburbID
  belongs_to :InvoiceToID
  belongs_to :CareOfID
end
