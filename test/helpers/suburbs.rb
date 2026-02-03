# frozen_string_literal: true

module SuburbsHelper
  def create_suburbs
    [
      create(:suburb, suburb: 'Brisbane', state: 'QLD', postcode: '4000'),
      create(:suburb, suburb: 'Sydney', state: 'NSW', postcode: '2000'),
      create(:suburb, suburb: 'Melbourne', state: 'VIC', postcode: '3000'),
      create(:suburb, suburb: 'Perth', state: 'WA', postcode: '6000'),
      create(:suburb, suburb: 'Adelaide', state: 'SA', postcode: '5000')
    ]
  end
end
