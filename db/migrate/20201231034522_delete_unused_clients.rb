# frozen_string_literal: true

class DeleteUnusedClients < ActiveRecord::Migration[6.0]
  def up
    execute "
      delete from clients where id in (
        select * from (
          select distinct c.id from clients c left outer join applications a on a.client_id = c.id
          where a.client_id is null and c.id in (
            select c1.id from clients c1 left outer join applications a1 on a1.applicant_id = c1.id
            where a1.applicant_id is null and c1.id in (
                select distinct c2.id from clients c2 left outer join applications a2 on a2.owner_id = c2.id
                where a2.owner_id is null
            )
          )
        ) as cc
      )
    "
  end
end
