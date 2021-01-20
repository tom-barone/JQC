SELECT 
	a.id, 
    t.application_type,
    a.reference_number,
    a.converted_to_from,
    a.street_number,
    a.lot_number,
    a.street_name,
    CONCAT(
		if(a.lot_number is null, '', concat(a.lot_number,' ')),
		if(a.street_number is null, '', concat(a.street_number,' ')),
        a.street_name) as location,
	s.display_name as suburb,
	a.description,
    contact.client_name as contact,
	owner.client_name as owner,
    applicant.client_name as applicant,
    council.name as council,
    a.created_at,
    a.development_application_number

FROM applications as a 
left join clients as contact on a.client_id = contact.id
left join clients as owner on a.owner_id = owner.id
left join clients as applicant on a.applicant_id = applicant.id
left join councils as council on a.council_id = council.id
left join application_types as t on a.application_type_id = t.id
left join suburbs as s on a.suburb_id = s.id
