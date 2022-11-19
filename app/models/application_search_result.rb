# frozen_string_literal: true

class ApplicationSearchResult < ApplicationRecord
  self.primary_key = :id

  scope :filter_all,
        lambda { |params|
          filter_by_type(params[:type])
            .filter_by_start_date(params[:start_date])
            .filter_by_end_date(params[:end_date])
            .filter_by_search_text(params[:search_text])
            # Filter out outliers
            # TODO: These outliers should be removed from the DB
            .where("created_at >= '1900-01-01'")
            # Show PC's first, then Q's
            .order(
              Arel.sql(
                'field (application_type, "PC", "Q", "C", "RC", "LG", "SC") asc, reference_number desc'
              )
            )
        }

  scope :filter_by_type,
        lambda { |application_type|
          if application_type.present?
            where(
              "application_type = '#{application_type}'" # Default to PC's
            )
          end
        }

  scope :filter_by_start_date,
        lambda { |start_date|
          where("created_at >= '#{start_date}'") if start_date.present?
        }

  scope :filter_by_end_date,
        lambda { |end_date|
          where("created_at <= '#{end_date}'") if end_date.present?
        }

  scope :filter_by_date,
        lambda { |start_date, end_date|
          if start_date.present? || end_date.present?
            where(
              "created_at >= '#{start_date}' and created_at <= '#{end_date}'"
            )
          end
        }

  scope :filter_by_search_text,
        lambda { |search_text|
          return nil if search_text.blank?

          # Chain where calls together using reduce
          search_text
            .split
            .reduce(self) do |chain, unsanitized_word|
              search_word = sanitize_sql_like(unsanitized_word)
              chain.where(
                sanitize_sql(
                  "
                  development_application_number LIKE '#{search_word}'
                  or street_number LIKE '#{search_word}'
                  or lot_number LIKE '#{search_word}'
                  or suburb LIKE '%#{search_word}%'
                  or reference_number LIKE '%#{search_word}%'
                  or description LIKE '%#{search_word}%'
                  or street_name LIKE '%#{search_word}%'
                  or council LIKE '%#{search_word}%'
                  or contact LIKE '%#{search_word}%'
                  or owner LIKE '%#{search_word}%'
                  or applicant LIKE '%#{search_word}%'
                "
                )
              )
            end
        }
end
