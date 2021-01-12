class Stage < ApplicationRecord
  belongs_to :application

  STAGE = ['Demolition', 'Civil', 'Substructure', 'Superstructure', 'Final']
end
