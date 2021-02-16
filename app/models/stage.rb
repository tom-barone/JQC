class Stage < ApplicationRecord
  belongs_to :application

  STAGE = [
    'Demolition',
    'Civil',
    'Substructure',
    'Superstructure',
    'Final',
    'Stage 1',
    'Stage 2',
    'Stage 3'
  ]
end
