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
              'application_type = ?', application_type # Default to PC's
            )
          end
        }

  scope :filter_by_start_date,
        lambda { |start_date|
          where('created_at >= ?', start_date) if start_date.present?
        }

  scope :filter_by_end_date,
        lambda { |end_date|
          where('created_at <= ?', end_date) if end_date.present?
        }

  scope :filter_by_date,
        lambda { |start_date, end_date|
          if start_date.present? || end_date.present?
            where(
              'created_at >= ? and created_at <= ?', start_date, end_date
            )
          end
        }

  # rubocop:disable Metrics/BlockLength
  scope :filter_by_search_text,
        lambda { |search_text|
          return nil if search_text.blank?

          # Chain where calls together using reduce
          search_text.split.reduce(self) do |chain, unsanitized_word|
            search_word = sanitize_sql_like(unsanitized_word)
            chain.where(
              "
                development_application_number LIKE ?
                or street_number LIKE ?
                or lot_number LIKE ?
                or suburb LIKE ?
                or reference_number LIKE  ?
                or description LIKE  ?
                or street_name LIKE  ?
                or council LIKE  ?
                or contact LIKE  ?
                or owner LIKE  ?
                or applicant LIKE  ?
                ",
              search_word,         # development_application_number
              search_word,         # street_number
              search_word,         # lot_number
              "%#{search_word}%",  # suburb
              "%#{search_word}%",  # reference_number
              "%#{search_word}%",  # description
              "%#{search_word}%",  # street_name
              "%#{search_word}%",  # council
              "%#{search_word}%",  # contact
              "%#{search_word}%",  # owner
              "%#{search_word}%"   # applicant
            )
          end
        }
  # rubocop:enable Metrics/BlockLength
end
