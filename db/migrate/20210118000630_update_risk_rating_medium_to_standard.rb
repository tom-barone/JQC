class UpdateRiskRatingMediumToStandard < ActiveRecord::Migration[6.0]
  def change
    execute"update applications set risk_rating = 'Standard' where risk_rating like '%Medium%'"
  end
end
