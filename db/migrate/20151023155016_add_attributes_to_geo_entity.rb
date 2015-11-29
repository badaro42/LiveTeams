class AddAttributesToGeoEntity < ActiveRecord::Migration
  def change
    add_column :geo_entities, :entity_type, :string, null: false
    add_column :geo_entities, :radius, :integer, null: false
  end
end
