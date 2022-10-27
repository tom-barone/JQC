select 
  a.id,
  t.application_type,
  a.reference_number,
  a.converted_to_from,
  council.name as council,
  a.development_application_number,
  applicant.client_name as applicant,
  applicant_c.name as applicant_council,
  owner.client_name as owner,
  owner_c.name as owner_council,
  client.client_name as contact,
  client_c.name as contact_council,
  a.description,
  a.cancelled,
  a.street_number,
  a.lot_number,
  a.street_name,
  s.display_name as suburb,
  a.section_93A,
  a.electronic_lodgement,
  a.hard_copy,
  a.job_type_administration,
  a.quote_accepted_date,
  a.administration_notes,
  a.number_of_storeys,
  a.construction_value,
  a.fee_amount,
  a.building_surveyor,
  a.structural_engineer,
  a.external_engineer_date,
  a.risk_rating,
  a.assessment_commenced,
  rfi.request_for_information_dates,
  a.consent_issued,
  a.variation_issued,
  a.coo_issued,
  a.job_type,
  a.consent,
  a.certifier,
  a.engineer_certificate_received,
  a.certification_notes,
  a.invoice_to,
  a.care_of,
  a.invoice_email,
  a.attention,
  a.purchase_order_number,
  a.fully_invoiced,
  a.invoice_debtor_notes,
  a.applicant_email,
  a.created_at,
  a.updated_at
from applications a
left join application_types t on a.application_type_id = t.id
left join suburbs s on a.suburb_id = s.id
left join councils council on a.council_id = council.id
left join clients client on a.client_id = client.id
left join clients applicant on a.applicant_id = applicant.id
left join clients owner on a.owner_id = owner.id
left join councils client_c on a.client_council_id = client_c.id
left join councils applicant_c on a.applicant_council_id = applicant_c.id
left join councils owner_c on a.owner_council_id = owner_c.id
left join (
    select application_id, 
    group_concat(request_for_information_date order by request_for_information_date asc SEPARATOR ',') as request_for_information_dates
    from request_for_informations
    group by application_id
) as rfi on a.id = rfi.application_id
