class CreateTeamGeoEntities < ActiveRecord::Migration
  def change
    create_table :team_geo_entities do |t|
      t.references :team, index: true, foreign_key: true
      t.references :geo_entity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
