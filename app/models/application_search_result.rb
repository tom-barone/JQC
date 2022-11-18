# frozen_string_literal: true

class ApplicationSearchResult < ApplicationRecord
  self.primary_key = :id

  scope :filter_all,
        lambda { |params|
          filter_by_search_text(params[:search_text])
            .filter_by_type(params[:type])
            .filter_by_start_date(params[:start_date])
            .filter_by_end_date(params[:end_date])
            # Filter out outliers
            # TODO: These outliers should be removed from the DB
            .where("created_at >= '1900-01-01'")
            .where("created_at <= '#{DateTime.now}'")
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
          return nil if search_text.nil?

          result = nil
          search_text.split.each_with_index do |search_word, index|
            result =
              if index == 0
                where(
                  '
                  match(
                      development_application_number,
                      street_name,
                      street_number,
                      lot_number,
                      description
                  ) against (? in boolean mode)
                  or match(suburb) against (? in boolean mode)
                  or match(contact) against (? in boolean mode)
                  or match(owner) against (? in boolean mode)
                  or match(applicant) against (? in boolean mode)
                  or development_application_number = ?
                  or street_number = ?
                  or lot_number = ?
                  or reference_number like ?
                  or converted_to_from like ?
                  or description like ?
                  or street_name like ?
                  or council like ?
                  ',
                  search_word,
                  search_word,
                  search_word,
                  search_word,
                  search_word,
                  search_word,
                  search_word,
                  search_word,
                  '%' + search_word + '%',
                  '%' + search_word + '%',
                  '%' + search_word + '%',
                  '%' + search_word + '%',
                  '%' + search_word + '%'
                )
              else
                result.where(
                  'match(
                      development_application_number,
                      street_name,
                      street_number,
                      lot_number,
                      description
                  ) against (? in boolean mode)
                  or match(suburb) against (? in boolean mode)
                  or match(contact) against (? in boolean mode)
                  or match(owner) against (? in boolean mode)
                  or match(applicant) against (? in boolean mode)
                  or development_application_number = ?
                  or street_number = ?
                  or lot_number = ?
                  or reference_number like ?
                  or converted_to_from like ?
                  or description like ?
                  or street_name like ?
                  or council like ?
                  ',
                  search_word,
                  search_word,
                  search_word,
                  search_word,
                  search_word,
                  search_word,
                  search_word,
                  search_word,
                  '%' + search_word + '%',
                  '%' + search_word + '%',
                  '%' + search_word + '%',
                  '%' + search_word + '%',
                  '%' + search_word + '%'
                )
              end
          end
          return result
        }
end
