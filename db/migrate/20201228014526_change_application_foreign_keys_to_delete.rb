# frozen_string_literal: true

class ChangeApplicationForeignKeysToDelete < ActiveRecord::Migration[6.0]
  def up
    # Delete old foreign keys
    execute 'alter table application_additional_informations drop foreign key application_additional_informations_ibfk_1'
    execute 'alter table application_uploads drop foreign key application_uploads_ibfk_1'
    execute 'alter table invoices drop foreign key invoices_ibfk_1'
    execute 'alter table stages drop foreign key stages_ibfk_1'

    # Add new foreign keys
    execute 'alter table application_additional_informations add constraint foreign key (application_id) references applications (id) on delete cascade'
    execute 'alter table application_uploads add constraint foreign key (application_id) references applications (id) on delete cascade'
    execute 'alter table invoices add constraint foreign key (application_id) references applications (id) on delete cascade'
    execute 'alter table stages add constraint foreign key (application_id) references applications (id) on delete cascade'
  end
end
