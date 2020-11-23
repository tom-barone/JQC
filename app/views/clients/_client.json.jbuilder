json.extract! client, :id, :ClientType, :ClientName, :FirstName, :Surname, :Title, :Initials, :Salutation, :CompanyName, :Street, :SuburbID, :PostalAddress, :PostalSuburbID, :ABN, :State, :Phone, :MobileNo, :Fax, :Email, :Notes, :BadPayer, :created_at, :updated_at
json.url client_url(client, format: :json)
