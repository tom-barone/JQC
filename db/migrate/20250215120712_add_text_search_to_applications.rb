# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class AddTextSearchToApplications < ActiveRecord::Migration[8.0]
  def up
    add_column :applications, :searchable_tsvector, :tsvector

    execute <<-SQL.squish
      CREATE OR REPLACE FUNCTION applications_search_vector(
        development_application_number TEXT,
        location TEXT,
        suburb_name TEXT,
        reference_number TEXT,
        description TEXT,
        administration_notes TEXT,
        building_surveyor TEXT,
        council_name TEXT,
        contact_name TEXT,
        owner_name TEXT,
        applicant_name TEXT
      )
      RETURNS tsvector AS $$
      BEGIN
        RETURN (
          setweight(to_tsvector('english', COALESCE(development_application_number, '')), 'A') ||
          setweight(to_tsvector('english', COALESCE(location, '')), 'A') ||
          setweight(to_tsvector('english', COALESCE(suburb_name, '')), 'A') ||
          setweight(to_tsvector('english', COALESCE(reference_number, '')), 'A') ||
          setweight(to_tsvector('english', COALESCE(description, '')), 'A') ||
          setweight(to_tsvector('english', COALESCE(administration_notes, '')), 'B') ||
          setweight(to_tsvector('english', COALESCE(building_surveyor, '')), 'A') ||
          setweight(to_tsvector('english', COALESCE(council_name, '')), 'A') ||
          setweight(to_tsvector('english', COALESCE(contact_name, '')), 'C') ||
          setweight(to_tsvector('english', COALESCE(owner_name, '')), 'C') ||
          setweight(to_tsvector('english', COALESCE(applicant_name, '')), 'A')
        );
      END;
      $$ LANGUAGE plpgsql IMMUTABLE;
    SQL

    # Create trigger function for applications
    execute <<-SQL.squish
      CREATE OR REPLACE FUNCTION applications_trigger_function()
      RETURNS trigger AS $$
      BEGIN
        NEW.searchable_tsvector := applications_search_vector(
          NEW.development_application_number,
          NEW.location,
          (SELECT display_name FROM suburbs WHERE id = NEW.suburb_id),
          NEW.reference_number,
          NEW.description,
          NEW.administration_notes,
          NEW.building_surveyor,
          (SELECT name FROM councils WHERE id = NEW.council_id),
          (SELECT client_name FROM clients WHERE id = NEW.contact_id),
          (SELECT client_name FROM clients WHERE id = NEW.owner_id),
          (SELECT client_name FROM clients WHERE id = NEW.applicant_id)
        );
        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;
    SQL

    # Create trigger for applications
    execute <<-SQL.squish
      CREATE TRIGGER applications_search_vector_update
      BEFORE INSERT OR UPDATE
      ON applications
      FOR EACH ROW
      EXECUTE FUNCTION applications_trigger_function();
    SQL

    # Create triggers for related tables
    execute <<-SQL.squish
      CREATE OR REPLACE FUNCTION update_applications_search_from_suburb()
      RETURNS trigger AS $$
      BEGIN
        UPDATE applications
        SET searchable_tsvector = applications_search_vector(
          development_application_number,
          location,
          NEW.display_name,
          reference_number,
          description,
          administration_notes,
          building_surveyor,
          (SELECT name FROM councils WHERE id = council_id),
          (SELECT client_name FROM clients WHERE id = contact_id),
          (SELECT client_name FROM clients WHERE id = owner_id),
          (SELECT client_name FROM clients WHERE id = applicant_id)
        )
        WHERE suburb_id = NEW.id;
        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;

      CREATE TRIGGER update_applications_search_suburb
      AFTER UPDATE OF display_name
      ON suburbs
      FOR EACH ROW
      EXECUTE FUNCTION update_applications_search_from_suburb();
    SQL

    execute <<-SQL.squish
      CREATE OR REPLACE FUNCTION update_applications_search_from_council()
      RETURNS trigger AS $$
      BEGIN
        UPDATE applications
        SET searchable_tsvector = applications_search_vector(
          development_application_number,
          location,
          (SELECT display_name FROM suburbs WHERE id = suburb_id),
          reference_number,
          description,
          administration_notes,
          building_surveyor,
          NEW.name,
          (SELECT client_name FROM clients WHERE id = contact_id),
          (SELECT client_name FROM clients WHERE id = owner_id),
          (SELECT client_name FROM clients WHERE id = applicant_id)
        )
        WHERE council_id = NEW.id;
        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;

      CREATE TRIGGER update_applications_search_council
      AFTER UPDATE OF name
      ON councils
      FOR EACH ROW
      EXECUTE FUNCTION update_applications_search_from_council();
    SQL

    execute <<-SQL.squish
      CREATE OR REPLACE FUNCTION update_applications_search_from_client()
      RETURNS trigger AS $$
      BEGIN
        UPDATE applications
        SET searchable_tsvector = applications_search_vector(
          development_application_number,
          location,
          (SELECT display_name FROM suburbs WHERE id = suburb_id),
          reference_number,
          description,
          administration_notes,
          building_surveyor,
          (SELECT name FROM councils WHERE id = council_id),
          (SELECT client_name FROM clients WHERE id = contact_id),
          (SELECT client_name FROM clients WHERE id = owner_id),
          (SELECT client_name FROM clients WHERE id = applicant_id)
        )
        WHERE contact_id = NEW.id OR owner_id = NEW.id OR applicant_id = NEW.id;
        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;

      CREATE TRIGGER update_applications_search_client
      AFTER UPDATE OF client_name
      ON clients
      FOR EACH ROW
      EXECUTE FUNCTION update_applications_search_from_client();
    SQL

    # Create index
    execute <<-SQL.squish
      CREATE INDEX applications_searchable_idx#{' '}
      ON applications#{' '}
      USING GIN(searchable_tsvector);
    SQL

    # Initialize all existing records
    execute <<-SQL.squish
      UPDATE applications
      SET searchable_tsvector = applications_search_vector(
        development_application_number,
        location,
        (SELECT display_name FROM suburbs WHERE id = suburb_id),
        reference_number,
        description,
        administration_notes,
        building_surveyor,
        (SELECT name FROM councils WHERE id = council_id),
        (SELECT client_name FROM clients WHERE id = contact_id),
        (SELECT client_name FROM clients WHERE id = owner_id),
        (SELECT client_name FROM clients WHERE id = applicant_id)
      );
    SQL
  end

  def down
    execute <<-SQL.squish
      DROP TRIGGER IF EXISTS applications_search_vector_update ON applications;
      DROP TRIGGER IF EXISTS update_applications_search_suburb ON suburbs;
      DROP TRIGGER IF EXISTS update_applications_search_council ON councils;
      DROP TRIGGER IF EXISTS update_applications_search_client ON clients;

      DROP FUNCTION IF EXISTS applications_trigger_function();
      DROP FUNCTION IF EXISTS applications_search_vector(TEXT, TEXT, TEXT, TEXT, TEXT, TEXT, TEXT, TEXT, TEXT, TEXT);
      DROP FUNCTION IF EXISTS update_applications_search_from_suburb();
      DROP FUNCTION IF EXISTS update_applications_search_from_council();
      DROP FUNCTION IF EXISTS update_applications_search_from_client();
    SQL

    remove_index :applications, :searchable_tsvector
    remove_column :applications, :searchable_tsvector
  end
end
# rubocop:enable Metrics/ClassLength
