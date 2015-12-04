class AddTeamIdToGeoEntity < ActiveRecord::Migration
  def change
    # add_reference :geo_entities, :team, index: true, null: true
    # add_foreign_key :geo_entities, :teams

    add_column :geo_entities, :team_ids, :text, array: true, default: []
  end
end
