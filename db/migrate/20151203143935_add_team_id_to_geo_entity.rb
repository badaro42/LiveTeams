class AddTeamIdToGeoEntity < ActiveRecord::Migration
  def change
    # add_column :geo_entities, :team_id, :integer
    add_reference :geo_entities, :team, index: true, null: false
    add_foreign_key :geo_entities, :teams
  end
end
