class Application < ApplicationRecord
  belongs_to :council, class_name: 'Council'
  belongs_to :applicant, class_name: 'Client'
  belongs_to :applicant_council, class_name: 'Council'
  belongs_to :owner, class_name: 'Client'
  belongs_to :owner_council, class_name: 'Council'
  belongs_to :client, class_name: 'Client'
  belongs_to :client_council, class_name: 'Council'
  belongs_to :suburb
  belongs_to :application_type

  scope :filter_by_type,
        ->(application_type) {
          if application_type != nil
            joins(:application_type).where(
              "application_types.application_type = '#{application_type}'" # Default to PC's
            )
          else
            nil
          end
        }

  scope :filter_by_date,
        ->(start_date, end_date) {
          if start_date != nil or end_date != nil
            where(
              "applications.created_at >= '#{
                start_date ||= '1900-01-01'
              }' and applications.created_at <= '#{end_date ||= DateTime.now}'"
            )
          else
            nil
          end
        }

  scope :filter_by_search_text,
        ->(search_text) {
          if search_text != nil
            joins('left join suburbs s on applications.suburb_id = s.id')
              .joins(
                'left join clients contact on applications.client_id = contact.id'
              )
              .joins(
                'left join clients owner on applications.owner_id = owner.id'
              )
              .joins(
                'left join clients applicant on applications.applicant_id = applicant.id'
              )
              .joins('left join councils c on applications.council_id = c.id')
              .where(
                'match(
                  development_application_number,
                  street_name,
                  street_number,
                  lot_number,
                  description
              ) against (? in boolean mode)
              or match(s.display_name) against (? in boolean mode) 
              or match(contact.client_name) against (? in boolean mode) 
              or match(owner.client_name) against (? in boolean mode) 
              or match(applicant.client_name) against (? in boolean mode) 
              or match(c.name) against (? in boolean mode) 
              or reference_number like ?
              ',
                search_text,
                search_text,
                search_text,
                search_text,
                search_text,
                search_text,
                "%" + search_text + "%"
              )
          else
            nil
          end
        }

  def self.to_csv
    attributes = %w[id reference_number ]
    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each { |user| csv << user.attributes.values_at(*attributes) }
    end
  end
end
