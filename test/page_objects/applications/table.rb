# frozen_string_literal: true

module Applications
  module TablePageObject
    NEW_APPLICATION_BUTTON = 'New Application'
    RESULTS_TABLE = '.applications-table'
    PAGINATION_NAV = '.pagination'
    TABLE_HEADERS = {
      reference_number: 'Reference number',
      location: 'Location',
      suburb: 'Suburb',
      description: 'Description',
      admin_notes: 'Admin notes',
      owner: 'Owner',
      applicant: 'Applicant',
      council: 'Council',
      date_entered: 'Date entered',
      building_surveyor: 'Building surveyor',
      da_no: 'DA no.'
    }.freeze

    def click_new_application
      click_on NEW_APPLICATION_BUTTON
    end

    def table_rows
      find(RESULTS_TABLE).all('tbody tr')
    end

    # Returns an array of hashes representing each row in the table:
    # [
    #   { reference_number: <element> location: <element>, ... }, ...
    # ]
    def table_rows_as_hashes
      table_rows.map do |row|
        columns = row.all('td')
        TABLE_HEADERS.map.with_index do |(field, _header), index|
          [field, columns[index]]
        end.to_h
      end
    end

    def goto_page(page_number)
      within(PAGINATION_NAV) do
        click_on page_number.to_s
      end
    end
  end
end
