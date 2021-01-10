class ApplicationSearchResult < ApplicationRecord
  self.primary_key = :id

  scope :filter_all,
        ->(params) {
          filter_by_search_text(params[:search_text])
            .filter_by_type(params[:type])
            .filter_by_date(params[:start_date], params[:end_date])
            # Show PC's first, then Q's
            .order(
              'field (application_type, "PC", "Q", "C", "RC", "LG", "SC") asc, reference_number desc'
            )
        }

  scope :filter_by_type,
        ->(application_type) {
          if application_type != nil
            where(
              "application_type = '#{application_type}'" # Default to PC's
            )
          else
            nil
          end
        }

  scope :filter_by_date,
        ->(start_date, end_date) {
          if start_date != nil or end_date != nil
            where(
              "created_at >= '#{
                start_date ||= '1900-01-01'
              }' and created_at <= '#{end_date ||= DateTime.now}'"
            )
          else
            nil
          end
        }

  scope :filter_by_search_text,
        ->(search_text) {
          if search_text != nil
              where(
                'match(
                  development_application_number,
                  location,
                  description
              ) against (? in boolean mode)
              or match(suburb) against (? in boolean mode) 
              or match(contact) against (? in boolean mode) 
              or match(owner) against (? in boolean mode) 
              or match(applicant) against (? in boolean mode) 
              or match(council) against (? in boolean mode) 
              or reference_number like ?
              ',
                search_text,
                search_text,
                search_text,
                search_text,
                search_text,
                search_text,
                '%' + search_text + '%'
              )
          else
            nil
          end
        }

end
